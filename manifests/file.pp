# = Define: user::file
#
# This define deploys files to the user's dir
#
# parameters can be parsed from the title as ${user}:${file}
#
# == Parameters
#
# ** user: the user to deploy for; will get indirected through hiera
# ** group: the group to deploy for; if undefined, looked up from hiera
# ** file: the name of the file to deploy
# ** file_source: if not defined, deploys the file with the same name
#    from this module
#
define user::file (
  $user  = undef,
  $group = undef,
  $file = undef,
  $mode = undef,
  $file_source_dir = "puppet:///modules/user",
  $file_source = undef,
) {

  validate_string($user)

  $real_user = $user ? {
    ''      => regsubst($title, '^([^:]+):.*$', '\1'),
    undef   => regsubst($title, '^([^:]+):.*$', '\1'),
    default => hiera("user::data::${user}:user", $user),
  }

  validate_string($file)

  $real_file = $file ? {
    ''       => regsubst($title, '^[^:]+:(.*)$', '\1'),
    undef    => regsubst($title, '^[^:]+:(.*)$', '\1'),
    default  => $file
  }

  $home = user_home($real_user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = hiera("user::data::${real_user}::group", $real_user)
  }

  if ($file_source) {
    $real_file_source = $file_source
  } else {
    $real_file_source = "${file_source_dir}/${real_file}"
  }

  file { "${home}/${real_file}":
    ensure  => present,
    owner   => $real_user,
    group   => $real_group,
    mode    => $mode,
    source  => $real_file_source
  }
}
