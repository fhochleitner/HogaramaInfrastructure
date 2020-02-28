#!/bin/bash

####################### 
# READ ONLY VARIABLES #
#######################

readonly PROGNAME=`basename "$0"`
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly TOPLEVEL_DIR=$( cd ${SCRIPT_DIR}/../.. > /dev/null && pwd )

#################### 
# GLOBAL VARIABLES #
####################

FLAG_DRYRUN=false

########## 
# SOURCE #
##########

for functionFile in ${TOPLEVEL_DIR}/bootstrap/functions/*.active;
  do source ${functionFile}
done

##########
# SCRIPT #
##########

main () {
  # INITIAL VALUES

  # GETOPT

  ####
  # CHECK INPUT
  # check if all required options are given

  ####
  # CORE LOGIC
  
  options=" --oc-admin-token "$(oc whoami -t)" \
            --oc-cluster https://api.p.aws.ocp.gepardec.com:6443 \
            --namespace hogarama \
            --git-branch $(git branch | grep \* | cut -d ' ' -f2)"

  set -e
  execute "docker run --rm -it \
    -v ${TOPLEVEL_DIR}:/mnt/hogarama \
    quay.io/openshift/origin-cli:latest \
    /mnt/hogarama/bootstrap/scripts/hogarama_create.sh ${options} ${*}"
  set +e
}
 
main $@