class user::bash_profile::ssh_agent::install {

  case $facts['os']['name'] {
    /^(RedHat|CentOS)$/: {

    }

    /^(Fedora|Ubuntu)$/: {
      package { 'keychain':
        ensure => installed
      }
    }
  }
}
