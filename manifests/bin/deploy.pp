# = Define: user::bin::deploy
#
# This define deploys scripts to the user's bin dir
#
# == Parameters
#
define user::bin::deploy (
  $user  = hiera("user::data::${title}::user", $title),
  $group = undef,
  $binary = undef,
  $binary_source = undef,
) {

  $home = user_home($user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = hiera("user::data::${user}::group", $user)
  }

  if ($binary_source) {
    $real_binary_source = $binary_source
  } else {
    $real_binary_source = "puppet:///modules/user/bin/${binary}"
  }

  file { "${home}/bin/${binary}":
    ensure  => present,
    owner   => $user,
    group   => $real_group,
    mode    => '0750',
    source  => $real_binary_source,
    require => User::Bin[$user],
  }
}
