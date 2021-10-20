# frozen_string_literal: true

module GameNumbers
  ##
  # Numbers
  class Numbers
    attr_accessor :numbers

    def initialize
      reset
    end

    def reset
      @numbers = []
      (1..19).each do |i|
        next if (i % 10).zero?

        if i > 10
          @numbers << i / 10
          i %= 10
        end
        @numbers << i
      end
    end

    def win?
      @numbers.all?(&:zero?)
    end

    def add
      remain = @numbers.reject(&:zero?)
      @numbers += remain
    end

    def select(a, b)
      a, b = [a, b].minmax
      if a.negative? || b >= @numbers.length || a == b
        raise ArgumentError, "Arguments must be between 0-#{@numbers.length - 1}"
      end

      return unless @numbers[a] == @numbers[b] || @numbers[a] + @numbers[b] == 10

      v = b - a
      if (v % 9).zero?
        (v / 9 - 1).times do |i|
          return unless @numbers[a + (i + 1) * 9].zero?
        end
      else
        return unless @numbers[(a + 1)..(b - 1)].all?(&:zero?)
      end

      @numbers[a] = @numbers[b] = 0
    end
  end
end
