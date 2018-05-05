describe SkillMatcher, '#add_skills_to_human' do
  context "when the human did not exist before" do
    let(:skill_matcher) do
      SkillMatcher.new
    end

    it "adds the human with the new skills" do
      expect(skill_matcher.humans).to eq({})
      skill_matcher.add_skills_to_human("Dimitris", ["Ruby"])
      expect(skill_matcher.humans).to eq({"Dimitris" => ["Ruby"]})
    end
  end
end

describe SkillMatcher, '#humans' do
  let (:skill_matcher){ SkillMatcher.new }

  it "returns the saved humans" do
    skill_matcher.add_skills_to_human("Dimitris", ["Ruby"])
    skill_matcher.add_skills_to_human("Marios", ["Golang"])

    expect(skill_matcher.humans).to eq(
      {"Dimitris" => ["Ruby"], "Marios" => ["Golang"]})
  end
end

describe SkillMatcher, '#pairs' do
  let (:skill_matcher){ SkillMatcher.new }

  context "when no pairs can be found" do
    before do
      skill_matcher.add_skills_to_human("Dimitris", ["Ruby"])
      skill_matcher.add_skills_to_human("Marios", ["Golang"])
    end

    it "returns no pairs" do
      expect(skill_matcher.pairs).to eq(
        {"Dimitris" => "Ruby", "Marios" => "Golang"})
    end
  end

  context "when some pairs can be found" do
    before do
      skill_matcher.add_skills_to_human("Dimitris", ["Ruby", "Golang"])
      skill_matcher.add_skills_to_human("Marios", ["Ruby", "Javascript"])
      skill_matcher.add_skills_to_human("Christos", ["Golang"])
      skill_matcher.add_skills_to_human("Evelina", ["Javascript"])
      skill_matcher.add_skills_to_human("Xaroula", ["Haskell"])
    end

    it "returns the maximum number of possible pairs" do
      expect(skill_matcher.pairs).to eq(
        ["Christos","Dimitris"] => "Golang",
        ["Evelina","Marios"] => "Javascript",
        "Xaroula" => "Haskell"
      )
    end
  end
end

describe SkillMatcher, '#pair_candidates' do
  let (:skill_matcher){ SkillMatcher.new }
  before do
    skill_matcher.add_skills_to_human("Dimitris", ["Ruby", "Golang"])
    skill_matcher.add_skills_to_human("Marios", ["Ruby", "Javascript"])
    skill_matcher.add_skills_to_human("Christos", ["Golang"])
    skill_matcher.add_skills_to_human("Evelina", ["Javascript"])
    skill_matcher.add_skills_to_human("Xaroula", ["Haskell"])
  end

  it "returns the candidates for each human" do
    expect(skill_matcher.pair_candidates).to eq(
      { "Dimitris" => ["Marios", "Christos"],
        "Marios" => ["Dimitris", "Evelina"],
        "Christos" => ["Dimitris"],
        "Evelina" => ["Marios"] })
  end
end

describe SkillMatcher, '#pop_pair' do
  let (:skill_matcher){ SkillMatcher.new }

  context "when pairs can be returned" do
    before do
      [
        ["Dimitris", ["Cobol", "Basic", "Fortan"]],
        ["Marios",   ["Ruby", "Javascript", "C++", ".NET"]],
        ["Christos", ["Golang", "Cobol", "Javascript"]],
        ["Evelina",  ["Javascript", ".NET"]],
        ["Xaroula",  ["Haskell", "Cobol"]],
        ["Patric",   [".NET"]]
      ].each { |params| skill_matcher.add_skills_to_human(*params) }
    end

    it "returns the next pair using the hardest to match humans" do
      expect(skill_matcher.pop_pair).to eq(["Dimitris", "Xaroula"])
    end

    it "removes the pair from the humans Array" do
      skill_matcher.pop_pair
      expect(skill_matcher.humans).to eq({
        "Marios"=>["Ruby", "Javascript", "C++", ".NET"],
        "Christos"=>["Golang", "Cobol", "Javascript"],
        "Evelina"=>["Javascript", ".NET"],
        "Patric"=>[".NET"]
      })
    end
  end

  context "when no pairs can be returned" do
    before do
      [
        ["Dimitris", ["Ruby"]],
        ["Marios",   ["Ruby"]],
        ["Patric",   ["Cobol"]]
      ].each { |params| skill_matcher.add_skills_to_human(*params) }
    end

    it "returns nil" do
      skill_matcher.pop_pair
      expect(skill_matcher.pop_pair).to be(nil)
      expect(skill_matcher.humans).to eq({"Patric" => ["Cobol"]})
    end
  end
end
