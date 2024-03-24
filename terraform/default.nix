{
  buildPythonApplication,
  terraform,
  fetchPypi,
  bc-python-hcl2,
  localstack-client,
  packaging,
}:
buildPythonApplication rec {
  pname = "terraform-local";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    # hash = "sha256-MZMhPFQnXVokB9AXY3eKh25FoE2qpIxKaYpkgH11eh4="; # 0.16.0
    hash = "sha256-dx/nPts3obTbU61kHPQ1Tqb+eseEnra0emnzPJkJ3zU="; # 0.18.1
  };

  doCheck = true;

  nativeBuildInputs = [
    packaging
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
