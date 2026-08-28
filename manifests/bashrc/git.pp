# = Define: user::bashrc::git
#
# This define deploys a .bashrc.d snippet to support a git command prompt
# Kept for compatibility; invoking user::bashrc_d directly is recommended
#
define user::bashrc::git (
  $user  = hiera("user::data::${title}::user", $title),
  $group = hiera("user::data::${title}::group", $title),
) {

  user::bashrc_d { "${user}-git":
    user    => $user,
    group   => $group,
    snippet => 'git',
  }
}
