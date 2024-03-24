{
  lib,
  buildPythonPackage,
  pythonRelaxDepsHook,
  fetchFromGitHub,
  setuptools,
  apispec,
  boto3,
  cachetools,
  click,
  cryptography,
  dill,
  dnslib,
  dnspython,
  localstack-client,
  plux,
  psutil,
  pyaes,
  python-dateutil,
  python-dotenv,
  python-jose,
  pyyaml,
  packaging,
  requests,
  rich,
  semver,
  tabulate,
  tailer,
}:
buildPythonPackage rec {
  pname = "localstack";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    rev = "refs/tags/v${version}";
    # hash = "sha256-r0KRPtsLr6Pyn/va93reLdHHKtiOLB1uflAJ2L/uZmU="; # 3.0.2
    # hash = "sha256-r0KRPtsLr6Pyn/va93reLdHHKtiOLB1uflAJ2L/uZmU="; # 3.2.0
    hash = "sha256-hUq1w0i2ui86qUKviqOkez/G9OXxEmGP1Ipgax4Ko5k="; # 3.1.0
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-warn "plux>=1.7" "plux~=1.50"
  '';

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cryptography"
    "dill"
    "plux"
  ];

  propagatedBuildInputs = [
    apispec
    boto3
    cachetools
    click
    cryptography
    dill
    dnslib
    dnspython
    localstack-client
    plux
    psutil
    pyaes
    python-dateutil
    python-dotenv
    python-jose
    pyyaml
    packaging
    requests
    rich
    semver
    tabulate
    tailer
  ];

  pythonImportsCheck = ["localstack"];

  # Test suite requires boto, which has been removed from nixpkgs
  # Just do minimal test, buildPythonPackage maps checkPhase
  # to installCheckPhase, so we can test that entrypoint point works.
  checkPhase = ''
    $out/bin/localstack --version
  '';

  meta = with lib; {
    description = "A fully functional local Cloud stack";
    homepage = "https://github.com/localstack/localstack";
    license = licenses.asl20;
  };
}
