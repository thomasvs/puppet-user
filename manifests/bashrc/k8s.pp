# = Define: user::bashrc::k8s
#
# This define deploys a .bashrc.d snippet to add k8s support
#
define user::bashrc::k8s (
  $user  = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  $home = user_home($user)

  file { "${home}/.bashrc.d/k8s":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    source  => 'puppet:///modules/user/bashrc.d/k8s',
    require => User::Bashrc[$user],
  }
}
