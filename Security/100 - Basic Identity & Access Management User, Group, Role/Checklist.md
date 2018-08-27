# Level 100: Basic Identity & Access Management User, Group, Role: Best Practice Checklist

- [ ] Account credential report is regularly reviewed preferably automated
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
