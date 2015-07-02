# = Define: user::bashrc::ssh_agent
#
# This define deploys a .bashrc.d snippet to use a session ssh-agent
#
define user::bashrc::ssh_agent (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  include user::bashrc::ssh_agent::install

  case $::operatingsystem {
    /^(RedHat|CentOS)$/: {

    }
    /^(Fedora|Ubuntu)$/: {

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
