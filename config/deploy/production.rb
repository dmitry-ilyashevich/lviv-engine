role :app, %w{application@139.162.186.95}
role :db,  %w{application@139.162.186.95}
role :web,  %w{application@139.162.186.95}
server '139.162.186.95', user: 'application', roles: %w{app db web}

set :rails_env, 'production'
set :branch, 'master'

set :puma_env, 'production'
