# == Class: cloudwatch_monitoring::prereqs
#
# classes to run for the cloudwatch monitoring::prereqs script 
# class parameters can be coded here or resolved
# via the hiera parameter hierachy
#
class cloudwatch_monitoring::prereqs()
{
  if  $::osfamily == 'RedHat' {
    if ! defined(Package['python-devel']) {
      package { 'python-devel':
        ensure => installed,
        before => Exec['pip install awscli'],
      }
    }
    if ! defined(Package['python-pip']) {
      package { 'python-pip':
        ensure  => installed,
        before  => Exec['pip install awscli'],
        require => Package['python-devel'],
      }
    }
    exec { 'pip install awscli':
      command => 'pip install awscli',
      unless  => 'which aws',
      timeout => '0',
    }
  } else {
    class { 'awscli': }
  }
}