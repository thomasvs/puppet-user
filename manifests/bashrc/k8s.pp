# = Define: user::bashrc::k8s
#
# This define deploys a .bashrc.d snippet to add k8s support
# Kept for compatibility; invoking user::bashrc_d directly is recommended
#
define user::bashrc::k8s (
  $user  = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
) {

  user::bashrc_d { "${user}-k8s":
    user    => $user,
    group   => $group,
    snippet => 'k8s',
  }
}
