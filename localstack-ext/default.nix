{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools
, plux

# dependencies
, cachetools
, click
, cryptography
, dill
, dnslib
, dnspython
, psutil
, pyaes
, python-dateutil
, python-dotenv
, python-jose
, pyyaml
, requests
, rich
, semver
, stevedore
, tailer
, tabulate

# Sensitive downstream dependencies
, localstack
}:

buildPythonPackage rec {
  pname = "localstack-ext";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    # hash = "sha256-53pbt7kNaYQRsLb+OI8gLwR3cBE18ZKLZmG4aP1/93E="; # 3.2.0
    hash = "sha256-FE9G8rT7xuDy8RIYS0xs4880CrXf342DW5aQ/3srZqI="; # 3.1.0
  };

  postPatch = ''
    # Avoid circular dependency
    sed -i '/localstack>=/d' setup.cfg

    # Pip is unable to resolve attr logic, so it will emit version as 0.0.0
    substituteInPlace setup.cfg \
      --replace "version = attr: localstack_ext.__version__" "version = ${version}"
    cat setup.cfg
  '';

  nativeBuildInputs = [
    plux
    setuptools
    tabulate
  ];

  pythonRelaxDeps = [
    # "cryptography" # 3.2.0
    # "dill"
    "plux"
  ];

  propagatedBuildInputs = [
    cachetools
    click
    cryptography
    dill
    dnslib
    dnspython
    plux
    psutil
    pyaes
    python-dateutil
    python-dotenv
    python-jose
    pyyaml
    rich
    requests
    semver
    stevedore
    tailer
    localstack
  ];

  pythonImportsCheck = [ "localstack_ext" ];

  # No tests in repo
  doCheck = false;

  passthru.tests = {
    inherit localstack;
  };

  meta = with lib; {
    description = "Extensions for LocalStack";
    homepage = "https://github.com/localstack/localstack";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
