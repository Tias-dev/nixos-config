{
  config.flake.lib = {
    mkSendMailProgram = {
      userEmail,
      relayHost ? "smtp.gmail.com",
      passwordPath,
    }: {
      programs.msmtp = {
        enable = true;
        extraConfig = ''
          defaults
          auth           on
          tls            on
          tls_trust_file /etc/ssl/certs/ca-certificates.crt
          logfile        ~/.msmtp.log

          account        gmail
          host           ${relayHost}
          port           587
          from           ${userEmail}
          user           ${userEmail}
          passwordeval   cat ${passwordPath}

          account default : gmail
        '';
      };
    };
  };
}
