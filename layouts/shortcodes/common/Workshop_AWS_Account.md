<!--
     noCreds: set this any value to skip the Get and store your AWS credentials step.  Otherwise that step will be shown (which was the previous behavior)
-->

1. Go to <https://dashboard.eventengine.run/login>

1. Enter the 16 character _hashcode_ you were provided and click "Proceed"
  ![AWSAccountCodeProceed](/Common/images/AWSAccountCodeProceed.png)

1. Sign-in using either an Amazon.com retail account or a One-Time Password (OTP) that will be emailed to you.
  ![AWSAccountSignIn](/Common/images/AWSAccountSignIn.png)

1. [optional] assign a name to your account (this is referred to as "Team name")
     * click "Set Team Name"
     * Enter a name and click "Set Team Name"

1. Click "AWS Console"
  ![AWSAccountEvent](/Common/images/AWSAccountEvent.png)

{{ if .Get "noCreds" }}
{{ else }}
1. Get and store your AWS credentials
     * **IMPORTANT** Copy the provided credentials and save them.  You wil need these to complete the workshop
        ![AWSAccountCredsAndConsole](/Common/images/AWSAccountCredsAndConsole.png)

     * Copy the _whole_ code block corresponding to the system you are using.
{{ end }}

1. Access the AWS console
    * Click "Open AWS Console".
    * The AWS Console will open and you can continue the lab.

---

