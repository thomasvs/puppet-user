# = Define: user::bash_profile
#
# This define manages .bash_profile and loads from .bash_profile.d
#
define user::bash_profile (
  $user = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
  $bash_profile_source = lookup("user::data::${title}::bash_profile_source", { 'default_value' => undef }),
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
