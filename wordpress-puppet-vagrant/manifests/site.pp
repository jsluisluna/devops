node default {

  #
  # Install Apache
  #

  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }

  package { 'apache2':
    require => Exec['apt-update'],
    ensure => installed
  }

  file { 'remove-index':
    path => '/var/www/html/index.html',
    ensure => absent,
    require => Package['apache2']
  }

  service { 'apache2':
    ensure => running,
  }

  #
  # Install PHP
  #
  
  exec { 'install-php':
    command => '/usr/bin/apt install apt-transport-https software-properties-common ca-certificates lsb-release -y'
  }

  exec { 'add-source-repo':
    command => '/usr/bin/add-apt-repository ppa:ondrej/php',
    require => Exec['install-php']
  }

  package { 'php8.1':
    require => Exec['add-source-repo'],
    ensure => installed
  }

  exec { 'php8.1-extensions':
    command => '/usr/bin/apt install php8.1-cli php8.1-fpm php8.1-common php8.1-imap php8.1-redis php8.1-xml php8.1-zip php8.1-mbstring php8.1-mysql -y',
    require => Package['php8.1']
  }

  exec { 'php8.1-enable':
    command => '/usr/sbin/a2enmod proxy_fcgi setenvif && a2enconf php8.1-fpm && a2enmod php8.1',
    require => Exec['php8.1-extensions']
  }

  #
  # Install MySQL
  #

  $packages = ['mysql-server', 'libapache2-mod-php8.1', 'php-mysql']

  package { $packages:
    ensure => installed
  }

  service { 'mysql':
    name => 'mysql',
    ensure => true,
    enable => true,
    require => Package[$packages],
    restart => '/usr/sbin/service mysql reload'
  }

  exec {'set-mysql-password':
    unless => '/usr/bin/mysqladmin -u root -p wordpress status',
    command => '/usr/bin/mysqladmin -u root password wordpress',
    require => Service['mysql']
  }

  file { '/home/vagrant/database.sql':
    ensure => 'present',
    source => 'puppet:///modules/mysql/database.sql'
  }

  exec { 'execute-query':
    command => '/usr/bin/mysql -h localhost -u root -D mysql < /home/vagrant/database.sql',
    require => File['/home/vagrant/database.sql']
  }

  #
  # Install Wordpress CLI
  #

  package { 'curl':
    ensure => 'installed',
  }

  exec { 'install-wp-cli':
    command => '/usr/bin/curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && /bin/chmod +x wp-cli.phar && /usr/bin/sudo /bin/mv wp-cli.phar /usr/local/bin/wp',
    creates => '/usr/local/bin/wp',
    require => Package['curl'],
  }

  #
  # Install Wordpress 6.2
  #

  file { '/var/www/html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '755',
  }

  exec { 'download-wordpress':
    command => '/usr/bin/wget -P /var/www/html https://wordpress.org/wordpress-6.2.tar.gz',
    creates => '/var/www/html/wordpress-6.2.tar.gz',
    require => Service['mysql']
  }

  exec { 'extract-wordpress':
    command => '/bin/tar -zxf /var/www/html/wordpress-6.2.tar.gz --strip-components=1 -C /var/www/html',
    creates => '/var/www/html/index.php',
    require => Exec['download-wordpress']
  }
  
  exec { 'configure-wordpress':
    command => '/usr/local/bin/wp core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=localhost --dbprefix=wp_ --allow-root',
    cwd     => '/var/www/html',
    creates => '/var/www/html/wp-config.php',
    require => Exec['extract-wordpress']
  }

  exec { 'install-wordpress':
    command => '/usr/local/bin/wp core install --url=http://localhost:8080 --title="DevOps Activity" --admin_user=admin --admin_password=admin --admin_email=jsluis.luna@gmail.com --allow-root',
    cwd     => '/var/www/html',
    notify  => Service['apache2']
  }

}

