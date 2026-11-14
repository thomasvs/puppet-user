# = Define: user::bashrc::git
#
# This define deploys a .bashrc.d snippet to support a git command prompt
# Kept for compatibility; invoking user::bashrc_d directly is recommended
#
define user::bashrc::git (
  $user  = lookup("user::data::${title}::user", { 'default_value' => $title }),
  $group = lookup("user::data::${title}::group", { 'default_value' => $title }),
) {

  user::bashrc_d { "${user}-git":
    user    => $user,
    group   => $group,
    snippet => 'git',
  }
}
