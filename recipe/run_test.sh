#!/bin/bash

set -ex
# Confirm that the _onedal_py_host .so/.pyd file was generated
# This is especially needed by scikit-learn-intelex.
if [ `ls -1 ${PREFIX}/lib/python*/site-packages/onedal/_onedal_py_host*.so 2>/dev/null | wc -l ` -gt 0 ];
then
    echo "OK"
else
    echo "Error: Necessary .so files missing from built package."
    exit 1
fi

# The downstream package scikit-learn-intelex v2023.1.1 requires the header `library_version_info.h`, 
# see https://github.com/intel/scikit-learn-intelex/blob/4abff0df77475a7e7c3f3da135fdc9dc586f8f1e/scripts/version.py#L39
# Make sure it is present.
test -f $PREFIX/include/services/library_version_info.h

# Upstream tests
cd tests
${PYTHON} -c "import daal4py"

# Run tests
mpirun -n 4 ${PYTHON} -m unittest discover -v -p spmd*.py
${PYTHON} -m unittest discover -v -p 'test*[!ex].py'
pytest --verbose --pyargs ../daal4py/sklearn
pytest --verbose --pyargs ../onedal
${PYTHON} run_examples.py
${PYTHON} -m daal4py ../examples/daal4py/sycl/sklearn_sycl.py

#*******************************************************************************
# Copyright 2014-2020 Intel Corporation
# All Rights Reserved.
#
# This software is licensed under the Apache License, Version 2.0 (the
# "License"), the following terms apply:
#
# You may not use this file except in compliance with the License.  You may
# obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#*******************************************************************************

# if dpc++ vars path is specified
if [ ! -z "${DPCPPROOT}" ]; then
    source ${DPCPPROOT}/env/vars.sh
fi

# if DAALROOT is specified
if [ ! -z "${DAALROOT}" ]; then
    conda remove daal --force -y
    source ${DAALROOT}/env/vars.sh
fi

# if TBBROOT is specified
if [ ! -z "${TBBROOT}" ]; then
    conda remove tbb --force -y
    source ${TBBROOT}/env/vars.sh
fi
