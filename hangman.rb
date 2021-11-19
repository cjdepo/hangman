

require 'json'

class Game
    attr_accessor :word, :guesses, :display, :active_game, :id, :remaining_misses

    @@gamecount = 0

    def load_saved_game
        Dir.glob('saved_games/*').each{ |game| puts game }
        puts "\n\nEnter game number to load: "
        game_number = gets.chomp.to_s
        game_file = File.open("saved_games/game_#{game_number}", "r")
        string = game_file.read
        data = JSON.load(string)
        @id = game_number
        @word = data["word"]
        @guesses = data["guesses"]
        @display = data["display"]
        @remaining_misses = data["remaining_misses"]
        @active_game = data["active_game"]
    end

    def load_new_game
        @@gamecount += 1
        @id = @@gamecount
        @word = self.generate_word.map(&:downcase)
        @guesses = []
        @remaining_misses = 7
        @display = Array.new(@word.length, "_")
        @active_game = true
    end

    def start_game
        while self.active_game == true
            puts "\n\nIf you would like to save the game, type 'save'.\nIf you would like to load a saved game, type 'load'.\nIf you would like to quit, type 'quit'\nOtherwise guess a letter!:   "  
            letter = gets.chomp.downcase
            if letter == 'save'
                self.save_game
            elsif letter == 'load'

            elsif letter == 'quit'
                self.active_game=(false)
            else
                self.guess(letter)
            end
        end
        self.start_menu
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
            @guesses.push(letter)
            correct = @word.map.with_index{ |l, i| l == letter ? letter : @display[i] }
            @display = correct
            puts "\n\n"
            p @display
            if !@word.include?(letter)
                @remaining_misses -= 1
            end
            check_game_status
        else
            puts "\n\nAlready guessed this letter."
        end
    end

    def check_game_status
        if @remaining_misses <= 0
            puts "\n\nGame over.\n\n"
            self.save_game
            @active_game = false
        elsif @display == @word
            puts "\n\nYou win!\n\n"
            self.save_game
            @active_game = false
        end
    end

    def save_game
        json_string = JSON.dump({
            :word => @word,
            :guesses => @guesses,
            :display => @display,
            :active_game => @active_game,
            :remaining_misses => @remaining_misses,
        })
        save_dir = Dir.mkdir("saved_games") unless File.exists?("saved_games")
        save_file = File.new("saved_games/game_#{self.id}", "w")
        save_file.puts(json_string)
        save_file.close
    end

end

def start_menu
    puts "\n\nWelcome to Hangman!\n"
    puts "If you would like to start a new game, type 'new'.\n"
    puts "If you would like to load a saved game, type 'load'.\n"
    puts "What's it gonna be?:  "
    while option = gets.chomp.downcase
        case option
        when 'new'
            current_game = Game.new
            current_game.load_new_game
            current_game.start_game
            break
        when 'load'
            current_game = Game.new
            current_game.load_saved_game
            current_game.start_game
            break
        else
            puts "\n\nPlease select either 'new' or 'load':   "
        end
    end
end

start_menu


