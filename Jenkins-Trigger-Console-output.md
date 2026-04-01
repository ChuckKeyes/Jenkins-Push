Started by GitHub push by ChuckKeyes
Obtained Jenkinsfile from git https://github.com/ChuckKeyes/Jenkins-Push.git
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/Jenkins-Trigger
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/Jenkins-Trigger/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/ChuckKeyes/Jenkins-Push.git # timeout=10
Fetching upstream changes from https://github.com/ChuckKeyes/Jenkins-Push.git
 > git --version # timeout=10
 > git --version # 'git version 2.50.1'
 > git fetch --tags --force --progress -- https://github.com/ChuckKeyes/Jenkins-Push.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision b9a1e35bf637867db6eb5f8e453fa948c385fd06 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f b9a1e35bf637867db6eb5f8e453fa948c385fd06 # timeout=10
Commit message: "test webhook"
 > git rev-list --no-walk b83e3a690982ebc4b70eec8f48f65982479e957c # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/Jenkins-Trigger/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/ChuckKeyes/Jenkins-Push.git # timeout=10
Fetching upstream changes from https://github.com/ChuckKeyes/Jenkins-Push.git
 > git --version # timeout=10
 > git --version # 'git version 2.50.1'
 > git fetch --tags --force --progress -- https://github.com/ChuckKeyes/Jenkins-Push.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision b9a1e35bf637867db6eb5f8e453fa948c385fd06 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f b9a1e35bf637867db6eb5f8e453fa948c385fd06 # timeout=10
Commit message: "test webhook"
[Pipeline] sh
+ pwd
/var/lib/jenkins/workspace/Jenkins-Trigger
+ ls -la
total 180
drwxr-xr-x. 5 jenkins jenkins 16384 Apr  1 15:54 .
drwxr-xr-x. 6 jenkins jenkins    84 Apr  1 14:52 ..
drwxr-xr-x. 7 jenkins jenkins   146 Apr  1 15:54 .git
-rw-r--r--. 1 jenkins jenkins  4543 Apr  1 14:52 .gitignore
drwxr-xr-x. 3 jenkins jenkins    23 Apr  1 14:52 .terraform
-rw-r--r--. 1 jenkins jenkins  1377 Apr  1 15:54 .terraform.lock.hcl
-rw-r--r--. 1 jenkins jenkins   581 Apr  1 14:52 1-auth.md
-rw-r--r--. 1 jenkins jenkins  1487 Apr  1 14:52 2-main.tf
-rw-r--r--. 1 jenkins jenkins  3355 Apr  1 14:52 Jenkinsfile
-rw-r--r--. 1 jenkins jenkins  3232 Apr  1 14:52 Jenkinsfile.old
-rw-r--r--. 1 jenkins jenkins 44225 Apr  1 14:52 Lab3-4-info.md
-rw-r--r--. 1 jenkins jenkins   477 Apr  1 14:52 README.md
drwxr-xr-x. 2 jenkins jenkins   188 Apr  1 14:52 Screen-Shots
-rw-r--r--. 1 jenkins jenkins 18926 Apr  1 14:52 Theo-email.png
-rw-r--r--. 1 jenkins jenkins    88 Apr  1 14:52 Waiting on Theo.md
-rw-r--r--. 1 jenkins jenkins   342 Apr  1 14:52 plugins.yaml
-rw-r--r--. 1 jenkins jenkins 35956 Apr  1 14:53 terraform.tfstate
-rw-r--r--. 1 jenkins jenkins   742 Apr  1 14:52 test-bucket.md
-rw-r--r--. 1 jenkins jenkins    43 Apr  1 15:54 test.txt
-rw-r--r--. 1 jenkins jenkins  5913 Apr  1 14:52 tfplan
-rw-r--r--. 1 jenkins jenkins  2397 Apr  1 14:52 trigger.md
-rw-r--r--. 1 jenkins jenkins  1365 Apr  1 14:52 user-data.sh
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Verify Environment)
[Pipeline] sh
+ set -e
+ whoami
jenkins
+ terraform version
Terraform v1.14.8
on linux_amd64
+ provider registry.terraform.io/hashicorp/aws v6.38.0
+ aws --version
aws-cli/2.33.15 Python/3.9.25 Linux/6.1.164-196.303.amzn2023.x86_64 source/x86_64.amzn.2023
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Terraform Init)
[Pipeline] dir
Running in /var/lib/jenkins/workspace/Jenkins-Trigger
[Pipeline] {
[Pipeline] withCredentials
Masking supported pattern matches of $AWS_ACCESS_KEY_ID or $AWS_SECRET_ACCESS_KEY
[Pipeline] {
[Pipeline] sh
+ set -e
+ terraform init
[0m[1mInitializing the backend...[0m
[0m[1mInitializing provider plugins...[0m
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/aws v6.38.0...
- Installed hashicorp/aws v6.38.0 (signed by HashiCorp)
Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

[0m[1m[32mTerraform has been successfully initialized![0m[32m[0m
[Pipeline] }
[Pipeline] // withCredentials
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Terraform Plan)
[Pipeline] dir
Running in /var/lib/jenkins/workspace/Jenkins-Trigger
[Pipeline] {
[Pipeline] withCredentials
Masking supported pattern matches of $AWS_ACCESS_KEY_ID or $AWS_SECRET_ACCESS_KEY
[Pipeline] {
[Pipeline] sh
+ set -e
+ terraform plan -out=tfplan
[0m[1maws_s3_bucket.frontend: Refreshing state... [id=jenkins-bucket-20260322204450920400000001][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/trigger3.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/trigger3.png][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/photo0.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/photo0.png][0m
[0m[1maws_s3_bucket_public_access_block.frontend: Refreshing state... [id=jenkins-bucket-20260322204450920400000001][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/s3-bucket-uploads.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/s3-bucket-uploads.png][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/trigger2.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/trigger2.png][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/trigger1.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/trigger1.png][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/s3-bucket.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/s3-bucket.png][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/photo1.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/photo1.png][0m
[0m[1maws_s3_object.docs["1-auth.md"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/1-auth.md][0m
[0m[1maws_s3_object.docs["Lab3-4-info.md"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/Lab3-4-info.md][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/photo2.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/photo2.png][0m
[0m[1maws_s3_object.screenshots["Screen-Shots/photo3.png"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/uploads/photo3.png][0m
[0m[1maws_s3_object.docs["README.md"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/README.md][0m
[0m[1maws_s3_object.docs["Waiting on Theo.md"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/Waiting on Theo.md][0m
[0m[1maws_s3_object.docs["test-bucket.md"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/test-bucket.md][0m
[0m[1maws_s3_bucket_policy.frontend_public: Refreshing state... [id=jenkins-bucket-20260322204450920400000001][0m
[0m[1maws_s3_object.docs["trigger.md"]: Refreshing state... [id=jenkins-bucket-20260322204450920400000001/trigger.md][0m

[0m[1m[32mNo changes.[0m[1m Your infrastructure matches the configuration.[0m

[0mTerraform has compared your real infrastructure against your configuration
and found no differences, so no changes are needed.
[Pipeline] }
[Pipeline] // withCredentials
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Terraform Apply)
[Pipeline] dir
Running in /var/lib/jenkins/workspace/Jenkins-Trigger
[Pipeline] {
[Pipeline] withCredentials
Masking supported pattern matches of $AWS_ACCESS_KEY_ID or $AWS_SECRET_ACCESS_KEY
[Pipeline] {
[Pipeline] sh
+ set -e
+ terraform apply -auto-approve tfplan
[0m[1m[32m
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.[0m
[Pipeline] }
[Pipeline] // withCredentials
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Optional Destroy)
[Pipeline] script
[Pipeline] {
[Pipeline] input
Input requested
Approved by C Keyes
[Pipeline] echo
Skipping destroy
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
