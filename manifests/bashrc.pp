# = Define: user::bashrc
#
# This define manages .bashrc and loads from .bashrc.d
#
define user::bashrc (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
  $bashrc_source = hiera("user::data::${title}::bashrc_source", undef),
) {
  if ($bashrc_source) {
    $real_bashrc_source = $bashrc_source
  } else {
    $real_bashrc_source = 'puppet:///modules/user/bashrc/dotbashrc'
  }

  $home = user_home($user)

  file { "${home}/.bashrc":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
    source => $real_bashrc_source,
  }

  file { "${home}/.bashrc.d":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
  }
}
