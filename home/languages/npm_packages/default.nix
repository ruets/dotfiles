{ config, pkgs, lib, ... }:

let
  packageLock = builtins.fromJSON (builtins.readFile ./package-lock.json);

  # Function to extract binaries from a package entry
  getBinaries = packageEntry:
    let
      bin = packageEntry.bin or {};
    in
    if builtins.isString bin then
      # Handle case where 'bin' is a string (single binary, name is package name)
      [ { name = packageEntry.name; path = bin; } ]
    else if builtins.isAttrs bin then
      # Handle case where 'bin' is an attribute set (multiple binaries)
      lib.mapAttrsToList (name: path: { inherit name path; }) bin
    else
      []; # No binaries

  # Collect all binaries from all packages
  allBinaries = lib.flatten (lib.mapAttrsToList (pkgPath: pkg:
    let
      packageName = lib.removePrefix "node_modules/" pkgPath;
    in
    # Only consider actual dependency packages, not the root package ""
    if pkgPath != "" && pkgPath != "node_modules/.bin" then # Exclude .bin directory
      lib.map (b: b // { pkgName = packageName; }) (getBinaries pkg)
    else
      []
  ) packageLock.packages);

  # Generate wrapper scripts
  makeWrappers = lib.concatStringsSep "\n" (lib.map (bin: ''
    makeWrapper ${pkgs.nodejs}/bin/node $out/bin/${bin.name} \
      --add-flags "$out/lib/node_modules/${bin.pkgName}/${bin.path}" \
      --set NODE_PATH "$out/lib/node_modules"
  '') allBinaries);

in pkgs.buildNpmPackage rec {
  pname = "npm_packages";
  version = "1.0.0";
  src = ./.;
  npmDepsHash = "sha256-/GxHDxfm59IKbVyXKqD0Aqks+qvKWP1BpRTjb3EgsNs=";
  dontNpmBuild = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/lib
    cp -r node_modules $out/lib/
    ${makeWrappers}
  '';
}