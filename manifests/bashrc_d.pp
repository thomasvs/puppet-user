# = Define: user::bashrc_d
#
# This define deploys snippets to the user's .bashrc.d dir
#
# parameters can be parsed from the title as ${user}:${snippet}
#
# == Parameters
#
# ** user: the user to deploy for; will get indirected through hiera
# ** group: the group to deploy for; if undefined, looked up from hiera
# ** snippet: the name of the snippet to deploy
# ** snippet_source_dir: if not defined, deploys the snippet with the same name
#    from this module (default: "puppet:///modules/user/bashrc.d")
# ** snippet_source: full custom source path (overrides snippet_source_dir)
#
define user::bashrc_d (
  $user               = undef,
  $group              = undef,
  $snippet            = undef,
  $snippet_source_dir = "puppet:///modules/user/bashrc.d",
  $snippet_source     = undef,
) {

  validate_string($user)

  $real_user = $user ? {
    ''      => regsubst($title, '^([^:]+):.*$', '\1'),
    undef   => regsubst($title, '^([^:]+):.*$', '\1'),
    default => hiera("user::data::${user}:user", $user),
  }

  validate_string($snippet)

  $real_snippet = $snippet ? {
    ''       => regsubst($title, '^[^:]+:(.*)$', '\1'),
    undef    => regsubst($title, '^[^:]+:(.*)$', '\1'),
    default  => $snippet
  }

  $home = user_home($real_user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = hiera("user::data::${real_user}::group", $real_user)
  }

  if ($snippet_source) {
    $real_snippet_source = $snippet_source
  } else {
    $real_snippet_source = "${snippet_source_dir}/${real_snippet}"
  }

  file { "${home}/.bashrc.d/${real_snippet}":
    ensure  => present,
    owner   => $real_user,
    group   => $real_group,
    mode    => '0640',
    source  => $real_snippet_source,
    require => User::Bashrc[$real_user],
  }
}
