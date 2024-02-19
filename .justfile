default_rebuild_operation := 'switch'

alias up := update

rebuild operation=default_rebuild_operation: update_hm
  nixos-rebuild {{operation}} --use-remote-sudo |& nom

debug operation=default_rebuild_operation: update_hm
  nixos-rebuild {{operation}} --use-remote-sudo --show-trace --verbose --option eval-cache false

update:
  nix flake update

update_hm:
  nix flake lock --update-input home-configs
