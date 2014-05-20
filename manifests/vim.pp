# = Define: vim
#
# This define sets up the .vim hierarchy in the home directory.
define user::vim (
  $user = $title,
  $group = $title,
) {

  $home = user_home($user)

  file { [
    "${home}/.vim",
    "${home}/.vim/ftplugin",
    ]
    :
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }
}
