if ENV['RAILS_ENV'] == 'production'
  worker_processes 2
else
  worker_processes 1
end
timeout 30         # restarts workers that hang for 30 seconds
preload_app true
