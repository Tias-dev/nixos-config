{
  config.flake.modules.homeManager."hosts/tabuchkin-nix" = {
    firefox.extra-bookmarks = [
      {
        name = "Messanger";
        tags = ["messanger" "personal"];
        url = "https://messenger.360.yandex.ru";
      }
      {
        name = "Staff";
        url = "https://staff.yandex-team.ru/";
        tags = ["personal"];
      }
      {
        name = "Tasks";
        url = "https://st.yandex-team.ru/";
        tags = ["personal"];
      }
      {
        name = "Arcanum";
        url = "https://a.yandex-team.ru/";
        tags = ["code"];
      }
      {
        name = "Wiki";
        url = "https://wiki.yandex-team.ru/";
        tags = [ "docs" ];
      }
      {
        name = "Docs";
        url = "https://docs.yandex-team.ru/";
        tags = [ "docs" ];
      }
      "separator"
      {
        name = "Yandex services";
        bookmarks = [
          {
            name = "Monium";
            url = "https://monium.yandex-team.ru/";
            tags = ["monitoring"];
          }
          {
            name = "Deploy";
            url = "https://deploy.yandex-team.ru/";
            tags = ["deploy"];
          }
          {
            name = "Nanny";
            url = "https://nanny.yandex-team.ru/";
            tags = ["deploy"];
          }
          {
            name = "Robodelivery RpsLimiter";
            url = "https://rpslimiter.z.yandex-team.ru/records/robot_routing_rpslimiter";
            tags = ["rpslimiter" "monitoring"];
          }
        ];
      }
      "separator"
      {
        name = "Team resources";
        bookmarks = [
          {
            name = "All map locations";
            url = "https://yc.yandex-team.ru/folders/foop8ggv57c8ou95rqep/storage/buckets/sdc-lanes-map?key=commit-tar%2Fmaps%2F&versionsDisplay=false";
          }
        ];
      }
    ];
  };
}
