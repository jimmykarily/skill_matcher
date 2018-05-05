# Skill Matcher

This is a Ruby application which can be used to create pair for pair programming during an event.

## Use case

A group of friends participate in a programming competition and want to work in pairs. This can happen as a fun way to practice on pair programming and also work with people you neven met before and exchange knowledge.

The problem is that maybe of the people might meet for the first time and don't have the same background. They don't speak the same programming languages, at least not all of them.

This application can be fed the programming languages each person speaks and returns the maximum possible pairs. It is possible that some of the people can't be paired (see the rspec examples).

## How to use

- In your programs:

  ```
  irb -I. -rskill_matcher
  > m = SkillMatcher.new
  > m.add_skills_to_human(["Dimitris", ["Ruby"])
  > m.add_skills_to_human(...)
  > ...
  > m.pairs
  ```

- As a standalone script:
  Create a yaml file in the root directory of this project named `skills.yaml`:

  ```yaml
  Dimitris:
    - Ruby
    - Golang
  Marios:
    - Ruby
    - .NET
  ```

  Run:

  ```
  chmod +x skill_matcher.rb
  ./skill_matcher.rb
  ```

  The resulting pairs will be printed on STDOUT.
