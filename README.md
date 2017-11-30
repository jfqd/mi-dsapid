mi-dsapid
=========

Use [joyent/mibe](https://github.com/joyent/mibe) to create a provisionable image

## description

SmartOS image server.

## Image upload

Ensure that the /tmp space (tmpfs) is big enough to hold the uploaded image.

```
curl -v -u your-secure-admin-token: https://10.10.10.10/api/upload -F manifest=@/opt/mibe/images/qutic-base-17.3.1-dsapi.dsmanifest  -Ffile=@/opt/mibe/images/qutic-base-17.3.1.zfs.gz
```

## mdata variables

See [mi-qutic-base Readme](https://github.com/jfqd/mi-qutic-base/blob/master/README.md) for a list of usable metadata.

## installation

The following sample can be used to create an image server.

```
BASE_IMAGE_UUID=$(imgadm list | grep 'qutic-base-64' | tail -1 | awk '{ print $1 }')
vmadm create << EOF
{
  "brand":      "joyent",
  "image_uuid": "$BASE_IMAGE_UUID",
  "alias":      "dsapid-server",
  "hostname":   "base.example.com",
  "dns_domain": "example.com",
  "resolvers": [
    "80.80.80.80",
    "80.80.81.81"
  ],
  "nics": [
    {
      "interface": "net0",
      "nic_tag":   "admin",
      "ip":        "10.10.10.10",
      "gateway":   "10.10.10.1",
      "netmask":   "255.255.255.0"
    }
  ],
  "max_physical_memory": 1024,
  "max_swap":            1024,
  "tmpfs":               1024,
  "quota":                 10,
  "cpu_cap":              100,
  "customer_metadata": {
    "admin_authorized_keys": "your-long-key",
    "root_authorized_keys":  "your-long-key",
    "mail_smarthost":        "mail.qutic.com",
    "mail_auth_user":        "your-name@example.com",
    "mail_auth_pass":        "smtp-account-password",
    "mail_adminaddr":        "report@example.com",
    "munin_master_allow":    "munin-master-ip",
    "admin_upload_token":    "your-secure-admin-token",
    "nginx_ssl":             "certificat"
  }
}
EOF
```
