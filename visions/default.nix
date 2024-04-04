{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  attrs,
  imagehash,
  matplotlib,
  multimethod,
  networkx,
  numpy,
  pandas,
  pillow,
  pydot,
  pygraphviz,
  shapely,
}:
buildPythonPackage rec {
  pname = "visions";
  version = "0.7.6";
  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-APSUp/eJF9sikuEeqDLG4Ca2R4PmiLEdok9MJx7xYx0=";
  };

  propagatedBuildInputs = [
    attrs
    imagehash
    multimethod
    networkx
    numpy
    pandas
  ];

  nativeCheckInputs =
    [
      pytestCheckHook
    ]
    ++ passthru.optional-dependencies.type-geometry
    ++ passthru.optional-dependencies.type-image-path
    ++ passthru.optional-dependencies.plotting;

  # errors due to use of deprecated Numpy API:
  disabledTests = ["test_declarative" "test_sequences"];
  disabledTestPaths = [
    # errors due to use of deprecated Numpy API:
    "tests/numpy_/typesets/test_standard_set.py"
    "tests/pandas_/typesets/test_standard_set_sparse.py"
    # requires running Spark:
    "tests/spark_/typesets/test_spark_standard_set.py"
  ];

  pythonImportsCheck = [
    "visions"
  ];

  passthru.optional-dependencies = {
    type-geometry = [shapely];
    type-image-path = [imagehash pillow];
    plotting = [matplotlib pydot pygraphviz];
  };

  meta = with lib; {
    description = "Type system for data analysis in Python";
    homepage = "https://dylan-profiler.github.io/visions";
    license = licenses.bsdOriginal;
  };
}
