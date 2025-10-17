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
      # Extract package name from pkgPath (e.g., "node_modules/adb-wifi" -> "adb-wifi")
      packageName = lib.last (lib.splitString "/" pkgPath);
    in
    # Only consider actual dependency packages, not the root package ""
    if pkgPath != "" && pkgPath != "node_modules/.bin" then # Exclude .bin directory
      lib.map (b: b // { pkgName = packageName; }) (getBinaries pkg)
    else
      []
  ) packageLock.packages);

  # Generate wrapper scripts
  wrapperScripts = lib.concatStringsSep "\n" (lib.map (bin: ''
    cat > $out/bin/${bin.name} << EOF
    #!${pkgs.runtimeShell}
    export NODE_PATH="$out/node_modules"
    exec "${pkgs.lib.getExe pkgs.nodejs}" "$out/node_modules/${bin.pkgName}/${bin.path}" "$@"
    EOF
    chmod +x $out/bin/${bin.name}
  '') allBinaries);

in pkgs.buildNpmPackage rec {
  pname = "npm_tools";
  version = "1.0.0";
  src = ./.;
  npmDepsHash = "sha256-KrZfKp7K86ZY7b03I4LVeM0R1nJJvsgUZbLi64kb1iU=";
  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r node_modules $out/

    ${wrapperScripts}
  '';
}