{ pkgs, lib, ... }:

{
  boot.initrd.includeDefaultModules = false;
  boot.initrd.systemd.tpm2.enable = false; # This also pulls in some modules our kernel is not build with.
  boot.initrd.availableKernelModules = [
    # These seem like the minimum needed (on t14s) to LUKS unlock and boot stage 2
    # (only 30s of display time!).
    "nvme" "tcsrcc_x1e80100" "phy_qcom_qmp_pcie" "pcie_qcom"
    "i2c_hid_of" "i2c_qcom_geni"
  ];


  boot.kernelParams = [
    "pd_ignore_unused"
    "clk_ignore_unused"
    "regulator_ignore_unused"
    "mem=31G"

    # Needed since 4c3d9c134892c4158867075c840b81a5ed28af1f ("arm64: dts: qcom:
    # x1e80100: Add debug uart to Lenovo Yoga Slim 7x"), I guess systemd picks
    # UART as the only console, and it does not output logs on the screen.
    # "console=tty1"
  ];

  hardware.deviceTree.enable = true;

  boot.kernelPackages = pkgs.x1e80100-linux;
}
