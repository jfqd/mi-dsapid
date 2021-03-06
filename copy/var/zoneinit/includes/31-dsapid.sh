
log "creating /data directory"

if [[ ! -e /data ]]; then
  mkdir /data
fi

if [[ ! -e /data/files ]]; then
  mkdir /data/files
fi

if [[ ! -e /data/config.json ]]; then
  log "creating initial configuration"

  cat > /data/config.json << EOF
{
  "log_level": "info",
  "base_url": "http://${HOSTNAME}/",
  "mount_ui": "/opt/dsapid/ui",
  "listen": {
    "http": {
      "address": "127.0.0.1:8080",
      "ssl": false
    }
  },
  "datadir": "/data/files",
  "users": "/data/users.json",
  "sync": [
    {
      "name": "official joyent dsapi",
      "active": false,
      "type": "dsapi",
      "provider": "joyent",
      "source": "https://datasets.joyent.com/datasets",
      "delay": "24h"
    },
    {
      "name": "official joyent imgapi",
      "active": false,
      "type": "imgapi",
      "provider": "joyent",
      "source": "https://images.joyent.com/images",
      "delay": "24h"
    }
  ]
}
EOF
fi

if [[ ! -e /data/users.json ]]; then
  log "creating initial users list and seed it with joyent uuids"

  ADMIN_UPLOAD_TOKEN=$(mdata-get admin_upload_token)
  
  cat > /data/users.json << EOF
[
  {
    "uuid": "352971aa-31ba-496c-9ade-a379feaecd52",
    "name": "sdc",
    "type": "system",
    "provider": "joyent"
  },
  {
    "uuid": "429694bc-c5a0-4263-9026-72299455f484",
    "name": "admin",
    "token": "${ADMIN_UPLOAD_TOKEN}",
    "type": "user",
    "roles": [
      "s_dataset.upload",
      "s_dataset.manage",
      "s_dataset.admin"
    ]
  },
  {
    "uuid": "684f7f60-5b38-11e2-8eae-6b88dd42e590",
    "name": "sdc",
    "type": "system",
    "provider": "joyent"
  },
  {
    "uuid": "a979f956-12cb-4216-bf4c-ae73e6f14dde",
    "name": "sdc",
    "type": "system",
    "provider": "joyent"
  },
  {
    "uuid": "9dce1460-0c4c-4417-ab8b-25ca478c5a78",
    "name": "jpc",
    "type": "system",
    "provider": "joyent"
  }
]
EOF
fi

log "force correct ownership of /data directory"

if [[ -z `/usr/sbin/mount | /usr/bin/grep "data"` ]]; then
  chown -R dsapid:dsapid /data
fi

log "starting dsapid"

/usr/sbin/svcadm enable dsapid
