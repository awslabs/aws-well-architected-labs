---
title: "Changing clock type on the Xen based EC2 instance"
menutitle: "Change clock type"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

We can change the clock type on Xen based EC2 instances to get better performance than the standard Xen clock source.  You will notice that the speed for Xen and Nitro/KVM instances will be close to identical after this change.  

## Code to change the clock source
```
echo "tsc" > /sys/devices/system/clocksource/clocksource0/current_clocksource
```
This changes the default time clock from xen to tsc (Time Stamp Counter), which is considered the best practice for Xen based EC2 instances.

## Using SSM to run the clock change document
1.	Open the AWS Console (https://console.awa.amazon.com)
1.	In the “Find Services” search bar, type “systems manager” and press enter
![ChangeClock1](/Performance/100_Clock_Source_Performance/Images/ChangeClock1.png)
1.	Under “Instances & Nodes” click on “Run Command” and on the left side of the screen again click on “Run a command”
![ChangeClock2](/Performance/100_Clock_Source_Performance/Images/ChangeClock2.png)
1.	In the search bar under Command Document, select “Owner” from the pulldown and then select “Owned by me”.
![ChangeClock3](/Performance/100_Clock_Source_Performance/Images/ChangeClock3.png)
![ChangeClock4](/Performance/100_Clock_Source_Performance/Images/ChangeClock4.png)
1.	You should see 2 SSM documents that have been created for you by the CloudFormation Template.  Click on the one with “setTSCdocument” in the name.
![ChangeClock5](/Performance/100_Clock_Source_Performance/Images/ChangeClock5.png)
1.	Scroll down and under “Targets”, select the checkbox next to the instance that is labeled “XenTimeInstanceTest”
![ChangeClock6](/Performance/100_Clock_Source_Performance/Images/ChangeClock6.png)
1.	Scroll down and uncheck the box that says “Enable writing to an S3 bucket” and then click the “Run” button at the bottom of the screen.
![ChangeClock7](/Performance/100_Clock_Source_Performance/Images/ChangeClock7.png)
1.	You should see the command running on the node selected.  Click Refresh until the command is in the “Success” state
![ChangeClock8](/Performance/100_Clock_Source_Performance/Images/ChangeClock8.png)
1. You can now go back to [Step 2](2_testing_before) and re-run the tests. You should see the time for the Xen based EC2 instance has dramatically improved from 110 to 24 seconds.
![ChangeClock9](/Performance/100_Clock_Source_Performance/Images/ChangeClock9.png)
