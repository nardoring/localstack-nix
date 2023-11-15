{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    awscli-local = pkgs.callPackage ./awscli {};
    awscdk-local = pkgs.callPackage ./awscdk {};
    terraform-local = pkgs.callPackage ./terraform {};

    localstack-nix = pkgs.buildEnv {
      name = "localstack-nix";
      paths = [awscli-local awscdk-local terraform-local];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.awscli
        pkgs.terraform
        pkgs.localstack

        awscli-local
        awscdk-local
        terraform-local
      ];
    };

    inherit localstack-nix;

    packages."x86_64-linux".default = localstack-nix;
  };
}
