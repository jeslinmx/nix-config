{
  pkgs,
  lib,
  ...
}: {
  programs.vim = {
    defaultEditor = true;
    plugins = let
      easyjump = pkgs.vimUtils.buildVimPlugin {
        name = "easyjump.vim";
        src = pkgs.fetchFromGitHub {
          owner = "girishji";
          repo = "easyjump.vim";
          rev = "137a4f9a3f61d4462bf3ce7652178dfd8c3a30b8";
          hash = "sha256-PK/9hUDmyWDyd4ka0eo+uTarqHaeGeOCSc/ivmMowLg=";
        };
      };
      vim-templates = pkgs.vimUtils.buildVimPlugin {
        name = "vim-templates";
        src = pkgs.fetchFromGitHub {
          owner = "tibabit";
          repo = "vim-templates";
          rev = "c4ce1903fc458688bc421f0cb4572af8a8977cdb";
          hash = "sha256-p0TEJr/2TBoOk48xgtrqwnAtQlYRkz/NEKcadLAJoCA=";
        };
      };
      vim-coloresque = pkgs.vimUtils.buildVimPlugin {
        name = "vim-coloresque";
        src = pkgs.fetchFromGitHub {
          owner = "gko";
          repo = "vim-coloresque";
          rev = "e12a5007068e74c8ffe5b1da91c25989de9c2081";
          hash = "sha256-b8EYF/CYhz6qDmhybNJUVyXmbSfEOap01wP4SwuANRY=";
        };
      };
      autosuggest = pkgs.vimUtils.buildVimPlugin {
        name = "autosuggest.vim";
        src = pkgs.fetchFromGitHub {
          owner = "girishji";
          repo = "autosuggest.vim";
          rev = "8caa30862ea7eac99ffc4efe5170a257233b86a2";
          hash = "sha256-i3I3pk7ngd5RN6a0ADGQu7vt/dU1nFcPtkWWS5TiVTU=";
        };
      };
    in
      (builtins.attrValues {
        inherit
          (pkgs.vimPlugins)
          # Editing
          vim-sensible
          vim-repeat
          vim-sleuth
          vim-surround
          vim-eunuch
          vim-speeddating
          vim-unimpaired
          editorconfig-vim
          auto-pairs
          vim-highlightedyank
          ReplaceWithRegister
          undotree
          Recover-vim
          rainbow
          # LSP/code completion/formatting
          vim-lsp
          vim-lsp-settings
          ale
          asyncomplete-vim
          asyncomplete-lsp-vim
          # Git
          vim-fugitive
          vim-gitgutter
          # UI
          vim-vinegar
          lightline-vim
          lightline-bufferline
          vim-bbye
          vim-which-key
          vim-peekaboo
          goyo-vim
          limelight-vim
          devdocs-vim
          vim-startify
          vim-devicons
          zoomwintab-vim
          ;
      })
      ++ [
        easyjump
        vim-templates
        vim-coloresque
        autosuggest
      ];
    extraConfig = builtins.concatStringsSep "\n" (
      map builtins.readFile (lib.filesystem.listFilesRecursive ./vimrc)
    );
  };
}
