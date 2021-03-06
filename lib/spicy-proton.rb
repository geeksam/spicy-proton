require 'forwardable'
require 'disk-corpus'
require 'memory-corpus'

module Spicy
  class Proton
    extend Forwardable

    def initialize
      @corpus = Memory::Corpus.new
    end

    def self.adjective(*args)
      Disk::Corpus.use do |c|
        c.adjective(*args)
      end
    end

    def self.noun(*args)
      Disk::Corpus.use do |c|
        c.noun(*args)
      end
    end

    def self.pair(separator = '-')
      Disk::Corpus.use do |c|
        "#{c.adjective}#{separator}#{c.noun}"
      end
    end

    def self.format(format)
      Disk::Corpus.use do |c|
        self.format_with(c, format)
      end
    end

    def format(format)
      self.class.format_with(self, format)
    end

    def_delegators :@corpus, :adjective, :noun, :pair, :adjectives, :nouns

    private

    def self.format_with(source, format)
      format.gsub(/%([an%])/) do
        case $1
        when 'a'
          source.adjective
        when 'n'
          source.noun
        when '%'
          '%'
        end
      end
    end
  end
end
