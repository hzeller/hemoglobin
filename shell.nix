{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs;
    [
      gnuplot
      inkscape
    ];
  shellHook =
  ''
  '';
}
