#!/bin/bash
set -x -e

# install pip & tmux
sudo yum -y install python27-pip tmux

# install rmate
sudo gem install rmate

# setup variables
PYTHON=/usr/bin/python2.7
PIP=/usr/bin/pip-2.7
HOME=/home/hadoop
SPARK_HOME=/usr/lib/spark

cd $HOME

#Install ipython and dependency
sudo $PIP install -U pip
sudo $PIP install -U setuptools
sudo $PIP install -U "ipython[notebook]"
sudo $PIP install -U "jupyter"
sudo $PIP install -U requests numpy pandas
sudo $PIP install -U matplotlib


#Create pyspark profile
ipython profile create pyspark

PYSPARK_KERNEL_CONFIG_DIR=$HOME"/.ipython/kernels/pyspark"
PYSPARK_KERNEL_CONFIG=$PYSPARK_KERNEL_CONFIG_DIR"/kernel.json"

# make pyspark kernel directory
mkdir -p $PYSPARK_KERNEL_CONFIG_DIR

# Configure pyspark kernel startup
IPYTHON_STARTUP_CONFIG=$HOME"/.ipython/profile_pyspark/startup/00-setup-pyspark.py"

cat > $PYSPARK_KERNEL_CONFIG <<- EOM
{
  "display_name": "pyspark",
  "language": "python",
  "argv": [
    "${PYTHON}",
    "-m",
    "IPython.kernel",
    "--profile=pyspark",
    "-f",
    "{connection_file}"
  ],
  "env": {
    "SPARK_HOME": "${SPARK_HOME}",
    "PYSPARK_SUBMIT_ARGS": "--master yarn pyspark-shell",
    "PYSPARK_PYTHON": "${PYTHON}"
  }
}
EOM

# Configure pyspark startup
IPYTHON_STARTUP_CONFIG=$HOME"/.ipython/profile_pyspark/startup/00-setup-pyspark.py"

cat > $IPYTHON_STARTUP_CONFIG <<- EOM
#!${PYTHON}
import os
import sys

spark_home = os.environ.get('SPARK_HOME', None)
if not spark_home:
    raise ValueError('SPARK_HOME environment variable is not set')
sys.path.insert(0, os.path.join(spark_home, 'python'))
sys.path.insert(0, os.path.join(spark_home, 'python/lib/py4j-0.9-src.zip'))
execfile(os.path.join(spark_home, 'python/pyspark/shell.py'))
EOM

# create jupyter conf
jupyter notebook --generate-config

# configure jupyter notebook
JUPYTER_CONFIG=$HOME"/.jupyter/jupyter_notebook_config.py"

cat > $JUPYTER_CONFIG <<- EOM
c = get_config()
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False

from subprocess import check_call
import os

def save_script_and_markdown(model, os_path, contents_manager):
    """post-save hook for converting notebooks to .py scripts"""
    if model['type'] != 'notebook':
        return  # only do this for notebooks
    d, fname = os.path.split(os_path)
    check_call(['jupyter', 'nbconvert', '--to', 'script', fname], cwd=d)
    check_call(['jupyter', 'nbconvert', '--to', 'markdown', fname], cwd=d)


def post_save(*args, **kwargs):
    save_script_and_markdown(*args, **kwargs)


c.FileContentsManager.post_save_hook = post_save

EOM

# setup spark environment on master
if [[ -e /usr/lib/spark/conf/spark-env.sh ]]; then
  . /usr/lib/spark/conf/spark-env.sh
fi

