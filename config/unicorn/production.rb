# set path to application
base_dir = File.expand_path('../../../..', __FILE__)
app_dir = "#{base_dir}/current"
shared_dir = "#{base_dir}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 4
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/tmp/sockets/unicorn.sock", backlog: 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/tmp/pids/unicorn.pid"

# Fix for Bundler::GemfileNotFound at some deploys
# See http://stackoverflow.com/a/8436516/5691309
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_dir}/Gemfile"
end
