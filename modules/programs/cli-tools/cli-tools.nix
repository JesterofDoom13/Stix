let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        home-manager
        tmux
        vim
      ];
    };
in
{
  flake.modules.nixos.cli-tools = { pkgs, ... }:
    let
      iso-mount = pkgs.writeShellApplication {
        name = "iso-mount";
        runtimeInputs = with pkgs; [ udisks2 util-linux gnused gnugrep coreutils ];
        text = ''
          f=$(realpath "$1")
          dev=$(losetup -j "$f" -n -O NAME | head -n1 || true)
          if [ -z "$dev" ]; then
            dev=$(udisksctl loop-setup -r -f "$f" | grep -oE '/dev/loop[0-9]+')
          fi
          mp=$(findmnt -rn -o TARGET -S "$dev" | head -n1 || true)
          if [ -z "$mp" ]; then
            mp=$(udisksctl mount -b "$dev" | sed -E 's/^Mounted .* at (.*)\.$/\1/')
          fi
          echo "$mp"
        '';
      };
      iso-source = pkgs.writeShellApplication {
        name = "iso-source";
        runtimeInputs = with pkgs; [ util-linux gnugrep coreutils ];
        text = ''
          # prints the backing .iso path if $1 is the root of a loop-mounted ISO
          # exit 3 = not one, so the caller can fall back to a plain `leave`
          mp=$(realpath "$1")
          src=$(findmnt -rn -M "$mp" -o SOURCE || true)

          case "$src" in
            /dev/loop*) ;;
            *) exit 3 ;;
          esac

          back=$(losetup -n -O BACK-FILE "$src" | head -n1 || true)
          if ! printf '%s' "$back" | grep -qi '\.iso$'; then
            exit 3
          fi

          echo "$back"
        '';
      };

      # for GUI: mount, then open the mountpoint in pcmanfm-qt
      iso-mount-open = pkgs.writeShellApplication {
        name = "iso-mount-open";
        runtimeInputs = [ iso-mount pkgs.pcmanfm-qt ];
        text = ''
          mp=$(iso-mount "$1")
          exec pcmanfm-qt "$mp"
        '';
      };
    in
    {
      imports = [
        genericPackages
      ];
      boot = {

        kernelModules = [
          "udf"
        ];
        supportedFilesystems = [
          "udf"
          "iso9660"
        ];
      };
      programs.fish.enable = true;
      environment.systemPackages = with pkgs; [
        iso-mount
        iso-source
        iso-mount-open
        udftools
        libcap
        wget
      ];
    };

  flake.modules.darwin.cli-tools = {
    imports = [
      genericPackages
    ];
  };
}
