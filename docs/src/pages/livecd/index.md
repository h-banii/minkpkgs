# Live CD

## Virtual Machine

Run it in a virtual machine (qemu)

```console
export QEMU_OPTS='-m 4G -device virtio-vga-gl -display gtk,gl=on'
nix run github:h-banii/MikanOS#livecd.vm
```

## ISO Image

Build the iso image

```sh
nix build github:h-banii/MikanOS#livecd.isoImage
```

Write .iso to usb stick (≥4GB)

```sh
dd bs=4M conv=fsync oflag=direct status=progress if=./result/iso/MikanOS.iso of=/dev/path-to-usb-flash-drive
```

> [!IMPORTANT]
> Make absolute sure you're writing to the right device
>
> `lsblk -o name,fstype,size,type,model,serial,mountpoint`
