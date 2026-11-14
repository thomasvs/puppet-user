# given a user name, return the home directory

require 'etc'

module Puppet::Parser::Functions
  newfunction(:user_home, :type => :rvalue) do |args|
    user = args[0]     # e.g. root

    debug "user_home(): called for user #{user}"

    raise Puppet::ParseError, ("user_home(): please pass a non-empty string as the first argument") unless (user and user.is_a?(String) and user.length > 0)

    # 1. Try targeted NSS lookup first (fast, 0.3ms, no facter dependency)
    home = nil
    begin
      home = Etc.getpwnam(user).dir
    rescue ArgumentError
      debug "user_home(): user #{user} not found via Etc.getpwnam"
    end

    # 2. If not found via NSS, check if a custom fact exists (safe under Puppet 8 strict=error)
    if home.nil? || home.empty?
      fact = 'home_' + user
      facts_hash = lookupvar('facts')
      if facts_hash.is_a?(Hash) && facts_hash.key?(fact)
        fact_val = facts_hash[fact]
        home = fact_val if fact_val && !fact_val.empty?
      elsif exist?(fact)
        fact_val = lookupvar(fact)
        home = fact_val if fact_val && fact_val != :undefined && !fact_val.empty?
      end
    end

    # 3. Fall back to sensible defaults (accounting for gLinux corporate paths)
    if home.nil? || home.empty? || home == :undefined
      debug "user_home(): could not resolve home for #{user}, falling back"
      case user
        when "root"
          home = '/root'
        else
          if File.directory?("/usr/local/google/home/#{user}")
            home = "/usr/local/google/home/#{user}"
          else
            home = '/home/' + user
          end
      end
    end

    # return home
    debug "user_home(): returning #{home}"
    home
  end

end
