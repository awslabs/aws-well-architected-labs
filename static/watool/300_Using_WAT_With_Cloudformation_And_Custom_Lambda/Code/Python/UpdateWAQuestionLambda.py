import botocore
import boto3
import json
import datetime
from aws_lambda_powertools import Logger
import jmespath
import cfnresponse
from pkg_resources import packaging

__author__    = "Eric Pullen"
__email__     = "eppullen@amazon.com"
__copyright__ = "Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved."
__credits__   = ["Eric Pullen"]

# Default region listed here
REGION_NAME = "us-east-1"
blankjson = {}
response = ""
logger = Logger()

# Helper class to convert a datetime item to JSON.
class DateTimeEncoder(json.JSONEncoder):
    def default(self, z):
        if isinstance(z, datetime.datetime):
            return (str(z))
        else:
            return super().default(z)

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

def lambda_handler(event, context):
    boto3_min_version = "1.16.38"
    # Verify if the version of Boto3 we are running has the wellarchitected APIs included
    if (packaging.version.parse(boto3.__version__) < packaging.version.parse(boto3_min_version)):
        logger.error("Your Boto3 version (%s) is less than %s. You must ugprade to run this script (pip3 upgrade boto3)" % (boto3.__version__, boto3_min_version))
        exit()
    responseData = {}
    print(json.dumps(event))
    try:
        WORKLOADID = event['ResourceProperties']['WorkloadId']
        PILLAR = event['ResourceProperties']['Pillar']
        LENS = event['ResourceProperties']['Lens']
        QUESTIONANSWERS = event['ResourceProperties']['QuestionAnswers']
        SERVICETOKEN = event['ResourceProperties']['ServiceToken']
    except:
        responseData['Error'] = "ERROR LOADING RESOURCE PROPERTIES"
        cfnresponse.send(event, context, cfnresponse.FAILED, responseData, 'createWAWorkloadHelperFunction')
        exit()
    IncomingARN = SERVICETOKEN.split(":")
    REGION_NAME = IncomingARN[3]


    logger.info("Starting Boto %s Session in %s" % (boto3.__version__, REGION_NAME))
    # Create a new boto3 session
    SESSION = boto3.session.Session()
    # Initiate the well-architected session using the region defined above
    WACLIENT = SESSION.client(
        service_name='wellarchitected',
        region_name=REGION_NAME,
    )

    for qaList in QUESTIONANSWERS:
        for question, answerList in qaList.items():
            print(question, answerList)
            # First we must find the questionID
            questionId = findQuestionId(WACLIENT,WORKLOADID,LENS,PILLAR,question)
            logger.info("Found QuestionID of '%s' for the question text of '%s'" % (questionId, question))
            choiceSet = []
            # Now we build the choice selection based on the answers provided
            for answers in answerList:
                choiceSet.append(findChoiceId(WACLIENT,WORKLOADID,LENS,questionId,answers))
            logger.info("All choices we will select for questionId of %s is %s" % (questionId, choiceSet))
            # Update the answer for the question
            updateAnswersForQuestion(WACLIENT,WORKLOADID,LENS,questionId,choiceSet,'Added by Python')
    # exit()
    cfnresponse.send(event, context, cfnresponse.SUCCESS, responseData, 'createWAWorkloadHelperFunction')


# SAMPLE JSON OBJECT TO PASS IN:
# {
#   "RequestType": "Create",
#   "ServiceToken": "arn:aws:lambda:us-east-1:299160763759:function:createNewWAWorkload",
#   "ResponseURL": "https://cloudformation-custom-resource-response-useast1.s3.amazonaws.com/arn%3Aaws%3Acloudformation%3Aus-east-1%3A299160763759%3Astack/test3/ad07a470-7d35-11eb-b059-125dcdb1e0b5%7CAnswerWAWorkloadQuestions%7C16728d5e-3a23-4a1d-b9fd-16c100f8532d?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20210305T022416Z&X-Amz-SignedHeaders=host&X-Amz-Expires=7200&X-Amz-Credential=AKIA6L7Q4OWT3UXBW442%2F20210305%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=9a9d8f0a36de0608cc0b3e32266d405981831afe9ee2d155609a4ffc11571f31",
#   "StackId": "arn:aws:cloudformation:us-east-1:299160763759:stack/test3/ad07a470-7d35-11eb-b059-125dcdb1e0b5",
#   "RequestId": "16728d5e-3a23-4a1d-b9fd-16c100f8532d",
#   "LogicalResourceId": "AnswerWAWorkloadQuestions",
#   "ResourceType": "Custom::AnswerWAWorkloadQuestionsHelperFunction",
#   "ResourceProperties": {
#     "ServiceToken": "arn:aws:lambda:us-east-1:299160763759:function:createNewWAWorkload",
#     "QuestionAnswers": [
#       {
#         "How do you determine what your priorities are": [
#           "Evaluate governance requirements",
#           "Evaluate compliance requirements"
#         ]
#       },
#       {
#         "How do you reduce defects, ease remediation, and improve flow into production": [
#           "Use version control",
#           "Perform patch management",
#           "Use multiple environments"
#         ]
#       }
#     ],
#     "Pillar": "operationalExcellence",
#     "Lens": "wellarchitected",
#     "WorkloadId": "d7ab8fbfac8a8c85bb08e985cb67f906"
#   }
# }
