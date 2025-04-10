{ pkgs, lib, ... }:

{
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/effa4c82-eaf9-4a08-93ab-fb136c24fa3b";
      preLVM = true;
    };
  };
  hardware.graphics.enable = true;

  x1e.el2.enable = true;
  boot.loader.systemd-boot = {
    enable = true;

    # The default EFI partition created by Windows is really small, limit to 2
    # generations to be on the safe side.
    configurationLimit = 2;
  };

  boot.initrd.systemd = {
    enable = true;

    # This is not secure, but it makes diagnosing errors easier.
    emergencyAccess = true;
  };

  hardware.enableRedistributableFirmware = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" =
    { device = "/dev/disk/by-uuid/02AF-B1F4";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  # Enable some SysRq keys (80 = sync + process kill)
  # See: https://docs.kernel.org/admin-guide/sysrq.html
  boot.kernel.sysctl."kernel.sysrq" = 80;

  users.users.user = {
    isNormalUser = true;
    # Default password, should be changed using `passwd` after first login.
    password = "nixos";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  networking.networkmanager = {
    enable = true;
    plugins = lib.mkForce [ ];
  };

  hardware.bluetooth.enable = true;

  programs.sway.enable = true;
  programs.firefox.enable = true;
}
