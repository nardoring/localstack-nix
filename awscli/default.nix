{
  lib,
  awscli,
  botocore,
  buildPythonApplication,
  fetchPypi,
  installShellFiles,
  localstack-client,
  patchRcPathBash,
}:
buildPythonApplication rec {
  pname = "awscli-local";
  version = "0.22.0";

  src = fetchPypi {
    inherit pname version;
    # hash = "sha256-marWuODP77IJNFOGbLzSTnENfmoVI8rAlp7Q9kRC6nw="; # 0.21
    hash = "sha256-OAfPLuS73U3038i+8CfyW95SPcr4EZcg9nftleu6ZqQ="; # 0.22.0
  };

  nativeBuildInputs = [
    installShellFiles
    patchRcPathBash
  ];

  propagatedBuildInputs = [
    awscli
    botocore
    localstack-client
  ];

  doInstallCheck = true;
  doFixup = true;

  installCheckPhase = ''
    $out/bin/awslocal -h
    $out/bin/awslocal --version
  '';

  postInstall = ''
    # Install Bash completions
    installShellCompletion --cmd awslocal \
      --bash <(echo "complete -C ${awscli}/bin/aws_completer awslocal")

    # Create Zsh initialization script
    cat > $out/bin/awslocal-zsh-init <<EOF
    #!/usr/bin/env zsh -i
    autoload -Uz compinit && compinit
    autoload -Uz bashcompinit && bashcompinit
    complete -C ${awscli}/bin/aws_completer awslocal

    EOF
    chmod +x $out/bin/awslocal-zsh-init

    patchRcPathBash $out/bin/awslocal-zsh-init
  '';

  # source the completion init script
  # source awslocal-zsh-init

  meta = with lib; {
    description = "Thin wrapper around the 'aws' command line interface for use with LocalStack";
    license = licenses.apsl20;
    maintainers = with maintainers; [katanallama];
    homepage = "https://github.com/localstack/awscli-local";
  };
}
