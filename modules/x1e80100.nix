{ pkgs, lib, ... }:

{
  boot.initrd.extraFirmwarePaths = [
    # Basically all of the x1e80100 modules. Avoids fw_load errors in initrd.
    "qcom/x1e80100/gen70500_zap.mbn"
    "qcom/x1e80100/LENOVO/21N1/cdspr.jsn"
    "qcom/x1e80100/LENOVO/21N1/qcadsp8380.mbn"
    "qcom/x1e80100/LENOVO/21N1/adspua.jsn"
    "qcom/x1e80100/LENOVO/21N1/battmgr.jsn"
    "qcom/x1e80100/LENOVO/21N1/adsps.jsn"
    "qcom/x1e80100/LENOVO/21N1/qcdxkmsuc8380.mbn"
    "qcom/x1e80100/LENOVO/21N1/qccdsp8380.mbn"
    "qcom/x1e80100/LENOVO/21N1/adspr.jsn"
    "qcom/x1e80100/LENOVO/21N1/adsp_dtbs.elf"
    "qcom/x1e80100/LENOVO/21N1/cdsp_dtbs.elf"
    "qcom/x1e80100/adsp.mbn"
    "qcom/x1e80100/adsp_dtb.mbn"
  ];

  boot.initrd.includeDefaultModules = false;
  boot.initrd.systemd.tpm2.enable = false; # This also pulls in some modules our kernel is not build with.
  boot.initrd.availableKernelModules = [
    # These seem like the minimum needed (on t14s) to LUKS unlock and boot stage 2
    # TODO: I can't figure out the modules needed to switch the console mode in initrd, so
    # only 30s of display time before regulators cut out.
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
