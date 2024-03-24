{ lib
, buildPythonPackage
, fetchFromGitHub
, boto3
, pytestCheckHook

# downstream dependencies
, localstack
}:

buildPythonPackage rec {
  pname = "localstack-client";
  version = "2.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack-python-client";
    # Request for proper tags: https://github.com/localstack/localstack-python-client/issues/38
    rev = "f6195ce4ed9e7a607d608ed8bbb27514aa7fd39e";
    hash = "sha256-/dORqvhc0+cLi+CaB2fmDs9ykxWTS78WkWM9vKwh4tA=";
  };

  propagatedBuildInputs = [
    boto3
  ];

  pythonImportsCheck = [
    "localstack_client"
  ];

  # All commands test `localstack` which is a downstream dependency
  doCheck = false;
  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Has trouble creating a socket
    "test_session"
  ];

  # For tests
  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit localstack;
  };

  meta = with lib; {
    description = "A lightweight Python client for LocalStack";
    homepage = "https://github.com/localstack/localstack-python-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
