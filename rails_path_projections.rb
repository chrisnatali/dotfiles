require 'json'
require 'optparse'

# Generate a projections.json file for vim-rails that customizes path for
# rails projects that don't use standard rails directory structure
#
# Will only work on a standard linux/unix based OS with default tools installed

options = {working_dir: Dir.pwd}

OptionParser.new do |opts|
  opts.banner = "Generate projections json for vim-rails"
  opts.on("-w", "--working-dir [WORKING_DIR]", "Directory to generate ruby path dirs for") do |dir|
    options[:working_dir] = dir
  end
  opts.on("-?", "--help", "Print help") do
    puts opts
    exit
  end
end.parse!

# simplest to just call out to find/sed/etc to get ruby file paths, their dirs and uniqify 'em
dirs = `find #{options[:working_dir]} -name '*.rb' -type f | sed 's|/[^/]*$||' | sort | uniq`.split(/\n/)

puts JSON.pretty_generate({"*": {"path": dirs}})
