---
title: "Creating a Pull Request"
date: 2020-08-29T11:16:08-04:00
chapter: false
weight: 6
hidden: false
---

### Create a Pull Request
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

*GitHub provides additional document on [forking a repository](https://help.github.com/articles/fork-a-repo/) and [creating a pull request](https://help.github.com/articles/creating-a-pull-request/).*

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
