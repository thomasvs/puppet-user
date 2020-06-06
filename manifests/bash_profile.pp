# = Define: user::bash_profile
#
# This define manages .bash_profile and loads from .bash_profile.d
#
define user::bash_profile (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
  $bash_profile_source = hiera("user::data::${title}::bash_profile_source", undef),
) {
  if ($bash_profile_source) {
    $real_bash_profile_source = $bash_profile_source
  } else {
    $real_bash_profile_source = 'puppet:///modules/user/bash_profile/dotbash_profile'
  }

  $home = user_home($user)

  file { "${home}/.bash_profile":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
    source => $real_bash_profile_source,
  }

  file { "${home}/.bash_profile.d":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
  }
}
