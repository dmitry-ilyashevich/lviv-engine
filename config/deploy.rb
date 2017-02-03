lock '3.7.2'

set :application, 'lviv'
set :repo_url, 'git@github.com:dmitry-ilyashevich/lviv-engine.git'

set :deploy_to, '/home/application/lviv'
set :linked_files, %w{
  config/database.yml
  config/secrets.yml
  config/puma.rb
  config/environments/production.rb
}
set :linked_dirs, %w{bin log tmp/pids tmp/cache public/uploads}
set :keep_releases, 5
set :ssh_options, {
  user: 'application',
  forward_agent: true,
  auth_methods: %w(publickey)
}
set :stages, %w(production staging)
set :default_stage, 'production'
set :log_level, :info

set :rbenv_type, :user
set :rbenv_ruby, '2.3.3'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :puma_threads, [4, 16]
set :puma_workers, 4
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
