{
  config.flake.modules.homeManager.mai-wifi-auto-login = {
    config,
    lib,
    username,
    pkgs,
    ...
  }: let
    script =
      pkgs.writers.writeBash "try-login"
      /*
      bash
      */
      ''
        password=$(cat ${config.sops.secrets.mai-wifi-password.path})
        output=`curl --noproxy '*' 'https://wifi.mai.ru/login' \
        -X POST \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
        -H 'Accept-Language: en-US,en;q=0.9' \
        -H 'Accept-Encoding: gzip, deflate, br, zstd' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Origin: https://wifi.mai.ru' \
        -H 'Connection: keep-alive' \
        -H 'Referer: https://wifi.mai.ru/login?dst=http%3A%2F%2Fdetectportal.firefox.com%2Fcanonical.html' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Sec-Fetch-Dest: document' \
        -H 'Sec-Fetch-Mode: navigate' \
        -H 'Sec-Fetch-Site: same-origin' \
        -H 'Sec-Fetch-User: ?1' \
        -H 'Priority: u=0, i' \
        --data-raw 'dst=maintenance.html&popup=true&username=${config.mai-wifi-auto-login.username}&password='$password`

        result=`echo $output | grep "Вы успешно"`
        if [ ! -z "$result" ]; then
          echo "Connect Successfull"
          exit 0
        else
          echo "Connect failed"
          exit 1
        fi
      '';
  in {
    options = {
      mai-wifi-auto-login.username = lib.mkOption {
        type = lib.types.str;
        default = "TABuchkin";
      };
    };
    config = {
      sops = {
        secrets.mai-wifi-password = {
          format = "yaml";
          sopsFile = ../../secrets/common-secrets.yaml;
          key = "mai-wifi-pass";
        };
      };
      systemd.user.services."mai-wifi-auto-login" = {
        Unit = {
          After = ["network-online.target"];
          Wants = ["network-online.target"];

          StartLimitIntervalSec = 1800;
          StartLimitBurst = 5;
        };
        Install = {
          WantedBy = ["default.target"];
        };
        Service = {
          Type = "oneshot";
          Restart = "on-failure";
          RestartSec = "20s";
          RemainAfterExit = "no";

          ExecStart = "${script}";
        };
      };
    };
  };
}
