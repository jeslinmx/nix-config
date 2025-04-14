{...}: {
  config,
  lib,
  ...
}: {
  programs.lazygit = {
    settings = {
      gui = {
        scrollPastBottom = false;
        showBottomLine = false;
        nerdFontsVersion = 3;
        border = "rounded";
        theme = {
          activeBorderColor = ["blue" "bold"];
          inactiveBorderColor = ["black"];
          searchingActiveBorderColor = ["cyan"];
          optionsTextColor = ["magenta"];
          selectedLineBgColor = ["reverse"];
          selectedRangeBgColor = ["reverse"];
          cherryPickedCommitBgColor = ["default"];
          cherryPickedCommitFgColor = ["yellow" "underline"];
          unstagedChangesColor = ["red"];
          defaultFgColor = ["default"];
        };
      };
      git = {
        log = {
          order = "date-order";
          showGraph = "always";
        };
        paging.externalDiffCommand = "${lib.getExe' config.programs.git.difftastic.package "difft"} --color=always";
      };
      notARepository = "skip";
      promptToReturnFromSubprocess = false;
      customCommands = [
        {
          # retrieved from: https://github.com/jesseduffield/lazygit/wiki/Custom-Commands-Compendium#conventional-commit
          key = "c";
          context = "files";
          description = "Create new conventional commit";
          prompts = [
            {
              type = "menu";
              key = "Type";
              title = "Type of change";
              options = builtins.attrValues (builtins.mapAttrs (value: description: {inherit value description;}) {
                build = "Changes that affect the build system or external dependencies";
                feat = "A new feature";
                fix = "A bug fix";
                chore = "Other changes that don't modify src or test files";
                ci = "Changes to CI configuration files and scripts";
                docs = "Documentation only changes";
                perf = "A code change that improves performance";
                refactor = "A code change that neither fixes a bug nor adds a feature";
                revert = "Reverts a previous commit";
                style = "Changes that do not affect the meaning of the code";
                test = "Adding missing tests or correcting existing tests";
              });
            }
            {
              type = "input";
              title = "Scope";
              key = "Scope";
              initialValue = "";
            }
            {
              type = "menu";
              key = "Breaking";
              title = "Breaking change?";
              options = [
                {
                  name = "no";
                  value = "";
                }
                {
                  name = "yes";
                  value = "!";
                }
              ];
            }
            {
              type = "input";
              title = "{{.Form.Type}}{{ if .Form.Scope }}({{ .Form.Scope }}){{ end }}{{.Form.Breaking}}: ...";
              key = "Message";
              initialValue = "";
            }
          ];
          command = "git commit --message '{{.Form.Type}}{{ if .Form.Scope }}({{ .Form.Scope }}){{ end }}{{.Form.Breaking}}: {{.Form.Message}}'";
          loadingText = "Creating conventional commit...";
        }
      ];
    };
  };
}
