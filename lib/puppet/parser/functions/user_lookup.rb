# Cross-version Hiera/lookup wrapper compatible with Puppet 3.x (hiera) and Puppet 4+/8.x (lookup)
module Puppet::Parser::Functions
  newfunction(:user_lookup, :type => :rvalue, :doc => <<-EOS
Looks up a key in Hiera using Puppet 4+/8.x lookup() when available,
or Puppet 3.x hiera()/hiera_hash()/hiera_array() on legacy masters.

Supports:
  user_lookup(key)
  user_lookup(key, default_value)
  user_lookup(key, { 'default_value' => ..., 'merge' => ... })
EOS
  ) do |args|
    if args.length < 1 || args.length > 2
      raise Puppet::ParseError, "user_lookup(): wrong number of arguments (#{args.length}; must be 1 or 2)"
    end

    key = args[0]

    if defined?(Puppet::Pops::Lookup)
      if args.length == 2 && !args[1].is_a?(Hash)
        call_function('lookup', [key, { 'default_value' => args[1] }])
      else
        call_function('lookup', args)
      end
    else
      opts = args[1]
      has_default = false
      default_val = nil
      merge = nil

      if args.length == 2
        if opts.is_a?(Hash)
          if opts.key?('default_value')
            has_default = true
            default_val = opts['default_value']
          end
          merge = opts['merge']
        else
          has_default = true
          default_val = opts
        end
      end

      if has_default && default_val.nil?
        default_val = :undef
      end

      case merge
      when 'hash', 'deep'
        Puppet::Parser::Functions.function(:hiera_hash)
        has_default ? function_hiera_hash([key, default_val]) : function_hiera_hash([key])
      when 'unique'
        Puppet::Parser::Functions.function(:hiera_array)
        has_default ? function_hiera_array([key, default_val]) : function_hiera_array([key])
      else
        Puppet::Parser::Functions.function(:hiera)
        has_default ? function_hiera([key, default_val]) : function_hiera([key])
      end
    end
  end
end
