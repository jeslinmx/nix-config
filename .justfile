switch: build
  sudo nixos-rebuild switch --fast

alias t := test
test: build
  sudo nixos-rebuild test --fast

alias b := build
build debug=false: _update_hm
  nixos-rebuild build {{ if debug == "debug" { debug_flags } else { "" } }} |& nom

alias up := update
update:
  nix flake update

_update_hm:
  nix flake lock --update-input home-configs

false := "false"
debug_flags := "--show-trace --verbose --option eval-cache false"
