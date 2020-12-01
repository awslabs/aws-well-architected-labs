<!--
     keypairname: What you want the user to name the keypair
     region: AWS region
     fileformat: pem or ppk
-->

1. In the upper right portion of the console, select the region you wish to deploy the lab into. For this example we will be using {{ .Get "region" }}
1. Go to this link: https://console.aws.amazon.com/ec2/v2/home?#KeyPairs
![CreateKeyPair1](/Common/CreateEC2KeyPair/CreateKeyPair1.png?width=50pc)
1. Type "**{{ .Get "keypairname" }}**" in the name field
1. For **File format** select "**{{ .Get "fileformat" }}**"
![CreateKeyPair1](/Common/CreateEC2KeyPair/CreateKeyPair2.png?width=50pc)
1. Click on "Create Key Pair"
1. When your browser prompts, save the file in a location on your local computer. You will need this later if you wish to login to the machine directly via RDP.
![CreateKeyPair3](/Common/CreateEC2KeyPair/CreateKeyPair3.png?width=50pc)
