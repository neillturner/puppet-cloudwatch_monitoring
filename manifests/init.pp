# == Class: cloudwatch_monitoring
#
# classes to run for the cloudwatch monitoring script 
# class parameters can be coded here or resolved
# via the hiera parameter hierachy
#
class cloudwatch_monitoring(
  $username         = 'cw_monitoring',
  $group            = 'cw_monitoring',
  $home_dir         = '/home/cw_monitoring',
  $aws_access_key   = undef,
  $aws_secret_key   = undef,
  $ec2_region       = undef,  
  $http_proxy       = undef,
  $cron_description = 'cloudwatch_monitoring',
  $options          = '--disk-space-util --disk-path=/ --disk-space-used  --disk-space-avail --swap-util --swap-used  --mem-util --mem-used --mem-avail',
  $cron_minute      = '*/5',
)
{

  if $http_proxy  {
    $cron_env = ["http_proxy=${http_proxy}","https_proxy=${http_proxy}"]
  } else { 
    $cron_env = []
  }
  
  group { $group:
    ensure  => present
  }

  user { $username:
    ensure     => present,
    gid        => $group,
    managehome => true,
    require    => Group[$group]
  }

  file { $home_dir:
    ensure  => directory,
    owner   => $username,
    group   => $group,
    require => [User[$username], Group[$group]]
  }
  
  class { 'cloudwatch_monitoring::prereqs':
    username      => $username,
    aws_access_key => $aws_access_key,
    aws_secret_key => $aws_secret_key,
    ec2_region     => $ec2_region,
    require        => File[$home_dir],
  }  

  file { "${home_dir}/aws-mon.sh":
    ensure  => 'file',
    owner   => $username,
    group   => $group,
    mode    => '0700',
    content => template('cloudwatch_monitoring/aws-mon.sh.erb'),
    require => Class['cloudwatch_monitoring::prereqs'],
  }

  cron  { $cron_description:
    user        => $username,  
    command     => "${home_dir}/aws-mon.sh ${options} --from-cron || logger -t aws-mon \"status=failed exit_code=$?\"",
    minute      => $cron_minute,
    environment => $cron_env,
    require     => File["${home_dir}/aws-mon.sh"]
  }
}


