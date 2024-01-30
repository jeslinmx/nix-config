rec {
  readDirFiltered = filetype: dir:
    with builtins; let
      dirContents = readDir dir;
    in
      listToAttrs (concatMap (
        fname:
          if dirContents.${fname} == filetype
          then [
            {
              name = fname;
              value = dir + "/${fname}";
            }
          ]
          else []
      ) (attrNames dirContents));
  readSubdirs = readDirFiltered "directory";
  readDirFiles = readDirFiltered "regular";
}
