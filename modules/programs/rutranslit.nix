let
  rutranslit = pkgs:
    pkgs.writers.writeBashBin "rutranslit"
    /*
    bash
    */
    ''
      NAME=""
      TRANSLIT=""

      TRTBL_l="
      s/а/a/g;
      s/б/b/g;
      s/в/v/g;
      s/г/g/g;
      s/д/d/g;
      s/е/e/g;
      s/ё/e/g;
      s/ж/zh/g;
      s/з/z/g;
      s/и/i/g;
      s/й/y/g;
      s/к/k/g;
      s/л/l/g;
      s/м/m/g;
      s/н/n/g;
      s/о/o/g;
      s/п/p/g;
      s/р/r/g;
      s/с/s/g;
      s/т/t/g;
      s/у/u/g;
      s/ф/f/g;
      s/х/h/g;
      s/ц/c/g;
      s/ч/ch/g;
      s/ш/sh/g;
      s/щ/sch/g;
      s/ъ//g;
      s/ы/yi/g;
      s/ь//g;
      s/э/je/g;
      s/ю/yu/g;
      s/я/ya/g"

      TRTBL_h="
      s/А/A/g;
      s/Б/B/g;
      s/В/V/g;
      s/Г/G/g;
      s/Д/D/g;
      s/Е/E/g;
      s/Ё/E/g;
      s/Ж/ZH/g;
      s/З/Z/g;
      s/И/I/g;
      s/Й/Y/g;
      s/К/K/g;
      s/Л/L/g;
      s/М/M/g;
      s/Н/N/g;
      s/О/O/g;
      s/П/P/g;
      s/Р/R/g;
      s/С/S/g;
      s/Т/T/g;
      s/У/U/g;
      s/Ф/F/g;
      s/Х/H/g;
      s/Ц/C/g;
      s/Ч/CH/g;
      s/Ш/SH/g;
      s/Щ/SCH/g;
      s/Ъ//g;
      s/Ы/YI/g;
      s/Ь//g;
      s/Э/JE/g;
      s/Ю/YU/g;
      s/Я/YA/g"





      translit()
      {
          local trans_var=$1
          trans_var=`echo -n $trans_var | sed "$TRTBL_l"`
          trans_var=`echo -n $trans_var | sed "$TRTBL_h"`
          echo $trans_var
      }



      translit_text()
      {
          result=`translit $1`
          echo $result
      }



      rename_file()
      {

          local ru_name=$1
          local trans_name
          if [ "x$ru_name" != "x" ] ; then
      	trans_name=`translit $ru_name`
      	echo "$ru_name -> $trans_name"
      	mv "$ru_name" "$trans_name"
          fi
      }




      case "$1" in
        text)
            translit_text $2
            exit 0;
        ;;
        rename)
            rename_file $2
            exit 0
        ;;
        *)
         echo "Usage: rutranslit <text | rename> <text to translit | filename>"
         exit 1;
        ;;
      esac

    '';
in {
  config.flake.modules.nixos.rutranslit = {pkgs, ...}: {
    environment.systemPackages = [(rutranslit pkgs)];
  };
  config.flake.modules.homeManager.rutranslit = {pkgs, ...}: {
    home.packages = [(rutranslit pkgs)];
  };
}
