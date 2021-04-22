#!/usr/bin/env python3

# This is a tool to copy a WA Framework Review from one account to another
# It can also be used to copy between regions for the same account
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
import base64
import argparse
from pkg_resources import packaging


__author__    = "Eric Pullen"
__email__     = "eppullen@amazon.com"
__copyright__ = "Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved."
__credits__   = ["Eric Pullen"]

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
PARSER.add_argument('--fromaccount', required=False, default="", help='AWS CLI Profile Name or will use the default session for the shell')
PARSER.add_argument('--toaccount', required=False, default="", help='AWS CLI Profile Name or will use the default session for the shell')
PARSER.add_argument('--workloadid', required=True, help='WorkloadID. Example: 1e5d148ab9744e98343cc9c677a34682')
PARSER.add_argument('--fromregion', required=False, default="us-east-1", help='From Region Name. Example: us-east-1')
PARSER.add_argument('--toregion', required=False, default="us-east-1", help='To Region Name. Example: us-east-2')
ARGUMENTS = PARSER.parse_args()

REGION_NAME = ARGUMENTS.fromregion
TO_REGION_NAME = ARGUMENTS.toregion
FROM_ACCOUNT = ARGUMENTS.fromaccount
TO_ACCOUNT = ARGUMENTS.toaccount
FROM_WORKLOADID = ARGUMENTS.workloadid

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
            UpdateWorkload(waclient,workloadId,workloadARN, workloadName,description,reviewOwner,environment,awsRegions,lenses,tags)
        else:
            logger.error("Exiting due to duplicate workload and user states they do not want to continue.")
            exit(1)
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
    lenses,
    tags
    ):

    logger.info("Updating workload properties")
    # Create your workload
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
    # Should add updates for the lenses?
    # Should add the tags as well
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

def disassociateLens(
    waclient,
    workloadId,
    lens
    ):

    # Disassociate the lens from the WorkloadId
    try:
        response=waclient.disassociate_lenses(
        WorkloadId=workloadId,
        LensAliases=lens
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

def associateLens(
    waclient,
    workloadId,
    lens
    ):

    # Associate the lens from the WorkloadId
    try:
        response=waclient.associate_lenses(
        WorkloadId=workloadId,
        LensAliases=lens
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)


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

def findQuestionId(
    waclient,
    workloadId,
    lensAlias,
    pillarId,
    questionTitle
    ):

    # Find a questionID using the questionTitle
    try:
        response=waclient.list_answers(
        WorkloadId=workloadId,
        LensAlias=lensAlias,
        PillarId=pillarId
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    answers = response['AnswerSummaries']
    while "NextToken" in response:
        response = waclient.list_answers(WorkloadId=workloadId,LensAlias=lensAlias,PillarId=pillarId,NextToken=response["NextToken"])
        answers.extend(response["AnswerSummaries"])

    jmesquery = "[?starts_with(QuestionTitle, `"+questionTitle+"`) == `true`].QuestionId"
    questionId = jmespath.search(jmesquery, answers)

    return questionId[0]

def findChoiceId(
    waclient,
    workloadId,
    lensAlias,
    questionId,
    choiceTitle,
    ):

    # Find a choiceId using the choiceTitle
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

    jmesquery = "Answer.Choices[?starts_with(Title, `"+choiceTitle+"`) == `true`].ChoiceId"
    choiceId = jmespath.search(jmesquery, response)

    return choiceId[0]

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

def getNotesForQuestion(
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
    # jmesquery = "Answer.Notes"
    # answers = jmespath.search(jmesquery, response)
    response = response['Answer']
    answers = response['Notes'] if "Notes" in response else ""

    # print(answers)
    return answers

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

def listMilestones(
    waclient,
    workloadId
    ):

    # Find a milestone for a workloadId
    try:
        response=waclient.list_milestones(
        WorkloadId=workloadId,
        MaxResults=50 # Need to check why I am having to pass this parameter
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)
    # print("Full JSON:",json.dumps(response['MilestoneSummaries'], cls=DateTimeEncoder))
    milestoneNumber = response['MilestoneSummaries']
    return milestoneNumber

def createMilestone(
    waclient,
    workloadId,
    milestoneName
    ):

    # Create a new milestone with milestoneName
    try:
        response=waclient.create_milestone(
        WorkloadId=workloadId,
        MilestoneName=milestoneName
        )
    except waclient.exceptions.ConflictException as e:
        milestones = listMilestones(waclient,workloadId)
        jmesquery = "[?starts_with(MilestoneName,`"+milestoneName+"`) == `true`].MilestoneNumber"
        milestoneNumber = jmespath.search(jmesquery,milestones)
        logger.error("ERROR - The milestone name %s already exists as milestone %s" % (milestoneName, milestoneNumber))
        return milestoneNumber[0]
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print("Full JSON:",json.dumps(response['MilestoneSummaries'], cls=DateTimeEncoder))
    milestoneNumber = response['MilestoneNumber']
    return milestoneNumber

def getMilestone(
    waclient,
    workloadId,
    milestoneNumber
    ):

    # Use get_milestone to return the milestone structure
    try:
        response=waclient.get_milestone(
        WorkloadId=workloadId,
        MilestoneNumber=milestoneNumber
        )
    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print("Full JSON:",json.dumps(response['Milestone'], cls=DateTimeEncoder))
    milestoneResponse = response['Milestone']
    return milestoneResponse

def getMilestoneRiskCounts(
    waclient,
    workloadId,
    milestoneNumber
    ):

    # Return just the RiskCount for a particular milestoneNumber

    milestone = getMilestone(waclient,workloadId,milestoneNumber)
    # print("Full JSON:",json.dumps(milestone['Workload']['RiskCounts'], cls=DateTimeEncoder))
    milestoneRiskCounts = milestone['Workload']['RiskCounts']
    return milestoneRiskCounts

def listAllAnswers(
    waclient,
    workloadId,
    lensAlias,
    milestoneNumber=""
    ):

    # Get a list of all answers
    try:
        if milestoneNumber:
            response=waclient.list_answers(
            WorkloadId=workloadId,
            LensAlias=lensAlias,
            MilestoneNumber=milestoneNumber
            )
        else:
            response=waclient.list_answers(
            WorkloadId=workloadId,
            LensAlias=lensAlias
            )

    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    answers = response['AnswerSummaries']
    while "NextToken" in response:
        if milestoneNumber:
            response = waclient.list_answers(WorkloadId=workloadId,LensAlias=lensAlias,MilestoneNumber=milestoneNumber,NextToken=response["NextToken"])
        else:
            response = waclient.list_answers(WorkloadId=workloadId,LensAlias=lensAlias,NextToken=response["NextToken"])
        answers.extend(response["AnswerSummaries"])

    # print("Full JSON:",json.dumps(answers, cls=DateTimeEncoder))
    return answers

def getLensReview(
    waclient,
    workloadId,
    lensAlias,
    milestoneNumber=""
    ):

    # Use get_lens_review to return the lens review structure
    try:
        if milestoneNumber:
            response=waclient.get_lens_review(
            WorkloadId=workloadId,
            LensAlias=lensAlias,
            MilestoneNumber=milestoneNumber
            )
        else:
            response=waclient.get_lens_review(
            WorkloadId=workloadId,
            LensAlias=lensAlias
            )

    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print("Full JSON:",json.dumps(response['LensReview'], cls=DateTimeEncoder))
    lensReview = response['LensReview']
    return lensReview

def getLensReviewPDFReport(
    waclient,
    workloadId,
    lensAlias,
    milestoneNumber=""
    ):

    # Use get_lens_review_report to return the lens review PDF in base64 structure
    try:
        if milestoneNumber:
            response=waclient.get_lens_review_report(
            WorkloadId=workloadId,
            LensAlias=lensAlias,
            MilestoneNumber=milestoneNumber
            )
        else:
            response=waclient.get_lens_review_report(
            WorkloadId=workloadId,
            LensAlias=lensAlias
            )

    except botocore.exceptions.ParamValidationError as e:
        logger.error("ERROR - Parameter validation error: %s" % e)
    except botocore.exceptions.ClientError as e:
        logger.error("ERROR - Unexpected error: %s" % e)

    # print("Full JSON:",json.dumps(response['LensReviewReport']['Base64String'], cls=DateTimeEncoder))
    lensReviewPDF = response['LensReviewReport']['Base64String']
    return lensReviewPDF

def main():
    boto3_min_version = "1.16.38"
    # Verify if the version of Boto3 we are running has the wellarchitected APIs included
    if (packaging.version.parse(boto3.__version__) < packaging.version.parse(boto3_min_version)):
        logger.error("Your Boto3 version (%s) is less than %s. You must ugprade to run this script (pip3 install boto3 --upgrade --user)" % (boto3.__version__, boto3_min_version))
        exit()

    # STEP 1 - Configure environment
    logger.info("Starting Boto %s Session" % boto3.__version__)
    # Create a new boto3 session
    if FROM_ACCOUNT:
        SESSION1 = boto3.session.Session(profile_name=FROM_ACCOUNT)
    else:
        SESSION1 = boto3.session.Session()
    if TO_ACCOUNT:
        SESSION2 = boto3.session.Session(profile_name=TO_ACCOUNT)
    else:
        SESSION2 = boto3.session.Session()
    # Initiate the well-architected session using the region defined above
    WACLIENT = SESSION1.client(
        service_name='wellarchitected',
        region_name=REGION_NAME,
    )

    WACLIENT_TO = SESSION2.client(
        service_name='wellarchitected',
        region_name=TO_REGION_NAME,
    )



    logger.info("Copy WorkloadID '%s' from '%s:%s' to '%s:%s'" % (FROM_WORKLOADID,REGION_NAME,FROM_ACCOUNT,TO_REGION_NAME,TO_ACCOUNT))
    # Ignoring milestones for now, will add later if interested
    workloadId = FROM_WORKLOADID
    # Find out what lenses apply to the from workloadid
    workloadJson = GetWorkload(WACLIENT,workloadId)
    WorkloadARN = workloadJson['WorkloadArn']
    # For each of the optional variables, lets check and see if we have them first:
    Notes = workloadJson['Notes'] if "Notes" in workloadJson else ""
    nonAwsRegions = workloadJson['NonAwsRegions'] if "NonAwsRegions" in workloadJson else []
    architecturalDesign = workloadJson['ArchitecturalDesign'] if "ArchitecturalDesign" in workloadJson else ""
    industryType = workloadJson['IndustryType'] if "IndustryType" in workloadJson else ""
    industry = workloadJson['Industry'] if "Industry" in workloadJson else ""
    accountIds = workloadJson['AccountIds'] if "AccountIds" in workloadJson else []
    tagresponse = WACLIENT.list_tags_for_resource(WorkloadArn=WorkloadARN)
    tags = tagresponse['Tags'] if "Tags" in tagresponse else []

    # Create the new workload to copy into
    toWorkloadId,toWorkloadARN = CreateNewWorkload(WACLIENT_TO,
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
        logger.info("Retrieving all answers for lens %s" % lens)
        answers = listAllAnswers(WACLIENT,workloadId,lens)
        # Ensure the lens is attached to the new workload
        associateLens(WACLIENT_TO,toWorkloadId,[lens])
        logger.info("Copying answers into new workload for lens %s" % lens)
        for answerCopy in answers:
            notesField = ''
            notesField = getNotesForQuestion(WACLIENT,workloadId,lens,answerCopy['QuestionId'])
            updateAnswersForQuestion(WACLIENT_TO,toWorkloadId,lens,answerCopy['QuestionId'],answerCopy['SelectedChoices'],notesField)

    logger.info("Copy complete - exiting")


if __name__ == "__main__":
    main()
