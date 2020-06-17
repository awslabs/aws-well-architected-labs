## Add object(s) to an S3 bucket

Use these instructions to add one or more objects to an S3 bucket

**Note**: You have the option to make the object(s) _publically readable_. Do NOT do this for S3 buckets used in production, or containing sensitive data. It is recommended you create a new test S3 bucket if you want to host _publically readable_ objects.

1. Click on the name of the bucket you are using (this can be the one you created above)
1. If, and only if, you want to make the uploaded object(s) _publically readable_ then:
    1. Click on the **Permissions** tab
    1. Clear _both_ **...access control lists (ACLs)** checkboxes (or verify they are already cleared)
    1. Click **Save**
    1. Type **confirm**
    1. Click **Confirm**
    1. Click on the **Overview** tab
1. Drag the file(s) you want to upload to the bucket into the object upload area
1. Click **Next**
1. If, and only if, you want to make this object(s) _publically readable_ then under **Manage public permissions** select **Grant public read access to this object(s)**
1. Click **Next** two more times
1. Click **Upload**
