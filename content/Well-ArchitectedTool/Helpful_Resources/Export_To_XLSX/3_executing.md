---
title: "Script usage examples"
date: 2021-05-04T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Generating a XLSX spreadsheet with all questions, best practices, and improvement plan links
Example Command: `./exportAnswersToXLSX.py --fileName ./demo.xlsx --profile acct2 --region us-east-1`

```shell
$ ./exportAnswersToXLSX.py --fileName ./demo.xlsx --profile acct2 --region us-east-1
2021-05-05 10:27:24.917 INFO exportAnswersToXLSX - main: Script version 0.1
2021-05-05 10:27:24.918 INFO exportAnswersToXLSX - main: Starting Boto 1.17.27 Session
2021-05-05 10:27:25.018 INFO exportAnswersToXLSX - main: No workload ID specified, we will create a TEMP workload
2021-05-05 10:27:25.314 INFO exportAnswersToXLSX - main: Lenses available: ["serverless", "wellarchitected", "softwareasaservice", "foundationaltechnicalreview"]
2021-05-05 10:27:25.314 INFO exportAnswersToXLSX - main: Creating a new workload to gather questions and answers
2021-05-05 10:27:25.574 INFO exportAnswersToXLSX - main: Creating xlsx file './demo.xlsx'
2021-05-05 10:29:32.879 ERROR exportAnswersToXLSX - findAllQuestionId: ERROR - Unexpected error: An error occurred (InternalServerErrorException) when calling the ListAnswers operation (reached max retries: 4): [InternalServerError] An internal error occurred.
2021-05-05 10:29:36.341 ERROR exportAnswersToXLSX - findAllQuestionId: ERROR - Unexpected error: An error occurred (InternalServerErrorException) when calling the ListAnswers operation (reached max retries: 4): [InternalServerError] An internal error occurred.
2021-05-05 10:29:58.579 INFO exportAnswersToXLSX - main: Closing Workbook File
2021-05-05 10:29:58.743 INFO exportAnswersToXLSX - main: Removing TEMP Workload
2021-05-05 10:29:59.652 INFO exportAnswersToXLSX - main: Done
```

### Example spreadsheet
![BlankSpreadsheetExample](/watool/utilities/Images/blank_spreadsheet.png?classes=lab_picture_auto)


## Generating a XLSX spreadsheet from an existing WellArchitected Workload
Example Command: `./exportAnswersToXLSX.py --fileName ./demo_existing.xlsx --profile acct2 --region us-east-1 --workloadid c896b2b1142f6ea8dc22874674400002`

```shell
$ ./exportAnswersToXLSX.py --fileName ./demo_existing.xlsx --profile acct2 --region us-east-1 --workloadid c896b2b1142f6ea8dc22874674400002
2021-05-05 11:00:01.031 INFO exportAnswersToXLSX - main: Script version 0.1
2021-05-05 11:00:01.032 INFO exportAnswersToXLSX - main: Starting Boto 1.17.27 Session
2021-05-05 11:00:01.215 INFO exportAnswersToXLSX - main: User specified workload id of c896b2b1142f6ea8dc22874674400002
2021-05-05 11:00:01.743 INFO exportAnswersToXLSX - main: Lenses for c896b2b1142f6ea8dc22874674400002: ["wellarchitected"]
2021-05-05 11:00:01.743 INFO exportAnswersToXLSX - main: Creating xlsx file './demo_existing.xlsx'
2021-05-05 11:00:15.073 INFO exportAnswersToXLSX - main: Closing Workbook File
2021-05-05 11:00:15.186 INFO exportAnswersToXLSX - main: Done
```

### Example spreadsheet
![BlankSpreadsheetExample](/watool/utilities/Images/existing_wafr.png?classes=lab_picture_auto)


{{< prev_next_button link_prev_url="../2_python_code/"  title="Congratulations!" final_step="true"  />}}
{{< prev_next_button />}}
