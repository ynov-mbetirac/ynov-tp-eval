resource "null_resource" "connect_ssh" {
    connection {
        type = "ssh"
        user = var.ssh_user
        host = var.ssh_host
        private_key = file(var.ssh_key)
    }
    provisioner "remote-exec" {
        inline = [
            "echo ${var.password} | sudo useradd -s /bin/bash -d /opt/stack -m stack",
            "sudo chmod +x /opt/stack",
            "echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack",
            "sudo -u stack -i",
            "git clone https://opendev.org/openstack/devstack",
            "cd devstack",
            cat <<EOF >>brightup.sh
            [[local|localrc]]
            ADMIN_PASSWORD=secret
            DATABASE_PASSWORD=$ADMIN_PASSWORD
            RABBIT_PASSWORD=$ADMIN_PASSWORD
            SERVICE_PASSWORD=$ADMIN_PASSWORD
            HOST_IP=172.26.10.110
            EOF,
            "./stack.sh"
            
        ]
    }
}