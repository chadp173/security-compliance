

export TAG=20200812
export BIN=/Users/chad.perry1/src/NetEngTools/ciocssp-service/
export LOGS=/Users/chad.perry1/Desktop/
export CORE=Users/chad.perry1/src/NetEngTools/core-deploy-tools/containers

# ibm cloud registry
export IMAGE=base_phusion_java8:$TAG
export SRC=bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/${IMAGE} 
export DEST=us.icr.io/bluefringe/base_phusion_java8:$TAG

docker tag $SRC $DEST 
docker push $DEST

// #-------------#
// # Base Images #
// #-------------#

// ./bin/build_base_images.sh -t $TAG -n base_phusion_java8 -o --no-cache -b
// ./bin/build_base_images.sh -t $TAG -nbase_phusion_nojava -o --no-cache -b 


// # All others
// ./bin/build_base_images.sh -g $TAG -t $TAG -n base_fringe_uep_svc -b
// ./bin/build_base_images.sh -g $TAG -t $TAG -n base_fringe_svc -b
// ./bin/build_base_images.sh -g $TAG -t $TAG -n base_fringe_de_java_web -b
// ./bin/build_base_images.sh -g $TAG -t $TAG -n base_build_tools -b




// # ./build_image.sh -f bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/base_fringe_uep_svc:20200810 -b -t $TAG

#----------------------# 
#   Create TAR Files   #
#----------------------#

cd $BIN 
APP =  fringe_analytics_svc, fringe_de_policy_approve, fringe_uep_svc, fringe_svc, vault_client 

# fringe_analytics
./bin/build_ciocssp_component.sh -c build_fringe_bfa_local.sh -p fringe_analytics_svc/config/fringe_bfa_src.tar 

# fringe_de_policy_approve
./bin/build_ciocssp_component.sh -c build_fringe_policy_approve_local.sh -p fringe_de_policy_approve/config/fringe_policy_approve_src.tar

# fringe_uep_svc
 ./bin/build_ciocssp_component.sh -c ./build_fringe_uep_local.sh -p fringe_uep_svc/config/fringe_uep_src.tar

# fringe_svc
./bin/build_ciocssp_component.sh -c build_fringe_svc_local.sh -p fringe_svc/config/fringe_svc_src.tar

# vault_client
./bin/build_ciocssp_component.sh -c build_vault_local.sh -p vault_client/config/vault_client.tar

cp containers/${APP}_svc/config/${APP}_src.tar ${CORE}/${APP}_sv/config

#----------------------#
#  Build Fringe Images #
#----------------------#
cd /Users/chad.perry1/src/NetEngTools/container/

#vault_client
docker build -t bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/vault_client:$TAG . 

# fringe_analytics_svc
docker build -t bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_analytics_svc:$TAG .

# fringe_uep_svc
docker build -t bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_uep_svc:$TAG .

# fringe_svc
docker build -t bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_svc:$TAG . 

# fringe_de_policy_approve
docker build -t bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_de_policy_approve:$TAG . 




./bin/build_ciocssp_component.sh -c build_fringe_expand_local.sh -p fringe_de_expand/config/fringe_expand_src.tar 



export image=base_phusion_java8:20200/81
export src=bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/base_phusion_java8:20200810
export dest=us.icr.io/bluefringe/base_phusion_java8:20200810

docker tag $src $dest
docker push $dest


Just rebuilding fringe svc
- can't build the docker image in core-deploy-tools without the tarball

- fringe_svc builds NetEngTools/ciocssp-core

- build_artifact.sh runs a bunch of build_ciocssp_component.sh, and I just want the one component so I'm just going to use that
  print_message "Building SVC component"
  ${BIN_DIR}/build_ciocssp_component.sh -c build_fringe_svc_local.sh -p fringe_svc/config/fringe_svc_src.tar
  check_status "Cannot build SVC component"

- Ran ./bin/build_ciocssp_component.sh -c build_fringe_svc_local.sh -p fringe_svc/config/fringe_svc_src.tar

- copied fringe_svc_src.tar into core-deploy-tools/containers/.../config

- ran docker build from core-deploy-tools/containers/.../config

- pushed as bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/fringe_svc:svc-proxy-heartbeats


  ./build_ciocssp_component.sh -c ./build_fringe_uep_local.sh -p fringe_uep_svc/config/fringe_uep_src.tar 

  ./bin/build_ciocssp_component.sh -c build_vault_local.sh -p vault_client/config/vault_client.tar