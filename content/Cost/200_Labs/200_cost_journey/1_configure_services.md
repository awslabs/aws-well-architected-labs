---
title: "Configure Services"
date: 2021-03-01T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Create S3 Bucket
Create a **single S3 bucket** that will contain the journey files for all workloads in that account.

1. Log into the console via SSO, go to the **S3** service page

2. Click **Create bucket**

3. Enter a **Bucket name** starting with **cost** (we have used cost-wa-reports, you will need to use a unique bucket name) and click **Create bucket**:
![Images/s3_bucketcreate.png](/Cost/200_cost_journey/Images/s3_bucketcreate.png)

4. Upload the following object into the bucket.
[Code/cost_journey.csv](/Cost/200_cost_journey/Code/cost_journey.csv)

{{% notice tip %}}
You can edit this CSV file to customize your journey for your organization. The definitions used within this file are at the end of this lab in the tear down step.
{{% /notice %}}

{{% notice note %}}
You have now setup the S3 bucket which contains your organizations journey configuration, all the journeys for the workloads.
{{% /notice %}}



### Create the Lambda Function
1. Go to the **Lambda Console**

2. Click **Create function**

3. Select **Author from scratch**

4. Enter a function name of **Cost_W-A_Journey**

4. Select a runtime of **Python 3.6**, this is a specifically required version

5. Under **Permissions**:
 - **Execution role**: Create a new role from AWS policy templates
 - **Role name**: extract-wa-reports_role


6. Click **Create function**:
![Images/lambda_create.png](/Cost/200_cost_journey/Images/lambda_create.png)

7. Select the **lambda_function.py** and paste the following code:

	{{%expand "Lambda function code" %}}

	import boto3
	import json
	import os
	import logging
	import urllib.parse
	
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	
	s3_bucket = os.environ['S3_BUCKET']
	s3_key = os.environ['S3_KEY']
	Image_XSize = os.environ['Image_XSize']
	Image_YSize = os.environ['Image_YSize']
	
	#################
	# Boto3 Clients #
	#################
	wa_client = boto3.client('wellarchitected')
	s3_client = boto3.client('s3')
	
	##############
	# Parameters #
	##############
	# The maximum number of results the API can return in a list workloads call.
	list_workloads_max_results_maximum = 50
	# The maximum number of results the API can return in a list answers call.
	list_answers_max_results_maximum = 50
	# The maximum number of results the API can return in a list milestones call.
	list_milestone_max_results_maximum = 50
	
	
	def get_all_workloads():
	    # Get a list of all workloads
	    list_workloads_result = wa_client.list_workloads(MaxResults=list_workloads_max_results_maximum)
	    logger.info(f'Found {len(list_workloads_result)} Well-Archtected workloads.')
	    workloads_all = list_workloads_result['WorkloadSummaries']
	    while 'NextToken' in list_workloads_result:
	        next_token = list_workloads_result['NextToken']
	        list_workloads_result = wa_client.list_workloads(
	            MaxResults=list_workloads_max_results_maximum, NextToken=next_token
	        )
	        workloads_all += list_workloads_result['WorkloadSummaries']
	    return (workloads_all)
	
	
	def get_milestones(workload_id):
	    # Get latest milestone review date
	    milestones = wa_client.list_milestones(
	        WorkloadId=workload_id, MaxResults=list_milestone_max_results_maximum
	    )['MilestoneSummaries']
	
	    # If workload has milestone get them.
	    logger.info(f'Workload {workload_id} has {len(milestones)} milestones.')
	    if milestones:
	        for milestone in milestones:
	            milestone['RecordedAt'] = milestone['RecordedAt'].isoformat()
	    return milestones
	
	
	def get_lens(workload_id):
	    # Which lenses have been activated for this workload
	    lens_reviews_result = wa_client.list_lens_reviews(
	        WorkloadId=workload_id
	    )['LensReviewSummaries']
	
	    # An array to hold the reviews we specifically want, in this case its those that used the 'wellarchitected' lens
	    lens_reviews = []
	
	    # Go through each lens review & look for W-A lenses of the right version
	    for lens_review in lens_reviews_result:
	        alias = lens_review['LensAlias']
	        version = lens_review['LensVersion']
	
	        # Add W-A lenses from the right version only to the array
	        if ("wellarchitected" in alias) and ("2020-07-02" in version):
	                    lens_reviews.append(lens_review)
	
	    # return the selected lens reviews
	    logger.info(f'Workload {workload_id} has used {len(lens_reviews)} lens')
	    return lens_reviews
	
	
	
	def get_lens_answers(workload_id, lens_reviews):
	    # Loop through each activated lens
	    list_answers_result = []
	    for lens in lens_reviews:
	        lens_name = lens['LensName']
	        logger.info(f'Looking at {lens_name} answers for Workload {workload_id}')
	
	        # Get All answers for the lens
	        list_answers_reponse = wa_client.list_answers(
	            WorkloadId=workload_id, LensAlias=lens['LensAlias'], MaxResults=list_answers_max_results_maximum
	        )
	
	        # An array to hold the answers that were 'selected' in the review
	        cost_answers = []
	
	        # Flatten the answer result to include LensAlias and Milestone Number
	        for answer_result in list_answers_reponse['AnswerSummaries']:
	            pillarid = answer_result['PillarId']
	
	            # If its a cost answer/Best practice that was selected, then store it
	            if "costOptimization" in pillarid:
	                # Get the list of selected answers/best practices
	                answers = answer_result['SelectedChoices']
	                
	                # Go through each selected answer
	                for answer in answers:
	                    
	                    # Remove answers with '_no', as they are the "none of these" answers
	                    if "_no" not in answer:
	                        
	                        # Add all selected answers to the array
	                        cost_answers.append(answer)
	
	    # Return all selected cost answers/best practices
	    return cost_answers
	
	
	
	def get_journey():
	    # Get the cost journey information from S3
	    response = s3_client.get_object(
	        Bucket=s3_bucket,
	        Key='cost_journey.csv'
	    )
	    
	    
	    data = []
	    # Array of dicts/maps, that have all the best practices & their journey attributes from the journey file
	    best_practices = []
	    
	    # Get the file contents & split it line by line, remove trailing formatting characters
	    data = response['Body'].read().decode('utf-8')
	    lines = data.split('\r\n')
	
	    # Go through each line in the journey file
	    for line in lines:
	        
	        # Only get lines with "cost", which ignores the header line
	        if "cost" in line:
	            
	            # Break the line up by ',', as its a CSV
	            line_attributes = line.split(',')
	            
	            # Put each element into a dict/map
	            best_practice_attributes = {"id": line_attributes[0], "name": line_attributes[1], "risk": line_attributes[2], "phase": int(line_attributes[3]), "order": int(line_attributes[4]), "effort": int(line_attributes[5]), "duration": int(line_attributes[6]), "frequency": line_attributes[7]}
	            
	            # Add the map into an array
	            best_practices.append(best_practice_attributes)
	
	    # Find out how big each phase is, so we can scale the image accordingly
	    ph1_sum = 0
	    ph2_sum = 0
	    ph3_sum = 0
	    ph4_sum = 0
	    
	    # The size of each phase is the effort of all best practices + the duration between them
	    # Go through each best practice
	    for best_practice in best_practices:
	        # If its a cost BP, ignore the header or any other non-cost BPs
	        if "cost" in best_practice['id']:
	            # Get the phase of the best prac incase they are not ordered in the file
	            phase = best_practice['phase']
	
	            # Add the effort & duration to each phases total
	            if phase == 1:
	                ph1_sum = ph1_sum + best_practice['effort'] + best_practice['duration']
	            elif phase == 2:
	                ph2_sum = ph2_sum + best_practice['effort'] + best_practice['duration']
	            elif phase == 3:
	                ph3_sum = ph3_sum + best_practice['effort'] + best_practice['duration']
	            elif phase == 4:
	                ph4_sum = ph4_sum + best_practice['effort'] + best_practice['duration']
	            
	
	    # Put the scale factor of each phase into an array
	    # The phases are staggered, ph1: x=0, ph2 = x=150, ph3 = x=300, ph4 = x=450
	    # The scale is (total image size - stagger) / phase_size. So that each phase could be scaled to fit the Image_XSize specified
	    phase_scales = [(int(Image_XSize) - 0) / int(ph1_sum), (int(Image_XSize) - 150) / int(ph2_sum), (int(Image_XSize) - 300) / int(ph3_sum), (int(Image_XSize) - 450) / int(ph4_sum)]
	    
	    # Scale all phases by the smallest overall factor - which is the largest phase
	    x_scale_factor = min(phase_scales)
	    
	    # Return the image scale factor & the answers/best practices from the journey file
	    return x_scale_factor, best_practices
	
	
	def draw_journey(scale_factor, best_practices, report_answers):
	    # Current cursor positions, come in & down a little from the top left
	    current_xpos = 10
	    current_ypos = 10*scale_factor + 10
	
	    # Create html file headers & part of the body
	    wa_journey = "<HTML xmlns=\"http://www.w3.org/1999/xhtml\">\n<HEAD>\n<meta charset=\"utf-8\"></meta>\n\t<TITLE>Journey</TITLE>\n</HEAD>\n\n"
	    wa_journey = wa_journey + "<BODY>\n\t<p>Here is the journey</p>\n\t\t<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1080\" height=\"1920\">\n"
	    wa_journey = wa_journey + "\t\t<svg width=\"" + str(Image_XSize) + "\" height=\"" + str(Image_YSize) + "\">\n"
	
	    # loop counter & tracking of the current phase so we can drop down on the next phase
	    x = 1
	    current_phase = 1
	
	    # Go through each best practice
	    while x <= len(best_practices):
	        # Get the best practices in order
	        current_bestprac = dict(list(filter(lambda best_practice: best_practice['order'] == x, best_practices))[0])
	
	        # If its a new phase move down & across in the image, otherwise hold steady
	        if current_bestprac['phase'] == current_phase:
	            current_ypos = current_ypos
	        else:
	            # Move across by 150 from the prevoius phase to stagger the start
	            current_xpos = current_phase * 150
	            # Move down by 10 (maximum effort/diameter) x scale factor, + a buffer of 10px
	            current_ypos = current_ypos + 10*scale_factor + 10
	            # We're on a new phase
	            current_phase = current_phase + 1
	
	        # Move to the center of the next circle, which is adding the duration between and half effort (radius) from previous point
	        current_xpos = current_xpos + (current_bestprac['duration'])/2*scale_factor + (current_bestprac['effort'])/2*scale_factor
	        
	        # Check if it was a selected best practice/answer, if so colour it green
	        if current_bestprac['id'] in report_answers: 
	            # print Green
	            wa_journey = wa_journey + "<circle cx=\"" + str(current_xpos) + "\" cy=\"" + str(current_ypos) + "\" r=\"" + str(current_bestprac["effort"]/2 * scale_factor) + "\" stroke=\"black\" stroke-width=\"" + str(current_bestprac['frequency']) + "\" fill=\"green\">\n"
	            wa_journey = wa_journey + "<title>" + current_bestprac['name'] + "</title>\n"
	            wa_journey = wa_journey + "</circle>\n"
	        # It wasnt selected so print red for high risk or blue otherwise
	        else:
	            # print red if high risk
	            if current_bestprac['risk'] == "High":
	                wa_journey = wa_journey + "<circle cx=\"" + str(current_xpos) + "\" cy=\"" + str(current_ypos) + "\" r=\"" + str(current_bestprac["effort"]/2 * scale_factor) + "\" stroke=\"black\" stroke-width=\"" + str(current_bestprac['frequency']) + "\" fill=\"red\">\n"
	                wa_journey = wa_journey + "<title>" + current_bestprac['name'] + "</title>\n"
	                wa_journey = wa_journey + "</circle>\n"
	            # print blue otherwise
	            else:
	                wa_journey = wa_journey + "<circle cx=\"" + str(current_xpos) + "\" cy=\"" + str(current_ypos) + "\" r=\"" + str(current_bestprac["effort"]/2 * scale_factor) + "\" stroke=\"black\" stroke-width=\"" + str(current_bestprac['frequency']) + "\" fill=\"blue\">\n"
	                wa_journey = wa_journey + "<title>" + current_bestprac['name'] + "</title>n"
	                wa_journey = wa_journey + "</circle>\n"
	
	        # Move to the end of the current circle, add half the effort
	        current_xpos = current_xpos + (current_bestprac['effort'])/2*scale_factor
	
	        # Onto the next best practice
	        x = x + 1
	
	    # Add the trailing HTML
	    wa_journey = wa_journey + "<script type=\"text/javascript\"><![CDATA[\n\t(function() {\n\t\tvar tooltip = document.getElementById('tooltip');\n\t\t})();\n\t]>\n\n\t\tvar triggers = document.getElementsByClassName('tooltip-trigger');\n\tfor (var i = 0; i < triggers.length; i++) {\n\ttriggers[i].addEventListener('mousemove', showTooltip);\n\t\ttriggers[i].addEventListener('mouseout', hideTooltip);\n\t}\n\n\tfunction showTooltip(evt) {\n\t\ttooltip.setAttributeNS(null, \"visibility\", \"visible\");\n\t}\n\tfunction hideTooltip() {\n\t\ttooltip.setAttributeNS(null, \"visibility\", \"hidden\");\n\t}"
	    wa_journey = wa_journey + "</SVG>\n</BODY>\n</HTML>\n"
	
	    # Return the html text of the journey
	    return wa_journey
	
	
	
	
	def lambda_handler(event, context):
	    workloads_all = get_all_workloads()
	    # Generate workload JSON file
	    logger.info(f'Generate JSON object for each workload.')
	
	    # Text to build the HTML index file of all workloads
	    generated_workloads = "<HTML>\n<HEAD>\n</HEAD>\n<BODY>\n"
	
	    for workload in workloads_all:
	        # Get workload info from WAR Tool API,
	        workload_id = workload['WorkloadId']
	        workload_name = workload['WorkloadName']
	
	        milestones = get_milestones(workload_id)
	        lens_reviews = get_lens(workload_id)
	
	        if len(lens_reviews) > 0:
	            list_answers_result = get_lens_answers(workload_id, lens_reviews)
	
	            # Build JSON of workload data
	            workload_report_data = {}
	
	            # Get the answers from the W-A report
	            workload_report_data['report_answers'] = list_answers_result
	
	            # Get the scale factor & best practices from the journey file
	            scale_factor, best_practices = get_journey()
	            
	            # Create the Journey image & HTML file te
	            journey_image = draw_journey(scale_factor, best_practices, workload_report_data['report_answers'])
	
	
	            # Write to S3
	            journey_file_name = workload_name + '_' + workload_id + '.html'
	            html_link = "https://" + s3_bucket + '.s3.amazonaws.com/' + s3_key + '/' + urllib.parse.quote_plus(journey_file_name)
	            
	            s3_client.put_object(
	                Body=journey_image,
	                Bucket=s3_bucket,
	                Key=f'{s3_key}/{journey_file_name}'
	            )
	            
	            # Add the next workload file to the index file
	            generated_workloads = generated_workloads + "<A href=\"" + html_link + "\">" + workload_name + "</A><BR>\n"
	    
	    # Add the closing HTML in the index file
	    generated_workloads = generated_workloads + "</HTML>"
	
	    # Write the index file to the S3 bucket        
	    file_name = "W-A Workload Journeys.html"
	    s3_client.put_object(
	            Body=generated_workloads,
	            Bucket=s3_bucket,
	            Key=f'{file_name}'
	        )

	{{% /expand%}}

8. Above the code click **Configuration**, select **Environment variables**
![Images/lambda_config.png](/Cost/200_cost_journey/Images/lambda_config.png)

9. Click **Edit** and add the following variables, then click **Save**
 - **Image_XSize** - 1440
 - **Image_YSize** - 900
 - **S3_BUCKET** - (the name of your bucket created previously)
 - **S3_KEY** - WorkloadReports
![Images/lambda_envvariables.png](/Cost/200_cost_journey/Images/lambda_envvariables.png)

10. Select **General configuration**, click **Edit**, change the timeout to 1min, click **Save**

{{% notice note %}}
You have now created the lambda function, however we need to add permissions before its run
{{% /notice %}}

### Create the IAM Role
Modify the IAM role that is used by the Lambda function, to allow access to your S3 bucket and your Well-Architected reviews.

1. Go to the **IAM Console**

2. Go to **Roles** and select the **extract-wa-reports_role** role

3. Add an **inline policy**

4. Modify the policy below replacing **<S3_BUCKET_NAME>**, and paste it into the json:

        {
		    "Version": "2012-10-17",
		    "Statement": [
    			{
				    "Action": [
    					"s3:GetObject",
					    "s3:PutObject"
				    ],
				    "Resource": "arn:aws:s3:::<S3_BUCKET_NAME>*",
				    "Effect": "Allow"
			    }
		    ]
	    }

5. Click **Review policy**, enter a name of **WAReportAccess** click **Create policy**

6. Click **Attach policies**, and attach the **WellArchitectedConsoleReadOnlyAccess**

![Images/iam_modifyrole.png](/Cost/200_cost_journey/Images/iam_modifyrole.png)


{{% notice note %}}
You have now added the required permissions and all configuration is complete.
{{% /notice %}}


{{< prev_next_button link_prev_url="../" link_next_url="../2_create_journey/" />}}
