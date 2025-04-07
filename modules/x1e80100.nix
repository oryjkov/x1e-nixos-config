{ pkgs, lib, ... }:

{
  boot.initrd.includeDefaultModules = false;
  boot.initrd.systemd.tpm2.enable = false; # This also pulls in some modules our kernel is not build with.
  boot.initrd.availableKernelModules = [
        /*
    "q6apm_lpass_dais"
"q6prm_clocks"
"q6apm_dai"
"q6prm"
"snd_q6apm"
"hci_uart"
"snd_soc_wcd938x"
"qcom_spmi_temp_alarm"
"pm8941_pwrkey"
#"iris"
"snd_soc_x1e80100"
"soundwire_qcom"
"snd_soc_lpass_wsa_macro"
"snd_soc_lpass_va_macro"
"snd_soc_lpass_rx_macro"
"snd_soc_lpass_tx_macro"
"fastrpc"
    #"pci_pwrctl_pwrseq"
"qcom_cpucp_mbox"
"apr"
"i2c_hid_of"
"rtc_pm8xxx"
"qcom_pon"
"nvmem_qcom_spmi_sdam"
"ps883x"
"phy_nxp_ptn3222"
"msm"
"qcom_q6v5_pas"
"qcom_spmi_pmic"
"qcom_stats"
"qcom_geni_serial"
"i2c_qcom_geni"
"pinctrl_sm8550_lpass_lpi"
"pinctrl_lpass_lpi"
        #"dispcc_x1e80100"
"videocc_sm8550"
"phy_qcom_edp"
"lpasscc_sc8280xp"
"icc_bwmon"
"gpucc_x1e80100"
"tcsrcc_x1e80100"
    #"qcom_ice"
"pwrseq_qcom_wcn"
"gpio_keys"
"fixed"

"pwm_bl"
    # Definitely needed for USB:
    "qcom_glink_smem"
    "usb_storage"
    "phy_qcom_qmp_combo"
    "phy_qcom_snps_eusb2"
    "phy_qcom_eusb2_repeater"
        #"tcsrcc_x1e80100"

    "i2c_hid_of"
    "i2c_qcom_geni"
        #"dispcc-x1e80100"
        #"gpucc-x1e80100"
    "phy_qcom_edp"
    "panel_edp"
    "msm"
    "nvme"
    "phy_qcom_qmp_pcie"
    #"pcie_qcom"
        #"panel_samsung_atna33xc20"

    # Needed with the DP altmode patches
    "ps883x"
    "pmic_glink_altmode"
    "qrtr"
        */
    # "needed" to boot?
    "nvme" "tcsrcc_x1e80100" "phy_qcom_qmp_pcie" "pcie_qcom"
    # Keyboard
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
