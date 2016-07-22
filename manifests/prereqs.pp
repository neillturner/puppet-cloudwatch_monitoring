# == Class: cloudwatch_monitoring::prereqs
#
# classes to run for the cloudwatch monitoring::prereqs script
# class parameters can be coded here or resolved
# via the hiera parameter hierachy
#
class cloudwatch_monitoring::prereqs(
  $manage_awscli = true
)
{

  if $manage_awscli == true {
    class { 'awscli': }
  }

  ensure_packages(['wget'])

}