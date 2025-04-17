final: prev: {
  grub2 = prev.grub2.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./grub.patch
      ];
  });
}
