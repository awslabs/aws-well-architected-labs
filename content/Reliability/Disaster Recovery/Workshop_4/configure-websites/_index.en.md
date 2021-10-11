+++
title = "Configure Websites"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

### Configure the Active-Primary Website

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the **Active-Primary** stack to complete this section.  For help, refer to the [CloudFormation Outputs](../prerequisites/cfn-outputs/) **Primary Region** section of the workshop.
{{% /notice %}}

{{< img pr-6.png >}}

1.1 Using your favorite editor, create a new file named `config.json` file.  Initialize the document to the template provided below.  Next, set the **host** property equal to the **APIGURL** output value from the **Active-Primary** CloudFormation stack.  Remove the trailing slash (`/`) if one is present.  Finally, set the **region** property to `us-east-1`.

```json
{
    "host": "{{Replace with your APIGURL copied from above}}",
    "region": "us-east-1"
}
```

Your final **config.json** should look similar to this example.

```json
{
    "host": "https://xxxxxxxx.execute-api.us-east-1.amazonaws.com/Production",
    "region": "us-east-1"
}
```

### Upload the configuration to Amazon S3

2.1 Click [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

2.2 Click the bucket link that begins with **active-primary-uibucket-** .

{{< img pc-9.png >}}

2.3 Click the **Upload** button.

{{< img pc-11.png >}}

2.4 Click the **Add Files** button and specify the **config.json** file from the previous step.

{{< img pc-12.png >}}

2.5 In the **Permissions Section** section. Select the **Specify Individual ACL permissions** radio button.  Enable the **Read** checkbox next to **Everyone (public access)** grantee.

{{< img pc-13.png >}}

2.6 Enable the **I understand the effets of these changes on the specified objects.** checkbox.  Click the **Upload** button.

{{< img pc-14.png >}}

### Configure the Passive-Secondary Website

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the **Passive-Secondary** stack to complete this section. For help, refer to the [CloudFormation Outputs](../prerequisites/cfn-outputs/) **Secondary Region** section of the workshop.
{{% /notice %}}

{{< img sr-6.png >}}

3.1 Using your favorite editor, open the `config.json` file you just created on your local machine.  Modify the document to set the **host** property equal to the **APIGURL** output value from the **Passive-Secondary** CloudFormation stack.  Remove the trailing slash (`/`) if one is present.  Finally, set the **region** property to `us-west-1`.

```json
{
    "host": "{{Replace with your APIGURL copied from above}}",
    "region": "us-west-1"
}
```

Your final **config.json** should look similar to this example.

```json
{
    "host": "https://xxxxxxxx.execute-api.us-west-1.amazonaws.com/Production",
    "region": "us-west-1"
}
```

### Upload the configuration to Amazon S3

4.1 Click [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

4.2 Click the bucket name that begins with **passive-secondary-uibucket-**.  

{{< img c-9.png >}}

4.3 Click the **Upload** button.

{{< img c-11.png >}}

4.4 Click the **Add Files** button and specify the **config.json** file from the previous step.

{{< img c-12.png >}}

4.5 In the **Permissions Section** section. Select the **Specify Individual ACL permissions** radio button.  Enable the **Read** checkbox next to **Everyone (public access)** grantee.

{{< img c-13.png >}}

4.6 Enable the **I understand the effets of these changes on the specified objects.** checkbox.  Click the **Upload** button.

{{< img c-14.png >}}

{{< prev_next_button link_prev_url="../enable-aurora-writefwd/" link_next_url="../verify-websites/" />}}