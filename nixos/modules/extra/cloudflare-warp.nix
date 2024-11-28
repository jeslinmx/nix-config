{pkgs, ...}: {
  environment.systemPackages = [pkgs.cloudflare-warp]; # for warp-svc
  systemd.packages = [pkgs.cloudflare-warp]; # for warp-cli
  systemd.targets.multi-user.wants = ["warp-svc.service"];
}
