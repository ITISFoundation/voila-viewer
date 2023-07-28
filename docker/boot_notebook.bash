#!/bin/bash
# SEE http://redsymbol.net/articles/unofficial-bash-strict-mode/

set -euo pipefail
IFS=$'\n\t'
INFO="INFO: [$(basename "$0")] "

echo "$INFO" "  User    :$(id "$(whoami)")"
echo "$INFO" "  Workdir :$(pwd)"

# Trust all notebooks in the notebooks folder
echo "$INFO" "trust all notebooks in path..."
find "${NOTEBOOK_BASE_DIR}" -name '*.ipynb' -type f | xargs -I % /bin/bash -c 'jupyter trust "%" || true' || true

# Configure
# Prevents notebook to open in separate tab
mkdir --parents "$HOME/.jupyter/custom"
cat > "$HOME/.jupyter/custom/custom.js" <<EOF
define(['base/js/namespace'], function(Jupyter){
    Jupyter._target = '_self';
});
EOF

# SEE https://jupyter-server.readthedocs.io/en/latest/other/full-config.html
cat > .jupyter_config.json <<EOF
{
    "FileCheckpoints": {
        "checkpoint_dir": "/home/jovyan/._ipynb_checkpoints/"
    },
    "KernelSpecManager": {
        "ensure_native_kernel": false,
        "whitelist": ["python-maths", "octave"]
    },
    "Session": {
        "debug": false
    },
    "VoilaConfiguration" : {
        "enable_nbextensions" : true
    },
    "ServerApp": {
        "base_url": "",
        "disable_check_xsrf": true,
        "extra_static_paths": ["/static"],
        "ip": "0.0.0.0",
        "notebook_dir": "${NOTEBOOK_BASE_DIR}",
        "open_browser": false,
        "port": 8888,
        "preferred_dir": "${NOTEBOOK_BASE_DIR}/workspace/",
        "quit_button": false,
        "root_dir": "${NOTEBOOK_BASE_DIR}",
        "token": "${NOTEBOOK_TOKEN}",
        "webbrowser_open_new": 0
    }
}
EOF

cat > "/opt/conda/share/jupyter/lab/overrides.json" <<EOF
{
     "@krassowski/jupyterlab-lsp:completion": {
        "disableCompletionsFrom": ["Kernel"],
        "kernelResponseTimeout": -1
      },
     "@jupyterlab/apputils-extension:themes": {
     "theme": "dark"
  },

}
EOF

# # shellcheck disable=SC1091
source .venv/bin/activate
export DEVEL_MODE=False
echo "Starting up a webserver to monitor the inputs..."
python /src/webserver_input_monitor.py

echo "Starting voila"
cp $DY_SIDECAR_PATH_INPUTS/input_1/voila.ipynb "${NOTEBOOK_BASE_DIR}"/workspace/voila.ipynb

voila "${NOTEBOOK_BASE_DIR}"/workspace/voila.ipynb --enable_nbextensions=True --port 8888 --Voila.ip="0.0.0.0" --no-browser