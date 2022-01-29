#!/bin/bash

set -e

export SCRIPT_DIR=$(dirname ${0})

echo "::group::Installing dependencies..."
wolframscript ${SCRIPT_DIR}/install_dependencies.wls
echo "::endgroup::"

echo "::group::Building Paclet..."
wolframscript ${SCRIPT_DIR}/build_paclet.wls
echo "::endgroup::"