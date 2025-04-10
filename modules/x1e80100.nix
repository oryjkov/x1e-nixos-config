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
    # For 64gb t14s.
    "mem=31G"
  ];

  hardware.deviceTree.enable = true;

  boot.kernelPackages = pkgs.x1e80100-linux;
}
