ALTER USER root@localhost IDENTIFIED VIA mysql_native_password;

SET PASSWORD = PASSWORD('root');

FLUSH PRIVILEGES;

CREATE DATABASE aribesni_db;

GRANT ALL PRIVILEGES ON  aribesni_db.* to root@localhost;

FLUSH PRIVILEGES;

quit
