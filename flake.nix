{
  description = "Fnordcredit Cash Solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-tree;

        devShell = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            nodePackages.prisma
            (yarn.override { nodejs = nodejs_22; })
            nodejs_22
            nodePackages.typescript
            nodePackages.typescript-language-server
            nodePackages."@tailwindcss/language-server"
          ];
          shellHook = with pkgs; ''
            export PRISMA_SCHEMA_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
            export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
            export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
            export POSTGRES_PRISMA_URL=postgres://fnordcredit:fnordcredit@localhost/fnordcredit
            export POSTGRES_URL_NON_POOLING=postgres://fnordcredit:fnordcredit@localhost/fnordcredit
          '';
        };
      }
    );
}
