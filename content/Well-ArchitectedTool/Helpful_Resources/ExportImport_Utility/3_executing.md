---
title: "Script usage examples"
date: 2021-05-19T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Exporting a workload to a JSON file
Example Command: `./exportImportWAFR.py -f test5.json --exportWorkload --profile acct2 -w c896b2b1142f6ea8dc22874674400002`

```shell
./exportImportWAFR.py -f workload_output.json --exportWorkload --profile acct2 -w c896b2b1142f6ea8dc22874674400002
2021-05-19 15:39:46.921 INFO exportImportWAFR - main: Script version 0.1
2021-05-19 15:39:46.921 INFO exportImportWAFR - main: Starting Boto 1.17.27 Session
2021-05-19 15:39:47.066 INFO exportImportWAFR - main: Exporting workload 'c896b2b1142f6ea8dc22874674400002' to file workload_output.json
2021-05-19 15:39:47.473 INFO exportImportWAFR - main: Gathering overall review for lens wellarchitected
2021-05-19 15:39:47.780 INFO exportImportWAFR - main: Retrieving all answers for lens wellarchitected
2021-05-19 15:40:00.024 INFO exportImportWAFR - main: Gathering overall review for lens serverless
2021-05-19 15:40:00.217 INFO exportImportWAFR - main: Retrieving all answers for lens serverless
2021-05-19 15:40:02.823 INFO exportImportWAFR - main: Gathering overall review for lens softwareasaservice
2021-05-19 15:40:03.052 INFO exportImportWAFR - main: Retrieving all answers for lens softwareasaservice
2021-05-19 15:40:14.197 INFO exportImportWAFR - main: Gathering overall review for lens foundationaltechnicalreview
2021-05-19 15:40:14.437 INFO exportImportWAFR - main: Retrieving all answers for lens foundationaltechnicalreview
2021-05-19 15:40:28.523 ERROR exportImportWAFR - findAllQuestionId: ERROR - Unexpected error: An error occurred (InternalServerErrorException) when calling the ListAnswers operation (reached max retries: 4): [InternalServerError] An internal error occurred.
2021-05-19 15:40:38.184 ERROR exportImportWAFR - findAllQuestionId: ERROR - Unexpected error: An error occurred (InternalServerErrorException) when calling the ListAnswers operation (reached max retries: 4): [InternalServerError] An internal error occurred.
2021-05-19 15:40:40.925 INFO exportImportWAFR - main: Export completed to file workload_output.json

```
## Importing a workload from a JSON file
Example Command: `./exportImportWAFR.py -f test5.json --importWorkload  --profile acct2 --region us-east-2`

```shell
./exportImportWAFR.py -f workload_output.json --importWorkload  --profile acct2 --region us-west-1
2021-05-19 15:41:31.711 INFO exportImportWAFR - main: Script version 0.1
2021-05-19 15:41:31.711 INFO exportImportWAFR - main: Starting Boto 1.17.27 Session
2021-05-19 15:41:31.836 INFO exportImportWAFR - main: Creating a new workload from file workload_output.json
2021-05-19 15:41:32.567 INFO exportImportWAFR - main: New workload id: c896b2b1142f6ea8dc22874674400003 (arn:aws:wellarchitected:us-west-1:222222222222:workload/c896b2b1142f6ea8dc22874674400003)
2021-05-19 15:41:32.567 INFO exportImportWAFR - main: Verifying lens version before restoring answers
2021-05-19 15:41:32.812 INFO exportImportWAFR - main: Versions match (2020-07-02)
2021-05-19 15:41:32.812 INFO exportImportWAFR - main: Retrieving all answers for lens wellarchitected
2021-05-19 15:41:33.048 INFO exportImportWAFR - main: Copying answers into new workload for lens wellarchitected
2021-05-19 15:41:49.368 INFO exportImportWAFR - main: Verifying lens version before restoring answers
2021-05-19 15:41:49.601 INFO exportImportWAFR - main: Versions match (2020-02-04)
2021-05-19 15:41:49.601 INFO exportImportWAFR - main: Retrieving all answers for lens serverless
2021-05-19 15:41:49.848 INFO exportImportWAFR - main: Copying answers into new workload for lens serverless
2021-05-19 15:41:52.862 INFO exportImportWAFR - main: Verifying lens version before restoring answers
2021-05-19 15:41:53.197 INFO exportImportWAFR - main: Versions match (2020-12-03)
2021-05-19 15:41:53.197 INFO exportImportWAFR - main: Retrieving all answers for lens softwareasaservice
2021-05-19 15:41:53.499 INFO exportImportWAFR - main: Copying answers into new workload for lens softwareasaservice
2021-05-19 15:41:58.677 INFO exportImportWAFR - main: Verifying lens version before restoring answers
2021-05-19 15:41:58.899 INFO exportImportWAFR - main: Versions match (2020-12-03)
2021-05-19 15:41:58.900 INFO exportImportWAFR - main: Retrieving all answers for lens foundationaltechnicalreview
2021-05-19 15:41:59.228 INFO exportImportWAFR - main: Copying answers into new workload for lens foundationaltechnicalreview
2021-05-19 15:42:04.291 INFO exportImportWAFR - main: Copy complete - exiting
```

{{< prev_next_button link_prev_url="../2_python_code/"  title="Congratulations!" final_step="true" >}}
{{< /prev_next_button >}}
