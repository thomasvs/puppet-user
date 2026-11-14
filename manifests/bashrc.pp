# = Define: user::bashrc
#
# This define manages .bashrc and loads from .bashrc.d
#
define user::bashrc (
  $user = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
  $bashrc_source = lookup("user::data::${title}::bashrc_source", { 'default_value' => undef }),
) {
  if ($bashrc_source) {
    $real_bashrc_source = $bashrc_source
  } else {
    $real_bashrc_source = lookup("user::data::${user}::bashrc_source", { 'default_value' => 'puppet:///modules/user/bashrc/dotbashrc' })
  }

  $home = user_home($user)

  if ! defined(File["${home}/.bashrc"]) {
    file { "${home}/.bashrc":
      ensure => present,
      owner  => $user,
      group  => $group,
      mode   => '0640',
      source => $real_bashrc_source,
    }
  }

  if ! defined(File["${home}/.bashrc.d"]) {
    file { "${home}/.bashrc.d":
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0750',
    }
  }
}
