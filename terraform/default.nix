{
  buildPythonApplication,
  terraform,
  fetchPypi,
  bc-python-hcl2,
  localstack-client,
}:
buildPythonApplication rec {
  pname = "terraform-local";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MZMhPFQnXVokB9AXY3eKh25FoE2qpIxKaYpkgH11eh4=";
  };

  doCheck = true;

  nativeBuildInputs = [
    bc-python-hcl2
    localstack-client
  ];

  propagatedBuildInputs = [
    bc-python-hcl2
  ];

  nativeCheckInputs = [
    terraform
  ];

  checkPhase = ''
    $out/bin/tflocal --version
  '';
}
