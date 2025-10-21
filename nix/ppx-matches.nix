{
  lib,
  ocamlPackages,
}:
with ocamlPackages;
  buildDunePackage {
    pname = "ppx-matches";
    version = "dev";

    src = lib.cleanSource ../.;

    propagatedBuildInputs = [core ppxlib];
    checkInputs = [core_unix];
  }
