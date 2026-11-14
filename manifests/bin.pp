# = Define: user::bin
#
# This define deploys the bin directory in the user home directory
#
# == Parameters
#
define user::bin (
  $user = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
) {

  $home = user_home($user)

  if ! defined(File["${home}/bin"]) {
    file { "${home}/bin":
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0750',
    }
  }

}
