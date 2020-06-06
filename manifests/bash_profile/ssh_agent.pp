# = Define: user::bash_profile::ssh_agent
#
# This define deploys a .bash_profile.d snippet to use a session ssh-agent
#
define user::bash_profile::ssh_agent (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  include user::bash_profile::ssh_agent::install

  case $::operatingsystem {
    /^(RedHat|CentOS)$/: {

    }
    /^(Fedora|Ubuntu)$/: {

      $home = user_home($user)

      file { "${home}/.bash_profile.d/ssh-agent":
        ensure  => present,
        owner   => $user,
        group   => $group,
        mode    => '0640',
        source  => 'puppet:///modules/user/bash_profile.d/ssh-agent',
        require => User::Bashrc[$user],
      }

    }
  }

}
