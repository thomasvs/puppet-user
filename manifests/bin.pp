# = Define: user::bin
#
# This define deploys the bin directory in the user home directory
#
# == Parameters
#
define user::bin (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  $home = user_home($user)

  file { "${home}/bin":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
  }
  
}
