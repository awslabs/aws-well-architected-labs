---
title: "Updating an Existing Lab"
date: 2020-08-29T11:16:08-04:00
chapter: false
weight: 4
hidden: false
---

Make the required updates to the content.

1. Change to your local lab directory **aws-well-architected-labs**
2. Navigate to the **content folder** then to the pillar and lab you are looking to edit (i.e. select the **folder of the pillar** you are looking to edit:
  ![Images/nav.png](/Contributing/Images/nav.png?classes=lab_picture_small)
3. Open the portion of the lab you are looking to edit and make the changes

For more information on lab formats and best practices, see the create a new lab section

### Verify your edits and/or additions
After making the changes or additions test and verify locally
 - Navigate back to the aws-well-architected-labs parent folder
 - Serve the content locally:

        hugo serve -D

 - Open a browser and navigate to [http://localhost:1313/](http://localhost:1313/)
 - Verify the change you made was correct and there were no problems introduced

### Push your changes to the remote repository:
Add, Commit and Push your changes to GitHub using the following commands:

        git add -A
        git commit -m "your comment here"
        git push

{{% notice note %}}
Please write a descriptive commit message following [this](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project) guidance. Smaller meaningful commits are better than one large commit with lots of changes
{{% /notice %}}

  ![Images/gitcommit.png](/Contributing/Images/gitcommit.png?classes=lab_picture_small)
All your changes will be in the remote repository in GitHub, which can now be merged into the Well-Architected Labs repository


### Picture Updates
When you update a lab picture please ensure it had the following:
* Black boarder
* Orange box's to show the item the customer is looking for
* Role/AccountID hidden using the same colour as the section 
* Image needs to be 800 wide to avoid wrap
* The description above the image much match the image e.g. if you say use 2688Mb then the picture must have 2688Mb

An example can be seen below:

**Step example** :
1. Role name LambdaOrgRole, click Create role:
![Images/create_role.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_role.png)
