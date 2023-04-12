:: Confirm that the _onedal_py_host .so/.pyd file was generated
:: This is especially needed by scikit-learn-intelex.
if not exist %PREFIX%\\Lib\\site-packages\\onedal\\_onedal_py_host*.pyd exit 1

:: Upstream tests
%PYTHON% -c "import daal4py"
mpiexec -localonly -n 4 %PYTHON% -m unittest discover -v -p spmd*.py
%PYTHON% -m unittest discover -v -p 'test*[!ex].py'
pytest --verbose --pyargs daal4py\sklearn\
::pytest --verbose --pyargs onedal\ --deselect="onedal\common\tests\test_policy.py" --deselect="onedal\svm\tests\test_svc.py::test_estimator"
%PYTHON% tests\run_examples.py
%PYTHON% -m daal4py examples\daal4py\sycl\sklearn_sycl.py
