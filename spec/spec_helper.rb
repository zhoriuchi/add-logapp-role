require 'serverspec'
require 'net/ssh'
require 'tempfile'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

# start added by yoshi for circleCI
if ENV['CIRCLECI']
   `echo "StrictHostKeyChecking no" >> ~/.ssh/config`
   `echo "UserKnownHostsFile=/dev/null" >> ~/.ssh/config`
   options = Net::SSH::Config.for(host, ["~/.ssh/config"])
   options[:user] = "root"
else
# end added by yoshi for circleCI
`vagrant up #{host}`

config = Tempfile.new('', Dir.tmpdir)
config.write(`vagrant ssh-config #{host}`)
config.close

options = Net::SSH::Config.for(host, [config.path])

options[:user] ||= Etc.getlogin

end

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
