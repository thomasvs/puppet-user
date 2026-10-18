class user::bash_profile::ssh_agent::install {

  if $facts != undef {
    $os_name = $facts['os']['name']
  } else {
    $os_name = $::operatingsystem
  }

  case $os_name {
    /^(RedHat|CentOS)$/: {

    }

    /^(Fedora|Ubuntu)$/: {
      package { 'keychain':
        ensure => installed
      }
    }
  }
}
