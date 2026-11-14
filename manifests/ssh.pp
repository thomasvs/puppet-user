# = Define: ssh
#
# This define sets up the .ssh hierarchy in the home directory,
# including .ssh/config and .ssh/config.d for drop-in snippets.
#
define user::ssh (
  $user = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
  $ensure = present,
) {

  $home = user_home($user)

  file { [
    "${home}/.ssh",
    "${home}/.ssh/config.d",
    ]
    :
    ensure => $ensure ? { 'present' => 'directory', 'absent' => 'absent'},
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  file { "${home}/.ssh/config":
    ensure  => $ensure,
    owner   => $user,
    group   => $group,
    mode    => '0600',
    source  => 'puppet:///modules/user/ssh/config',
    require => File["${home}/.ssh"],
  }
}
