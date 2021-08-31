require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.setup

require_relative 'lib/db'

task :console do
  require 'irb'
  require 'irb/completion'

  ARGV.clear
  IRB.start
end

namespace :db do
  task :migrate do
    require_relative 'migrations/migrations'
    Migrations.migrate(:up)
  end

  task :rollback do
    require_relative 'migrations/migrations'
    Migrations.migrate(:down)
  end
end

task :c => :console
