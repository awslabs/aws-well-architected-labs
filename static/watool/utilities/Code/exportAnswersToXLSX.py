#!/usr/bin/env python3

# This is a tool to export the WA framework answers to a XLSX file
#
# This code is only for use in Well-Architected labs
# *** NOT FOR PRODUCTION USE ***
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
import xlsxwriter
import argparse
from pkg_resources import packaging
import urllib.request
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

PARSER = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='''\
This utility has two options to run:
------------------------------------
1) If you provide a workloadid, this will gather all of the answers across all Well-Architected Lenss and export them to a spreadsheet.
2) If you do not provide a workloadid, the utility will generate a TEMP workload and auto-answer every question. It will then generate a spreadsheet with all of the questions, best practices, and even the improvement plan links for each.
    '''
    )

PARSER.add_argument('-p','--profile', required=False, default="default", help='AWS CLI Profile Name')
PARSER.add_argument('-r','--region', required=False, default="us-east-1", help='From Region Name. Example: us-east-1')
PARSER.add_argument('-w','--workloadid', required=False, default="", help='Workload Id to use instead of creating a TEMP workload')
PARSER.add_argument('-k','--keeptempworkload', action='store_true', help='If you want to keep the TEMP workload created at the end of the export')

PARSER.add_argument('-f','--fileName', required=True, default="./demo.xlsx", help='FileName to export XLSX')
PARSER.add_argument('-v','--debug', action='store_true', help='print debug messages to stderr')


ARGUMENTS = PARSER.parse_args()
PROFILE = ARGUMENTS.profile
FILENAME = ARGUMENTS.fileName
REGION_NAME = ARGUMENTS.region
WORKLOADID = ARGUMENTS.workloadid
KEEPTEMP = ARGUMENTS.keeptempworkload

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
                    "costOptimization": "COST",
                    "sustainability": "SUS"
}

PILLAR_PROPER_NAME_MAP = {
                    "operationalExcellence": "Operational Excellence",
                    "security": "Security",
                    "reliability": "Reliability",
                    "performance": "Performance Efficiency",
                    "costOptimization": "Cost Optimization",
                    "sustainability": "Sustainability"
}

# Helper class to convert a datetime item to JSON.
class DateTimeEncoder(json.JSONEncoder):
    def default(self, z):
        if isinstance(z, datetime.datetime):
            return (str(z))
        else:
            return super().default(z)

def CreateNewWorkload(
    waclient,
    workloadName,
    description,
    reviewOwner,
    environment,
    awsRegions,
    lenses,
    tags,
    pillarPriorities,
    notes="",
    nonAwsRegions=[],
    architecturalDesign='',
    industryType='',
    industry='',
    accountIds=[]
    ):
    # Create your workload
    try:
        response=waclient.create_workload(
        WorkloadName=workloadName,
        Description=description,
        ReviewOwner=reviewOwner,
        Environment=environment,
        AwsRegions=awsRegions,
        Lenses=lenses,
        NonAwsRegions=nonAwsRegions,
        ArchitecturalDesign=architecturalDesign,
        IndustryType=industryType,
        Industry=industry,
        Notes=notes,
        AccountIds=accountIds
        )
    except waclient.exceptions.ConflictException as e:
        workloadId,workloadARN = FindWorkload(waclient,workloadName)
        logger.error("ERROR - The workload name %s already exists as workloadId %s" % (workloadName, workloadId))
        return workloadId, workloadARN
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    workloadId = response['WorkloadId']
    workloadARN = response['WorkloadArn']
    return workloadId, workloadARN

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
    workloadArn = response['WorkloadSummaries'][0]['WorkloadArn']
    # print("WorkloadId",workloadId)
    return workloadId, workloadArn

def DeleteWorkload(
    waclient,
    workloadId
    ):

    # Delete the WorkloadId
    try:
        response=waclient.delete_workload(
        WorkloadId=workloadId
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

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
        exit()

    # print("Full JSON:",json.dumps(response['Workload'], cls=DateTimeEncoder))
    workload = response['Workload']
    # print("WorkloadId",workloadId)
    return workload

def listLens(
    waclient
    ):
    # List all lenses currently available
    try:
        response=waclient.list_lenses()
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print(json.dumps(response))
    lenses = jmespath.search("LensSummaries[*].LensAlias", response)

    return lenses

def getCurrentLensVersion(
    waclient,
    lensAlias
    ):

    # List all lenses currently available
    try:
        response=waclient.list_lenses()
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print(json.dumps(response))
    searchString = "LensSummaries[?LensAlias==`"+lensAlias+"`].LensVersion"
    lenses = jmespath.search(searchString, response)

    return lenses[0]

def findAllQuestionId(
    waclient,
    workloadId,
    lensAlias
    ):

    answers = []
    # Due to a bug in some lenses, I have to iterate over each pillar in order to
    # retrieve the correct results.
    for pillar in PILLAR_PARSE_MAP:
        logger.debug("Grabbing answers for %s %s" % (lensAlias, pillar))
        # Find a questionID using the questionTitle
        try:
            response=waclient.list_answers(
            WorkloadId=workloadId,
            LensAlias=lensAlias,
            PillarId=pillar
            )
        except botocore.exceptions.ParamValidationError as e:
            logger.error("ERROR - Parameter validation error: %s" % e)
        except botocore.exceptions.ClientError as e:
            logger.error("ERROR - Unexpected error: %s" % e)

        answers.extend(response["AnswerSummaries"])
        while "NextToken" in response:
            try:
                response = waclient.list_answers(WorkloadId=workloadId,LensAlias=lensAlias,PillarId=pillar,NextToken=response["NextToken"])
            except botocore.exceptions.ParamValidationError as e:
                logger.error("ERROR - Parameter validation error: %s" % e)
            except botocore.exceptions.ClientError as e:
                logger.error("ERROR - Unexpected error: %s" % e)
            answers.extend(response["AnswerSummaries"])
    return answers

def getQuestionDetails(
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


    qDescription = jmespath.search("Answer.QuestionDescription", response)
    qImprovementPlanUrl = jmespath.search("Answer.ImprovementPlanUrl", response)
    qHelpfulResourceUrl = jmespath.search("Answer.HelpfulResourceUrl", response)
    qNotes = jmespath.search("Answer.Notes", response)
    return qDescription, qImprovementPlanUrl, qHelpfulResourceUrl, qNotes


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

def getImprovementPlanItems(
    waclient,
    workloadId,
    lensAlias,
    QuestionId,
    PillarId,
    ImprovementPlanUrl,
    ChoiceList
):
    # This will parse the IP Items to gather the links we need
    response = {}
    htmlString = ""
    urlresponse = urllib.request.urlopen(ImprovementPlanUrl)
    htmlBytes = urlresponse.read()
    htmlStr = htmlBytes.decode("utf8")
    htmlSplit = htmlStr.split('\n')
    ipHTMLList = {}
    for line in htmlSplit:
        for uq in ChoiceList:
            if uq in line:
                parsed = BeautifulSoup(line,features="html.parser")
                ipHTMLList.update({uq: str(parsed.a['href'])})
    return ipHTMLList

def getImprovementPlanHTMLDescription(
    ImprovementPlanUrl,
    PillarId
    ):

    logger.debug("ImprovementPlanUrl: %s for pillar %s " % (ImprovementPlanUrl,PILLAR_PARSE_MAP[PillarId]))
    stepRaw = ImprovementPlanUrl.rsplit('#')[1]

    # Grab the number of the step we are referencing
    # This will work as long as their are less than 99 steps.
    if len(stepRaw) <= 5:
        stepNumber = stepRaw[-1]
    else:
        stepNumber = stepRaw[-2]

    #Generate the string for the step number
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

    prettyHTML = BeautifulSoup(ipString,features="html.parser")
    # Need to remove all of the "local glossary links" since they point to relative paths
    for a in prettyHTML.findAll('a', 'glossref'):
        a.replaceWithChildren()

    return prettyHTML, questionIdText

def lensTabCreation(
    WACLIENT,
    workloadId,
    lens,
    workbook,
    allQuestionsForLens,
    workloadName="",
    AWSAccountId="",
    workloadDescription=""
    ):

    # Setup some formatting for the workbook
    bold = workbook.add_format({'bold': True})
    bold_border = workbook.add_format({
    'border': 1,
    'border_color': 'black',
    'text_wrap': True
    })
    bold_border_bold = workbook.add_format({
    'border': 1,
    'border_color': 'black',
    'text_wrap': True,
    'font_size': 20,
    'bold': True
    })

    heading = workbook.add_format({
    'font_size': 24,
    'bold': True
    })

    lineA = workbook.add_format({
    'border': 1,
    'border_color': 'black',
    'bg_color': '#E0EBF6',
    'align': 'top',
    'text_wrap': True
    })

    lineB = workbook.add_format({
    'border': 1,
    'border_color': 'black',
    'bg_color': '#E4EFDC',
    'align': 'top',
    'text_wrap': True
    })

    lineAnoborder = workbook.add_format({
    'border': 0,
    'top': 1,
    'left': 1,
    'right': 1,
    'border_color': 'black',
    'bg_color': '#E0EBF6',
    'align': 'top',
    'text_wrap': True
    })

    lineBnoborder = workbook.add_format({
    'border': 0,
    'top': 1,
    'left': 1,
    'right': 1,
    'border_color': 'black',
    'bg_color': '#E4EFDC',
    'align': 'top',
    'text_wrap': True
    })


    lineAhidden = workbook.add_format({
    'border': 0,
    'left': 1,
    'right': 1,
    'border_color': 'black',
    'bg_color': '#E0EBF6',
    'align': 'top',
    'text_wrap': False,
    'indent': 100
    })

    lineBhidden = workbook.add_format({
    'border': 0,
    'left': 1,
    'right': 1,
    'border_color': 'black',
    'bg_color': '#E4EFDC',
    'align': 'top',
    'text_wrap': False,
    'indent': 100
    })

    sub_heading = workbook.add_format()
    sub_heading.set_font_size(20)
    sub_heading.set_bold(True)

    small_font = workbook.add_format()
    small_font.set_font_size(9)

    # Get the current version of Lens
    logger.debug("Getting lens version for '"+lens+"'")
    versionString = getCurrentLensVersion(WACLIENT,lens)
    logger.debug("Adding worksheet using version "+versionString)
    lensName = lens[0:18]
    worksheet = workbook.add_worksheet((lensName+' v'+versionString))
    # Print in landscape
    worksheet.set_landscape()
    # Set to 8.5x11 paper size
    worksheet.set_paper(1)

    # Set the column widths
    worksheet.set_column('A:A', 11)
    worksheet.set_column('B:B', 32)
    worksheet.set_column('C:C', 56)
    worksheet.set_column('D:D', 29)
    worksheet.set_column('E:E', 57)
    worksheet.set_column('F:F', 18)
    worksheet.set_column('G:G', 70)

    # Top of sheet
    worksheet.merge_range('A1:G1', 'Workload Overview', heading)
    worksheet.merge_range('A3:B3', 'Workload Name', bold_border_bold)
    worksheet.merge_range('A4:B4', 'AWS Account ID', bold_border_bold)
    worksheet.merge_range('A5:B5', 'Workload Description', bold_border_bold)

    # If we are using an existing workload, then display the Name, ID, and Description at the top
    #  or else just make it blank
    if WORKLOADID:
        worksheet.write('C3', workloadName, bold_border)
        accountIdParsed = AWSAccountId.split(':')[4]
        worksheet.write('C4', accountIdParsed, bold_border)
        worksheet.write('C5', workloadDescription, bold_border)
    else:
        worksheet.write('C3', '', bold_border)
        worksheet.write('C4', '', bold_border)
        worksheet.write('C5', '', bold_border)
    worksheet.write('D3', 'Enter the name of system', small_font)
    worksheet.write('D4', 'Enter 12-degit AWS account ID', small_font)
    worksheet.write('D5', 'Briefly describe system architecture and workload, flow etc.', small_font)

    # Subheadings for columns
    worksheet.write('A8', 'Pillar', sub_heading)
    worksheet.write('B8', 'Question', sub_heading)
    worksheet.write('C8', 'Explanation', sub_heading)
    worksheet.write('D8', 'Choice (Best Practice)', sub_heading)
    worksheet.write('E8', 'Detail', sub_heading)
    worksheet.write('F8', 'Response', sub_heading)
    worksheet.write('G8', 'Notes (optional)', sub_heading)

    # Freeze the top of the sheet
    worksheet.freeze_panes(8,0)

    # AutoFilter on the first two columns
    worksheet.autofilter('A8:B8')

    # Make it easier to print
    worksheet.repeat_rows(1, 8)
    worksheet.fit_to_pages(1, 99)

    # Starting point for pillar questions
    cellPosition = 8

    # Starting cell look with lineA. Will switch back and forth
    myCell = lineA
    myCellhidden = lineAhidden
    myCellnoborder = lineAnoborder

    for pillar in PILLAR_PARSE_MAP:
        # This is the question number for each pillar (ex: OPS1, OPS2, etc)
        qNum = 1

        # The query will return all questions for a lens and pillar
        jmesquery = "[?PillarId=='"+pillar+"']"
        allQuestionsForPillar = jmespath.search(jmesquery, allQuestionsForLens)

        # For each of the possible answers, parse them and put into the Worksheet
        for answers in allQuestionsForPillar:
            # List all best practices
            questionTitle = PILLAR_PARSE_MAP[answers['PillarId']]+str(qNum)+" - "+answers['QuestionTitle']
            qDescription, qImprovementPlanUrl, qHelpfulResourceUrl, qNotes = getQuestionDetails(WACLIENT,workloadId,lens,answers['QuestionId'])
            # Some of the questions have extra whitespaces and I need to remove those to fit into the cell
            qDescription = qDescription.replace('\n         ','').replace('  ','').replace('\t', '').replace('\n', '')
            qDescription = qDescription.rstrip()
            qDescription = qDescription.strip()

            logger.debug("Working on '"+questionTitle+"'")
            logger.debug("It has answers of: "+json.dumps(answers['SelectedChoices']))

            cellID = cellPosition + 1

            # If the question has been answered (which we do for the TEMP workload) we grab the URL and parse for the HTML content
            if qImprovementPlanUrl:
                jmesquery = "[?QuestionId=='"+answers['QuestionId']+"'].Choices[].ChoiceId"
                choiceList = jmespath.search(jmesquery, allQuestionsForLens)
                ipList = getImprovementPlanItems(WACLIENT,workloadId,lens,answers['QuestionId'],answers['PillarId'],qImprovementPlanUrl,choiceList)
            else:
                ipList = []

            startingCellID=cellID
            # If its the first time through this particular pillar question:
            #   I want to only write the name once, but I need to fill in
            #   each cell with the same data so the autosort works properly
            #   (else it will only show the first best practice)
            firstTimePillar=True

            for choices in answers['Choices']:

                # Write the pillar name and question in every cell for autosort, but only show the first one
                cell = 'A'+str(cellID)
                if firstTimePillar:
                    worksheet.write(cell, PILLAR_PROPER_NAME_MAP[pillar], myCellnoborder)
                    cell = 'B'+str(cellID)
                    worksheet.write(cell, questionTitle, myCellnoborder)
                    firstTimePillar=False
                else:
                    worksheet.write(cell, PILLAR_PROPER_NAME_MAP[pillar], myCellhidden)
                    cell = 'B'+str(cellID)
                    worksheet.write(cell, questionTitle, myCellhidden)

                # Start writing each of the BP's, details, etc
                cell = 'D'+str(cellID)
                Title = choices['Title'].replace('  ','').replace('\t', '').replace('\n', '')
                if any(choices['ChoiceId'] in d for d in ipList):
                    worksheet.write_url(cell, ipList[choices['ChoiceId']], myCell, string=Title)
                    #ipItemHTML, questionIdText = getImprovementPlanHTMLDescription(ipList[choices['ChoiceId']],answers['PillarId'])
                    #htmlString = ipItemHTML.text
                    htmlString = "" 
                    htmlString = htmlString.replace('\n         ','').replace('  ','').replace('\t', '').strip().rstrip()
                    # print(htmlString)
                    worksheet.write_comment(cell, htmlString, {'author': 'Improvement Plan'})
                else:
                    worksheet.write(cell,Title,myCell)

                # Add all Details for each best practice/choice
                cell = 'E'+str(cellID)
                # Remove all of the extra spaces in the description field
                Description = choices['Description'].replace('\n               ','')
                Description = Description.replace('\n         ','')
                Description = Description.replace('  ','').replace('\t', '').replace('\n', '')
                Description = Description.rstrip()
                Description = Description.strip()
                worksheet.write(cell, Description ,myCell)

                # If this is an existing workload, we will show SELECTED if the have it checked
                # I would love to use a XLSX checkbox, but this library doesn't support it
                cell = 'F'+str(cellID)
                responseText = ""
                if choices['ChoiceId'] in answers['SelectedChoices']:
                    responseText = "SELECTED"
                else:
                    responseText = ""
                worksheet.write(cell, responseText ,myCell)
                cellID+=1

            # We are out of the choice/detail/response loop, so know how many rows were consumed
            # and we can create the explanation and notes field to span all of them
            # Explanantion field
            cellMerge = 'C'+str(startingCellID)+':C'+str(cellID-1)
            worksheet.merge_range(cellMerge, qDescription,myCell)

            # Notes field
            cellMerge = 'G'+str(startingCellID)+':G'+str(cellID-1)
            if WORKLOADID:
                worksheet.merge_range(cellMerge, qNotes, myCell)
            else:
                worksheet.merge_range(cellMerge, "", myCell)

            cellID-=1
            # Increase the question number
            qNum += 1
            # Reset the starting cellPosition to the last cellID
            cellPosition = cellID

            # Reset the cell formatting to alternate between the two colors
            if myCell == lineA:
                myCell = lineB
                myCellhidden = lineBhidden
                myCellnoborder = lineBnoborder
            else:
                myCell = lineA
                myCellhidden = lineAhidden
                myCellnoborder = lineAnoborder

def main():
    boto3_min_version = "1.16.38"
    # Verify if the version of Boto3 we are running has the wellarchitected APIs included
    if (packaging.version.parse(boto3.__version__) < packaging.version.parse(boto3_min_version)):
        logger.error("Your Boto3 version (%s) is less than %s. You must ugprade to run this script (pip3 upgrade boto3)" % (boto3.__version__, boto3_min_version))
        exit()

    logger.info("Script version %s" % __version__)
    logger.info("Starting Boto %s Session" % boto3.__version__)
    # Create a new boto3 session
    SESSION1 = boto3.session.Session(profile_name=PROFILE)
    # Initiate the well-architected session using the region defined above
    WACLIENT = SESSION1.client(
        service_name='wellarchitected',
        region_name=REGION_NAME,
    )

    # If this is an existing workload, we need to query for the various workload properties
    if WORKLOADID:
        logger.info("User specified workload id of %s" % WORKLOADID)
        workloadJson = GetWorkload(WACLIENT,WORKLOADID)
        LENSES = workloadJson['Lenses']
        logger.info("Lenses for %s: %s" % (WORKLOADID, json.dumps(LENSES)))
        WORKLOADNAME = workloadJson['WorkloadName']
        DESCRIPTION = workloadJson['Description']
        REVIEWOWNER = workloadJson['ReviewOwner']
        ENVIRONMENT= workloadJson['Environment']
        AWSREGIONS = workloadJson['AwsRegions']
        workloadId = WORKLOADID
        workloadARN = workloadJson['WorkloadArn']
    else:
    # In order to gather all of the questions, you must create a TEMP Workload
        logger.info("No workload ID specified, we will create a TEMP workload")
        # Grab all lenses that are currently available
        LENSES = listLens(WACLIENT)
        logger.info("Lenses available: "+json.dumps(LENSES))
        # Set the needed workload variables before we create it
        WORKLOADNAME = 'TEMP DO NOT USE WORKLOAD'
        DESCRIPTION = 'TEMP DO NOT USE WORKLOAD'
        REVIEWOWNER = 'WA Python Script'
        ENVIRONMENT= 'PRODUCTION'
        AWSREGIONS = [REGION_NAME]
        # Creating the TEMP workload
        logger.info("Creating a new workload to gather questions and answers")
        workloadId, workloadARN = CreateNewWorkload(WACLIENT,WORKLOADNAME,DESCRIPTION,REVIEWOWNER,ENVIRONMENT,AWSREGIONS,LENSES,"[]","[]")



    # Create an new xlsx file and add a worksheet.
    logger.info("Creating xlsx file '"+FILENAME+"'")
    workbook = xlsxwriter.Workbook(FILENAME)
    workbook.set_size(2800, 1600)

    # Simple hack to get Wellarchitected base framework first (reverse sort)
    # This will no longer work if we ever have a lens that starts with WB*, X, Y, or Z :)
    LENSES.sort(reverse=True)

    # Iterate over each lens that we either have added or is in the workload
    for lens in LENSES:
        # Grab all questions for a particular lens
        allQuestions = findAllQuestionId(WACLIENT,workloadId,lens)
        if WORKLOADID:
            # If this is an existing workload, just go ahead and create the Tab and cells
            logger.debug("Not answering questions for existing workload")
            lensTabCreation(WACLIENT,workloadId,lens,workbook,allQuestions,WORKLOADNAME,workloadARN,DESCRIPTION)
        else:
            # If this is the TEMP workload, we need to first gather all of the questionIDs possible
            jmesquery = "[*].{QuestionId: QuestionId, PillarId: PillarId, Choices: Choices[].ChoiceId}"
            allQuestionIds = jmespath.search(jmesquery, allQuestions)
            # Next we answer all of the questions across all lenses in the TEMP workload
            for question in allQuestionIds:
                logger.debug("Answering question %s in the %s lens" % (question['QuestionId'], lens))
                updateAnswersForQuestion(WACLIENT,workloadId,lens,question['QuestionId'],question['Choices'],'TEMP WORKLOAD - Added by export script')
            # Once the questions have been answered, we go ahead and create the tab for each
            lensTabCreation(WACLIENT,workloadId,lens,workbook,allQuestions)


    # Close out the workbook file
    logger.info("Closing Workbook File")
    workbook.close()

    # If this is TEMP workload, we may remove it if it has not been set to keep
    if not WORKLOADID:
        if not KEEPTEMP:
            logger.info("Removing TEMP Workload")
            DeleteWorkload(WACLIENT, workloadId)
    logger.info("Done")


if __name__ == "__main__":
    main()
