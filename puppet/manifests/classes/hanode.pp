class hanode {
  package { ["mysql-server", "mysql-client", "libdbd-mysql-perl"]:
    ensure => present,
  }

  package { "mha4mysql-node":
    require => Package["libdbd-mysql-perl"],
    ensure => present,
    provider => dpkg,
    source => "/vagrant/puppet/files/packages/mha4mysql-node_0.52_all.deb",
  }

  service { "mysql":
    ensure => "running",
  }

  exec { "root4all":
    require => [Service["mysql"],Package["mysql-client"]],
    command => "/usr/bin/mysql -u root -e\"GRANT ALL ON *.* TO 'root'@'%';\"",
    unless => "/usr/bin/mysql -u root -e\"SELECT User FROM mysql.user Where User='root' AND Host='%';\" | grep -q root",
  }
}

