# = Define: ssh
#
# This define sets up the .ssh hierarchy in the home directory.
#
define user::ssh (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
  $ensure = present,
) {

  $home = user_home($user)

  file { [
    "${home}/.ssh",
    ]
    :
    ensure => $ensure ? { 'present' => 'directory', 'absent' => 'absent'},
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }
}
