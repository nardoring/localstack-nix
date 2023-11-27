{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  apispec,
  boto3,
  cachetools,
  click,
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
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    rev = "refs/tags/v${version}";
    hash = "sha256-2K1Kza7OkBGi6ezrEObj6qXcoNd8EFBJZXFH2Prwzps=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "requests>=2.20.0,<2.26" "requests~=2.20" \
      --replace "cachetools~=5.0.0" "cachetools~=5.0" \
      --replace "boto3>=1.20,<1.25.0" "boto3~=1.20"
  '';

  propagatedBuildInputs = [
    apispec
    boto3
    cachetools
    click
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
}
