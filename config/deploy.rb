# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

set :application, 'petitions.eu'
set :repo_url, 'git@github.com:petities/petitions.eu.git'

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# set :branch, fetch(:stage)
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/projects/petitions.eu/#{fetch(:stage)}/"

# Defaults to [:web]
set :assets_roles, [:web, :app]

set :keep_assets, 2

set :ssh_options, forward_agent: true

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push()

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system'
)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Configure sidekiq
set :sidekiq_config, 'config/sidekiq.yml'

set :maintenance_template_path, 'app/views/maintenance/application.html.erb'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
