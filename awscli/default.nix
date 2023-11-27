{
  buildPythonApplication,
  awscli,
  substituteAll,
  urllib3,
  localstack-client,
  fetchPypi,
}:
buildPythonApplication rec {
  pname = "awscli-local";
  version = "0.21";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-marWuODP77IJNFOGbLzSTnENfmoVI8rAlp7Q9kRC6nw=";
  };

  doCheck = true;

  nativeBuildInputs = [
    urllib3
    localstack-client
  ];

  patches = [
    # hardcode paths to aws in awscli2 package
    (substituteAll {
      src = ./fix-path.patch;
      aws = "${awscli}/bin/aws";
    })
  ];

  checkPhase = ''
    $out/bin/awslocal -h
    $out/bin/awslocal --version
  '';
}
