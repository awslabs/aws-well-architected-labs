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
- Alee Whitman, Commercial Architect (AWS OPTICS)


## Introduction
The Well-Architected labs are open source and we welcome feedback and contributions from the community. 

Please read through this document before submitting any issues or pull requests to ensure we have all the necessary information to effectively respond to your bug report or contribution. 

If there are errors or you wish to make improvements to the labs, you can perform a pull request. To create a pull request, follow the steps below.

## Reporting Bugs/Feature Request

We welcome you to use the GitHub issue tracker to report bugs or suggest features.

When filing an issue, please check [existing open](https://github.com/awslabs/aws-well-architected-labs/issues) or [recently closed](https://github.com/awslabs/aws-well-architected-labs/issues?utf8=%E2%9C%93&q=is%3Aissue%20is%3Aclosed%20) issues to make sure somebody else hasn't already 
reported the issue. Please try to include as much information as you can. Details like these are incredibly useful:

* A label with the Well-Architected framework pillar (i.e. COST)
* A reproducible test case or series of steps
* The version of our code being used
* Any modifications you've made relevant to the bug
* Anything unusual about your environment or deployment
 

## Contributing via Pull Requests
Process for updating any existing labs or creating a new lab

### Requirements
 - You check existing open, and recently merged, pull requests to make sure someone else hasn't addressed the problem already.
 - You open an issue to discuss any significant work or new lab ideas - we would hate for your time to be wasted.
 - GitHub account
 - Git setup locally on your PC
 - [Install Hugo](https://gohugo.io/getting-started/installing/)


### Create a fork
You will create a fork to work on, make the edits and then submit it to be merged back into production. A local fork will be your local copy of the Well-Architected Labs repository.
 1. Go to the production [Well-Architected Labs repository](https://github.com/awslabs/aws-well-architected-labs)
 2. On the right side of the page, click on the Fork icon
 ![Images/fork.png](/watool/Contributing/Images/fork.png?classes=lab_picture_small)
 3. Select your GitHub account to fork to
 ![Images/fork2.png](/watool/Contributing/Images/fork2.png?classes=lab_picture_small)
 4. You will then have a **remote** repository of /aws-well-architected-labs
 ![Images/directory.png](/watool/Contributing/Images/directory.png?classes=lab_picture_small)
This is effectively your own version of the labs, stored on GitHub


### Create a local repository from the fork
You will create a local copy of the fork to work on, and make the required edits, his allows you to work locally and view the changes.
 1. Create a directory on your PC to hold the local repository
 2. Change to that directory or navigate to that directory and right click and select **Git Bash Here**
  ![Images/git.png](/watool/Contributing/Images/git.png?classes=lab_picture_small)
 3. Replace the repository name **(username)/aws-well-architected-labs** below with your repository name, and clone it:
        git clone git@github.com:(username)/aws-well-architected-labs.git
 - It will download the repository
  ![Images/git2.png](/watool/Contributing/Images/git2.png?classes=lab_picture_small)
 - You now have your local copy setup & have your own GitHub repository to push to


### Make changes or create new content

{{% notice note %}}
Note: Modify the source. Please focus on the specific change you are contributing. If you make modifications to multiple labs please submit a separate request for each lab. 
{{% /notice %}}

#### Make changes on an existing lab
{{%expand "Click here for the steps to make changes on an existing lab" %}}
Make the required updates to the content. 

1. Change to your local lab directory **aws-well-architected-labs**
2. Navigate to the **content folder** then to the pillar and lab you are looking to edit (i.e. select the **folder of the pillar** you are looking to edit 
  ![Images/nav.png](/watool/Contributing/Images/nav.png?classes=lab_picture_small)
3. Open the portion of the lab you are looking to edit and make the changes


For more information on lab formats and best practices, see the create a new lab section

 
{{% /expand%}}

#### Create a new lab
{{%expand "Click here for the process to create a new lab" %}}

1. Prior to starting work on a new lab
	- Open an issue with your lab idea with a brief summary explaining how it fits into the Well-Architected labs, and an outline of your idea. Make sure to add a Label with the Well-Architected Pillar (i.e. COST)
	- A Well-Architected Lead will reach out to confirm or get additional context on your idea
2. For a description of how Hugo's directory structure works, [see this:](https://gohugo.io/getting-started/directory-structure/#directory-structure-explained)
3. Labs are built using Hugo and the Learn theme, which utilizes markdown. You can see the Markdown reference for Hugo [here](https://en.support.wordpress.com/markdown-quick-reference/https://en.support.wordpress.com/markdown-quick-reference/)
4. For a sample lab, look at the existing labs .md file
5. File structure (note case sensitivity: 
	- All labs must belong to a pillar (if they can cross over, you may want to make them reusable via short codes). 
	- The pillar directories are located in /content/<Pillar Name>/<lab level>/<content folder for lab>. For instance, you would put a 100 level performance lab in /content/Performance Efficiency/100_Labs/100_my_new_lab 
	- No spaces in file names
	- _index.md is required in the root folder for your lab, it’s the lab landing page (old README.md) and then each step is its own markdown file, prefaced with the order number. For example: 1_starthere.md, 2_do_a_thing.md, 3_cleanup.md).
		- You can also create a directory structure to hold additional markdown content as needed (MUST be markdown files, non-markdown files are in static)
	- All files must have front-matter at the top of the file.  See this for more information: https://gohugo.io/content-management/front-matter/
		- For all front-matter, make sure you have a title defined and a weight. The weight is used to order the labs. 
	- Non-markdown Code must be stored in /static/(shortpillarname)/(content folder for lab)/code
	- Images must be stored in /static/(shortpillarname)/(content folder for lab)/Images
		- Image size should be that of a laptop screen. Roughly 1000px x 700px is good, if you use larger images they get scaled & are hard to read
		- Image width MUST always be >800px, which stops images from being placed next to text. Create the image border and then resize with whitespace
		- Ensure there is a black border around the images by formatting your images using the following structure ![Images/(your image.png)](/(shortpillarname)/(content folder for lab)/Images/(your image.png)?classes=lab_picture_small)

{{% /expand%}}

### Verify your edits and/or additions
After making the changes or additions test and verify locally
 - Navigate back to the aws-well-architected-labs parent folder
 - Serve the content locally:
 
        hugo serve -D
			
 - Open a browser and navigate to **http://localhost:1313/**
 - Verify the change you made was correct and there were no problems introduced

### Push your changes to the remote repository:
Push your changes to GitHub, so that they are stored and backed up by GitHub. Use the following commands:

        git add -A
        git commit -m "your comment here"
        git push

  ![Images/gitcommit.png](/watool/Contributing/Images/gitcommit.png?classes=lab_picture_small)
All your changes will be in the remote repository in GitHub, which can now be merged into the Well-Architected Labs repository.

#### Additional Validation Step for New Labs
 - **New labs** require an additional validation step of two peer reviews. Please have **two peers review your lab** step by step to confirm it is working as expected prior to submitting a pull request.


### Perform a pull request
All the changes are now in your remote repository, let’s do a pull request to merge it into the public Well-Architected Labs repository:

1. Go to the your GitHub Well-Architected Labs remote repository http://github.com/(username)/aws-well-architected-labs/pulls)
	- Make sure you update with your username
2. Click **Pull Request**
  ![Images/pull.png](/watool/Contributing/Images/pull.png?classes=lab_picture_small)
3. Click **compare across forks**
4. Select **your fork** on the right side as **head repository**
  ![Images/pull2.png](/watool/Contributing/Images/pull2.png?classes=lab_picture_small)
5. Review the changes, and click **Create pull request**
6. Edit the info (this is public – be careful and add a brief description of the edit or addition)	
	- Make sure to add the label of the Well-Architected Pillar (i.e. COST)
  ![Images/pull3.png](/watool/Contributing/Images/pull3.png?classes=lab_picture_small)
7. Click **Create pull request**

*GitHub provides additional document on [forking a repository](https://help.github.com/articles/fork-a-repo/) and 
[creating a pull request](https://help.github.com/articles/creating-a-pull-request/).*


{{% notice note %}}
Thank you for your contribution. The Well-Architected team will receive a notification of the pull request, we will review and commit the change or reach out with any questions. 
{{% /notice %}}

### Cleanup
Clean up your local and remote repositories, delete them if there is not additional work.

 - Go to your remote repository, modify the link: https://github.com/(username)/aws-well-architected-labs
 - Click **Settings**
 - Scroll down under **Danger Zone** and click **Delete this repository**
 - Confirm & click delete
 - Clean up your local repository by deleting the directory created previously
 
 
## Code of Conduct
This project has adopted the [Amazon Open Source Code of Conduct](https://aws.github.io/code-of-conduct). 
For more information see the [Code of Conduct FAQ](https://aws.github.io/code-of-conduct-faq) or contact 
opensource-codeofconduct@amazon.com with any additional questions or comments.


## Security issue notifications
If you discover a potential security issue in this project we ask that you notify AWS/Amazon Security via our [vulnerability reporting page](https://aws.amazon.com/security/vulnerability-reporting/). Please do **not** create a public GitHub issue.


## Licensing

See the [LICENSE](https://github.com/awslabs/aws-well-architected-labs/blob/master/LICENSE) file for our project's licensing. We will ask you to confirm the licensing of your contribution.

We may ask you to sign a [Contributor License Agreement (CLA)](https://en.wikipedia.org/wiki/Contributor_License_Agreement) for larger changes.


