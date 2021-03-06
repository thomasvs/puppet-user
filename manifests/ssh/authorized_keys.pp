# = Define: user::ssh::authorized_keys
#
# This define deploys .ssh/authorized_keys
#
define user::ssh::authorized_keys (
  $user     = hiera("user::data::${title}::user", $title),
  $group    = hiera("user::data::${title}::group", $title),
  $keys     = {},
  $allusers = true,
  $users    = [],
  $mode     = '0600',
  $path     = undef,
  $ensure   = present,
) {

  $home = user_home($user)

  if ($path) {
    $real_path = $path
    $_require = delete_undef_values(flatten([$require, ]))
  } else {
    $real_path = "${home}/.ssh/authorized_keys"
    $_require = delete_undef_values(flatten([
      $require,
      File["${home}/.ssh"],
    ]))
  }

  file { $real_path:
    owner   => $user,
    group   => $group,
    mode    => $mode,
    content => template('user/ssh/authorized_keys.erb'),
    require => $_require,
    ensure  => $ensure,
  }
}
