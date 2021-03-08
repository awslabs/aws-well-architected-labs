#!/usr/bin/env pwsh

# This is a simple Powershell app for use with the Well-Architected labs
# This will simulate all of the steps in the 200-level lab on using the
#  Well-Architected API calls
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

# Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.618.0'}


$__author__    = "Eric Pullen"
$__email__     = "eppullen@amazon.com"
$__copyright__ = "Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved."
$__credits__   = @({"Eric Pullen"})

# Default region listed here
$REGION_NAME = "us-east-1"

# Setup Log Message Routine to print current date/time to console
function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    Write-Output ("{0} - {1}" -f (Get-Date), $LogMessage)
}

function Find-Workload
{
  [CmdletBinding()]
  Param
  (
      [Parameter(Mandatory=$true)]
      [string]$workloadName
  )

  $response = Get-WATWorkloadList -WorkloadNamePrefix $workloadName
  if (!$response.WorkloadId)
  {
    Write-Warning ("Did not find a workload called "+$workloadName) -InformationAction Continue
  }

  return $response.WorkloadId
}

function Create-New-Workload
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$workloadName,
        [Parameter(Mandatory=$true)]
        [string]$description,
        [Parameter(Mandatory=$true)]
        [string]$reviewOwner,
        [Parameter(Mandatory=$true)]
        [string]$environment,
        [Parameter(Mandatory=$true)]
        [array]$awsRegions,
        [Parameter(Mandatory=$true)]
        [array]$lenses
    )
    try
     {
       $response = New-WATWorkload -WorkloadName $workloadName -Description $description -ReviewOwner $reviewOwner -Environment $environment -AwsRegion $awsRegions -Lense $lenses
       $returnValue = $response.WorkloadId
     }
    catch [Amazon.WellArchitected.Model.ConflictException]
    {
      Write-Warning ("Conflict - Found a workload that already exists with the name "+$workloadName+". Finding the workloadId to return") -InformationAction Continue
      $returnValue = Find-Workload $workloadName
    }
    return $returnValue
}

function Create-New-Milestone
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$workloadId,
        [Parameter(Mandatory=$true)]
        [string]$milestoneName
    )
    try
     {
       $response = New-WATMilestone -WorkloadId $workloadId -MilestoneName $milestoneName
       $returnValue = $response
     }
    catch [Amazon.WellArchitected.Model.ConflictException]
    {
      Write-Warning ("Conflict - Found a milestone that already exists with the name "+$milestoneName+". Finding the milestone to return") -InformationAction Continue
      $milestoneReturn = Get-WATMilestoneList -WorkloadId $workloadId
      $foundMilestone = $milestoneReturn.MilestoneSummaries | where {$_.MilestoneName -like $milestoneName+"*" }
      $returnValue = $foundMilestone
    }
    return $returnValue
}

$WORKLOADNAME = 'WA Lab Test Workload'
$DESCRIPTION = 'Test Workload for WA Lab'
$REVIEWOWNER = 'WA Python Script'
$ENVIRONMENT= 'PRODUCTION'
$AWSREGIONS = @($REGION_NAME)
$LENSES = @('wellarchitected', 'serverless')

Log-Message ("1 - Starting LabExample.ps1")

# STEP 2 - Creating a workload
#  https://wellarchitectedlabs.com/well-architectedtool/200_labs/200_using_awscli_to_manage_wa_reviews/2_create_workload/
Log-Message ("2 - Creating new workload")

$createId = Create-New-Workload $WORKLOADNAME $DESCRIPTION $REVIEWOWNER $ENVIRONMENT $AWSREGIONS $LENSES
Log-Message ("Created with new workloadId: "+$createId)

Log-Message ("2 - Finding your WorkloadId for name "+$WORKLOADNAME)
$workloadId = Find-Workload $WORKLOADNAME
Log-Message ("New workload created with id " + $workloadId)

Log-Message ("2 - Using WorkloadId to remove and add lenses")
$listOfLenses = Get-WATLenseList
Log-Message ("Lenses currently available: "+$listOfLenses.LensAlias)

$workload = Get-WATWorkload -WorkloadId $workloadId
Log-Message ("WorkloadId "+$workloadId+" has lenses '"+$workload.Lenses+"'")
Log-Message ("Removing the serverless lens")
Remove-WATLense -WorkloadId $workloadId -LensAlias "serverless" -Force
$workload = Get-WATWorkload -WorkloadId $workloadId
Log-Message ("WorkloadId "+$workloadId+" has lenses '"+$workload.Lenses+"'")

Log-Message ("Adding serverless lens back into the workload")
Add-WATLense -WorkloadId $workloadId -LensAlias "serverless" -Force
$workload = Get-WATWorkload -WorkloadId $workloadId
Log-Message ("WorkloadId "+$workloadId+" has lenses '"+$workload.Lenses+"'")

# STEP 3 - Performing a review
# https://wellarchitectedlabs.com/well-architectedtool/200_labs/200_using_awscli_to_manage_wa_reviews/3_perform_review/
Log-Message ("3 - Performing a review")
Log-Message ("3 - STEP1 - Find the QuestionId and ChoiceID for a particular pillar question and best practice")

$questionSearch = "How do you reduce defects, ease remediation, and improve flow into production"

$questionReturn = Get-WATAnswerList -WorkloadId $workloadId -LensAlias "wellarchitected" -PillarId "operationalExcellence"
$foundQuestion = $questionReturn.AnswerSummaries | where { $_.QuestionTitle -like $questionSearch+"*" }
$questionId = $foundQuestion.QuestionId
Log-Message ("Found QuestionID of "+$questionId+" for the question text of '"+$questionSearch+"'")

$choiceSet = @()

$answerReturn = Get-WATAnswer -WorkloadId $workloadId -LensAlias "wellarchitected" -QuestionId $questionId
$answerSearch = "Use version control"
$foundAnswer = $answerReturn.Answer.Choices | where {$_.Title -like $answerSearch+"*" }
$choiceSet += $foundAnswer.ChoiceId
Log-Message ("Found choiceId of '"+$choiceSet+"' for the choice text of 'Use version control'")
$answerSearch = "Use configuration management systems"
$foundAnswer = $answerReturn.Answer.Choices | where {$_.Title -like $answerSearch+"*" }
$choiceSet += $foundAnswer.ChoiceId
$answerSearch = "Use build and deployment management systems"
$foundAnswer = $answerReturn.Answer.Choices | where {$_.Title -like $answerSearch+"*" }
$choiceSet += $foundAnswer.ChoiceId
$answerSearch = "Perform patch management"
$foundAnswer = $answerReturn.Answer.Choices | where {$_.Title -like $answerSearch+"*" }
$choiceSet += $foundAnswer.ChoiceId
$answerSearch = "Use multiple environments"
$foundAnswer = $answerReturn.Answer.Choices | where {$_.Title -like $answerSearch+"*" }
$choiceSet += $foundAnswer.ChoiceId
Log-Message ("All choices we will select for questionId of "+$questionId+" is " + $choiceSet)

Log-Message ("3 - STEP2 - Use the QuestionID and ChoiceID to update the answer in well-architected review")
Log-Message ("Current answer for questionId '"+$questionId+"' is '"+$answerReturn.Answer.SelectedChoices+"'")
Log-Message ("Adding answers found in choices above '"+$choiceSet+"'")

$updateResponse = Update-WATAnswer -WorkloadId $workloadId -LensAlias "wellarchitected" -QuestionId $questionId -SelectedChoices $choiceSet -Notes "Question modified by PowerShell script"
$answerReturn = Get-WATAnswer -WorkloadId $workloadId -LensAlias "wellarchitected" -QuestionId $questionId
Log-Message ("Now the answer for questionId '"+$questionId+"' is '"+$answerReturn.Answer.SelectedChoices+"'")

# STEP 4 - Saving a milestone
# https://wellarchitectedlabs.com/well-architectedtool/200_labs/200_using_awscli_to_manage_wa_reviews/4_save_milestone/
Log-Message ("4 - Saving a Milestone")

Log-Message ("4 - STEP1 - Create a Milestone")
$milestoneReturn = Get-WATMilestoneList -WorkloadId $workloadId
Log-Message ("Workload "+$workloadId+" has "+($milestoneReturn.MilestoneSummaries | measure ).Count+" milestones")
$createMilestoneResponse = Create-New-Milestone $workloadId "Rev1"
$createdmilestoneNumber = $createMilestoneResponse.MilestoneNumber
Log-Message ("Created Milestone #"+$createMilestoneResponse.MilestoneNumber+" called Rev1")

Log-Message ("4 - STEP2 - List all Milestones")
$milestoneReturn = Get-WATMilestoneList -WorkloadId $workloadId

Log-Message ("Now workload "+$workloadId+" has "+($milestoneReturn.MilestoneSummaries | measure ).Count+" milestones")
Log-Message ("4 - STEP3 - Retrieve the results from a milestone")
$milestoneDetailReturn = Get-WATMilestone -WorkloadId $workloadId -MilestoneNumber $createdmilestoneNumber
$riskCounts = $milestoneDetailReturn.Milestone.Workload.RiskCounts
Log-Message ("Risk counts for all lenses for milestone "+$createdmilestoneNumber+" are: "+($riskCounts | Out-String))

Log-Message ("4 - STEP4 - List all question and answers based from a milestone")
$questionReturn = Get-WATAnswerList -WorkloadId $workloadId -LensAlias "wellarchitected" -MilestoneNumber $createdmilestoneNumber

# STEP 5 - Viewing and downloading the report
# https://wellarchitectedlabs.com/well-architectedtool/200_labs/200_using_awscli_to_manage_wa_reviews/5_view_report/
Log-Message ("5 - Viewing and downloading the report")
Log-Message ("5 - STEP1 - Gather pillar and risk data for a workload")

$LensReviewReturn = Get-WATLensReview -WorkloadId $workloadId -LensAlias "wellarchitected"
$LensReviewRiskCounts = $LensReviewReturn.LensReview.RiskCounts

Log-Message ("The Well-Architected base framework has the following RiskCounts "+($LensReviewRiskCounts | Out-String))

Log-Message ("5 - STEP2 - Generate and download workload PDF")

$LensPDFReviewReturn = Get-WATLensReviewReport -WorkloadId $workloadId -LensAlias "wellarchitected"
$filename = 'WAReviewOutput.pdf'
$bytes = [Convert]::FromBase64String($LensPDFReviewReturn.LensReviewReport.Base64String)
[IO.File]::WriteAllBytes($filename, $bytes)

# STEP 6 - Teardown
# https://wellarchitectedlabs.com/well-architectedtool/200_labs/200_using_awscli_to_manage_wa_reviews/6_cleanup/
Log-Message ("6 - Teardown")

# Allow user to keep the workload
Read-Host -Prompt "Press any key to continue or CTRL+C to quit"
Log-Message ("6 - STEP1 - Delete Workload")
Remove-WATWorkload -WorkloadId $workloadId -ClientRequestToken "ClientRequestToken1" -Force
# ClientRequestToken is required at this time, but we are investigating if we can remove this in the future.
