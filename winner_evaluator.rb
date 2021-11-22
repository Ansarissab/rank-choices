#!/usr/bin/env ruby

require 'csv'

class WinnerEvaluator
  BALLOT_FILE = './votes.csv'

  CANDIDATES = [
    'Three Body Problem',
    'Roadside Picnic',
    'The Left Hand of Darkness',
    'Dune',
    'Neuromancer',
    'Snow Crash',
    'Do Androids Dream of Electric Sheep?',
    'Solaris',
    'The Hitchhiker\'s Guide to the Galaxy'
  ]

  def initialize
    @ballot_data = []

    CSV.foreach(BALLOT_FILE, headers: true) do |row|
      @ballot_data << row
    end

    @round = 1
    @result = {}
    @sorted_result = {}
  end

  def self.call
    new.call
  end

  def call
    remove_not_first_choice_candidate = true

    loop do
      count_vote

      if remove_not_first_choice_candidate
        not_first_choice_candidates = CANDIDATES - @result.keys
        not_first_choice_candidates.each { |candidate| eliminate_candidate(candidate) }

        remove_not_first_choice_candidate = false
      end

      sort_result_by_vote

      candidate, vote_count = @sorted_result.first

      display_vote_distibution
      @round += 1

      if winner?(vote_count)
        puts "Winner Winner.. Got the Winner"
        puts "#{candidate} has Won with #{vote_count} votes (#{vote_percent(vote_count)}%)"

        return
      end

      candidate, vote_count = @sorted_result.last

      @result.delete(candidate)
      puts "#{candidate} has been eliminated with minimum votes" if @result.length > 1

      eliminate_candidate(candidate)

      if @result.length == 1
        puts "Both candidates has equal votes so no one is win"

        break
      end
    end
  end

  private

  def sort_result_by_vote
    @sorted_result = @result.sort_by { |k, v| -v }
  end

  def remaining_voters
    @result.map { |_, v| v }.sum
  end

  def vote_percent(value)
    ((value.to_f / remaining_voters) * 100).round(2)
  end

  def winner?(value)
    vote_percent(value) > 50
  end

  def eliminate_candidate(candidate)
    @ballot_data.map! do |vote|
      if candidate == vote['choice 1']
        vote['choice 1'] = nil
      end

      if candidate == vote['choice 2']
        vote['choice 2'] = nil
      end

      if candidate == vote['choice 3']
        vote['choice 3'] = nil
      end

      if candidate == vote['choice 4']
        vote['choice 4'] = nil
      end

      if candidate == vote['choice 5']
        vote['choice 5'] = nil
      end

      vote
    end
  end

  def count_vote
    @result = {}

    @ballot_data.each do |row|
      if row['choice 1']
        @result[row['choice 1']] ||= 0
        @result[row['choice 1']] += 1
      elsif row['choice 2']
        @result[row['choice 2']] ||= 0
        @result[row['choice 2']] += 1
      elsif row['choice 3']
        @result[row['choice 3']] ||= 0
        @result[row['choice 3']] += 1
      elsif row['choice 4']
        @result[row['choice 4']] ||= 0
        @result[row['choice 4']] += 1
      elsif row['choice 5']
        @result[row['choice 5']] ||= 0
        @result[row['choice 5']] += 1
      end
    end
  end

  def display_vote_distibution
    puts "\n\n=================== Round ##{@round} ================="

    puts "==== #{@result.length} candidates and #{remaining_voters} ballots.======"

    puts "Number of first votes per candidate:"

    @sorted_result.each do |candidate, vote_count|
      puts "#{candidate} has the number of votes with #{vote_count} votes (#{vote_percent(vote_count)}%)"
    end

    puts "\n"
  end

end


WinnerEvaluator.call
