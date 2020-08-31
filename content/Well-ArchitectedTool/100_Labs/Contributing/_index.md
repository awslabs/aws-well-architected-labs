---
title: "Contributing to Well-Architected Labs"
#menutitle: "Lab #2"
date: 2020-08-29T11:16:08-04:00
chapter: false
weight: 2
hidden: false
---
## Authors
- Nathan Besh. Cost-Lead, Well-Architected, AWS


## Introduction
The Well-Architected labs are open source and we welcome feedback and contributions from the community. If there are errors or you wish to make improvements to the labs, you can perform a pull request. To do a pull request follow the steps below.


## Requirements
 - GitHub account
 - Git setup locally on your PC
 - [Install Hugo](https://gohugo.io/getting-started/installing/)


## Create a fork
You will create a fork to work on, make the edits and then submit it to be merged back into production. A local fork will be your local copy of the Well-Architected Labs repository.
 - Go to the production [Well-Architected Labs repository](https://github.com/awslabs/aws-well-architected-labs)
 - On the right side of the page, click on the Fork icon
 - Select your GitHub account to fork to
 - You will then have a **remote** repository of <username>/aws-well-architected-labs

This is effectively your own version of the labs, stored on GitHub


## Create a local repository from the fork
You will create a local copy of the fork to work on, and make the required edits, his allows you to work locally and view the changes.
 - Create a directory on your PC to hold the local repository
 - Change that to directory
 - Replace the repository name **(username)/aws-well-architected-labs** below with your repository name, and clone it:

        git clone git@github.com:(username)/aws-well-architected-labs.git
 - It will download the repository
 - You now have your local copy setup & have your own GitHub repository to push to


## Make changes and verify 
Make the required updates to the content, test and verify locally
 - Change to the labs directory **aws-well-architected-labs**
 - Navigate to the content folder and make the required edits
 - Navigate back to the aws-well-architected-labs parent folder
 - Serve the content locally:

        hugo serve -D
 - Open a browser and navigate to **http://localhost:1313/**
 - Verify the change you made was correct and there were no problems introduced


## Push your changes to the remote repository:
Push your changes to GitHub, so that they are stored and backed up by GitHub. Use the following commands:

        git add -A
        git commit -m "your comment here"
        git push

All your changes will be in the remote repository in GitHub, which can now be merged into the Well-Architected Labs repository.


## Perform a pull request
All the changes are now in your remote repository, lets do a pull request to merge it into the public Well-Architected Labs repository:

 - Go to the [Well-Architected Labs pull requests](http://github.com/awslabs/aws-well-architected-labs/pulls)
 - Click **New pull request**
 - Click **compare across forks**
 - Select **your fork** on the right side as **head repository**
 - Review the changes, and click **Create pull request**
 - Edit the info (this is public – be careful)
 - Click **Create pull request**

The W-A team will receive a notification of the pull request, will review & include the changes.


## Cleanup
Clean up your local and remote repositories, delete them if there is not additional work.

 - Go to your remote repository, modify the link: https://github.com/(username)/aws-well-architected-labs
 - Click **Settings**
 - Scroll down under **Danger Zone** and click **Delete this repository**
 - Confirm & click delete
 - Clean up your local repository by deleting the directory created previously

