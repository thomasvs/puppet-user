# = Define: user::bashrc::ssh_agent
#
# This define deploys a .bashrc.d snippet to use a session ssh-agent
#
define user::bashrc::ssh_agent (
  $user = $title,
  $group = $title,
) {

  case $::operatingsystem {
    /^(RedHat|CentOS)$/: {

    }
    /^(Fedora|Ubuntu)$/: {
      package { 'keychain':
        ensure => installed
      }

      $home = user_home($user)

      file { "${home}/.bashrc.d/ssh-agent":
        ensure  => present,
        owner   => $user,
        group   => $group,
        mode    => '0640',
        source  => 'puppet:///modules/user/bashrc.d/ssh-agent',
        require => User::Bashrc[$user],
      }

    }
  }

}
