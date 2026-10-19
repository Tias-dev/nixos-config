{inputs, ...}: {
  config.flake.modules.homeManager.umbriel = {
    config,
    username,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
      inputs.dank-calendar.homeModules.default
    ];

    programs.dank-calendar = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
    };
    programs.noctalia = {
      enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
        calendar = {
          enabled = true;
          dedupe_events = true;
          refresh_minutes = 15;
          event_date_format = "%A %e %B";
          event_time_format = "%H:%M";
          account = {
            homeserver_connector = {
              type = "caldav";
              name = "Personal";
              provider = "custom";
              server_url = "https://calendar.tias-dev.tech";
              username = "Tias";
              credential_source = "file";
              password_file = config.sops.secrets.calendar-pass.path;
            };
          };
          remainders = {
            enabled = true;
            use_event_reminders = true; # honor per-event reminders; off = always use the default lead below
            default_lead_minutes = 10; # used for events with no reminder of their own; 0 = at event start
            all_day_digest_time = "09:00"; # one notification listing today's all-day events; "" disables it
          };
        };
      };
    };
    sops.secrets.calendar-pass = {
      sopsFile = ../../../../secrets/common-secrets.yaml;
      format = "yaml";
      key = "calendar-plain-pass";
    };
    programs.umbriel.settings = {
      general = {
        autostart = ["noctalia"];
      };
    };
  };
}
