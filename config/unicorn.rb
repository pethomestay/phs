# # App location.
# deploy_dir = '/home/deploy/apps/staging/pethomestay'
# shared_dir = "#{deploy_dir}/shared"
# working_directory "#{deploy_dir}/current"
#
# # Unicorn options.
# preload_app true
# timeout 30
# worker_processes 2
#
# # Socket location.
# listen "#{shared_dir}/sockets/unicorn.sock", backlog: 64
#
# # Logging.
# stderr_path "#{shared_dir}/log/unicorn.stderr.log"
# stdout_path "#{shared_dir}/log/unicorn.stdout.log"
#
# # Master PID location.
# pid "#{shared_dir}/pids/unicorn.pid"

if ENV['RAILS_ENV'] == 'production'
  worker_processes 2
else
  worker_processes 1
end
timeout 30         # restarts workers that hang for 30 seconds
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['DB_POOL'] || 2
    ActiveRecord::Base.establish_connection(config)
  end
end
