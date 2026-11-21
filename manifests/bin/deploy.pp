# = Define: user::bin::deploy
#
# This define deploys scripts to the user's bin dir
#
# parameters can be parsed from the title as ${user}:${binary}
#
# == Parameters
#
# ** user: the user to deploy for; will get indirected through hiera
# ** group: the group to deploy for; if undefined, looked up from hiera
# ** binary: the name of the binary to deploy
# ** binary_source: if not defined, deploys the binary with the same name
#    from this module
#
define user::bin::deploy (
  $user  = undef,
  $group = undef,
  $binary = undef,
  $binary_source_dir = "puppet:///modules/user/bin",
  $binary_source = undef,
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

  validate_string($binary)

  $real_binary = $binary ? {
    ''       => $_title_rest,
    undef    => $_title_rest,
    default  => $binary
  }

  $home = user_home($real_user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = user_lookup("user::data::${real_user}::group", { 'default_value' => $real_user })
  }

  if ($binary_source) {
    $real_binary_source = $binary_source
  } else {
    $real_binary_source = "${binary_source_dir}/${real_binary}"
  }

  file { "${home}/bin/${real_binary}":
    ensure  => present,
    owner   => $real_user,
    group   => $real_group,
    mode    => '0750',
    source  => $real_binary_source,
    require => File["${home}/bin"],
  }
}
