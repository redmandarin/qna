# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'qna'
set :repo_url, 'git@github.com:redmandarin/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', '.env', 'config/private_pub_thin.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', '.env', 'config/private_pub_thin.yml', 'tmp/pids/thin.pid')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'db/sphinx', 'binlog')

namespace :deploy do
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml --daemonize start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml restart'
        end
      end
    end
  end
end

namespace :sphinx do
  task :index do
    on roles(:app) do
      within current_path do
        execute :bundle, 'exec rake ts:index RAILS_ENV=production'
        execute :bundle, 'exec rake ts:restart RAILS_ENV=production'
      end
    end
  end
end

# after 'deploy:publishing', 'sphinx:index'
after 'deploy:publishing', 'private_pub:stop'
after 'deploy:publishing', 'private_pub:start'