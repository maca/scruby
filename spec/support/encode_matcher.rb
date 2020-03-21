RSpec::Matchers.define :encode_as do |expected|
  match do |actual|
    actual.encode == expected
  end

  failure_message do |actual|
    <<~MSG

    expected: #{diff(expected, actual.encode)}

    got:      #{diff(actual.encode, expected)}
    MSG
  end

  def diff(str_a, str_b)
    str_a.each_char.zip(str_b.each_char).map do |a, b|
      str = a.inspect.gsub(/^"|"$/, "")
      a == b ? str : "\e[33m#{str}\e[31m"
    end.join
  end
end
