{
  lib,
  fetchFromGitHub,
  buildLinux,
  linuxPackagesFor,
  fetchpatch,
  fetchurl,
  ...
}:

linuxPackagesFor (buildLinux {
  src = fetchFromGitHub {
    owner = "jhovold";
    repo = "linux";
    rev = "wip/x1e80100-6.14";
    hash = "sha256-s1DKyjz9qm+M4YcCEQbfglqWFasUNfxrrIh8Y6zWVqg=";
  };
  version = "6.14.0";
  defconfig = "johan_defconfig";

  structuredExtraConfig = with lib.kernel; {
    VIRTUALIZATION = yes;
    KVM = yes;
    MAGIC_SYSRQ = yes;
    HZ_1000 = yes;
  };

  # TODO: Look into the errors and remove this.
  ignoreConfigErrors = true;
})
