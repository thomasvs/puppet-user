# = Define: user::bash_profile::ssh_agent
#
# This define deploys a .bash_profile.d snippet to use a session ssh-agent
#
define user::bash_profile::ssh_agent (
  $user = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
) {

  include user::bash_profile::ssh_agent::install

  if $facts != undef {
    $os_name = $facts['os']['name']
  } else {
    $os_name = $::operatingsystem
  }

  case $os_name {
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
