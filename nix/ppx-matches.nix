{
  lib,
  ocamlPackages,
}:
with ocamlPackages;
  buildDunePackage {
    pname = "ppx_matches";
    version = "dev";

    src = lib.cleanSource ../.;

    propagatedBuildInputs = [core ppxlib];
    checkInputs = [core_unix];
  }
