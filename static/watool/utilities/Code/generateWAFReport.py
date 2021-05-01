#!/usr/bin/env python3

# This is a simple python app for use with the Well-Architected labs
# to generate a report that includes Improvement Plans
#
# This code is only for use in Well-Architected labs
# *** NOT FOR PRODUCTION USE ***
#
#
# Licensed under the Apache 2.0 and MITnoAttr License.
#
# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
# https://aws.amazon.com/apache2.0/


import botocore
import boto3
import json
import datetime
import logging
import jmespath
import base64
import argparse
import webbrowser
import tempfile
import urllib.request
from pkg_resources import packaging
from pathlib import Path
from bs4 import BeautifulSoup, NavigableString, Tag

__author__    = "Eric Pullen"
__email__     = "eppullen@amazon.com"
__copyright__ = "Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved."
__credits__   = ["Eric Pullen"]
__version__   = "0.1"

# Default region listed here
REGION_NAME = "us-east-1"
blankjson = {}
response = ""

# Setup Logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
)

logger = logging.getLogger()
logging.getLogger('boto3').setLevel(logging.CRITICAL)
logging.getLogger('botocore').setLevel(logging.CRITICAL)
logging.getLogger('s3transfer').setLevel(logging.CRITICAL)
logging.getLogger('urllib3').setLevel(logging.CRITICAL)

PARSER = argparse.ArgumentParser()
PARSER.add_argument('--profile', required=False, default="default", help='AWS CLI Profile Name')
PARSER.add_argument('--workloadid', required=True, help='WorkloadID. Example: 1e5d148ab9744e98343cc9c677a34682')
PARSER.add_argument('--region', required=False, default="us-east-1", help='From Region Name. Example: us-east-1')
PARSER.add_argument('--debug', action='store_true', help='print debug messages to stderr')

ARGUMENTS = PARSER.parse_args()

REGION_NAME = ARGUMENTS.region
PROFILE = ARGUMENTS.profile
WORKLOADID = ARGUMENTS.workloadid

if ARGUMENTS.debug:
    logger.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.INFO)

# To map our short hand names in the console to the API defined pillars
# Example: print(PILLAR_PARSE_MAP['performance'])
PILLAR_PARSE_MAP = {
                    "operationalExcellence": "OPS",
                    "security": "SEC",
                    "reliability": "REL",
                    "performance": "PERF",
                    "costOptimization": "COST"
                    }

PILLAR_PROPER_NAME_MAP = {
                    "operationalExcellence": "Operational Excellence",
                    "security": "Security",
                    "reliability": "Reliability",
                    "performance": "Performance Efficiency",
                    "costOptimization": "Cost Optimization"
}

# Helper class to convert a datetime item to JSON.
class DateTimeEncoder(json.JSONEncoder):
    def default(self, z):
        if isinstance(z, datetime.datetime):
            return (str(z))
        else:
            return super().default(z)

def FindWorkload(
    waclient,
    workloadName
    ):

    # Finding your WorkloadId
    try:
        response=waclient.list_workloads(
        WorkloadNamePrefix=workloadName
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print("Full JSON:",json.dumps(response['WorkloadSummaries'], cls=DateTimeEncoder))
    workloadId = response['WorkloadSummaries'][0]['WorkloadId']
    # print("WorkloadId",workloadId)
    return workloadId

def getAnswersForQuestion(
    waclient,
    workloadId,
    lensAlias,
    questionId
    ):

    # Find a answer for a questionId
    try:
        response=waclient.get_answer(
        WorkloadId=workloadId,
        LensAlias=lensAlias,
        QuestionId=questionId
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print(json.dumps(response))
    jmesquery = "Answer.SelectedChoices"
    answers = jmespath.search(jmesquery, response)
    # print(answers)
    return answers

def getUnansweredForQuestion(
    waclient,
    workloadId,
    lensAlias,
    questionId
    ):

    # Find a answer for a questionId
    try:
        response=waclient.get_answer(
        WorkloadId=workloadId,
        LensAlias=lensAlias,
        QuestionId=questionId
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    jmesquery = "Answer.SelectedChoices"
    answers = jmespath.search(jmesquery, response)
    jmesquery = "Answer.Choices[].ChoiceId"
    possibleAnswers = jmespath.search(jmesquery, response)

    s = set(answers)
    diff = [x for x in possibleAnswers if x not in s]

    # print(answers)
    return diff

def updateAnswersForQuestion(
    waclient,
    workloadId,
    lensAlias,
    questionId,
    selectedChoices,
    notes
    ):

    # Update a answer to a question
    try:
        response=waclient.update_answer(
        WorkloadId=workloadId,
        LensAlias=lensAlias,
        QuestionId=questionId,
        SelectedChoices=selectedChoices,
        Notes=notes
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print(json.dumps(response))
    jmesquery = "Answer.SelectedChoices"
    answers = jmespath.search(jmesquery, response)
    return answers


def getImprovementPlanHTMLDescription(
    ImprovementPlanUrl,
    PillarId
    ):

    logger.debug("ImprovementPlanUrl: %s for pillar %s " % (ImprovementPlanUrl,PILLAR_PARSE_MAP[PillarId]))
    stepRaw = ImprovementPlanUrl.rsplit('#')[1]

    if len(stepRaw) <= 5:
        stepNumber = stepRaw[-1]
    else:
        stepNumber = stepRaw[-2]
    # print(stepNumber)
    firstItem = "step"+stepNumber
    secondItem = ("step"+str((int(stepNumber)+1)))
    logger.debug ("Going from %s to %s" % (firstItem, secondItem))
    urlresponse = urllib.request.urlopen(ImprovementPlanUrl)
    htmlBytes = urlresponse.read()
    htmlStr = htmlBytes.decode("utf8")
    htmlSplit = htmlStr.split('\n')

    foundit = 0
    ipString = ""
    questionIdText = ""
    for i in htmlSplit:
        if PILLAR_PARSE_MAP[PillarId] in i:
            bsparse = BeautifulSoup(i,features="html.parser")
            questionIdText = str(bsparse.text).split(':')[0].strip()
        if (secondItem in i) or ("</div>" in i):
            foundit = 0
        if firstItem in i:
            foundit = 1
            ipString+=i
        elif foundit:
            ipString+=i
    # print(ipString)

    prettyHTML = BeautifulSoup(ipString,features="html.parser")
    # We need to remove all of the "local glossary links" since they point to relative paths
    for a in prettyHTML.findAll('a', 'glossref'):
        a.replaceWithChildren()

    return prettyHTML, questionIdText

def getImprovementPlanItems(
    waclient,
    workloadId,
    lensAlias,
    QuestionId,
    PillarId,
    ImprovementPlanUrl
):
    response = {}
    htmlString = ""
    unanswered = getUnansweredForQuestion(waclient,workloadId,'wellarchitected',QuestionId)
    # print("Unanswered: ",json.dumps(unanswered))

    urlresponse = urllib.request.urlopen(ImprovementPlanUrl)
    htmlBytes = urlresponse.read()
    htmlStr = htmlBytes.decode("utf8")
    htmlSplit = htmlStr.split('\n')
    # print(" ")
    # htmlString += 'Improvement Plan Items:<br>'
    # htmlString += '<div id="detect-investigate-events"><ul>'
    ipHTMLList = []

    # ipHTMLList.append({"ChoiceId": "1234", "ParsedURL": "http://test.com/#step1"})
    for line in htmlSplit:
        for uq in unanswered:
            if uq in line:
                parsed = BeautifulSoup(line,features="html.parser")
                ipHTMLList.append({"ChoiceID": uq, "ParsedURL": str(parsed.a['href'])})
                # htmlString += '<li class="listitem">' + str(parsed.a['href']) + '</li>'
                # print(line)
    # print("Full JSON:",json.dumps(response))
    # print(ipHTMLList)
    # exit()
    # htmlString += "</ul></div>"
    # return htmlString
    return ipHTMLList

def listLensReviewImprovements(
    waclient,
    workloadId,
    lensAlias,
    pillarId,
    milestoneNumber=""
):
    response = {}
    try:
        if milestoneNumber:
            response=waclient.list_lens_review_improvements(
            WorkloadId=workloadId,
            LensAlias=lensAlias,
            PillarId=pillarId,
            MilestoneNumber=milestoneNumber
            )
        else:
            response=waclient.list_lens_review_improvements(
            WorkloadId=workloadId,
            LensAlias=lensAlias,
            PillarId=pillarId
            )

    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print("Full JSON:",json.dumps(response['LensReviewReport']['Base64String'], cls=DateTimeEncoder))

    return response['ImprovementSummaries']

def GetWorkload(
    waclient,
    workloadId
    ):

    # Get the WorkloadId
    try:
        response=waclient.get_workload(
        WorkloadId=workloadId
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print("Full JSON:",json.dumps(response['Workload'], cls=DateTimeEncoder))
    workload = response['Workload']
    # print("WorkloadId",workloadId)
    return workload

def generateHTMLHeader():
    htmlPage = '<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>How do you detect and investigate security events? - AWS Well-Architected Framework</title><meta charset="utf-8"><link rel="script" href="./nav_shim.js" /><link rel="stylesheet" href="https://a0.awsstatic.com/main/css/1/style.css" /><link rel="icon" type="image/ico" href="https://a0.awsstatic.com/main/images/site/fav/favicon.ico" /><link rel="shortcut icon" type="image/ico" href="https://a0.awsstatic.com/main/images/site/fav/favicon.ico" /><link rel="stylesheet" type="text/css" href="https://docs.aws.amazon.com/css/awsdocs.css?v=20170615"><link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.2/css/all.css" integrity="sha384-/rXc/GQVaYpyDdyxK+ecHPVYJSN9bmVFBvjA/9eOB+pb3F2w2N6fc5qB9Ew5yIns" crossorigin="anonymous"><style type="text/css"> #pre, #main, #nav, #post { width: 80%; margin-left: 10%; margin-right: 10%; float: inherit; } #pre { margin-top: 80px; } #nav { margin-top: 90px; } #main * { font-size: x-large; text-rendering: optimizelegibility; } @media (max-width: 800px) { #main * { font-size: xx-large; } } .collapsible { background-color: #777; color: white; cursor: pointer; padding: 18px; width: 100%; border: none; text-align: left; outline: none; font-size: 15px; } .active, .collapsible:hover { background-color: #555; } p { line-height: 1.5em; } b { font-weight: bold; } .glossref { color: #444444; text-decoration: none; border-bottom: 1px dotted green; } .glossref:link, .glossref:visited { color: #444444; } .glossref:hover { color: green; } .waTable td:first-child { width: 15pc; } .waTable thead > tr { background-color: #EAF3FE; } .waTable td { padding: 5pt; border: 1pt solid black; } .waQuestionTableRef { width: 100%; margin-top: 1pc; padding: 5pt; border: 1pt solid black; background-color: #EEEEEE; } .waQuestionTableRef td { padding: 5pt; } .waQuestionTable { margin-top: 1pc; padding: 5pt; border: 1pt solid black; } .waQuestionTable tr:nth-child(3n+1) { background-color: #EAF3FE; } .stretchtext { margin-left: 1pt; margin-right: 1pt; padding-left: 8pt; padding-right: 8pt; background-color: #EAF3FE; border-radius: 10pt; } .stretchtext span:nth-child(1) { display: none; background-color: #EAF3FE; } .stretchtext :nth-child(1):target { display: inline; } .stretchtext :nth-child(1):target + a:not(target) { display: none; } #nav-breadcrumbs a, #nav-breadcrumbs span { margin: 0 10px } .toc, .toc li { list-style: none; } #walogo { width: 180px; float: right; } :target:before { content:" "; display:block; height:90px; margin:-90px 0 0; } ul.itemizedlist { margin-left: 2.5em } </style></head><body><header id="aws-page-header" class="awsm m-page-header" role="banner"></header>  '
    # Add the ability to use a header file instead via an passed argument
    # Here is how I would do do that:
    # htmlPage = Path('header_file.html').read_text()
    htmlPage += '<div id="main" role="main">'
    htmlPage += "<h1>Python Well-Architected Report v"+__version__
    htmlPage += "<br></div>"
    return htmlPage

def generateHTMLTOC():
    htmlPage = ""
    htmlPage += '<div id="main" role="main">'
    htmlPage += '<h1>Table of Contents</h1>'
    htmlPage += '<ul class="itemizedlist" type="disc">'
    htmlPage += "<br>"


    for pillar in PILLAR_PARSE_MAP:
        htmlPage += ('<li class="listitem"><b><a href="#%s">%s</a></b> </li>' % (pillar,PILLAR_PROPER_NAME_MAP[pillar]))

    htmlPage += '<br></div>'


    return htmlPage

def getWorkloadProperties(
    waclient,
    workloadId
    ):
    htmlPage = ""

    workloadJson = GetWorkload(waclient,workloadId)

    htmlPage += '<div id="main" role="main">'
    htmlPage += "<h1>Workload Properties</h1>"
    htmlPage += '<ul class="itemizedlist" type="disc">'


    # Notes = workloadJson['Notes'] if "Notes" in workloadJson else ""
    # nonAwsRegions = workloadJson['NonAwsRegions'] if "NonAwsRegions" in workloadJson else []
    #

    # industry = workloadJson['Industry'] if "Industry" in workloadJson else ""
    # accountIds = workloadJson['AccountIds'] if "AccountIds" in workloadJson else []

    htmlPage += "<br>"
    htmlPage += '<li class="listitem"><b>Workload Name:</b> ' + workloadJson['WorkloadName'] + "</li>"
    htmlPage += '<li class="listitem"><b>ARN:</b> ' + workloadJson['WorkloadArn'] + "</li>"
    htmlPage += '<li class="listitem"><b>Description:</b> ' + workloadJson['Description'] + "</li>"
    htmlPage += '<li class="listitem"><b>Review Owner:</b> ' + workloadJson['ReviewOwner'] + "</li>"
    htmlPage += '<li class="listitem"><b>Industry Type:</b> ' + workloadJson['IndustryType'] + "</li>" if "IndustryType" in workloadJson else ""
    # Environment
    # AwsRegions
    # NonAwsRegions
    # htmlPage += '<li class="listitem"><b>Account IDs:</b> ' + workloadJson['AccountIds'] + "</li>" if "AccountIds" in workloadJson else []
    htmlPage += '<li class="listitem"><b><a href="'+workloadJson['ArchitecturalDesign']+'">Architectural Design</a></b> '+ "</li>" if "ArchitecturalDesign" in workloadJson else ""

    htmlPage += "<br></ul></div>"

    return htmlPage

def getPillarReport(
    waclient,
    workloadId,
    lensAlias,
    pillarId
    ):
    htmlPage = ""

    fullResponse = listLensReviewImprovements(waclient,workloadId,"wellarchitected",pillarId)

    for answeredQuestion in fullResponse:
        htmlString = ""
        headerString = ""
        ipList = getImprovementPlanItems(waclient,workloadId,"wellarchitected",answeredQuestion['QuestionId'],answeredQuestion['PillarId'],answeredQuestion['ImprovementPlanUrl'])
        for showChoices in ipList:
            ipItemHTML, questionIdText = getImprovementPlanHTMLDescription(showChoices['ParsedURL'],answeredQuestion['PillarId'])

            headerString = "<h2><b>"+questionIdText+" - "+answeredQuestion['QuestionTitle']+"</h2>"
            # headerString = '<div class="wrap-collabsible"> <input id="collapsible" class="toggle" type="checkbox"> <label for="collapsible" class="lbl-toggle">'
            # headerString += questionIdText+" - "+answeredQuestion['QuestionTitle']
            # headerString += '</label><div class="collapsible-content"><div class="content-inner"><p>'
            headerString += "<h2><b>Current Risk: "+answeredQuestion['Risk']+"</h2>"
            htmlString += ipItemHTML.prettify()
            # htmlString += "</p></div></div></div>"
            # print(htmlString)

            # print(showChoices['ChoiceID'],)
        # exit()
        htmlPage += headerString
        htmlPage += htmlString
        # htmlPage += '</p></div>'
        # htmlPage += '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='

    return htmlPage


def getPillarSummary(
    waclient,
    workloadId,
    lensAlias,
    pillarId
    ):
    htmlPage = ""


    return htmlPage


def main():
    boto3_min_version = "1.16.38"
    # Verify if the version of Boto3 we are running has the wellarchitected APIs included
    if (packaging.version.parse(boto3.__version__) < packaging.version.parse(boto3_min_version)):
        logger.error("Your Boto3 version (%s) is less than %s. You must ugprade to run this script (pip3 upgrade boto3)" % (boto3.__version__, boto3_min_version))
        exit()

    # STEP 1 - Configure environment
    # WORKLOADID = ARGUMENTS.workloadid

    logger.info("Starting Boto %s Session" % boto3.__version__)
    # Create a new boto3 session
    SESSION1 = boto3.session.Session(profile_name=PROFILE)
    # Initiate the well-architected session using the region defined above
    WACLIENT = SESSION1.client(
        service_name='wellarchitected',
        region_name=REGION_NAME,
    )

    htmlPage = generateHTMLHeader()

    htmlPage += getWorkloadProperties(WACLIENT,WORKLOADID)
    # TODO - This currently will only do the base framework.
    #   If people are interested, I can add an enumeration over the
    #   Lenses and gather the same report for them.


    # htmlPage += "<h1>Improvement Plan</h1>"
    htmlPage += generateHTMLTOC()

    htmlPage += '<div id="main" role="main">'
    for pillar in PILLAR_PARSE_MAP:
        # htmlPage += "<h1 id="+pillar+Improvement Plan</h1>"
        htmlPage += ('<h1 id="%s">%s Improvement Plans</h1>' % (pillar, PILLAR_PROPER_NAME_MAP[pillar]))
        htmlPage += getPillarSummary(WACLIENT,WORKLOADID,"wellarchitected",pillar)
        htmlPage += getPillarReport(WACLIENT,WORKLOADID,"wellarchitected",pillar)


    # Close out the HTML for the page
    htmlPage += "</body>"
    htmlPretty = BeautifulSoup(htmlPage,features="html.parser")
    htmlPage = htmlPretty.prettify()

    # Open the file in a browser
    # Might want to make this an argument in the future
    with tempfile.NamedTemporaryFile('w', delete=False, suffix='.html') as f:
        url = 'file://' + f.name
        logger.info("Creating HTML file %s " % f.name)
        f.write(htmlPage)

    logger.info("Opening HTML URL (%s) in default WebBrowser" % url)
    webbrowser.open(url)


if __name__ == "__main__":
    main()
