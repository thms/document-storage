set :deploy_to, '/var/www/document-storage-staging.example.com'
server 'document-storage-staging.example.com', user: 'deployer', roles: %w(web app db)
set :thin_init_file, 'document-storage-staging.example.com'
set :branch, 'master'
set :rvm_ruby_version, 'ruby-2.2.5@global' 
set :thin, 'thin_2.2.5'