
node default{
  # Update packages
  exec { 'apt-update':
    command => '/bin/echo `hostname`';
  }
}

node "appserver", /appserver.*/ {
  # Install curl
  package { 'curl':
    ensure => installed,
  }

  # Get node source
  exec { 'get-node-source':
    require => Package['curl'],
    command => '/usr/bin/curl -sL https://deb.nodesource.com/setup_16.x | sudo -E /usr/bin/bash -';
  }

  # Install nodejs
  package { 'nodejs':
    require => Exec['get-node-source'],
    ensure => installed,
  }

}

node "dbserver", /dbserver\.*/ {# Install mysql
  package { 'mysql-server':
    ensure => installed,
  }

  # Ensure mysql is running
  service { 'mysql':
    ensure => running,
    enable => true,
    require => Package['mysql-server']
  }
}
