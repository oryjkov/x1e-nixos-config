{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.x1e.el2 = {
    enable = lib.mkEnableOption ''
      Enable the `el2` specialization and slbounce EFI driver. Needed to run
      virtual machines using KVM.
    '';

    baseDeviceTreeName = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Base device tree name (set by x1e80100 module)";
    };
  };

  config = lib.mkIf config.x1e.el2.enable {
    # Base config uses el2 device tree (default boot entry)
    # No mkForce needed - x1e80100.nix uses mkDefault which has lower priority
    hardware.deviceTree.name =
      lib.replaceString ".dtb" "-el2.dtb" config.x1e.el2.baseDeviceTreeName;

    boot.kernelParams = [ "id_aa64mmfr0.ecv=1" ];

    # Specialisation for limited memory mode (non-el2)
    specialisation.limited.configuration = {
      # mkForce beats the inherited regular assignment from base config
      hardware.deviceTree.name = lib.mkForce config.x1e.el2.baseDeviceTreeName;

      boot.kernelParams = lib.mkForce [
        "pd_ignore_unused"
        "clk_ignore_unused"
        "mem=31G"
      ];
    };

    boot.loader.systemd-boot.extraFiles."EFI/systemd/drivers/slbounceaa64.efi" =
      "${pkgs.slbounce}/slbounce.efi";
  };
}
