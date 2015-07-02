# = Define: user::vim
#
# This define sets up the .vim hierarchy in the home directory.
define user::vim (
  $user = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
  $vimrc_source = hiera("user::data::${title}::vim_source", undef),
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

  if ($vimrc_source) {
    file { "${home}/.vimrc":
      ensure => present,
      source => $vimrc_source,
    }
  }
}
