# = Define: user::bin::git_wtf
#
# This define deploys the git_wtf script.
#
# == Parameters
#
define user::bin::git_wtf (
  $user = $title,
  $group = $title,
) {

  $home = user_home($user)

  file { "${home}/bin/git-wtf":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    source  => 'puppet:///modules/user/bin/git-wtf',
    require => User::Bin[$user],
  }
  
}
