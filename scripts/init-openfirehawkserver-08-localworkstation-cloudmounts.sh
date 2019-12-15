#!/bin/bash
argument="$1"

SCRIPTNAME=`basename "$0"`
echo "Argument $1"
echo ""
ARGS=''

cd /vagrant

if [[ -z $argument ]] ; then
  echo "Error! you must specify an environment --dev or --prod" 1>&2
  exit 64
else
  case $argument in
    -d|--dev)
      ARGS='--dev'
      echo "using dev environment"
      source ./update_vars.sh --dev
      ;;
    -p|--prod)
      ARGS='--prod'
      echo "using prod environment"
      source ./update_vars.sh --prod
      ;;
    *)
      raise_error "Unknown argument: ${argument}"
      return
      ;;
  esac
fi

echo 'Use vagrant reload and vagrant ssh after executing each .sh script'
echo "openfirehawkserver ip: $TF_VAR_openfirehawkserver"

# this stage will configure mounts from onsite onto the cloud site, and vice versa.

# vagrant reload
# vagrant ssh

# test the vpn buy logging into softnas and ping another system on your local network.

export TF_VAR_softnas_storage=true
export TF_VAR_site_mounts=true
export TF_VAR_remote_mounts_on_local=true
terraform apply --auto-approve

echo "for the deadline spot plugin to be updated, pulse must be restarted.  Use exit and vagrant reload"
#should add a test script at this point to validate vpn connection is established, or licence servers may not work.

printf "\n...Finished $SCRIPTNAME\n\n"