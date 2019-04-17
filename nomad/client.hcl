name = "nomad-client"
data_dir = "/tmp/nomad-client"

client {
    enabled = true

    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = ["127.0.0.1:4647"]
    alloc_dir = "/tmp/nomad-allocations"
}

plugin "docker" {
    config {
#       allow_caps = [ "CHOWN,DAC_OVERRIDE,FSETID,FOWNER,MKNOD,NET_RAW,SETGID,SETUID,SETFCAP,SETPCAP,NET_BIND_SERVICE,SYS_CHROOT,KILL,AUDIT_WRITE,NET_ADMIN" ]
       allow_caps = [ "ALL" ]
    }
}

ports {
    http = 5656
}
