
f_inode_usage() {
    echo ""
    df -i | head -1
    df -i | grep "/dev"
    echo ""
}

f_big_files() {
    echo -e "\nBig Files (>100MB):\n"
    sudo find / -type f -size +100M 2>/dev/null | xargs du -h
    echo -e "\n"
}

f_disk_usage() {
    echo ""
    df -h | head -1
    df -h | grep "/dev"
    echo ""
}

f_partitions() {
    echo ""
    echo "Disk: $(sudo fdisk -l | head -3 | grep Disk  | awk -F " " '{print $2}' | tr ':' ' ' )"
    echo "Disk Size: $(sudo fdisk -l | head -3 | grep Disk  | awk -F " " '{print $3,$4}' | tr ',' ' ')"
    echo "RootFS Partition: $(mount | grep " on / " | awk -F " " '{print $1}')" 
    echo "RootFS FS Type: $(mount | grep " on / " | awk -F " " '{print $5}')"
    echo ""
}

f_disk_status() {
    echo "======== DISK STATUS ========"
    f_partitions
    f_disk_usage
    f_inode_usage
    f_big_files
}

f_disk_status
