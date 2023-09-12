```bash
nixos-generate-config --dir "nixos/${HOSTNAME}/"
sudo nixos-rebuild switch --flake ".#${HOSTNAME}"
```
