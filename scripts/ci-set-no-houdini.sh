#!/bin/bash

to_abs_path() {
  python -c "import os; print os.path.abspath('$1')"
}

config_override=$(to_abs_path $TF_VAR_firehawk_path/../secrets/config-override-$TF_VAR_envtier) # ...Config Override path $config_override.
echo "config_override path- $config_override"
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'allow_interrupt=' 'true' # destroy before deploy

python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_houdini_license_server_address=' 'none' # remove the ip address
python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_install_houdini=' 'false' # install houdini

python $TF_VAR_firehawk_path/scripts/replace_value.py -f $config_override 'TF_VAR_taint_single=' '' # taint vpn