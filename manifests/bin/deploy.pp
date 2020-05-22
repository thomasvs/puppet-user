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

  $real_user = $user ? {
    ''      => regsubst($title, '^([^:]+):.*$', '\1'),
    undef   => regsubst($title, '^([^:]+):.*$', '\1'),
    default => hiera("user::data::${user}:user", $user),
  }

  validate_string($binary)

  $real_binary = $binary ? {
    ''       => regsubst($title, '^[^:]+:(.*)$', '\1'),
    undef    => regsubst($title, '^[^:]+:(.*)$', '\1'),
    default  => $binary
  }

  $home = user_home($real_user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = hiera("user::data::${real_user}::group", $real_user)
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
    require => User::Bin[$real_user],
  }
}
