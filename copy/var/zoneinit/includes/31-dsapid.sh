
log "creating /data directory"

if [[ ! -e /data ]]; then
  mkdir /data
  mkdir /data/files
fi

if [[ ! -e /data/config.json ]]; then
  log "creating initial configuration"

  cat > /data/config.json << EOF
{
  "hostname": "${HOSTNAME}",
  "base_url": "http://${HOSTNAME}/",
  "datadir": "/data/files",
  "mount_ui": "/opt/dsapid/ui",
  "users": "/data/users.json",
  "listen": {
    "http": {
      "address": "0.0.0.0:80",
      "ssl": false
    }
  },
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

  cat > /data/users.json << EOF
[
  {
    "uuid": "352971aa-31ba-496c-9ade-a379feaecd52",
    "name": "sdc",
    "type": "system",
    "provider": "joyent"
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

log "starting dsapid"

/usr/sbin/svcadm enable dsapid