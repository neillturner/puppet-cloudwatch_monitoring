# == Class: cloudwatch_monitoring::prereqs
#
# classes to run for the cloudwatch monitoring::prereqs script 
# class parameters can be coded here or resolved
# via the hiera parameter hierachy
#
class cloudwatch_monitoring::prereqs(
  $username       = 'cw_monitoring',
  $aws_access_key = undef,
  $aws_secret_key = undef,
  $ec2_region     = undef,
)
{

  file { '/etc/profile.d/aws_keys.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('cloudwatch_monitoring/aws_keys.sh.erb'),
  }
  
  exec { '/bin/bash /etc/profile.d/aws_keys.sh':
    command => '/bin/bash /etc/profile.d/aws_keys.sh',
    timeout => 0,
    require => File['/etc/profile.d/aws_keys.sh']
  }  
  
  class { 'awscli':
    require => Exec['/bin/bash /etc/profile.d/aws_keys.sh'],
  }
  
  if ! defined(Package['wget']) {   
    package { 'wget':
      ensure   => 'installed',
      provider => 'yum',
      require  => Class['awscli']
    }  
  }

}