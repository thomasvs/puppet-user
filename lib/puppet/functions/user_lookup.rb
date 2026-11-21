# Puppet 4+/5+/8+ native function delegating directly to lookup() without 3.x type coercion
Puppet::Functions.create_function(:user_lookup) do
  dispatch :lookup_key do
    param 'String', :key
  end

  dispatch :lookup_with_default_or_opts do
    param 'String', :key
    param 'Any', :arg
  end

  def lookup_key(key)
    call_function('lookup', key)
  end

  def lookup_with_default_or_opts(key, arg)
    if arg.is_a?(Hash)
      call_function('lookup', key, arg)
    else
      call_function('lookup', key, { 'default_value' => arg })
    end
  end
end
