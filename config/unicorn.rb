# App location.
deploy_dir = '/home/deploy/apps/staging/pethomestay'
shared_dir = "#{deploy_dir}/shared"
working_directory "#{deploy_dir}/current"

# Unicorn options.
preload_app true
timeout 30
worker_processes 2

# Socket location.
listen "#{shared_dir}/sockets/unicorn.sock", backlog: 64

# Logging.
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Master PID location.
pid "#{shared_dir}/pids/unicorn.pid"
