# cloudwatch_monitoring

[![Puppet Forge](http://img.shields.io/puppetforge/v/neillturner/cloudwatch_monitoring.svg)](https://forge.puppetlabs.com/neillturner/cloudwatch_monitoring)

Bash script that reports custom metric data about Linux performance to Amazon CloudWatch

This bash script will work on:
* Amazon Linux 2014.3
* Red Hat Enterprise Linux 6.4
* Ubuntu Server 13.10
although the puppet script needs a little bit of work.

The script is written in simple Bash, so you can use it very easily and it use the aws-cli.
The script is from https://github.com/moomindani/aws-mon-linux.
The script is almost compatible with [Amazon CloudWatch Monitoring Scripts for Linux](http://aws.amazon.com/code/8720044071969977), so you can use almost same options. 

The script also supports running instance behind an http proxy!!!

## Minimual Usage

      `class { 'cloudwatch_monitoring': }`

## Detailed Usage

      `class { 'cloudwatch_monitoring':
         username         => 'cw_monitoring',
         group            => 'cw_monitoring',
         home_dir         => '/home/cw_monitoring',
         aws_access_key   => 'MYAWSACCESSKEYID',
         aws_secret_key   => 'MYAWSSECRETACESSKEY',
         http_proxy       => undef,
         cron_description => 'cloudwatch_monitoring',
         options          => '--disk-space-util --disk-path=/ --disk-space-used  --disk-space-avail --swap-util --swap-used  --mem-util --mem-used --mem-avail',
         cron_minute      => '*/5',
      }`

## AWS authentication

### with IAM role (recommended)

If your instance has an IAM role, then the script will use it to and you don't have to worry about setting keys.

Make sure that the role has permissions to perform the Amazon CloudWatch `PutMetricData` operation.


### with a key

If your instance does not have a role, you need to specify the aws_access_key and aws_secret_keya key.
It recommended that you store these encrypted in your puppet repository in hiera using eyaml to encrypt them.


## Metrics of This Script

This script can report the following metrics:

* load average
* interrupt
* context switch
* cpu (user/system/idle/wait/steal)
* memory
* swap
* disk


## Using the Script

This script collects load average, cpu, memory, swap, and disk space utilization data on the current system. It then makes a remote call to Amazon CloudWatch to report the collected data as custom metrics.

### Options

Name                       | Description
-------------------------- | -------------------------------------------------
--help                     | Displays usage information.
--version                  | Displays the version number.
--verify                   | Checks configuration and prepares a remote call.
--verbose                  | Displays details of what the script is doing.
--debug                    | Displays information for debugging.
--from-cron                | Use this option when calling the script from cron.
--profile VALUE            | Use a specific profile from your credential file.
--load-ave1                | Reports load average for 1 minute in counts.
--load-ave5                | Reports load average for 5 minutes in counts.
--load-ave15               | Reports load average for 15 minutes in counts.
--interrupt                | Reports interrupt in counts.
--context-switch           | Reports context switch in counts.
--cpu-us                   | Reports cpu utilization (user) in percentages.
--cpu-sy                   | Reports cpu utilization (system) in percentages.
--cpu-id                   | Reports cpu utilization (idle) in percentages.
--cpu-wa                   | Reports cpu utilization (wait) in percentages.
--cpu-st                   | Reports cpu utilization (steal) in percentages.
--memory-units UNITS       | Specifies units in which to report memory usage. If not specified, memory is reported in megabytes. UNITS may be one of the following: bytes, kilobytes, megabytes, gigabytes.
--mem-used-incl-cache-buff | Count memory that is cached and in buffers as used.
--mem-util                 | Reports memory utilization in percentages.
--mem-used                 | Reports memory used in megabytes.
--mem-avail                | Reports available memory in megabytes.
--swap-util                | Reports swap utilization in percentages.
--swap-used                | Reports allocated swap space in megabytes.
--swap-avail               | Reports available swap space in megabytes.
--disk-path PATH           | Selects the disk by the path on which to report.
--disk-space-units UNITS   | Specifies units in which to report disk space usage. If not specified, disk space is reported in gigabytes. UNITS may be one of the following: bytes, kilobytes, megabytes, gigabytes.
--disk-space-util          | Reports disk space utilization in percentages.
--disk-space-used          | Reports allocated disk space in gigabytes.
--disk-space-avail         | Reports available disk space in gigabytes.
--all-items                | Reports all items.

## TO DO

Support Multiple disk paths.

Support ubuntu would be very easy.