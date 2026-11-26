{ self, config, ... }:
let
  gpgKeyId = config.flake.meta.gpgKeyId;
in
{
  flake.modules.homeManager.qutebrowser-keepassxc =
    { config, lib, pkgs, ... }:
    let
      assets = "${self}/assets/qute-autofill";

      upstream = pkgs.fetchFromGitHub {
        owner = "rafaeluriarte";
        repo = "qute-autofill-keepassxc";
        rev = "796f7ab0f66a62411b089c6af3047e424091b8e7";
        hash = "sha256-TrtTSTvW4Je/S+7Un5w6Bc6+yWtA+43f7M5Gj6avDCg=";
      };

      src = pkgs.applyPatches {
        name = "qute-autofill-keepassxc-gpg";
        src = upstream;
        patches = [
          "${assets}/qute-autofill-gpg.patch"
          "${assets}/qute-autofill-phone.patch"
        ];
      };

      py = pkgs.python3.withPackages (ps: [ ps.pynacl ps.tomlkit ]);

      rofiShim = pkgs.writeScriptBin "rofi"
        ("#!${pkgs.python3}/bin/python3\n" + builtins.readFile "${assets}/rofi-noctalia.py");

      wrap = name: script: pkgs.writeShellScript name ''
        export PATH=${lib.makeBinPath [ rofiShim pkgs.gnupg pkgs.keepassxc ]}:$PATH
        export QUTE_KEEPASSXC=${pkgs.qutebrowser}/share/qutebrowser/userscripts/qute-keepassxc
        export QUTE_PINENTRY=${pkgs.pinentry-qt}/bin/pinentry-qt
        exec ${py}/bin/python ${script} "$@"
      '';

      mk = name: wrap "qb-${name}" "${src}/userscripts/${name}";
      qbKeepassxc = wrap "qb-keepassxc" "${pkgs.qutebrowser}/share/qutebrowser/userscripts/qute-keepassxc";

      autofill = mk "autofill";
      login = mk "keepassxc-login";
      newpass = mk "keepassxc-newpass";
      save = mk "keepassxc-save";
      key = "--key ${gpgKeyId}";
    in
    {
      config = lib.mkIf (config.programs.keepassxc.enable && config.programs.qutebrowser.enable) {
        programs.qutebrowser.keyBindings = {
          normal = {
            "<Space>p" = "spawn --userscript ${qbKeepassxc} ${key}";
            "<Space>Pu" = "spawn --userscript ${qbKeepassxc} ${key} --username-only";
            "<Space>Pp" = "spawn --userscript ${qbKeepassxc} ${key} --password-only";
            "<Space>Pt" = "spawn --userscript ${qbKeepassxc} ${key} --totp";

            "<Space>af" = "spawn --userscript ${autofill}";
            "<Space>aF" = "spawn --userscript ${autofill} --choose";
            "<Space>au" = "spawn --userscript ${autofill} --undo";
            "<Space>aw" = "spawn --userscript ${login} ${key}";
            "<Space>aW" = "spawn --userscript ${login} ${key} --submit";
            "<Space>aT" = "spawn --userscript ${login} ${key} --totp";
            "<Space>an" = "spawn --userscript ${newpass} ${key}";
            "<Space>as" = "spawn --userscript ${save} ${key}";
          };
          insert."<Alt+p>" = "spawn --userscript ${qbKeepassxc} ${key}";
          prompt."<Alt+p>" = "spawn --userscript ${qbKeepassxc} ${key}";
        };
        programs.fish.functions.autofill-pass = {
          description = "Edit the autofill file in qutebrowser";
          body = ''
            set -l dir ~/.config/qutebrowser/autofill
            set -l t /run/user/(id -u)/profiles.toml

            if test -z "$GPG_KEYID";
            or test -z "$EDITOR"
              echo "GPG_KEYID and EDITOR must both be set" >&2
              return 1
            end

            gpg --quiet --decrypt $dir/profiles.toml.gpg > $t
            or begin
              rm -f $t
              return 1
            end

            $EDITOR $t
            or begin
              echo "editor exited with an error; plaintext left at $t" >&2
              return 1
            end

            cp $dir/profiles.toml.gpg $dir/profiles.toml.gpg.bak
            and gpg --yes --encrypt --recipient $GPG_KEYID --output $dir/profiles.toml.gpg $t
            and rm -f $t
            or echo "encrypting failed; your edits are still at $t" >&2
          '';
        };
      };
    };
}
