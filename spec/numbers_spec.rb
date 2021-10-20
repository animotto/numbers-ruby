# frozen_string_literal: true

require 'game_numbers/numbers'
require 'securerandom'
require 'json'

include GameNumbers

RSpec.describe Numbers do
  it 'Creates instance of numbers' do
    example = JSON.parse(File.read('spec/numbers/init.json'))
    numbers = Numbers.new
    expect(numbers.numbers).to eq(example)
  end

  it 'Resets numbers' do
    example = JSON.parse(File.read('spec/numbers/init.json'))
    100.times do
      numbers = Numbers.new
      SecureRandom.rand(1..999) do
        numbers.numbers << SecureRandom.rand(10)
      end
      numbers.reset
      expect(numbers.numbers).to eq(example)
    end
  end

  it 'Adds the remaining numbers to the end' do
    100.times do
      numbers = Numbers.new
      SecureRandom.rand(1..999).times do
        numbers.numbers << SecureRandom.rand(10)
      end
      remain = numbers.numbers.reject(&:zero?)
      numbers_expect = numbers.numbers + remain
      numbers.add
      expect(numbers.numbers).to eq(numbers_expect)
    end
  end

  it 'Checks if the player has won' do
    examples = JSON.parse(File.read('spec/numbers/win.json'))
    examples.each do |example|
      numbers = Numbers.new
      numbers.numbers = example['numbers']
      expect(numbers.win?).to eq(example['win'])
    end
  end

  it 'Selects two numbers and strikes out them' do
    numbers = Numbers.new
    expect { numbers.select(-5, 4) }.to raise_error(ArgumentError)
    expect { numbers.select(15, -16) }.to raise_error(ArgumentError)
    expect { numbers.select(5, 42) }.to raise_error(ArgumentError)
    expect { numbers.select(51, 5) }.to raise_error(ArgumentError)
    expect { numbers.select(8, 8) }.to raise_error(ArgumentError)

    examples = JSON.parse(File.read('spec/numbers/select.json'))
    examples.each do |example|
      numbers = Numbers.new
      numbers.numbers = example[1]
      numbers.select(example[0][0], example[0][1])
      expect(numbers.numbers).to eq(example[2])
    end
  end
end
