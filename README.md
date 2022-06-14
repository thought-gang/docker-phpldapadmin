 # phpLDAPadmin

phpLDAPadmin (also known as PLA) is a web-based LDAP client. It provides easy, anywhere-accessible, multi-language administration for your LDAP server. This versions runs in a Docker container is optimized to be run within a Kubernetes Cluster.

### Usage

#### Running your container

For simple use cases you may want

```shell
docker run -p 80:80 \
           -e PLA_HOST=ldaps://ldap.yourcompany.com:636/ 
           -e PLA_PORT=636 -e PLA_BASE=dc=yourcompany,dc=com -e PLA_ADMIN=cn=admin,dc=yourcompany,dc=com thoughtgang/phpldapadmin:latest
```

If you need advanced control over every config setting you may want to provide your own config.php file

```shell
docker run -v /etc/phpldapadmin/config.php:<path to your config.php> \
           -p 80:80 \
           phpldapadmin:latest \
```


### Environment Variables


* `PLA_HOST` (required) - The hostname or IP address of the LDAP server to connect to.

* `PLA_PORT` - The port of the LDAP server to connect to. Use 389 for unencrypted communication or TLS, 636 for SSL.

   *Default:* 389

* `PLA_TLS` - Whether to use TLS when connecting.

   *Default:* false

* `PLA_BASE` - The base on which the the LDAP editor will work. If the this is left blank phpLDAPadmin will auto-detect the root node of your LDAP server.

   *Default:* <auto-detect>

* `PLA_ADMIN` - This is the distinguished name of the admin account. It is used to prefill the login script.

   *Default:* cn=admin,dc=example,dc=com

* `PLA_UNIQUE_ATTRS` - phpLDAPadmin can enforce uniquness of certain attributes. However, this prevents using the internal copy function to use an existing node as template. The environment vairable `PLA_UNIQUE_ATTRS` allows you to select for which attributes you want to enforce uniqueness.

   *Default:* mail uid uidNumber

### Volumes

phpLDAPadmin does not persist data locally. Therefore no volumes are necessary.

### Useful File Locations

* `/etc/phpldapadmin/config.php` - Confiuration file for phpLDAPadmin. You may want to edit this by hand for more advanced options.

* `/usr/local/share/ca-certificates` - You can place any self-signed certificates (with a .crt extension) in this folder and run update-ca-certificates to accept them as trusted root certificates. 

## Find Us

* [GitHub](https://github.com/thought-gang/docker-phpldapadmin)
* [Docker.io](https://hub.docker.com/repository/docker/thoughtgang/docker-phpldapadmin)


## Authors

* **Felix Hoßfeld** - *Initial work* - [Thought Gang GmbH](https://www.thoughtgang.de/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
