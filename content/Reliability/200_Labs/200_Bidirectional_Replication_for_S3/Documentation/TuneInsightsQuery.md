# Troubleshooting Guide to Tuning your Insights Query

## Verify you are in the correct AWS Region

You should be in the _east_ region
 * If you used the directions in this lab, then this is **Ohio (us-east-2)**

## If your query returned zero results or less than three results:

### Possibility #1: It was been too recent since you did the bucket operations

* It usually takes five minutes after an operation for it to show up in CloudTrail and can take as long as 15 minutes

or

### Possibility #2: It was been too long ago since you did the bucket operations

* If you did the previous part of the lab much earlier you should expand the _time range_ for your query, found to the right of **Select log group(s)**

## If you see more than three results

* Then you are seeing bucket activity _other_ than the operations you did with this lab
* You are looking for three events, one for each of the test objects you uploaded.  See the _key_ field to see the test object names
* You can also update the query to only look at the lab buckets. Add the following to your query

        filter requestParameters.bucketName like'crrlab'

**[Click here]({{< ref "../3_test_replication.md#putobject_events" >}}) to return to the Lab Guide**
