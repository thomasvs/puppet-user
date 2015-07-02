class user::bashrc::ssh_agent::install {

  case $::operatingsystem {
    /^(RedHat|CentOS)$/: {

    }

    /^(Fedora|Ubuntu)$/: {
      package { 'keychain':
        ensure => installed
      }
    }
  }
}
