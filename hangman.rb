



class Game
    attr_reader :word, :guesses, :display
    
    def initialize
        @word = generate_word
        @guesses = []
        @remaining_guesses = 7
        @display = Array.new(@word.length, "_")
    end

    def generate_word
        wordlist = File.open("5desk.txt", "r")
        words = wordlist.read
        words_arr = words.split("\r\n")
        correct_length_words = words_arr.select{ |word| word.length >= 5 && word.length <= 12 }
        correct_length_words[Random.rand(correct_length_words.length)].split("")
    end

    def guess(letter)
        if !guesses.include?(letter)
            correct = @word.map.with_index{ |l, i| l == letter ? letter : @display[i] }
            @display = correct
            p @display
        else
            puts "Already guessed this letter."
        end
    end

end

game = Game.new
p game.word
p game.guesses
game.guess("t")
game.guess("s")
game.guess("n")
game.guess("e")
game.guess("i")