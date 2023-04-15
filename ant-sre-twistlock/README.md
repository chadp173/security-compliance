# ant-sre-twistlock-automation

#### SOS Twistlock Documentation
* https://pages.github.ibm.com/SOSTeam/SOS-Docs/container-security/usetwlk/

![Full-Dev](https://github.ibm.com/NetEngTools/ant-sre-twistlock/blob/main/files/full%20cycle.jpg)
______

##### Twistlock Control Groups

 Project Name  | Twistlock Control Group | 
|--------------|-------------------------|
| AAAaaS       | eal_eal-006480          |
| BlueFringe   | eal_eal-006403          |
| Edge Compute | eal_eal-010561          | 
| Polar-Hub    | TO_BE_DEFINED

### Local Build

* Copy secrets.example to secrets.env and fill in values for the secrets. The secret.env needs to be saved in the files filder.

```
W3ID=
ICR_API_KEY=
TWISTLOCK_API=
time_stamp=$(date +"%Y%m%d")
```

#### Create Twistlock API Credentials
```
./files/tt_v1.4.0/macos_x86_64/tt images pull-and-scan -u Chad.Perry1@ibm.com:<IBM_PASSWORD> -g eal_eal-006403 -ik <ICR_API_KEY> -q --has-fix-filter Y --issue-type-filter V us.icr.io/bluefringe/fringe_analytics_svc:GOLD -of api-key.csv
chad.perry1@Chads-MacBook-Pro:~/src/NetEngTools/twistlock-prod/ant-sre-twistlock$ ./files/tt_v1.4.0/macos_x86_64/tt api-key sh -u Chad.Perry1@ibm.com:<W3_PASSWORD>
{
  "userid": "chad.perry1@ibm.com",
  "api_key": "{API_KEY}",
  "api_version": "v1.0.2"
}

./tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API_KEY} --control-group eal_eal-006403 --iam-api-key ${IBM_CLOUD_API_KEY} us.icr.io/bluefringe/vault_client:20210301 --output-dir $PWD --output-file test-scan.csv
```

#### Create IBM Cloud API Credentials
https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui <br/>
<br/> Creating an API key


As an IBM Cloud user you might want to use an API key when you enable a program or script without distributing your password to the script. A benefit of using an API key can be that a user or organization can create several API keys for different programs and the API keys can be deleted independently if compromised without interfering with other API keys or even the user. You can create up to 20 API keys.

To create an API key for your user identity in the UI, complete the following steps:

1. In the IBM Cloud console, go to Manage > Access (IAM) > API keys.
2. Click Create an IBM Cloud API key.
3. Enter a name and description for your API key.
4. Click Create.
5. Then, click Show to display the API key.
   - Or, click Copy to copy and save it for later, or click Download.

```
{
	"name": "IBM Cloud API Key",
	"description": "Twistlock API Key ",
	"createdAt": "2022-03-22T17:13+0000",
	"apikey": "API-KEY"
}
```

#### Create GitHub Credentials - {.travis.yaml]

    
   1. Create a personal access token with repo scope
       - https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
   2. Add the token as en encrypted environment variable to .travis.yml
   3. travis endpoint --set-default -e https://travis.ibm.com/api
   4. travis login -X --github-token <TOKEN>
   5. travis encrypt GITHUB_API_TOKEN=<token> --add env.global
    

####  Create Travis CI SSH Key 
	
1. Create an SSH Key for Travis CI. 

```python
Generating public/private rsa key pair. 
Enter file in which to save the key (/Users/chad.perry1/.ssh/id_rsa): /Users/chad.perry1/.ssh/examp
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/chad.perry1/.ssh/examp
Your public key has been saved in /Users/chad.perry1/.ssh/examp.pub
The key fingerprint is:
SHA256:f3GqGxMVvnPnHACCQkmdlmyK7iFHdUmvauSiO3v4SD4 chad.perry1@Chads-MacBook-Pro.local
The key's randomart image is:
+---[RSA 3072]----+
|    oo=.=. ..    |
|     + @. ....   |
|    o *  .  o.   |
|   o .  .  . ..  |
|  o  . .S . + o..|
| . +o .  . . * +.|
| .=..+    + o   o|
|oEooo      =     |
| *B.      o.     |
+----[SHA256]-----+
```

2. Copy the SSH key and add to GitHub 
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

```python
pbcopy < ~/.ssh/USERNAME/KEYNAME
```
3. Add the SSH to Travis CI 
- https://docs.travis-ci.com/user/private-dependencies/#dedicated-user-account

##### Copy secrets.example to secrets.env and fill in values for the secrets. secrets.env is git-ignored so your changes will not be committed:
***Note***
Store secret.env files:
```
ant-sre-twistlock
├── files
│   └── secret.env
```

#### secret.env
```bash
W3ID=
ICR_API_KEY=
TWISTLOCK_API=
time_stamp=$(date +"%Y%m%d")
```

##### Build and run for local development with docker-compose
```bash
export COMPOSE_FILE=twistlock-local.yaml
docker-compose build --no-cache
docker-compose up -d
```

##### Create reports
```bash
docker exec -it twistlock bash -c "./tmp/00_local_build.sh"
```
***Note***
* bf_local_build.sh
* aaa_local_build.sh
* ecn_local_build.sh

#####  Extract Reports to Local Machine
```bash
docker cp docker cp twistlock:/tmp/<W3ID>.tgz .
mkdir docker-cid-<CID>/; mv /tmp/*.tgz docker-cid-<CID>
rm -rf $PWD/tmp/
```

![local](files/Picture1.jpg)
#### SOS Twistlock Documentation
* https://pages.github.ibm.com/SOSTeam/SOS-Docs/container-security/usetwlk/

#### GitHub CLI Documentation
* https://cli.github.com/manual/
