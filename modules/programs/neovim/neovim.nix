{ inputs, ... }:
let
  inherit (inputs.nixCats) utils;
  # Points to your local lua folder for the builder
  luaPath = "${inputs.self}/assets";

  categoryDefinitions =
    { pkgs, ... }:
    {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          ast-grep
          chafa
          cmake-lint
          curl
          fd
          lua5_1
          lua51Packages.lualine-nvim
          lua51Packages.luarocks
          lua51Packages.luasnip
          lua51Packages.neotest
          lua51Packages.rustaceanvim
          #TODO: Check back. Broken when inputting this comment.
          # lua51Packages.magick
          lua-language-server
          lldb
          nil
          nixd
          nixfmt
          nixpkgs-fmt
          ripgrep
          shfmt
          sqlite
          statix
          stdenv.cc.cc
          stylua
          tree-sitter
          tree-sitter-grammars.tree-sitter-norg
          tree-sitter-grammars.tree-sitter-norg-meta
          ueberzugpp
          universal-ctags
          viu
          vscode-json-languageserver
          yazi
          (pkgs.writeShellScriptBin "lazygit" ''exec ${pkgs.lazygit}/bin/lazygit --use-config-file ${pkgs.writeText "lazygit_config.yml" ""} "$@" '')
        ];
        markdown = with pkgs; [
          harper
          markdownlint-cli2
          markdown-toc
          marksman
          mermaid-cli
          prettier
          tectonic
        ];
        node = with pkgs; [ nodejs_24 ];
        perl = with pkgs; [
          perl5Packages.NeovimExt
          perl5Packages.CPAN
        ];
        python = with pkgs; [
          black
          isort
          python313Packages.pynvim
          python313Packages.debugpy
        ];
        ruby = with pkgs; [ gem ];
        zig = with pkgs; [ zig ];
      };
      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lazy-nvim
          LazyVim
          base16-nvim
          blink-cmp
          blink-emoji-nvim
          blink-nerdfont-nvim
          bufferline-nvim
          catppuccin-nvim
          conform-nvim
          dial-nvim
          fastaction-nvim
          flash-nvim
          friendly-snippets
          fzf-lua
          gitsigns-nvim
          grug-far-nvim
          inc-rename-nvim
          lazydev-nvim
          lazygit-nvim
          lualine-nvim
          luasnip
          markdown-preview-nvim
          nerdy-nvim
          noice-nvim
          nui-nvim
          nvim-dap
          nvim-dap-cortex-debug
          nvim-dap-lldb
          nvim-dap-python
          nvim-dap-ui
          nvim-dap-view
          nvim-lint
          nvim-lspconfig
          # nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          nvim-ts-autotag
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          render-markdown-nvim
          rocks-nvim
          SchemaStore-nvim
          smart-splits-nvim
          snacks-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          tmux-nvim
          todo-comments-nvim
          tokyonight-nvim
          transparent-nvim
          trouble-nvim
          ts-comments-nvim
          vim-illuminate
          vim-startuptime
          vimtex
          which-key-nvim
          yazi-nvim
          yanky-nvim
          {
            plugin = catppuccin-nvim;
            name = "catppuccin";
          }
          {
            plugin = live-preview-nvim;
            name = "live-preview.nvim";
          }
          {
            plugin = mini-ai;
            name = "mini.ai";
          }
          {
            plugin = mini-icons;
            name = "mini.icons";
          }
          {
            plugin = mini-operators;
            name = "mini.operators";
          }
          {
            plugin = mini-pairs;
            name = "mini.pairs";
          }
          {
            plugin = mini-splitjoin;
            name = "mini.splitjoin";
          }
          {
            plugin = mini-surround;
            name = "mini.surround";
          }
          {
            plugin = mini-hipatterns;
            name = "mini.hipatterns";
          }
        ];
        markdown = with pkgs.vimPlugins; [
          obsidian-nvim
        ];
        rust = with pkgs.vimPlugins; [
          rustaceanvim
          crates-nvim
        ];
      };
      optionalPlugins = with pkgs.neovimPlugins; {
        markdown = [
          kanban-nvim
          {
            plugin = markdownplus;
            name = "markdown-plus.nvim";
          }
        ];
      };
      sharedLibraries = {
        general = with pkgs; [ libgit2 ];
      };
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };
      extraWrapperArgs = {
        test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
      };
      python3.libraries = {
        test = [ (_: [ ]) ];
      };
      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };
    };

  packageDefinitions = {
    nvim =
      { pkgs, ... }:
      {
        settings = {
          wrapRc = false;
          aliases = [
            "vim"
            "nv"
            "mvim"
          ];
          # unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. ''";
        };
        categories = {
          general = true;
          markdown = true;
          node = true;
          perl = true;
          python = true;
          ruby = true;
          rust = true;
          zig = true;
          test = false;
          gitPlugins = true;
          lldb.path = "${pkgs.lldb}/bin/lldb";
        };
      };
    tvim = # for test nvim or debugging
      { ... }:
      {
        settings = {
          wrapRc = false;
          aliases = [
            "debugnvim"
          ];
          unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/.config/nvim'";
        };
        categories = {
          general = true;
          markdown = true;
          node = true;
          perl = true;
          python = true;
          ruby = true;
          gitPlugins = true;
          test = false;
        };
        extra = { };
      };
  };
in
{
  flake.modules.homeManager.neovim = { pkgs, lib, ... }: {
    imports = [
      (utils.mkHomeModules {
        inherit (inputs) nixpkgs;
        inherit luaPath categoryDefinitions packageDefinitions;
        dependencyOverlays = [ (utils.standardPluginOverlay inputs) ];
      })
    ];
    nixCats.enable = true;
    nixCats.packageNames = [
      "nvim"
      "tvim"
    ];
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Was wworking with pulling it from inside the directory but I'm going to work like this so I can
    # reload my configs more easier and it saves to a git repo
    home.activation.cloneNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.config/nvim/.git" ]; then
        ${pkgs.git}/bin/git clone https://github.com/JesterofDoom13/nvim-config "$HOME/.config/nvim"
      fi
    '';
    home.activation.pushNvimConfig = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"
      if [ -d "$HOME/.config/nvim/.git" ]; then
        cd "$HOME/.config/nvim"
        git add -A
        if ! git diff --staged --quiet; then
          git commit -m "auto: pre-rebuild snapshot" || true
          git push || echo "pushNvimConfig: push failed, continuing" >&2
        fi
      fi
    '';
  };
}
