{
  flake-file.inputs = {
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    plugins-kanban-nvim = {
      url = "github:arakkkkk/kanban.nvim";
      flake = false;
    };
    plugins-markdownplus = {
      url = "github:yousefhadder/markdown-plus.nvim";
      flake = false;
    };
  };
}

