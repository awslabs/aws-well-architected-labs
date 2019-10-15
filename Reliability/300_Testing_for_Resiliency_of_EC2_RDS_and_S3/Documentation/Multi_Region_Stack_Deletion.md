# Delete workshop CloudFormation stacks - Multi region deployment

* Since AWS resources deployed by AWS CloudFormation stacks may have dependencies on the stacks that were created before, then deletion must occur in the opposite order they were created
* Stacks with the same ordinal can be deleted at the same time. _All_ stacks for a given ordinal must be **DELETE_COMPLETE** before moving on to the next ordinal

|Order|CloudFormation stack|Region|
|:---:|:---|:---|
|1|DMSforResiliencyTesting|Oregon|
|1|MySQLReadReplicaResiliencyTesting|Oregon|
|1|DMSforResiliencyTesting|Ohio|
|1|MySQLReadReplicaResiliencyTesting|Ohio|
|  |  |
|2|WebServersforResiliencyTesting|Ohio|
|2|MySQLforResiliencyTesting|Ohio|
|  |  |
|3|ResiliencyVPC|Ohio|
|3|DeployResiliencyWorkshop|Ohio|
