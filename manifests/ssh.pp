# = Define: ssh
#
# This define sets up the .ssh hierarchy in the home directory.
define user::ssh (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  $home = user_home($user)

  file { [
    "${home}/.ssh",
    ]
    :
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }
}
