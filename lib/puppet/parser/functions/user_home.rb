# given a user name, return the home directory

module Puppet::Parser::Functions
  newfunction(:user_home, :type => :rvalue) do |args|
    user = args[0]     # e.g. root

    debug "user_home(): called for user #{user}"

    raise Puppet::ParseError, ("user_home(): please pass a non-empty string as the first argument") unless (user and user.is_a?(String) and user.length > 0)

    fact = 'home_' + user
    home = lookupvar(fact)

    if home == nil || home == :undefined
      debug "user_home(): could not find fact #{fact}, falling back"
      # fall back to sensible defaults
      case user
        when "root"
          home = '/root'
        else
          home = '/home/' + user
      end
    end

    # return home
    debug "user_home(): returning #{home}"
    home
  end

end
