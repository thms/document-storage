# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "document-storage.example.com"
set :repo_url, "git@github.com:example.com/document-storage.git"

# RVM Settings
set :rvm_ruby_version, 'ruby-2.2.5'
set :default_env, rvm_bin_path: '~/.rvm/bin'
SSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"

# Default value for :pty is false
set :pty, true

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

namespace :deploy do
  after :publishing, :restart

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo service #{fetch(:thin)} restart #{fetch(:thin_init_file)}"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo service #{fetch(:thin)} stop #{fetch(:thin_init_file)}"
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo service #{fetch(:thin)} start #{fetch(:thin_init_file)}"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
