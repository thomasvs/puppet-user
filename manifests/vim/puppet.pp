# = Define: user::vim::puppet
#
# This define deploys puppet stuff for vim.
#
define user::vim::puppet (
  $user = $title,
  $group = $title,
) {

  $home = user_home($user)

  file { "${home}/.vim/ftplugin/puppet.vim":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    source  => 'puppet:///modules/user/vim/ftplugin/puppet.vim',
    require => File["${home}/.vim/ftplugin"],
  }

}
