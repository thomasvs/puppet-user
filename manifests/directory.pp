# = Define: user::directory
#
# This define ensures user directories exist
#
# parameters can be parsed from the title as ${user}:${directory}
#
# == Parameters
#
# ** user: the user to ensure for; will get indirected through hiera
# ** group: the group to ensure for; if undefined, looked up from hiera
# ** directory the name of the directory to ensure
# ** binary_source: if not defined, deploys the binary with the same name
#    from this module
#
define user::directory (
  $user  = undef,
  $group = undef,
  $directory = undef,
  $mode = '0777',
) {

  validate_string($user)

  $real_user = $user ? {
    ''      => regsubst($title, '^([^:]+):.*$', '\1'),
    undef   => regsubst($title, '^([^:]+):.*$', '\1'),
    default => hiera("user::data::${user}:user", $user),
  }

  validate_string($directory)

  $real_directory = $directory ? {
    ''       => regsubst($title, '^[^:]+:(.*)$', '\1'),
    undef    => regsubst($title, '^[^:]+:(.*)$', '\1'),
    default  => $directory
  }

  $home = user_home($real_user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = hiera("user::data::${real_user}::group", $real_user)
  }

  file { "${home}/${real_directory}":
    ensure  => directory,
    owner   => $real_user,
    group   => $real_group,
    mode    => $mode
  }
}
