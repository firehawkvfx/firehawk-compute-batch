#!/bin/bash

to_abs_path() {
  python -c "import os; print os.path.abspath('$1')"
}

config_override=$(to_abs_path $TF_VAR_firehawk_path/../secrets/config-override-$TF_VAR_envtier) # ...Config Override path $config_override.
echo "config_override path- $config_override"
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'allow_interrupt=' 'true' # destroy before deploy
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_enable_vpc=' 'true' # ...Enable the vpc.
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_softnas_storage=' 'true' # ...On first apply, don't create softnas instance until vpn is working.
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_aws_nodes_enabled=' 'true' # ...Site mounts will not be mounted in cloud.  currently this will disable provisioning any render node or remote workstation until vpn is confirmed to function after this step.

# Alter the config file directly for these tests.  Revert to defaults in config.  config override will not disable if the var is set to itself
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_houdini_license_server_address=' '$TF_VAR_houdini_license_server_address' # inherit default
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_localnas1_private_ip=' '$TF_VAR_localnas1_private_ip' # inherit default
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_localnas1_path_abs=' '$TF_VAR_localnas1_path_abs' # inherit default
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_localnas1_export_path=' '$TF_VAR_localnas1_export_path' # inherit default
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_localnas1_volume_name=' '$TF_VAR_localnas1_volume_name' # inherit default

python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_provision_deadline_spot_plugin=' 'true' # Don't provision the deadline spot plugin for this stage
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_install_houdini=' 'true' # install houdini
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_install_deadline_db=' 'true' # install deadline
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_install_deadline_rcs=' 'true' # install deadline
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_install_deadline_worker=' 'true' # install deadline
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_workstation_enabled=' 'true' # install deadline
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_tf_destroy_before_deploy=' 'false' # destroy before deploy
# python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_taint_single=' '(module.node.null_resource.install_deadline_db[0])' # taint
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_taint_single=' '()' # taint
