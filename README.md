puppet-user
===========

A puppet module to deploy common user-specific functionality, for both root and normal users

lookup of defaults
==================

For each resource, defaults can be specified in hieradata for:
 - group
 - bashrc_source
 - vimrc_source

To do so, add hieradata based on the resource title's name (typically the id):

user::data::thomasvs::group: "users"

This sets users as the default group to use for thomasvs (for example, on a
shared system where users don't get their own group)
