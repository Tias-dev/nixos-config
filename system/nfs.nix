{
  services.nfs.server = {
    enable = true;
    createMountPoints = true;
    exports = ''
      /export					10.42.0.1(rw,fsid=0,no_subtree_check) 10.42.0.2(rw,fsid=0,no_subtree_check)
      /export/raison	10.42.0.1(rw,nohide,insecure,no_subtree_check) 10.42.0.2(rw,nohide,insecure,no_subtree_check)
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };
}
