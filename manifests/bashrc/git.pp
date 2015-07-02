# = Define: user::bashrc::git
#
# This define deploys a .bashrc.d snippet to support a git command prompt
#
define user::bashrc::git (
  $user  = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  $home = user_home($user)

  file { "${home}/.bashrc.d/git":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    source  => 'puppet:///modules/user/bashrc.d/git',
    require => User::Bashrc[$user],
  }
}
