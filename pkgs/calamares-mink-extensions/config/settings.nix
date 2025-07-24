{
  modules-search = [
    "local"
    "/run/current-system/sw/lib/calamares/modules"
  ];
  sequence = [
    {
      show = [
        "welcome"
        "locale"
        "keyboard"
        "users"
        "partition"
        "summary"
      ];
    }
    {
      exec = [
        "partition"
        "mount"
        # "linux-mink" # TODO: generate config files
        "users"
        "umount"
      ];
    }
    {
      show = [
        "finished"
      ];
    }
  ];
  # branding = "linux-mink"; # TODO: add branding
  prompt-install = false;
  dont-chroot = false;
  oem-setup = false;
  disable-cancel = false;
  disable-cancel-during-exec = false;
  hide-back-and-next-during-exec = false;
  quit-at-end = false;
}
