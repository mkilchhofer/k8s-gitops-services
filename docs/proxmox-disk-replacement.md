# Howto replace disks in my Proxmox hypervisor

Last executed Sep 17, 2025 on Proxmox VE 8.4.13.

## General commands

```bash
btrfs filesystem usage /
btrfs device usage /
```

## Replacement procedure

1. Prepare new disks

    ```bash
    # Clone partition scheme
    sgdisk /dev/sda -R /dev/sdc
    sgdisk /dev/sdb -R /dev/sdd

    # Randomize GPT IDs again
    sgdisk -G /dev/sdc
    sgdisk -G /dev/sdd
    fdisk -l
    ```

1. Check filesystem ID

    ```bash
    cat /etc/fstab 
    btrfs fi show
    ```

    -> the IDs will match

1. Replace/clone boot partitions:

    ```bash
    fdisk -l
    # BIOS boot
    dd if=/dev/sda1 of=/dev/sdc1 status=progress
    dd if=/dev/sdb1 of=/dev/sdd1 status=progress

    # EFI
    dd if=/dev/sda2 of=/dev/sdc2 status=progress
    dd if=/dev/sdb2 of=/dev/sdd2 status=progress
    ```

1. Replace disk 1 in btrfs raid

    ```bash
    btrfs replace start -f 1 /dev/sdc3 /
    btrfs scrub status /
    btrfs device usage /
    ```

1. Check and watch status

    ```bash
    root@pve:~# btrfs replace status /
    Started on 17.Sep 13:24:14, finished on 17.Sep 13:39:55, 0 write errs, 0 uncorr. read errs
    ```

1. Replace disk 2 in btrfs raid

    ```bash
    btrfs replace start -f 2 /dev/sdd3 /
    ```

1. Check and watch status

    > see step above

1. check dmesg as well

    ```bash
    root@pve:~# dmesg | grep replace
    [  795.983263] BTRFS info (device sda3): dev_replace from /dev/sda3 (devid 1) to /dev/sdc3 started
    [ 1747.498695] BTRFS info (device sda3): dev_replace from /dev/sda3 (devid 1) to /dev/sdc3 finished
    [ 2500.495477] BTRFS info (device sda3): dev_replace from /dev/sdb3 (devid 2) to /dev/sdd3 started
    [ 3441.897817] BTRFS info (device sda3): dev_replace from /dev/sdb3 (devid 2) to /dev/sdd3 finished
    ```
