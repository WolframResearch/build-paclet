#!/bin/bash

set -e

echo "GITHUB_ENV="$GITHUB_ENV

export SCRIPT_DIR=$(dirname ${0})

wolframscript ${SCRIPT_DIR}/install_dependencies.wls

wolframscript ${SCRIPT_DIR}/build_paclet.wls

echo $(cat $GITHUB_ENV)
echo "pwd="$(pwd)
echo "BUILD_DIR="$BUILD_DIR
echo $(ls -la)
