# = Define: user::bashrc
#
# This define manages .bashrc and loads from .bashrc.d
#
define user::bashrc (
  $user = $title,
  $group = $title,
) {
  $home = user_home($user)

  file { "${home}/.bashrc":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
    source => 'puppet:///modules/user/bashrc/dotbashrc'
  }

  file { "${home}/.bashrc.d":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
  }
}
