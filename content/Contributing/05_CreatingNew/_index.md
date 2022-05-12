---
title: "Creating a New lab"
date: 2020-08-29T11:16:08-04:00
chapter: false
weight: 5
hidden: false
---

1. Prior to starting work on a new lab
	- [Open an issue](https://github.com/awslabs/aws-well-architected-labs/issues/new) with your lab idea with a brief summary explaining how it fits into the Well-Architected labs, and an outline of your idea. Make sure to add a Label with the Well-Architected Pillar (i.e. COST)
	- A Well-Architected Lead will reach out to confirm or get additional context on your idea
2. For a description of how Hugo's directory structure works, [see this:](https://gohugo.io/getting-started/directory-structure/#directory-structure-explained)
3. Labs are built using Hugo and the Learn theme, which utilizes markdown. You can see the Markdown reference for Hugo [here](https://en.support.wordpress.com/markdown-quick-reference/https://en.support.wordpress.com/markdown-quick-reference/)
4. For a sample lab, look at the existing labs .md file
5. File structure (note case sensitivity:
	- All labs must belong to a pillar (if they can cross over, you may want to make them reusable via short codes).
	- The pillar directories are located in `/content/<Pillar Name>/<lab level>/<content folder for lab>`. For instance, you would put a 100 level performance lab in `/content/Performance Efficiency/100_Labs/100_my_new_lab`
	- No spaces in file names
	- `_index.md` is required in the root folder for your lab, it’s the lab landing page (old README.md) and then each step is its own markdown file, prefaced with the order number. (For example: `1_starthere.md`, `2_do_a_thing.md`, `3_cleanup.md`).
		- You can also create a directory structure to hold additional markdown content as needed (MUST be markdown files, non-markdown files are in static)
	- All files must have front-matter at the top of the file.  See [this](https://gohugo.io/content-management/front-matter/) for more information.
		- For all front-matter, make sure you have a title defined and a weight. The weight is used to order the labs.
	- Non-markdown Code must be stored in `/static/(shortpillarname)/(content folder for lab)/code`
	- Images must be stored in `/static/(shortpillarname)/(content folder for lab)/Images`
		- Image size should be that of a laptop screen. Roughly `1000px x 700px` is good, if you use larger images they get scaled & are hard to read
		- Image width MUST always be `>800px`, which stops images from being placed next to text. Create the image border and then resize with whitespace
		- Ensure there is a black border around the images by formatting your images using the following structure `![Images/(your image.png)](/(shortpillarname)/(content folder for lab)/Images/(your image.png)?classes=lab_picture_small)`

### Picture Formatting
When you update a lab picture please ensure it had the following:
* Black boarder
* Orange box's to show the item the customer is looking for
* Role/AccountID hidden using the same colour as the section 
* Image width MUST always be `>800px`, which stops images from being placed next to text. Create the image border and then resize with whitespace
* The description above the image much match the image e.g. if you say use 2688Mb then the picture must have 2688Mb

An example can be seen below:

**Step example** :
1. Role name LambdaOrgRole, click Create role:
![Images/create_role.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_role.png)


### Verify your edits and/or additions
After making the changes or additions test and verify locally
 - Navigate back to the aws-well-architected-labs parent folder
 - Serve the content locally:

        hugo serve -D

 - Open a browser and navigate to [http://localhost:1313/](http://localhost:1313)
 - Verify the change you made was correct and no problems were introduced

### Push your changes to the remote repository:
Push your changes to GitHub, so that they are stored and backed up by GitHub. Use the following commands:

        git add -A
        git commit -m "your comment here"
        git push

{{% notice note %}}
Please write a descriptive commit message following [this](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project) guidance. Smaller meaningful commits are better than one large commit with lots of changes
{{% /notice %}}

  ![Images/gitcommit.png](/Contributing/Images/gitcommit.png?classes=lab_picture_small)

All your changes will be in the remote repository in GitHub, which can now be merged into the Well-Architected Labs repository.

### Review process

{{% notice note %}}
**New labs** require an additional validation step of two peer reviews. Please have **two peers review your lab** step by step to confirm it is working as expected prior to submitting a pull request.
{{% /notice %}}
