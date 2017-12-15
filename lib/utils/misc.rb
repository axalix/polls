class Utils::Misc
  class << self
    def format_time(time)
      time.utc.iso8601(3)
    end

    def random_float(a, b)
      (b - a) * rand + a
    end

    # Example: {men: 0.3, women: 0.6, both: 0.1}
    def random_by_weight(attrs)
      intervals = []
      left_border = 0
      attrs.each do |k, weight|
        intervals << {
          k: k,
          i: [left_border, left_border + weight]
        }
        left_border = left_border + weight + 0.0000001
      end
      rnd = rand
      r = intervals.first[:k]
      intervals.each do |int|
        if rnd.between?(int[:i][0], int[:i][1])
          r = int[:k]
          break
        end
      end
      r
    end

    def random_by_range(range)
      random_float(range[0], range[1])
    end

    def sleep_by_range(range)
      sleep(random_by_range range)
    end

    def miles_to_meters(miles)
      1.60934 * miles
    end
  end
end
