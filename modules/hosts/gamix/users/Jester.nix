{ inputs, ... }: {
  flake.modules.nixos.gamix =
    {
      imports =
        with inputs.self.modules.nixos;
        with inputs.self.factory;
        [
          Jester
          disko
          gaming
          umbriel-desktop
          (jovian "Jester" "umbriel")
        ];
      users.users.Jester.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8BPmGuNXUEmhqpkZJQxuyUv+X/C5wQgUS3eThEf7fl Jester@steamdeck"
      ];

      home-manager.users.Jester =
        { ... }:
        {
          imports =
            with inputs.self.modules.homeManager;
            [
              syncthing
              umbriel-desktop
            ];
          programs.xbox-cloud-gaming.enable = true;
        };
    };
}




