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

task :c => :console
