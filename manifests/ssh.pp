# = Define: ssh
#
# This define sets up the .ssh hierarchy in the home directory.
define user::ssh (
  $user = $title,
  $group = $title,
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
