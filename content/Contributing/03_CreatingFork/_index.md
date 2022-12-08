---
title: "Creating a Fork"
date: 2020-08-29T11:16:08-04:00
chapter: false
weight: 3
hidden: false
---

You should work on updates and new features on your own fork of the [Well-Architected Labs repository](https://github.com/awslabs/aws-well-architected-labs), make the edits and then submit a Pull Request to be merged back into production. A local fork will be your local copy of the Well-Architected Labs repository.

### Creating a Fork
 1. Go to the production [Well-Architected Labs repository](https://github.com/awslabs/aws-well-architected-labs)
 2. On the right side of the page, click on the Fork icon
 ![Images/fork.png](/Contributing/Images/fork.png?classes=lab_picture_small)
 3. Select your GitHub account to Fork to
 ![Images/fork2.png](/Contributing/Images/fork2.png?classes=lab_picture_small)
 4. You will then have a **remote** repository of /aws-well-architected-labs
 ![Images/directory.png](/Contributing/Images/directory.png?classes=lab_picture_small)
This is effectively your own version of the labs, stored on GitHub


### Create a local repository from the Fork
You will create a local copy of the Fork to work on, and make the required edits, his allows you to work locally and view the changes.
 1. Create a directory on your PC to hold the local repository
 2. Change to that directory or navigate to that directory and right click and select **Git Bash Here**
  ![Images/git.png](/Contributing/Images/git.png?classes=lab_picture_small)
 3. Replace the repository name **(username)/aws-well-architected-labs** below with your repository name, and clone it:
        `git clone git@github.com:(username)/aws-well-architected-labs.git`
 - It will download the repository
  ![Images/git2.png](/Contributing/Images/git2.png?classes=lab_picture_small)
 - You now have your local copy setup & have your own GitHub repository to push to


### Create Upstream of fork

You must configure a remote that points to the upstream repository in Git to sync changes you make in a fork with the original repository. This also allows you to sync changes made in the original repository with the fork [git instructions](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-repository-for-a-fork) 

### Serve Hugo
After creating your local Fork verify locally
 - Navigate back to the `aws-well-architected-labs` parent folder
 - Serve the content locally:

        hugo serve -D

 - Open a browser and navigate to [http://localhost:1313/](http://localhost:1313/)

### Refresh your local Fork from the remote
See the [GitHub docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks)
