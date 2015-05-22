# == Class: cloudwatch_monitoring::prereqs
#
# classes to run for the cloudwatch monitoring::prereqs script 
# class parameters can be coded here or resolved
# via the hiera parameter hierachy
#
class cloudwatch_monitoring::prereqs()
{

  class { 'awscli': }
  
  if ! defined(Package['wget']) {
    package { 'wget':
      ensure   => 'installed',
      provider => 'yum',
      require  => Class['awscli']
    }
  }

}