---
title: "Script usage examples"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Generating a WellArchitected Framework HTML Report
Example Command: `./generateWAFReport.py --profile acct2 --workloadid c896b2b1142f6ea8dc22874674400002 --region us-east-1`

```shell
$ ./generateWAFReport.py --profile acct2 --workloadid c896b2b1142f6ea8dc22874674400002 --region us-east-1
2021-04-19 12:47:06.672 INFO generateWAFReport - main: Starting Boto 1.17.27 Session
2021-04-19 12:47:15.097 INFO generateWAFReport - main: Creating HTML file /var/folders/sw/1xkhcl751fj_fxr63jb5qr2m0000gs/T/tmpft2fam0k.html
2021-04-19 12:47:15.097 INFO generateWAFReport - main: Opening HTML URL (file:///var/folders/sw/1xkhcl751fj_fxr63jb5qr2m0000gs/T/tmpft2fam0k.html) in default WebBrowser
```

## Example HTML Output
{{< readfile file="/static/watool/utilities/Code/example.html" code="false" >}}

{{< prev_next_button link_prev_url="../2_python_code/"  title="Congratulations!" final_step="true"  />}}
{{< prev_next_button />}}
