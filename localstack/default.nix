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
  localstack-ext,
  plux,
  psutil,
  python-dotenv,
  pyyaml,
  packaging,
  requests,
  rich,
  semver,
  tailer,
}:
buildPythonPackage rec {
  pname = "localstack";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    rev = "refs/tags/v${version}";
    hash = "sha256-HncD/lhYfBrqtXF8F1Gz7JqwrASoHbsXvp1HXM5rldw=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "requests>=2.20.0,<2.26" "requests~=2.20" \
      --replace "cachetools~=5.0.0" "cachetools~=5.0" \
      --replace "boto3>=1.20,<1.25.0" "boto3~=1.20"
  '';

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "dill"
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
    localstack-ext
    plux
    psutil
    python-dotenv
    pyyaml
    packaging
    requests
    rich
    semver
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