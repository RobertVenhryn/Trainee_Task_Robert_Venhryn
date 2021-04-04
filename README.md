There is my project (Trainee task definition).
Created by Robert Venhryn.
Let's start
<(￣︶￣)>
---------------------------------------------------------------------------------------------------------------------------------

Terraform file you can find above. The is the beginning:

![Screenshot_1](https://user-images.githubusercontent.com/75696130/113060587-86b63f00-91b9-11eb-9b9b-7914ee3fe2a9.png)

![Screenshot_2](https://user-images.githubusercontent.com/75696130/113060638-9897e200-91b9-11eb-95bf-94ca47987dcc.png)

After that, I run my mega script: .\site_creating.ps1 (it will be above in the folder, so you can see it). there are mistakes because I delete folders that don't exist yet. It doesn't cause any issues.

![Screenshot_4](https://user-images.githubusercontent.com/75696130/113061280-76529400-91ba-11eb-8f51-d29d01555446.png)

on my host Windows 10 I ran:

winrm quickconfig -force
Start-Service -Name Winrm
Set-Item WSMan:localhost\client\trustedhosts -value *

There are some configuration with firewall on instances in Terraform ("user_data = <<EOF" line)

Finally, the script has done its job:

![Screenshot_5](https://user-images.githubusercontent.com/75696130/113061774-422ba300-91bb-11eb-9782-30b7b37eefd6.png)

And we've got our WebSite:

![Screenshot_6](https://user-images.githubusercontent.com/75696130/113508763-82dc4100-955a-11eb-86ac-ac4795a60dd2.png)


Turning back to the load balancer and targets, they are healthy now:

![Screenshot_7](https://user-images.githubusercontent.com/75696130/113304479-be80cc00-930a-11eb-9eb9-e65825c80910.png)

Configuration of instance:

![Screenshot_8](https://user-images.githubusercontent.com/75696130/113508779-a0a9a600-955a-11eb-9e0f-d38289cfe1df.png)


The names of the script and tf files are different because I saved them to push to git. The original are: example.tf and site_creating.ps1.
I'll leave instances working to let you see them. I didn't add the task definition here. Tell me please if needed.
---------------------------------------------------------------------------------------------------------------------------------
Thank you for your attention)
My network load balancer:   

The link:
http://test-lb-tf-740451f005f3c398.elb.eu-central-1.amazonaws.com/


![Screenshot_9](https://user-images.githubusercontent.com/75696130/113508807-c5058280-955a-11eb-8447-bef9f794097d.png)
