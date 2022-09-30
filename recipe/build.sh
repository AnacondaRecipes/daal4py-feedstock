#!/bin/bash

if [ "$PY3K" == "1" ]; then
    ARGS="--single-version-externally-managed --record=record.txt"
else
    ARGS="--old-and-unmanageable"
fi

# if dpc++ vars path is specified
if [ ! -z "${DPCPPROOT}" ]; then
    source ${DPCPPROOT}/env/vars.sh
    export CC=dpcpp
    export CXX=dpcpp
    dpcpp --version
fi

# if DAALROOT not exists then provide PREFIX
if [ "${DAALROOT}" != "" ] && [ "${DALROOT}" == "" ] ; then
    export DALROOT="${DAALROOT}"
fi

if [ -z "${DALROOT}" ]; then
    export DALROOT=${PREFIX}
fi

if [ "$(uname)" == "Darwin" ]; then
    export CXX=clang++
fi

export DAAL4PY_VERSION=$PKG_VERSION
export MPIROOT=${PREFIX}

${PYTHON} setup.py install $ARGS

# Confirm that the _onedal_py_host .so file was generated.
test -f onedal/_onedal_py_host*.so || "ERROR: Failed to generate onedal/_onedal_py_host*.so"