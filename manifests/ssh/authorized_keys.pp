# = Define: user::ssh::authorized_keys
#
# This define deploys .ssh/authorized_keys
#
define user::ssh::authorized_keys (
  $user     = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group    = lookup("user::data::${title}::group", { 'default_value' => $title }),
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
