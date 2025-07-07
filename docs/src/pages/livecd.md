# Live CD

## Virtual Machine

Run it in a virtual machine (qemu)

```console
$ export QEMU_OPTS='-m 4G -device virtio-vga-gl -display gtk,gl=on'
$ nix run github:h-banii/LinuxMink#livecd.vm
```

## ISO Image

Build the iso image

```sh
nix build github:h-banii/LinuxMink#livecd.isoImage
```

Write the iso to an usb stick (≥4GB)

```sh
dd bs=4M conv=fsync oflag=direct status=progress \
    if=./result/iso/linux-mink.iso \
    of=/dev/sdX
```

> [!IMPORTANT]
> Make absolute sure you're writing to the right device
>
> `lsblk -o name,fstype,size,type,model,serial,mountpoint`
