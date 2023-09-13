---
title: "Script usage examples"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

Below are some examples on how you can utilize the script:

## Copying a WellArchitected Tool Review from one region to another
Example Command: `./duplicateWAFR.py --fromaccount acct2 --toaccount acct2 --workloadid c896b2b1142f6ea8dc228746744c0000 --fromregion us-east-1 --toregion us-east-2`

```shell
$ ./duplicateWAFR.py --fromaccount acct2 --toaccount acct2 --workloadid c896b2b1142f6ea8dc228746744c0000 --fromregion us-east-1 --toregion us-east-2
2021-04-19 09:43:37.832 INFO duplicateWAFR - main: Starting Boto 1.17.27 Session
2021-04-19 09:43:38.130 INFO duplicateWAFR - main: Copy WorkloadID 'c896b2b1142f6ea8dc228746744c0000' from 'us-east-1:acct2' to 'us-east-2:acct2'
2021-04-19 09:43:38.920 INFO duplicateWAFR - main: New workload id: 76a20b805f62a136ad54bf6c1483a98b (arn:aws:wellarchitected:us-east-2:222222222222:workload/76a20b805f62a136ad54bf6c1483a98b)
2021-04-19 09:43:38.920 INFO duplicateWAFR - main: Retrieving all answers for lens wellarchitected
2021-04-19 09:43:40.206 INFO duplicateWAFR - main: Copying answers into new workload for lens wellarchitected
2021-04-19 09:44:00.213 INFO duplicateWAFR - main: Retrieving all answers for lens serverless
2021-04-19 09:44:00.532 INFO duplicateWAFR - main: Copying answers into new workload for lens serverless
2021-04-19 09:44:03.690 INFO duplicateWAFR - main: Copy complete - exiting
```

## Copying a WellArchitected Tool Review from one account to another in the same region
Example Command: `./duplicateWAFR.py --fromaccount acct2 --toaccount acct3 --workloadid c896b2b1142f6ea8dc228746744c0000 --fromregion us-east-1 --toregion us-east-1`

```shell
$ ./duplicateWAFR.py --fromaccount acct2 --toaccount acct3 --workloadid c896b2b1142f6ea8dc228746744c0000 --fromregion us-east-1 --toregion us-east-1
2021-04-19 09:46:05.400 INFO duplicateWAFR - main: Starting Boto 1.17.27 Session
2021-04-19 09:46:05.543 INFO duplicateWAFR - main: Copy WorkloadID 'c896b2b1142f6ea8dc228746744c0000' from 'us-east-1:acct2' to 'us-east-1:acct3'
2021-04-19 09:46:06.533 INFO duplicateWAFR - main: New workload id: 3a701d540b4b09579e99c303ac4a0499 (arn:aws:wellarchitected:us-east-1:333333333333:workload/3a701d540b4b09579e99c303ac4a0499)
2021-04-19 09:46:06.534 INFO duplicateWAFR - main: Retrieving all answers for lens wellarchitected
2021-04-19 09:46:07.734 INFO duplicateWAFR - main: Copying answers into new workload for lens wellarchitected
2021-04-19 09:46:31.283 INFO duplicateWAFR - main: Retrieving all answers for lens serverless
2021-04-19 09:46:31.598 INFO duplicateWAFR - main: Copying answers into new workload for lens serverless
2021-04-19 09:46:35.143 INFO duplicateWAFR - main: Copy complete - exiting
```

## Copying a WellArchitected Tool Review from one account to another in a different region
Example Command: `./duplicateWAFR.py --fromaccount acct2 --toaccount acct3 --workloadid c896b2b1142f6ea8dc228746744c0000 --fromregion us-east-1 --toregion us-east-2`

```shell
$ ./duplicateWAFR.py --fromaccount acct2 --toaccount acct3 --workloadid c896b2b1142f6ea8dc228746744c0000 --fromregion us-east-1 --toregion us-east-2
2021-04-19 09:47:14.227 INFO duplicateWAFR - main: Starting Boto 1.17.27 Session
2021-04-19 09:47:14.451 INFO duplicateWAFR - main: Copy WorkloadID 'c896b2b1142f6ea8dc228746744c0000' from 'us-east-1:acct2' to 'us-east-2:acct3'
2021-04-19 09:47:15.374 INFO duplicateWAFR - main: New workload id: 8f1df75b01f132a4b31649e834d4c606 (arn:aws:wellarchitected:us-east-2:333333333333:workload/8f1df75b01f132a4b31649e834d4c606)
2021-04-19 09:47:15.374 INFO duplicateWAFR - main: Retrieving all answers for lens wellarchitected
2021-04-19 09:47:16.456 INFO duplicateWAFR - main: Copying answers into new workload for lens wellarchitected
2021-04-19 09:47:34.067 INFO duplicateWAFR - main: Retrieving all answers for lens serverless
2021-04-19 09:47:34.433 INFO duplicateWAFR - main: Copying answers into new workload for lens serverless
2021-04-19 09:47:37.326 INFO duplicateWAFR - main: Copy complete - exiting
```

{{< prev_next_button link_prev_url="../2_python_code/"  title="Congratulations!" final_step="true"  />}}
{{< prev_next_button />}}
