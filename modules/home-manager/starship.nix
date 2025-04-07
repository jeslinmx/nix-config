{lib, ...}: {
  programs.starship = {
    settings = {
      format = lib.concatStrings [
        "($fill$cmd_duration$fill$line_break$line_break)"
        "$time$custom"
        "(// $username(@$hostname:)$directory$sudo$\{custom.ssh_agent})"
        "(// $fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$vcsh)"
        "(// $aws$azure$gcloud$openstack)"
        "(// $container$singularity)"
        "(// $conda$guix_shell$meson$nix_shell$spack$package)"
        "(// $docker_context$kubernetes$helm$buf$bun$cmake$gradle)"
        "(// $all)"
        "$line_break"
        "$shlvl$shell$character"
      ];

      fill.symbol = " ";

      character = {
        success_symbol = "[❭](bold green)";
        error_symbol = "[❭](bold red)";
        vimcmd_symbol = "[❬](bold green)";
        vimcmd_replace_one_symbol = "[❬](bold purple)";
        vimcmd_replace_symbol = "[❬](bold purple)";
        vimcmd_visual_symbol = "[❬](bold cyan)";
      };

      cmd_duration = {
        min_time = 0;
        format = "[<<=====/](dimmed white) [$duration]($style) [/=====>>](dimmed white)";
      };

      directory = {
        truncation_length = 0;
        truncation_symbol = "…/";
        read_only = " 󰏯 ";
      };

      direnv = {
        disabled = false;
        format = "[$symbol $allowed]($style) ";
        style = "bold 208";
        symbol = "󰌪";
        allowed_msg = "✓";
        denied_msg = "✗";
        loaded_msg = "▣";
        unloaded_msg = "⬚";
      };

      git_metrics.disabled = false;

      git_status = {
        conflicted = "≠";
        renamed = "Δ";
        deleted = "×";
      };

      hostname = {
        ssh_symbol = "";
        trim_at = "";
        format = "[$ssh_symbol$hostname]($style)";
      };

      shell = {
        disabled = false;
        bash_indicator = "󱆃";
        fish_indicator = "󰈺";
        zsh_indicator = "Z";
        powershell_indicator = "󰨊";
        xonsh_indicator = "";
        cmd_indicator = "";
        nu_indicator = "𝜈";
        unknown_indicator = "#?";
      };

      shlvl = {
        symbol = "❬";
        format = "[$symbol]($style)";
        repeat = true;
        threshold = 1;
        style = "bold dimmed white";
        disabled = false;
      };

      status = {
        format = "[$symbol]($style)";
        style = "dimmed white";
        symbol = "[‼](dimmed yellow)";
        success_symbol = "[✓](dimmed green)";
        not_executable_symbol = "[×](dimmed red)";
        not_found_symbol = "[⬚](dimmed blue)";
        sigint_symbol = "[╎](dimmed purple)";
        signal_symbol = "[†](dimmed white)";
        recognize_signal_code = true;
        map_symbol = true;
        pipestatus = true;
        pipestatus_format = "[$pipestatus => $symbol]($style)";
        pipestatus_separator = "[ | ](dimmed white)";
      };

      time = {
        disabled = false;
        format = "[$time]($style) ";
      };

      username.format = "[$user]($style)";

      custom.ssh_agent = {
        description = "Number of keys in SSH agent";
        when = "ssh-add -l";
        command = "ssh-add -l | wc -l";
        symbol = "󰌆 ";
      };
    };
  };
}
