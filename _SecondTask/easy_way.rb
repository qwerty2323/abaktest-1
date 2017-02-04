require 'benchmark'
require_relative '_help'

Benchmark.bm do |x|

  options = get_options
  data = generate_data options[:size]
  result = nil

  x.report do
    result = data.find_all do |elem|
      check_item elem, options[:filters]
    end
  end

  puts "Number of found objects: #{result.size}"

end
