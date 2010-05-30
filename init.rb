require 'ohm'
require File.expand_path(File.join(File.dirname(__FILE__), "lib", "ohm.rb"))

Dir.glob("lib/*").each do |lib_file|
  require File.expand_path(File.join(File.dirname(__FILE__), lib_file))
end
