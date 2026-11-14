# = Define: user::bin::git_wtf
#
# This define deploys the git_wtf script.
# Kept for compatibility; invoking user::bin::deploy directly is recommended
#
# == Parameters
#
define user::bin::git_wtf (
  $user  = lookup("user::data::${title}::user", { 'default_value' => $title }),
) {
  user::bin::deploy { "${user}-git-wtf":
    user   => $user,
    binary => 'git-wtf'
  }
}
