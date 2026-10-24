{
  boot.kernelParams = [ "i915.enable_psr=0" "xe.enable_psr=0" "xe.enable_fbc=0" "xe.enable_panel_replay=0" "acpi_rev_override=1" "acpi_osi=Linux" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
