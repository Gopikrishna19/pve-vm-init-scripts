set -e

showOptions() {
    options=("$@")
    PS3="Select an option: "
    select option in "${options[@]}"
    do
        selected=$option
        [[ -n "${selected}" ]] && break
    done
    echo "$selected"
}

vmId=$(pvesh get /cluster/nextid)
storage=$(showOptions "network-storage" "machine-storage")
images=$(pveam list ISOs | awk '{print $1}' | tail +2)
osTemplate=$(showOptions $images)

while true
do
    echo && read -rsp "Enter password: " password
    echo && read -rsp "Confirm password: " cpassword
    [[ "$password" == "$cpassword" ]] && break
done

echo && read -r -p "Disk size in Gs (4): " diskSize
echo && read -r -p "Memory in Ms (512): " memory
echo && read -r -p "Hostname (CT${vmId}): " hostname
echo && read -r -p "Enter X in 10.0.0.X/16: " ipv4
echo && read -r -p "Install docker tools? (Y/n): " -n 1 docker
echo

volume="subvol-${vmId}-disk-0"
diskSize="${diskSize:-4}G"
hostname=${hostname:-"CT${vmId}"}

pvesm alloc "${storage}" "${vmId}" "${volume}" "${diskSize}" --format subvol;

pct create "${vmId}" "${osTemplate}" \
    --password "${password}" \
    --unprivileged 0 \
    --rootfs volume="${storage}:${volume}" \
    --cores 2 \
    --memory ${memory:-512} \
    --swap ${memory:-512} \
    --storage "${storage}" \
    --hostname "${hostname}" \
    --net0 name=eth0,bridge=vmbr1,firewall=1,gw=10.0.0.1,ip=10.0.0."${ipv4}"/16,ip6=dhcp \
    --searchdomain 'rg-10' \
    --nameserver 192.168.1.239 \
    --description "${vmId} (${hostname})" \
    --features mount=nfs\;cifs,nesting=1 \
    --onboot 1 \
    --start 0

pct start "${vmId}"

if [[ ! $docker =~ ^[Nn]$ ]]; then
    cat <<EOF >> "/etc/pve/lxc/${vmId}.conf"
lxc.apparmor.profile: unconfined
lxc.cgroup.devices.allow: a
lxc.cap.drop:
EOF

    pct exec "${vmId}" -- bash -c " \
        apt-get update ;\
        apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common ;\
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - ;\
        add-apt-repository -y \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" ;\
        apt-get update ;\
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose ;\
        docker --version ;\
        docker-compose --version ;\
    "
fi
