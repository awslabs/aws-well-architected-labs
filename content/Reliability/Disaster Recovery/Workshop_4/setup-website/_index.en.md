+++
title = "Setup Websites"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

## Configure the Active-Primary Website

1.1 Change your [console](https://us-east-1.console.aws.amazon.com/console)’s region to **US East (N. Virginia) us-east-1 using the Region Selector in the upper right corner.

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the `Active-Primary` stack to complete this section.
{{% /notice %}}

{{< img pr-6.png >}}

1.2 Using your favorite editor, create a new file named `config.json` file.  Initialize the document to the template provided below.  Next, set the **host** property equal to the **APIGURL** output value from the `Active-Primary` CloudFormation stack.  Remove the trailing slash (`/`) if one is present.  Finally, set the **region** property to `us-east-1`.

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

2.1 Navigate to **S3** in the console.

{{< img c-8.png >}}

2.2 Find the bucket that begins with **active-primary-uibucket-**.  It will have a random suffix from the Amazon CloudFormation deployment.

{{< img c-9.png >}}

2.3 Next, click into the bucket and then click the **Upload** button.

{{< img c-11.png >}}

2.4 Click the **Add Files** button and specify the `config.json` file from the previous step.

{{< img c-12.png >}}

2.5 Scroll down to **Permissions Section** section. Select the **Specify Individual ACL permissions** radio button.  Next, check the **Read** checkbox next to **Everyone (public access)** grantee.

{{< img c-13.png >}}

2.6 Enable the **I understand the effets of these changes on the specified objects.** checkbox.  Then click the **Upload** button to continue.

{{< img c-14.png >}}

## Configure the Passive-Secondary Website

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the `Passive-Secondary` stack to complete this section.
{{% /notice %}}

{{< img sr-6.png >}}

3.1 Similar to step 1.1, create a new `config.json` file on your local machine.  Set the **host** property equal to the **APIGURL** from the `Passive-Secondary` CloudFormation output parameter.  Set the **region** property to `us-west-1`.

Your final `config.json` should look similar to this example.

```json
{
    "host": "https://yyyyyyyyy.execute-api.us-east-1.amazonaws.com/Production",
    "region": "us-west-1"
}
```

3.2 Change your [console](https://us-east-1.console.aws.amazon.com/console)’s region to **US West 1 (N. Virginia)** using the Region Selector in the upper right corner.

3.3 Upload the `config.json` into the **passive-secondary-** bucket by repeating the steps from section 2.
