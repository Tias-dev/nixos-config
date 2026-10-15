{
  config.flake.modules.homeManager.mai-wifi-login = {
    config,
    lib,
    pkgs,
    ...
  }: let
    script =
      pkgs.writers.writeBashBin "mai-wifi-login"
      /*
      bash
      */
      ''
        password=$(cat ${config.sops.secrets.mai-wifi-password.path})
        output=` curl --noproxy '*' 'https://wifi.mai.ru/login' \
        -X POST \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:155.0) Gecko/20100101 Firefox/155.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
        -H 'Accept-Language: en-US,en;q=0.9' \
        -H 'Accept-Encoding: gzip, deflate, br, zstd' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Origin: https://wifi.mai.ru' \
        -H 'Sec-GPC: 1' \
        -H 'Connection: keep-alive' \
        -H 'Referer: https://wifi.mai.ru/login' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Sec-Fetch-Dest: document' \
        -H 'Sec-Fetch-Mode: navigate' \
        -H 'Sec-Fetch-Site: same-origin' \
        -H 'Sec-Fetch-User: ?1' \
        -H 'Priority: u=0, i' \
        --data-raw 'dst=maintenance.html&popup=true&username=${config.mai-wifi-login.username}&password='$(cat ${config.sops.secrets.mai-wifi-password.path})`

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
      mai-wifi-login.username = lib.mkOption {
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
      home.packages = [script];
    };
  };
}
