# frozen_string_literal: true

ENV["APP_ENV"] ||= ENV["RACK_ENV"] || "development"
environment(ENV["APP_ENV"])

if ENV["APP_ENV"] == "development"
  # better_errors and binding_of_caller works better with only only the master process and one thread
  threads(1, 1)
else
  if ENV["PUMA_WORKERS"]
    workers(ENV["PUMA_WORKERS"].to_i)
  end
  if ENV["PUMA_MAX_THREADS"]
    threads(0, ENV["PUMA_MAX_THREADS"].to_i)
  end
end

preload_app!

app_path = File.expand_path("../..", __FILE__)
pidfile("#{app_path}/tmp/puma.pid")
bind("unix://#{app_path}/tmp/puma.sock")

if ENV["LOG_ENABLED"]
  stdout_redirect("#{app_path}/log/puma-stdout.log", "#{app_path}/log/puma-stderr.log", true)
end
