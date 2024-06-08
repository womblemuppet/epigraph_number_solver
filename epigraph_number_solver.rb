def main
  start_time = Time.now

  p1 = Puzzle.new([
    ["王", "ⴴ", "ⵀ", "山"],
    ["Ʉ", "Ә", "ⵀ","⨁"],
    ["ⵀ","⫛", "ⴴ", "ⴴ"]
  ])
  
  p2 = Puzzle.new([
    ["ⵀ", "又", "⨁"],
    ["⫛", "口", "⨁"],
    ["ⴴ", "山", "口", "山"]
  ])

  all_digit_sets = (0..9).to_a.permutation(10).to_a

  all_digit_sets.each do |digit_set|
    character_map = CharacterMap.new(digit_set)
    p1.try_solve(character_map: character_map)
    p2.try_solve(character_map: character_map)
  end

  solutions = p1.successful_character_value_maps & p2.successful_character_value_maps

  puts "Works for both puzzles:"
  solutions.each do |solution|
    puts solution.characters
    puts p1.pretty(character_map: solution)
    puts p2.pretty(character_map: solution)
    puts "\n"
  end

  end_time = Time.now
  elapsed_time = end_time.to_i - start_time.to_i
  puts "Elapsed time: #{elapsed_time}"
  puts "Done"
end

class Puzzle
  attr_reader :successful_character_value_maps
  def initialize(rows)
    @row_one, @row_two, @row_three = *rows
    @successful_character_value_maps = []
  end

  def try_solve(character_map:)
    row_one_number = character_map.make_number(@row_one)
    row_two_number = character_map.make_number(@row_two)
    row_three_number = character_map.make_number(@row_three)

    if row_one_number + row_two_number == row_three_number
      @successful_character_value_maps << character_map
      return true
    else
      return false
    end

  end

  def pretty(character_map:)
    <<~DISPLAY
      #{character_map.make_number(@row_one)}
    + #{character_map.make_number(@row_two)}
    ------
    = #{character_map.make_number(@row_three)}
    DISPLAY
  end

end

class CharacterMap
  attr_reader :characters
  def initialize(digit_set)
    @digit_set = digit_set

    symbol_list = [
      "⨁",
      "王",
      "ⵀ",
      "口",
      "又",
      "Ʉ",
      "⫛",
      "山",
      "Ә",
      "ⴴ"
    ]

    @characters = symbol_list.each_with_object({}).with_index do |(symbol, hash), i|
      hash[symbol] = digit_set[i]
    end

  end

  def make_number(row)
    row.map { |character| @characters[character] }.join.to_i
  end

  def eql?(other)
    @characters == other.characters
  end
  alias :== eql?

  def hash
    @characters.hash
  end

end


main() if __FILE__ == $PROGRAM_NAME
