exec { 'apt-get update':
	command => 'apt-get update',
	path  => '/usr/local/bin:/bin/:/usr/bin/',
}

package {
    ['apache2', 'php5', 'libapache2-mod-php5', 'unzip', 'python', 'graphviz']:
        ensure => installed,
		require => Exec['apt-get update'],
}

package { 'php5-xdebug':
	ensure => installed,
	require => Package['php5'],
}

service {
    'apache2':
        ensure => true,
        enable => true,
        require => Package['apache2']
}

file { '/var/www/webgrind/':
	ensure => directory,
    source => "/vagrant/modules/webgrind/",
	recurse => true,
	require => Package['apache2'],
}

file{ '/etc/php5/conf.d/xdebug.ini':
	ensure => file,
	source => "/vagrant/modules/traces/xdebug.ini",
	require => Package['php5-xdebug'],
	notify => Service['apache2'],
}