# = Define: user::ssh::authorized_keys
#
# This define deploys .ssh/authorized_keys
#
define user::ssh::authorized_keys (
  $owner = $title,
  $group = $title,
  $keys     = {},
  $allusers = true,
  $users    = [],
  $mode     = '0600',
  $path = undef,
) {

  $home = user_home($owner)

  if ($path) {
    $real_path = $path
  } else {
    $real_path = "${home}/.ssh/authorized_keys"
  }

  file { $real_path:
    owner   => $owner,
    group   => $group, 
    mode    => $mode, 
    content => template('user/ssh//authorized_keys.erb'), 
  } 
}
