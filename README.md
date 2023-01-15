# support-enabler
Simple bash script to enable/disable supports on a web site share on GL.iNET devices

## Pre-requisites
You have to move GL.iNET admin panel to 8080/8443 editing `/etc/nginx/conf.d/gl.conf`, changing
```bash
    listen 80;
    listen [::]:80;

    listen 443 ssl;
    listen [::]:443 ssl;

```
to
```bash
    listen 8080;
    listen [::]:8080;

    listen 8443 ssl;
    listen [::]:8443 ssl;
```

Install cryptsetup and apache2 package
```bash
opkg install apache2 cryptsetup
```
In Apache2 configuration file at `/etc/apache2/apache2.conf`, please modify lines:
```bash
Listen 80

[...]

DocumentRoot "/usr/share/apache2/site-enabled"
<Directory "/usr/share/apache2/site-enabled">
    Options Indexes FollowSymLinks
    AllowOverride Options Indexes FileInfo
    Require all granted
</Directory>
```

Copy the content of usr-share-apache2-htdocs in `/usr/share/apache2/htdocs/`

Copy the content of mnt-encrypted to `/mnt/encrypted` while SDCard is mounted.

Run `support-disable`.

# how does it work?
This script mount your luks-ed sdcard, look for the support asked in `/mnt/encrypted/supports/`, then put it as a symlink in `/mnt/encrypted/htdocs/Supports`, and changes apache2 webroot to `/mnt/encrypted/htdocs`
