require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

file_path = Pathname.new(__FILE__).realpath
libdir = File.join(File.dirname(File.dirname(File.dirname(file_path))), "lib")
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'forge'

require 'rspec/expectations'
require 'aruba/cucumber'