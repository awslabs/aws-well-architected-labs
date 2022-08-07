#!/usr/bin/env python3
"""
This is a tool to export a WAFR to a JSON file or import from a JSON file into a new review

This code is only for use in Well-Architected labs
*** NOT FOR PRODUCTION USE ***

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License").
You may not use this file except in compliance with the License.
A copy of the License is located at https://aws.amazon.com/apache2.0/
"""

import json
import datetime
import logging
import sys

import argparse
import botocore
import boto3
import jmespath
from pkg_resources import packaging


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
1) Export - Export the contents of a workload from the Well-Architected tool
2) Import - Create a new workload from the JSON export file generated in export
    '''
    )

# We need to know if we should import or export, so these are mutually exclusive requireds
GROUP = PARSER.add_mutually_exclusive_group(required=True)
GROUP.add_argument('--exportWorkload', action='store_true', help='export the workload to a file')
GROUP.add_argument('--importWorkload', action='store_true', help='import the workload from a file')

PARSER.add_argument('-p','--profile', required=False, default="default", help='AWS CLI Profile Name')
PARSER.add_argument('-r','--region', required=False, default="us-east-1", help='From Region Name. Example: us-east-1')
PARSER.add_argument('-w','--workloadid', required=False, default="", help='Workload Id to use instead of creating a TEMP workload')
PARSER.add_argument('-f','--fileName', required=True, default="./demo.xlsx", help='FileName to export JSON file to')
PARSER.add_argument('-v','--debug', action='store_true', help='print debug messages to stderr')

ARGUMENTS = PARSER.parse_args()
PROFILE = ARGUMENTS.profile
FILENAME = ARGUMENTS.fileName
REGION_NAME = ARGUMENTS.region
WORKLOADID = ARGUMENTS.workloadid

exportWorkload=False
importWorkload=False

if ARGUMENTS.exportWorkload:
    exportWorkload=True
elif ARGUMENTS.importWorkload:
    importWorkload=True
else:
    logger.error("--exportWorkload or --importWorkload is required")
    sys.exit()

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

class DateTimeEncoder(json.JSONEncoder):
    """Helper class to convert a datetime item to JSON."""
    def default(self, z):
        if isinstance(z, datetime.datetime):
            return str(z)
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
     accountIds=[]):
    """ Create your workload  """
    try:
        response=waclient.create_workload(
        WorkloadName=workloadName,
        Description=description,
        ReviewOwner=reviewOwner,
        Environment=environment,
        AwsRegions=awsRegions,
        Lenses=lenses,
        NonAwsRegions=nonAwsRegions,
        PillarPriorities=pillarPriorities,
        ArchitecturalDesign=architecturalDesign,
        IndustryType=industryType,
        Industry=industry,
        Notes=notes,
        AccountIds=accountIds
        )
    except waclient.exceptions.ConflictException as e:
        workloadId,workloadARN = FindWorkload(waclient,workloadName)
        logger.error("ERROR - The workload name %s already exists as workloadId %s" % (workloadName, workloadId))
        userAnswer=input("Do You Want To Overwrite workload %s? [y/n]" % workloadId)
        if userAnswer == "y":
            logger.info("Overwriting existing workload")
            UpdateWorkload(waclient,workloadId,workloadARN, workloadName,description,reviewOwner,environment,awsRegions,tags)
        else:
            logger.error("Exiting due to duplicate workload and user states they do not want to continue.")
            sys.exit(1)
        return workloadId, workloadARN
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    workloadId = response['WorkloadId']
    workloadARN = response['WorkloadArn']
    return workloadId, workloadARN

def UpdateWorkload(
    waclient,
    workloadId,
    workloadARN,
    workloadName,
    description,
    reviewOwner,
    environment,
    awsRegions,
    tags
    ):
    """ Update your workload """
    logger.info("Updating workload properties")
    try:
        waclient.update_workload(
        WorkloadId=workloadId,
        WorkloadName=workloadName,
        Description=description,
        ReviewOwner=reviewOwner,
        Environment=environment,
        AwsRegions=awsRegions,
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    if tags:
        logger.info("Updating workload tags")
        try:
            waclient.tag_resource(WorkloadArn=workloadARN,Tags=tags)
        except botocore.exceptions.ParamValidationError as e:
            logger.error("ERROR - Parameter validation error: %s" % e)
        except botocore.exceptions.ClientError as e:
            logger.error("ERROR - Unexpected error: %s" % e)
    else:
        logger.info("Found blank tag set, removing any I find")
        try:
            tagresponse = waclient.list_tags_for_resource(WorkloadArn=workloadARN)
        except botocore.exceptions.ParamValidationError as e:
            logger.error("ERROR - Parameter validation error: %s" % e)
        except botocore.exceptions.ClientError as e:
            logger.error("ERROR - Unexpected error: %s" % e)
        tagkeys = list(tagresponse['Tags'])
        if tagkeys:
            try:
                waclient.untag_resource(WorkloadArn=workloadARN,TagKeys=tagkeys)
            except botocore.exceptions.ParamValidationError as e:
                logger.error("ERROR - Parameter validation error: %s" % e)
            except botocore.exceptions.ClientError as e:
                logger.error("ERROR - Unexpected error: %s" % e)
        else:
            logger.info("TO Workload has blank keys as well, no need to update")

def findAllQuestionId(
    waclient,
    workloadId,
    lensAlias
    ):
    """ Find all question ID's """
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


def FindWorkload(
    waclient,
    workloadName
    ):
    """ Finding your WorkloadId and ARN """
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
    return workloadId, workloadArn


def GetWorkload(
    waclient,
    workloadId
    ):
    """ Get the Workload JSON """
    try:
        response=waclient.get_workload(
        WorkloadId=workloadId
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)
        sys.exit()

    # print("Full JSON:",json.dumps(response['Workload'], cls=DateTimeEncoder))
    workload = response['Workload']
    return workload

def associateLens(
    waclient,
    workloadId,
    lens
    ):
    """ Associate the lens from the WorkloadId"""
    try:
        response=waclient.associate_lenses(
        WorkloadId=workloadId,
        LensAliases=lens
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)
    return response

def getAnswerForQuestion(
    waclient,
    workloadId,
    lensAlias,
    questionId
    ):
    """ Find a answer for a questionId """
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

    answers = response['Answer']
    return answers

def updateAnswersForQuestion(
    waclient,
    workloadId,
    lensAlias,
    questionId,
    selectedChoices,
    notes
    ):
    """ Update a answer to a question """
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

def listAllAnswers(
    waclient,
    workloadId,
    lensAlias
    ):
    """ Get a list of all answers"""
    answers = []

    allQuestionsForLens = findAllQuestionId(waclient,workloadId,lensAlias)
    for pillar in PILLAR_PARSE_MAP:
        jmesquery = "[?PillarId=='"+pillar+"']"
        allQuestionsForPillar = jmespath.search(jmesquery, allQuestionsForLens)
        for answersLoop in allQuestionsForPillar:
            fullAnswerForQuestion = getAnswerForQuestion(waclient, workloadId, lensAlias, answersLoop['QuestionId'])
            answers.append(fullAnswerForQuestion)
    return answers


def getWorkloadLensReview(
    waclient,
    workloadId,
    lensAlias
    ):
    """ List all lenses currently available"""
    try:
        response=waclient.get_lens_review(
        WorkloadId=workloadId,
        LensAlias=lensAlias
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    return response['LensReview']

def main():
    """ Main program run """

    boto3_min_version = "1.16.38"
    # Verify if the version of Boto3 we are running has the wellarchitected APIs included
    if packaging.version.parse(boto3.__version__) < packaging.version.parse(boto3_min_version):
        logger.error("Your Boto3 version (%s) is less than %s. You must ugprade to run this script (pip3 upgrade boto3)" % (boto3.__version__, boto3_min_version))
        sys.exit()

    logger.info("Script version %s" % __version__)
    logger.info("Starting Boto %s Session" % boto3.__version__)
    # Create a new boto3 session
    SESSION1 = boto3.session.Session(profile_name=PROFILE)
    # Initiate the well-architected session using the region defined above
    WACLIENT = SESSION1.client(
        service_name='wellarchitected',
        region_name=REGION_NAME,
    )

    # This will setup a blank dict we can use to export to a JSON file
    exportObject = {
        "workload": [],
        "lenses": [],
        "lens_review": [],
    }


    if exportWorkload:
        logger.info("Exporting workload '%s' to file %s" % (WORKLOADID, FILENAME))
        workloadJson = GetWorkload(WACLIENT,WORKLOADID)
        exportObject['workload'].append(workloadJson)

        # Iterate over each lens and copy all of the answers
        for lens in workloadJson['Lenses']:
            logger.info("Gathering overall review for lens %s" % lens)
            lensReview = getWorkloadLensReview(WACLIENT,WORKLOADID,lens)
            exportObject['lens_review'].append({lens: lensReview})
            logger.info("Retrieving all answers for lens %s" % lens)
            answers = listAllAnswers(WACLIENT,WORKLOADID,lens)
            exportObject['lenses'].append({lens: answers})
        with open(FILENAME, 'w') as outfile:
            json.dump(exportObject, outfile, indent=4, cls=DateTimeEncoder)
        logger.info("Export completed to file %s" % FILENAME)

    if importWorkload:
        logger.info("Creating a new workload from file %s" % FILENAME)
        with open(FILENAME) as json_file:
            importObject = json.load(json_file)
        workloadJson = importObject['workload'][0]

        # For each of the optional variables, lets check and see if we have them first:
        Notes = workloadJson['Notes'] if "Notes" in workloadJson else ""
        nonAwsRegions = workloadJson['NonAwsRegions'] if "NonAwsRegions" in workloadJson else []
        architecturalDesign = workloadJson['ArchitecturalDesign'] if "ArchitecturalDesign" in workloadJson else ""
        industryType = workloadJson['IndustryType'] if "IndustryType" in workloadJson else ""
        industry = workloadJson['Industry'] if "Industry" in workloadJson else ""
        accountIds = workloadJson['AccountIds'] if "AccountIds" in workloadJson else []
        tags = workloadJson['Tags'] if "Tags" in workloadJson else []
        # Create the new workload to copy into
        toWorkloadId,toWorkloadARN = CreateNewWorkload(WACLIENT,
                                                    (workloadJson['WorkloadName']),
                                                    workloadJson['Description'],
                                                    workloadJson['ReviewOwner'],
                                                    workloadJson['Environment'],
                                                    workloadJson['AwsRegions'],
                                                    workloadJson['Lenses'],
                                                    tags,
                                                    workloadJson['PillarPriorities'],
                                                    Notes,
                                                    nonAwsRegions,
                                                    architecturalDesign,
                                                    industryType,
                                                    industry,
                                                    accountIds
                                                    )
        logger.info("New workload id: %s (%s)" % (toWorkloadId,toWorkloadARN))

        # Iterate over each lens and copy all of the answers
        for lens in workloadJson['Lenses']:
            # We need to verify the lens version first
            logger.info("Verifying lens version before restoring answers")
            lensReview = getWorkloadLensReview(WACLIENT,toWorkloadId,lens)
            importLensVersion = jmespath.search("[*]."+lens+".LensVersion", importObject['lens_review'])[0]
            # ************************************************************************
            #  There is no ability to restore to a specific lens version
            #  in the API at this time, so we just have to error out if
            #  the version has changed.
            # ************************************************************************
            if lensReview['LensVersion'] != importLensVersion:
                logger.error("Version of the lens %s does not match the new workload" % lens)
                logger.error("Import Version: %s" % importLensVersion)
                logger.error("New Workload Version: %s" % lensReview['LensVersion'])
                logger.error("You may need to delete the workload %s" % toWorkloadId)
                sys.exit()
            else:
                logger.info("Versions match (%s)" % importLensVersion)

            logger.info("Retrieving all answers for lens %s" % lens)

            answers = jmespath.search("[*]."+lens+"[]", importObject['lenses'])
            associateLens(WACLIENT,toWorkloadId,[lens])
            logger.info("Copying answers into new workload for lens %s" % lens)
            for answerCopy in answers:
                notesField = answerCopy['Notes'] if "Notes" in answerCopy else ""
                updateAnswersForQuestion(WACLIENT,toWorkloadId,lens,answerCopy['QuestionId'],answerCopy['SelectedChoices'],notesField)

        logger.info("Copy complete - exiting")


if __name__ == "__main__":
    main()
