{
  lib,
  fetchFromGitHub,
  buildLinux,
  linuxPackagesFor,
  fetchpatch,
  fetchurl,
  b4,
  ...
}:
linuxPackagesFor (buildLinux {
  src = fetchFromGitHub {
    owner = "jhovold";
    repo = "linux";
    rev = "refs/heads/wip/x1e80100-6.16";
    forceFetchGit = true;
    nativeBuildInputs = [b4];
    preFetch = "export ${lib.toShellVar "NIX_PREFETCH_GIT_CHECKOUT_HOOK" ''
      pushd "$dir"
      git config user.name "nix"
      git config user.email "nix"

      # power: supply: Add several features support in qcom-battmgr driver
      b4 shazam --use-version 2 'https://lore.kernel.org/lkml/20250530-qcom_battmgr_update-v2-0-9e377193a656@oss.qualcomm.com'

      # arm64: dts: qcom: x1e80100-lenovo-yoga-slim7x: add Bluetooth support
      b4 shazam --use-version 3 'https://lore.kernel.org/lkml/20250624-slim7x-bt-v3-1-7ada18058419@oldschoolsolutions.biz/'

      # Collect some stats
      du -sh .git

      popd
    ''}";

    # Should be reproducible if you do the above range cherry-picks and b4 commands manually.
    hash = "sha256-q9uAwqYSlM6btjnEpT8mhEXknTDhtW8kJlZs3jOk/KA=";
  };
  version = "6.16.0";
  defconfig = "johan_defconfig";

  structuredExtraConfig = with lib.kernel; {
    VIRTUALIZATION = yes;
    KVM = yes;
    MAGIC_SYSRQ = yes;
    EC_LENOVO_YOGA_SLIM7X = module;
    VIDEO_OV02C10 = module;
  };

  # TODO: Look into the errors and remove this.
  ignoreConfigErrors = true;

  kernelPatches = [
    {
      name = "platform: arm64: Add driver for Lenovo Yoga Slim 7x's EC";
      patch = fetchpatch {
        url = "https://lore.kernel.org/platform-driver-x86/20240927185345.3680-2-maccraft123mc@gmail.com/raw";
        excludes = ["MAINTAINERS"];
        hash = "sha256-D3Vso/TwzooNbTScv6fjBaXTA7eA+PiWqvSaXFVV/g8=";
      };
    }
    {
      name = "arm64: dts: qcom: Add EC to Lenovo Yoga Slim 7x";
      patch = fetchurl {
        url = "https://lore.kernel.org/linux-arm-msm/20240927185345.3680-3-maccraft123mc@gmail.com/raw";
        hash = "sha256-tnpo07ZPi/3cdiY9h90rf2UgTjr9ZfR1PYRVVQJ2pUQ=";
      };
    }

    # Patch for getting some limited aDSP functionality in EL2 (e.g. battery status)
    {
      name = "WIP: remoteproc: q6v5-pas: Attach to lite ADSP firmware";
      patch = fetchpatch {
        url = "https://git.codelinaro.org/stephan.gerhold/linux/-/commit/7c2a82017d32a4a0007443680fd0847e7c92d5bb.patch";
        hash = "sha256-LNAjF4eNkGiKhlVlXg8FJ8TtXmuR3u+ct0cas7nzM4E=";
      };
    }
  ];
})
