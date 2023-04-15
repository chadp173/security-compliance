1. Dependency Local Software:

    Install Homebrew (https://brew.sh/)
        Brew is primarly used on MacBooks


Paste the following command on the CLI:

sudo /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

2. Install GIT on your MacBook

    MacBook run the following command to install GIT.

brew install git 

3. Create an SSH Key

ssh-keygen -t rsa

    Store it to the default location

~/.ssh/
Chads-MacBook-Pro:dev-env chad.perry1$ ls -l ~/.ssh/
total 16
-rw-------  1 chad.perry1  staff  1843 Jan 22 09:14 id_rsa
-rw-r--r--  1 chad.perry1  staff   417 Jan 22 09:14 id_rsa.pub

    Copy the contents of that file in Github.

view ~/.ssh/id_rsa.pub

( Then Log into https://github.ibm.com and select your name, then Edit Profile. Click on the "SSH Keys" tab. Click "Add SSH key" and paste in the contents of your clipboard.)
4. Create the local workspace for the repositories

It can be anywhere (and called anything), but we suggest:
"The Folllowing location $HOME/src/NetEngTools"

cd $HOME 
mkdir -p /src/NetEngTools 

mkdir -p src/NetEngTools
cd $HOME/src/NetEngTools/
git clone git@github.ibm.com:NetEngTools/ciocssp-frontend.git
git clone git@github.ibm.com:NetEngTools/core-deploy-tools.git

5. Install and setup Docker for Desktop

cd $HOME/src/core-deploy-tools/ &&
./bin/setup_local_env.sh -n -i 

6. Set up local Docker environment: use Native Docker.

Follow terminal for steps. More in https://github.ibm.com/cio-bluefringe/ciocssp/issues/1731 Update your Docker configs in Docker app in top bar (Docker icon -> Daemon -> Advanced) to look like this:

 {
      "debug" : true,
      "experimental" : true,
      "dns" : [
	"9.0.130.50",
	"9.0.128.50"
      ],
      "insecure-registries" : [
	"isdockreg101.innovate.ibm.com"
      ]
    }

    Assign 8GB of memory for Docker engine (Docker app in top bar -> Preferences -> Advanced) and restart Docker

Run ./bin/setup_local_env.sh -n -s

You should have a Docker working in a new terminal now - confirm with docker ps -a
7. Docker Registrery access.

Go to this web site and follow the one time instructions for docker registry access. https://github.ibm.com/NetEngTools/ciocssp/wiki#docker-registry-access

Docker Registry access CIOCSSP Docker Registry is being moved to Artifactory. In order to be able to use our images, you need to onboard to Artifactory:

Open a ticket in https://github.ibm.com/netengtools/delivery/ to be added to txo-ant-sre-bf-team team in Taas portal once added, log in with your w3id to https://na.artifactory.swg-devops.com/artifactory/webapp/ to get an API key, click on your profiles in right top corner and copy an API Key (you might need to generate it first) - this key will be used to authenticate to Docker Registry later Setting up access to Docker Registry (one time set up)

docker login bluefringe-docker-local.artifactory.swg-devops.com

    Prompt 1: your email address
    Prompt 2: your API Key from Artifactory portal

8. Prepare the environment

Change to the new ciocssp-frontend directory. Clean up any old stuff you might have by running

cd $HOME/src/NetEngTools/ciocssp-frontend
./prepare_deployment.sh -c
##############################################
# Notes about Flags
#  -c
#  Clean local environment (clean volumes)
##############################################

9. Set up your environment by running:

/prepare_deployment.sh

If prepare_deployment gives errors, such as Cannot remove current devops image , try running Kitematic . Stop and delete all containers that it lists. Run docker ps --all on the command line to make sure all containers have gone away. If that does not fix it, run docker volume ls. If you see any volumes listed, try docker volume rm .
10. Deploy Bluefringe apps locally

cd $HOME/src/NetEngTools/ciocssp-frontend/
./prepare_deployment.sh -c
./prepare_deployment.sh
docker images -a
cd $HOME/src/core-deploy-tools
./bin/deploy_ciocssp_attempt.sh -r
##############################################
# Notes about Flags
#  -r
#  redeploy CIOCSSP containers (destroy and create).
##############################################

11. Run the smoke test

If you are unsure the base system has deployed correctly, you can run the standard BlueFringe smoke test as follows.

./bin/test_smoke.sh

(Check what is in https://github.ibm.com/NetEngTools/ciocssp about the test)
12. Test Server

Choose your environment url in https://github.ibm.com/NetEngTools/ciocssp