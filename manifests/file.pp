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
# ** content: inline or templated file content (overrides source)
# ** replace: whether Puppet overwrites existing content (default: true)
#
define user::file (
  $user  = undef,
  $group = undef,
  $file = undef,
  $mode = undef,
  $file_source_dir = "puppet:///modules/user",
  $file_source = undef,
  $content = undef,
  $replace = true,
) {

  validate_string($user)

  $_title_parts = split($title, ':')
  $_title_user  = $_title_parts[0]
  $_title_rest  = join(delete_at($_title_parts, 0), ':')

  $real_user = $user ? {
    ''      => $_title_user,
    undef   => $_title_user,
    default => user_lookup("user::data::${user}:user", { 'default_value' => $user }),
  }

  validate_string($file)

  $real_file = $file ? {
    ''       => $_title_rest,
    undef    => $_title_rest,
    default  => $file
  }

  $home = user_home($real_user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = user_lookup("user::data::${real_user}::group", { 'default_value' => $real_user })
  }

  if ($content) {
    $real_file_source = undef
  } elsif ($file_source) {
    $real_file_source = $file_source
  } else {
    $real_file_source = "${file_source_dir}/${real_file}"
  }

  file { "${home}/${real_file}":
    ensure  => present,
    owner   => $real_user,
    group   => $real_group,
    mode    => $mode,
    source  => $real_file_source,
    content => $content,
    replace => $replace,
  }
}
