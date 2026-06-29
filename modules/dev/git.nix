{
  flake.modules.homeManager.develop = {
    programs.git = {
      enable = true;
      attributes = [
        "user.email=timur.buchkin@mail.ru"
        "user.name=Timur Buchkin"
        "pull.rebase=true"
      ];
    };
  };
}
