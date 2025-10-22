{
  description = "PPX Matches Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # Linting
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks.url = "github:cachix/git-hooks.nix";

    # OCaml overlay
    ocaml-overlay = {
      url = "github:nix-ocaml/nix-overlays";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            ocaml-overlay.overlays.default
            (import ./nix/overlay.nix)
          ];
        };

        ppx-matches = pkgs.callPackage ./nix/ppx-matches.nix {};

        fmt = treefmt.lib.evalModule pkgs {
          projectRootFile = "flake.nix";

          programs.alejandra.enable = true;
          programs.ocamlformat.enable = true;

          settings.global.excludes = ["result" ".direnv" "_build" "_opam"];
        };
      in {
        packages = {
          inherit ppx-matches;
          default = ppx-matches;
        };

        checks = {
          ppx-matches = ppx-matches.overrideAttrs (old: {
            name = "check-${old.name}";
            doCheck = true;
          });

          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              commitizen.enable = true;

              # Configure treefmt to use the above treefmt config
              treefmt.enable = true;
              treefmt.package = fmt.config.build.wrapper;
            };
          };
        };

        formatter = fmt.config.build.wrapper;

        devShells.default = let
          pre-commit-check = self.checks.${system}.pre-commit-check;
        in
          pkgs.mkShell {
            name = "ppx-matches-dev-shell";

            # Inherit inputs for tests as well
            inputsFrom = [(ppx-matches.overrideAttrs (_: {doCheck = true;}))];
            inherit (pre-commit-check) shellHook;

            buildInputs = with pkgs;
              [
                # Formatters
                alejandra
                ocamlformat
                commitizen

                # OCaml devenv
                ocamlPackages.utop
                ocamlPackages.ocaml-lsp
                ocamlPackages.merlin
                ocamlPackages.merlin-lib
                ocamlPackages.ocaml
                ocamlPackages.dune
                ocamlPackages.dune-release
              ]
              ++ pre-commit-check.enabledPackages;
          };

        apps.ci-cz = {
          type = "app";
          program = "${pkgs.commitizen}/bin/cz";
        };
      });
}
