def get_options
  result = {}
  data = {}

  ARGV.each do |elem|
    key, val = elem.split '='
    data[key.to_sym] = val
  end

  result[:size] = data[:size] ? data[:size].to_i : 1000000
  result[:filters] = []

  %w[age width height price].each do |key|
    equal = key.to_sym
    min = ('min_' + key).to_sym
    max = ('max_' + key).to_sym

    # Если генерировать анонимки и запускать при проверке элемента только их,
    # то будет быстрее, чем 12 проверок для каждого элемента
    # return false if <filter_val> && <filter_val> <operator> <value>
    # P.S. выяснилось -эмпирически- методом тыка
    if data[equal]
      data[equal] = key === 'price' ? data[equal].to_f : data[equal].to_i
      result[:filters] << proc{ |val| val[equal] == data[equal] }
    end

    if data[min]
      data[min] = key === 'price' ? data[min].to_f : data[min].to_i
      result[:filters] << proc{ |val| val[equal] > data[min] }
    end

    if data[max]
      data[max] = key === 'price' ? data[max].to_f : data[max].to_i
      result[:filters] << proc{ |val| val[equal] < data[max] }
    end
  end

  result
end


def generate_data(count)
  result = []

  count.times do
    result << {
        age: rand(101),
        width: rand(201),
        height: rand(201),
        price: (rand * 100_000_000).to_i.to_f / 100
    }
  end

  result
end


def check_item(item, filters)
  i = 0
  while filters[i]
    return false unless filters[i].call(item)
    i += 1
  end

  true
end