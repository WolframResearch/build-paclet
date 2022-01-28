#!/bin/bash

set -e

export SCRIPT_DIR=$(dirname ${0})

wolframscript ${SCRIPT_DIR}/install_dependencies.wls

wolframscript ${SCRIPT_DIR}/build_paclet.wls