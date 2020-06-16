<!--
     Inner: (between the tags) is used for the Parameters section
     templatename: filename for the CloudFormation template to use
          (you need to have instructed them to download/create this file PRIOR to these instructions)
     stackname: the stack name to use for the CloudFormation stack

     For Example usage see content/common/examples/useCreateNewCloudFormationStack.md
     If you do not use the Inner Variable, you MUST use a trailing "/"
-->

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and click **Create Stack** > **With new resources**
     ![Images/CFNCreateStackButton](/Common/images/CreateNewCloudFormationStack/CFNCreateStackButton.png)

1. Leave **Prepare template** setting as-is
      * For **Template source** select **Upload a template file**
      * Click **Choose file** and supply the CloudFormation template you downloaded: _{{ .Get "templatename" }}_
       ![CFNUploadTemplateFile](/Common/images/CreateNewCloudFormationStack/CFNUploadTemplateFile.png)

1. Click **Next**

1. For **Stack name** use **{{ .Get "stackname" }}**

1. **Parameters**
    * Look over the Parameters and their default values.
    {{ .Inner }}
    * Click **Next**

1. For **Configure stack options** we recommend configuring tags, which are key-value pairs, that can help you identify your stacks and the resources they create. For example, enter *Owner* in the left column which is the key, and your email address in the right column which is the value. We will not use additional permissions or advanced options so click **Next**. For more information, see [Setting AWS CloudFormation Stack Options](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide//cfn-console-add-tags.html).

1. For **Review**
    * Review the contents of the page
    * At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
    * Click **Create stack**
     ![CFNIamCapabilities](/Common/images/CreateNewCloudFormationStack/CFNIamCapabilities.png)

1. This will take you to the CloudFormation stack status page, showing the stack creation in progress.  
    * Click on the **Events** tab
    * Scroll through the listing. It shows (in reverse order) the activities performed by CloudFormation, such as starting to create a resource and then completing the resource creation.
    * Any errors encountered during the creation of the stack will be listed in this tab.
      ![StackCreationStarted](/Common/images/CreateNewCloudFormationStack/CFNStackInProgress.png)  

1. When it shows **status** _CREATE_COMPLETE_, then you are finished with this step.
