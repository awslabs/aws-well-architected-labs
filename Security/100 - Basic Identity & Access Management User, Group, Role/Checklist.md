# Level 100: AWS Accounts & IAM: Best Practice Checklist

- [ ] Root user has no access keys
- [ ] Root user is protected by a strong password with MFA stored securely
- [ ] Enable security questions in account
- [ ] Account credential report is regularly reviewed preferably automated
- [ ] AWS account email address to a secured, limited distribution list
- [ ] AWS account phone number for account to trusted contact
- [ ] IAM users’ credentials are rotated on a regular basis
- [ ] IAM user credential lifecycle is integrated with HR process upon suspension or termination of staff
- [ ] IAM trust policies in roles are reviewed regularly against business needs
- [ ] Permission are limited business needs (least privilege) and evaluated periodically
- [ ] All credentials unused within X days are de-activated, preferably automated
- [ ] Access keys are used only where absolutely necessary and rotated every X days
- [ ] No IAM credentials are embedded in source code/scripts or stored insecurely
- [ ] A unique IAM Role is used for each function/application
- [ ] Non-EC2-based applications use IAM federation and Roles to access AWS services
- [ ] Mobile applications use Cognito
- [ ] Organizations with control policies for multiple accounts with stack sets
