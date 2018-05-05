#!/usr/bin/env ruby

class SkillMatcher
  attr_accessor :humans

  def initialize
    @humans = Hash.new { |h, k| h[k] = [] }
  end

  def add_skills_to_human(name, skills=[])
    humans[name] = humans[name].to_a | skills
  end

  # Returns the possible pairs for each human. The candidates for a human are
  # humans with at least one common skill.
  def pair_candidates
    result = Hash.new { |h, k| h[k] = [] }
    humans.each do |name, skills|
      humans.each do |candidate_name, candidate_skills|
        if name != candidate_name && (skills & candidate_skills).any?
          result[name] << candidate_name
        end
      end
    end

    result
  end

  # Extracts the next pair from humans.
  # It find the human with the least candidates and pairs with the candidate
  # which in turn, has the least candidates himself.
  # The pair is removed from humans.
  def pop_pair
    if selected = pair_candidates.min { |a,b| a[1].length <=> b[1].length }
      first_in_pair = selected[0]
    else
      return nil
    end

    candidates = pair_candidates[first_in_pair]
    # From the pair candidates of first_in_pair find the one with the least candidates.
    candidates_candidates = pair_candidates.select do |k,v|
      candidates.include?(k)
    end
    second_in_pair =
      candidates_candidates.min { |a,b| a[1].length <=> b[1].length }[0]

    # Remove the pair from humans
    humans.delete_if { |k,v| [first_in_pair, second_in_pair].include?(k) }

    [first_in_pair, second_in_pair].sort
  end

  # Returns an Array of Arrays with 2 elements each (array or pairs).
  # Each pair has 2 humans from the humans Hash which have at least
  # one common skill.
  def pairs
    result = {}
    original_humans = humans.clone # pop_pair modifies the humans Hash
    while pair = pop_pair
      language = (original_humans[pair[0]] & original_humans[pair[1]])[0]
      result[pair] = language
    end

    # Add the rest of the humans without pairs or languages
    humans.each do |name, languages|
      result.merge!({name => languages[0]})
    end

    result
  end
end

if __FILE__ == $0
    matcher = SkillMatcher.new
    matcher.add_skills_to_human("Dimitris")
    matcher.add_skills_to_human("Marios",["Dotnet"])
    matcher.add_skills_to_human("Dimitris", ["Ruby"])

    puts matcher.humans
end
