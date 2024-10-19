class SgRomanizer
  FORMAT = /\A(M{0,3})(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})\z/

  CHAR_INT_MAP = {
    'I' => 1,
    'V' => 5,
    'X' => 10,
    'L' => 50,
    'C' => 100,
    'D' => 500,
    'M' => 1000
  }.freeze

  def romanize(arabic)
    raise ArgumentError, "Expected integer, got #{arabic}" unless arabic.is_a?(Integer)
    raise ArgumentError, "Expected 0 to 3999, got #{arabic}" unless (0..3999).cover?(arabic)

    roman, _ = [1000, 100, 10, 1].inject(['', arabic]) do |(s, i), divisor|
      [
        s + CHAR_INT_MAP.invert[divisor] * (i / divisor),
        i % divisor
      ]
    end

    roman.gsub(/C{9}/, 'CM')
         .gsub(/C{5}/, 'D')
         .gsub(/C{4}/, 'CD')
         .gsub(/X{9}/, 'XC')
         .gsub(/X{5}/, 'L')
         .gsub(/X{4}/, 'XL')
         .gsub(/I{9}/, 'IX')
         .gsub(/I{5}/, 'V')
         .gsub(/I{4}/, 'IV')
  end

  def deromanize(roman)
    raise ArgumentError, "Invalid format (given #{roman})" unless roman.match?(FORMAT)

    roman.gsub('IV', 'IIII')
         .gsub('IX', 'VIIII')
         .gsub('XL', 'XXXX')
         .gsub('XC', 'LXXXX')
         .gsub('CD', 'CCCC')
         .gsub('CM', 'DCCCC')
         .chars
         .map { |char| CHAR_INT_MAP[char] }.sum
  end
end
