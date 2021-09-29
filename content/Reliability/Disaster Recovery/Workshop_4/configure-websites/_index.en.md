+++
title = "Configure Websites"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

## Configure the Active-Primary Website

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the `Active-Primary` stack to complete this section.  For help, refer to the [CloudFormation Outputs](../prerequisites/cfn-outputs/) section of the workshop.
{{% /notice %}}

{{< img pr-6.png >}}

1.1 Using your favorite editor, create a new file named `config.json` file.  Initialize the document to the template provided below.  Next, set the **host** property equal to the **APIGURL** output value from the `Active-Primary` CloudFormation stack.  Remove the trailing slash (`/`) if one is present.  Finally, set the **region** property to `us-east-1`.

```json
{
    "host": "{{Replace with your APIGURL copied from above}}",
    "region": "us-east-1"
}
```

Your final `config.json` should look similar to this example.

```json
{
    "host": "https://xxxxxxxx.execute-api.us-east-1.amazonaws.com/Production",
    "region": "us-east-1"
}
```

### Upload the configuration to Amazon S3

2.1 Navigate to [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

2.2 Find the bucket that begins with **active-primary-uibucket-**.  It will have a random suffix from the Amazon CloudFormation deployment.

{{< img pc-9.png >}}

2.3 Next, click into the bucket and then click the **Upload** button.

{{< img pc-11.png >}}

2.4 Click the **Add Files** button and specify the `config.json` file from the previous step.

{{< img pc-12.png >}}

2.5 Scroll down to **Permissions Section** section. Select the **Specify Individual ACL permissions** radio button.  Next, check the **Read** checkbox next to **Everyone (public access)** grantee.

{{< img pc-13.png >}}

2.6 Enable the **I understand the effets of these changes on the specified objects.** checkbox.  Then click the **Upload** button to continue.

{{< img pc-14.png >}}

## Configure the Passive-Secondary Website

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the `Passive-Secondary` stack to complete this section. For help, refer to the [CloudFormation Outputs](../prerequisites/cfn-outputs/) section of the workshop.
{{% /notice %}}

{{< img sr-6.png >}}

3.1 Using your favorite editor, open the `config.json` file you just created on your local machine.  Modify the document to set the **host** property equal to the **APIGURL** output value from the `Passive-Secondary` CloudFormation stack.  Remove the trailing slash (`/`) if one is present.  Finally, set the **region** property to `us-west-1`.

```json
{
    "host": "{{Replace with your APIGURL copied from above}}",
    "region": "us-west-1"
}
```

Your final `config.json` should look similar to this example.

```json
{
    "host": "https://xxxxxxxx.execute-api.us-west-1.amazonaws.com/Production",
    "region": "us-west-1"
}
```

### Upload the configuration to Amazon S3

4.1 Navigate to [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

4.2 Find the bucket that begins with **passive-secondary-uibucket-**.  It will have a random suffix from the Amazon CloudFormation deployment.

{{< img c-9.png >}}

4.3 Next, click into the bucket and then click the **Upload** button.

{{< img c-11.png >}}

4.4 Click the **Add Files** button and specify the `config.json` file from the previous step.

{{< img c-12.png >}}

4.5 Scroll down to **Permissions Section** section. Select the **Specify Individual ACL permissions** radio button.  Next, check the **Read** checkbox next to **Everyone (public access)** grantee.

{{< img c-13.png >}}

4.6 Enable the **I understand the effets of these changes on the specified objects.** checkbox.  Then click the **Upload** button to continue.

{{< img c-14.png >}}

{{< prev_next_button link_prev_url="../enable-aurora-writefwd/" link_next_url="../verify-websites/" />}}