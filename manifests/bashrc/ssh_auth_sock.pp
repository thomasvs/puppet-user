# = Define: user::bashrc::ssh_auth_sock
#
# This define deploys a .bashrc.d snippet to maintain ~/.ssh/ssh_auth_sock
# Kept for compatibility; invoking user::bashrc_d directly is recommended
#
define user::bashrc::ssh_auth_sock (
  $user  = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  user::bashrc_d { "${user}-ssh_auth_sock":
    user    => $user,
    group   => $group,
    snippet => 'ssh_auth_sock',
  }
}
