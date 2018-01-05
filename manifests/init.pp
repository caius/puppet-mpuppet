class mpuppet {
  $user_sbin = $facts['os']['family'] ? {
    'Debian'  => '/usr/local/sbin',
    'Solaris' => '/opt/local/sbin',
  }

  $cron_d = $facts['os']['family'] ? {
    'Debian'  => '/etc/cron.d',
    'Solaris' => '/etc/cron.d',
  }

  file { "${user_sbin}/mpuppet-apply":
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/mpuppet-apply.sh",
  }

  file { "${user_sbin}/mpuppet-fetch":
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/mpuppet-fetch.sh",
  }

  file { "${user_sbin}/mpuppet-run":
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/mpuppet-run.sh",
  }

  $minute = fqdn_rand(30)

  file { "${cron_d}/mpuppet":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/mpuppet_cron.erb"),
  }
}
