_lib:
let
  readFlat = srcPath: srcAbsPath: destPath: mkSource:
    let
      names  = builtins.attrNames (builtins.readDir srcPath);
      mkKey  = name: if destPath == "" then name else "${destPath}/${name}";
    in
    map (name: {
      name  = mkKey name;
      value.source = mkSource "${srcAbsPath}/${name}";
    }) names;

  readRecursive = srcPath: srcAbsPath: destPath: mkSource:
    let
      entries = builtins.readDir srcPath;
      names   = builtins.attrNames entries;
      mkKey   = name: if destPath == "" then name else "${destPath}/${name}";
    in
    builtins.concatLists (map (name:
      let
        key        = mkKey name;
        fullSrc    = srcPath + "/${name}";
        fullAbsSrc = "${srcAbsPath}/${name}";
      in
      if entries.${name} == "directory"
        then readRecursive fullSrc fullAbsSrc key mkSource
        else [{ name = key; value.source = mkSource fullAbsSrc; }]
    ) names);
in
{
  # config    : le `config` du module appelant
  # srcPath   : Nix path vers le dossier source (pour builtins.readDir, évaluation pure)
  # srcAbsPath: chemin absolu vers le même dossier (pour le symlink hors-store)
  # destPath  : préfixe des clés dans l'attrset résultant (défaut : "")
  # recursive : descend dans les sous-dossiers (défaut : false)
  mkConfigSymlinks =
    { config
    , srcPath
    , srcAbsPath
    , destPath  ? ""
    , recursive ? false
    }:
    let mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in builtins.listToAttrs (
      if recursive
        then readRecursive srcPath srcAbsPath destPath mkOutOfStoreSymlink
        else readFlat      srcPath srcAbsPath destPath mkOutOfStoreSymlink
    );
}
