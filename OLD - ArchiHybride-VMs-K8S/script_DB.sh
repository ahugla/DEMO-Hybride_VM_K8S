


# sur CentOS 7 showroom
# DB test : 10.11.10.34



# Recuperation des variables
DB_password=$1
echo "DB_password = " $DB_password


cd /tmp


# install MySLQ
yum install -y  git wget vim mariadb-server
systemctl start mariadb
systemctl enable mariadb



# set password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('$DB_password') WHERE User = 'root'"
systemctl restart mariadb

#mysql -u root -p
#MariaDB [(none)]> SHOW DATABASES;
#+--------------------+
#| Database           |
#+--------------------+
#| information_schema |
#| mysql              |
#| performance_schema |
#| test               |
#+--------------------+
#4 rows in set (0.00 sec)



# creation du fichier de compte
cat >/var/lib/mysql/extra <<EOF
[client]
user=root
password=$DB_password
EOF



# create base et populate
mysql  --defaults-extra-file=/var/lib/mysql/extra  < /tmp/Docaposte/ArchiHybride-VMs-K8S/dump_testndc.sql
#mysql -u root -p
#USE testndc;
#SHOW TABLES;
#select * from contenu_base_testndc;


# create user testndcuser and enable remote connection
sed -i '2 i\bind-address = 0.0.0.0' /etc/my.cnf
mysql --defaults-extra-file=/var/lib/mysql/extra -e "CREATE USER 'testndcuser'@'%' IDENTIFIED BY '$DB_password';"
mysql --defaults-extra-file=/var/lib/mysql/extra -e "GRANT ALL PRIVILEGES ON testndc.* TO 'testndcuser'@'%';"
mysql --defaults-extra-file=/var/lib/mysql/extra -e "FLUSH PRIVILEGES;"



systemctl restart mariadb

