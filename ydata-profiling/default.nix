{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  pythonRelaxDepsHook,
  fastparquet,
  htmlmin,
  imagehash,
  jinja2,
  matplotlib,
  multimethod,
  numpy,
  pandas,
  pydantic,
  pyyaml,
  requests,
  scipy,
  seaborn,
  statsmodels,
  tqdm,
  typeguard,
  visions,
  numba,
  dacite,
  wordcloud,
}:
buildPythonPackage rec {
  pname = "ydata-profiling";
  version = "4.7.0";
  disabled = pythonOlder "3.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-iDsNVwQd2qLw09neLwfaXvN+Kk0gutPqHdd0pfV/ens=";
  };

  nativeBuildInputs = [pythonRelaxDepsHook];
  pythonRelaxDeps = ["numpy" "scipy" "matplotlib" "wordcloud"];

  preBuild = ''
    echo ${version} > VERSION
  '';

  propagatedBuildInputs = [
    htmlmin
    imagehash
    jinja2
    matplotlib
    multimethod
    numpy
    pandas
    pydantic
    pyyaml
    requests
    scipy
    seaborn
    statsmodels
    tqdm
    typeguard
    visions
    numba
    dacite
    wordcloud
  ];

  nativeCheckInputs = [
    pytestCheckHook
    fastparquet
  ];

  doCheck = false;

  meta = with lib; {
    description = "Create HTML profiling reports from Pandas DataFrames";
    homepage = "https://ydata-profiling.ydata.ai";
    license = licenses.mit;
    mainProgram = "ydata_profiling";
  };
}
