There is my project (Trainee task definition)
Created by Robert Venhryn
Let's start
<(￣︶￣)>
---------------------------------------------------------------------------------------------------------------------------------

Terraform file you can find above. The is the beginning:

![Screenshot_1](https://user-images.githubusercontent.com/75696130/113060587-86b63f00-91b9-11eb-9b9b-7914ee3fe2a9.png)

![Screenshot_2](https://user-images.githubusercontent.com/75696130/113060638-9897e200-91b9-11eb-95bf-94ca47987dcc.png)

Targets are unhealthy yet

![Screenshot_3](https://user-images.githubusercontent.com/75696130/113060838-e1e83180-91b9-11eb-839f-10fbde9a1c90.png)

After that, I run my mega script: .\site_creating.ps1 (it will be above in the folder, so you can see it). there are mistakes because I delete folders that don't exist yet. It doesn't cause any issues

![Screenshot_4](https://user-images.githubusercontent.com/75696130/113061280-76529400-91ba-11eb-8f51-d29d01555446.png)

on my host Windows 10 I ran:

winrm quickconfig -force
Start-Service -Name Winrm
Set-Item WSMan:localhost\client\trustedhosts -value *

There are some configuration with firewall on instances in Terraform ("user_data = <<EOF" line)

Finally, the script has done its job:

![Screenshot_5](https://user-images.githubusercontent.com/75696130/113061774-422ba300-91bb-11eb-9782-30b7b37eefd6.png)

And we've got our WebSites

![Screenshot_6](https://user-images.githubusercontent.com/75696130/113061876-6d15f700-91bb-11eb-8f25-0e363ffae142.png)

Turning back to the load balancer and targets, they are healthy now

![Screenshot_7](https://user-images.githubusercontent.com/75696130/113061945-92a30080-91bb-11eb-88b7-db6f5bc6f142.png)

Configuration of instance

![Screenshot_8](https://user-images.githubusercontent.com/75696130/113062054-cbdb7080-91bb-11eb-8feb-40c5f8a25741.png)

The names of script and tf files are different because I save them to push to git. The original are example.tf and site_creating.ps1
I'll leave instances working to let you see them.
---------------------------------------------------------------------------------------------------------------------------------
Thank you for your attention)
http://18.197.210.234:8888/
http://3.121.225.193:8888/
