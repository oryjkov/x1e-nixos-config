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
    rev = "wip/x1e80100-6.15-rc1";
    hash = "sha256-Vx+AQux363QGo/v5Rd7Dg3r5V8vszrLihbD8mQvVFsA=";
  };
  version = "6.15-rc1";
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
