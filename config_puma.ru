require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.enable_reloading
loader.setup

run FayeApp
