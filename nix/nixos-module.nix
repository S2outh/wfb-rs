{ config, pkgs, ... }:

{
  # Configure wifibroadcast drivers
  boot.blacklistedKernelModules = [ "rtw88_8812au" ];
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./rtl8812au-svpcom.nix { })
  ];
  # force loading the custom driver at boot
  boot.kernelModules = [ "88XXau_wfb" ];
}
