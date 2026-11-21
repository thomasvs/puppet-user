# = Define: user::ssh::config_d
#
# This define deploys snippets to the user's .ssh/config.d dir
#
# parameters can be parsed from the title as ${user}:${snippet}
#
# == Parameters
#
# ** user: the user to deploy for; will get indirected through hiera
# ** group: the group to deploy for; if undefined, looked up from hiera
# ** snippet: the name of the snippet to deploy
# ** snippet_source_dir: if not defined, deploys the snippet with the same name
#    from this module (default: "puppet:///modules/user/ssh/config.d")
# ** snippet_source: full custom source path (overrides snippet_source_dir)
# ** content: explicit content (overrides snippet_source and snippet_source_dir)
#
define user::ssh::config_d (
  $user               = undef,
  $group              = undef,
  $snippet            = undef,
  $snippet_source_dir = "puppet:///modules/user/ssh/config.d",
  $snippet_source     = undef,
  $content            = undef,
) {

  validate_string($user)

  $_title_parts = split($title, ':')
  $_title_user  = $_title_parts[0]
  $_title_rest  = join(delete_at($_title_parts, 0), ':')

  $real_user = $user ? {
    ''      => $_title_user,
    undef   => $_title_user,
    default => user_lookup("user::data::${user}:user", { 'default_value' => $user }),
  }

  validate_string($snippet)

  $real_snippet = $snippet ? {
    ''       => $_title_rest,
    undef    => $_title_rest,
    default  => $snippet
  }

  $home = user_home($real_user)

  if ($group) {
    $real_group = $group
  } else {
    $real_group = user_lookup("user::data::${real_user}::group", { 'default_value' => $real_user })
  }

  if ($content) {
    $real_snippet_source = undef
  } elsif ($snippet_source) {
    $real_snippet_source = $snippet_source
  } else {
    $real_snippet_source = "${snippet_source_dir}/${real_snippet}"
  }

  file { "${home}/.ssh/config.d/${real_snippet}":
    ensure  => present,
    owner   => $real_user,
    group   => $real_group,
    mode    => '0600',
    source  => $real_snippet_source,
    content => $content,
    require => User::Ssh[$real_user],
  }
}
