class WordChainer
    attr_reader :dictionary
    def initialize(dictionary_file_name)
        @file = File.open(dictionary_file_name)
        @dictionary = File.readlines(@file)
        @current_word = nil
        @all_seen_word = nil
    end

    def adjacent_words(word)
        adjacent_words = []
        @dictionary.each do |adjacent_word|
            other_word = adjacent_word.chomp
            adjacent_words << other_word if adjacent?(word, other_word)
        end
        adjacent_words
    end

    def adjacent?(word, other_word)
        if word.length == other_word.length
            count = 0
            (0...word.length).each { |idx| count += 1 if word[idx] == other_word[idx] }
            return true if count == word.length - 1
        end
        false
    end

    def run(source, target)
        @current_words = [source]
        @all_seen_words = { source => nil }

        while @current_words.length > 0
            new_current_words = explore_current_words(@current_words, @all_seen_words)
            @current_words = new_current_words

            break if @all_seen_words.include?(target)
        end

        p self.build_path(target)
    end

    def explore_current_words(current_words, all_seen_words)
        new_current_words = []
        current_words.each do |current_word|
            adjacent_words = adjacent_words(current_word)
            adjacent_words.each do |adjacent_word|
                if !all_seen_words.include?(adjacent_word)
                    new_current_words << adjacent_word
                    all_seen_words[adjacent_word] = current_word
                end
            end
        end
        new_current_words.each {|word| p "#{word}, #{all_seen_words[word]}"}
        new_current_words
    end

    def build_path(target)
        return [] if target == nil
        path = [target]
        prev = @all_seen_words[target]
        path + build_path(prev)
    end
end



