{
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.vimium-options.homeManagerModules.vimium-options
  ];

  home.vimiumOptions = {
    enable = true;
    outputFilePath = ".cache/vimium-options.json";
    keyMappings = {
      unmap = [
        "J"
        "K"
      ];
      map = {
        J = "nextTab";
        K = "previousTab";
      };
    };
  };

  programs.zen-browser = {
    enable = true;
    package = inputs.zen-browser.packages.${system}.beta;
    policies = {
      SecurityDevices."CAC-Device" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
    };
    profiles.default = rec {
      id = 0;
      isDefault = true;
      extensions.packages = with inputs.firefox-addons.packages.${system}; [
        vimium-c
      ];
      keyboardShortcuts = [
        {
          id = "zen-toggle-sidebar";
          key = "s";
          modifiers = {
            control = true;
            alt = true;
          };
        }
        {
          id = "zen-compact-mode-show-sidebar";
          key = "s";
          modifiers = {
            control = true;
          };
        }
        {
          id = "zen-compact-mode-toggle";
          key = "s";
          modifiers = {
            control = true;
            shift = true;
          };
        }
        {
          id = "zen-close-all-unpinned-tabs";
          key = "x";
          modifiers = {
            control = true;
            shift = true;
          };
        }
        {
          id = "zen-workspace-backward";
          key = "k";
          modifiers = {
            control = true;
            shift = true;
          };
        }
        {
          id = "zen-workspace-forward";
          key = "j";
          modifiers = {
            control = true;
            shift = true;
          };
        }
        {
          id = "zen-split-view-unsplit";
          key = "k";
          modifiers = {
            control = true;
            shift = true;
          };
        }
        {
          id = "zen-split-view-horizontal";
          key = "h";
          modifiers = {
            control = true;
            shift = true;
          };
        }
        {
          id = "zen-split-view-vertical";
          key = "v";
          modifiers = {
            control = true;
            shift = true;
          };
        }
        {
          id = "key_webconsole";
          disabled = true;
        }
        {
          id = "key_screenshot";
          disabled = true;
        }
        {
          id = "viewGenaiChatSidebarKb";
          disabled = true;
        }
        {
          id = "key_switchTextDirection";
          disabled = true;
        }
        {
          id = "key_browserConsole";
          disabled = true;
        }
      ];
      keyboardShortcutsVersion = 17;
      containersForce = true;
      spacesForce = true;
      pinsForce = true;
      containers = {
        "Personal" = {
          color = "blue";
          icon = "briefcase";
          id = 0;
        };
      };
      spaces = {
        "Server" = {
          id = "572910e1-4468-4832-a869-0b3a93e2f165";
          icon = "🌐";
          position = 1000;
          container = 0;
        };
        "3D Printing" = {
          id = "08be3ada-2398-4e63-bb8e-f8bf9caa8d10";
          icon = "🖨️";
          position = 2000;
        };
        "Nix" = {
          id = "2441acc9-79b1-4afb-b582-ee88ce554ec0";
          icon = "❄️";
          position = 3000;
        };
        "Messanging" = {
          id = "f09f2618-5c6e-4006-aead-8c71ecfebb09";
          icon = "💬";
          position = 4000;
        };
      };
      pins = {
        "Prox" = {
          workspace = spaces.Server.id;
          id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
          url = "https://bigprox:8006";
          position = 101;
        };
        "NzbGet" = {
          workspace = spaces.Server.id;
          id = "8af62707-0722-4049-9801-bedced343333";
          url = "http://10.0.0.54:6789";
          position = 102;
        };
        "Plex" = {
          workspace = spaces.Server.id;
          id = "8e27e91c-b113-4779-bfd6-069c6a334c85";
          url = "https://fastplex:32400/web/index.html";
          position = 103;
        };
        "dockge" = {
          workspace = spaces.Server.id;
          id = "fb316d70-2b5e-4c46-bf42-f4e82d635153";
          url = "http://docker:5001";
          position = 104;
        };
        "Johnny" = {
          workspace = spaces."3D Printing".id;
          id = "5c2b6e3d-f53d-48b6-ad62-b98ab7a96ade";
          url = "http://johnny";
          position = 201;
        };
        "Printables" = {
          workspace = spaces."3D Printing".id;
          id = "24ef3986-4e1f-41c0-a6b2-a74160735067";
          url = "https://www.printables.com";
          position = 202;
        };
        "Nix Packages" = {
          id = "f8dd784e-11d7-430a-8f57-7b05ecdb4c77";
          workspace = spaces.Nix.id;
          url = "https://search.nixos.org/packages";
          position = 301;
        };
        "Nix Options" = {
          id = "92931d60-fd40-4707-9512-a57b1a6a3919";
          workspace = spaces.Nix.id;
          url = "https://search.nixos.org/options";
          position = 302;
        };
        "Home Manager Options" = {
          id = "2eed5614-3896-41a1-9d0a-a3283985359b";
          workspace = spaces.Nix.id;
          url = "https://home-manager-options.extranix.com";
          position = 303;
        };
        "Messenger" = {
          id = "c90b48d1-3830-4d17-89e2-bba58f5c7986";
          workspace = spaces.Messanging.id;
          url = "https://www.facebook.com/messages";
          position = 401;
        };
        "Messages" = {
          id = "47a4bfbc-bddc-44e7-a3f8-443f9cbd533c";
          workspace = spaces.Messanging.id;
          url = "https://messages.google.com/web";
          position = 402;
        };
      };
    };
  };
}
