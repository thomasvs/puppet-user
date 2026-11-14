# = Define: user::vim
#
# This define sets up the .vim hierarchy in the home directory.
define user::vim (
  $user = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
  $vimrc_source = lookup("user::data::${title}::vim_source", { 'default_value' => undef }),
) {

  $home = user_home($user)

  file { [
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
