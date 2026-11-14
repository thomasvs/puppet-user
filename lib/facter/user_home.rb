require 'etc'

# Avoid full NSS/passwd enumeration (Etc.passwd) which traverses 750,000+ cached
# LDAP accounts on corporate gLinux workstations and causes severe CPU/RAM exhaustion.
# Only register home facts for root and active/primary users.
users = ['root']
['SUDO_USER', 'USER', 'LOGNAME'].each do |var|
  u = ENV[var]
  users << u if u && !u.empty?
end
if File.exist?('/etc/owner') && !File.zero?('/etc/owner')
  users << File.read('/etc/owner').strip
end

users.uniq.each do |username|
  begin
    pw = Etc.getpwnam(username)
    Facter.add("home_#{username}") do
      setcode do
        pw.dir
      end
    end
  rescue ArgumentError
    # User not in passwd database
  end
end

