module InferencesHelper
  def assets_equal?(expected, obtained)
    return false if expected.nil? || obtained.nil?

    [[expected, obtained], 
      [obtained, expected]].all? do |expected_assets, obtained_assets|
      expected_assets.all? do |expected_asset|
        obtained_assets.any? do |obtained_asset|
          next if expected_asset.name != obtained_asset.name
          obtained_asset.facts.reload.all? do |obtained_asset_fact|
            expected_asset.facts.reload.any? do |expected_asset_fact|
              val = (obtained_asset_fact.predicate == expected_asset_fact.predicate)
              unless obtained_asset_fact.object_asset.nil?
                val && (obtained_asset_fact.object_asset.name == expected_asset_fact.object_asset.name)
              else
                val && (obtained_asset_fact.object == expected_asset_fact.object)
              end
            end
          end
        end
      end
    end
  end

  def assets_to_n3(assets)
    "\n"+assets.map do |asset|
      asset.facts.map do |fact|
        ":#{asset.name}\t:#{fact.predicate}\t#{fact.object_asset.nil? ? fact.object: ':'+fact.object_asset.name} ."
      end
    end.flatten.join("\n")+"\n"
  end

  def assets_are_equal(expected_assets, obtained_assets)
    expect(assets_equal?(expected_assets, obtained_assets)).to eq(true), "expected #{assets_to_n3(expected_assets)}, obtained #{assets_to_n3(obtained_assets)} shoud be equal"
  end

  def assets_are_different(expected_assets, obtained_assets)
    expect(assets_equal?(expected_assets, obtained_assets)).to eq(false), "expected #{assets_to_n3(expected_assets)}, obtained #{assets_to_n3(obtained_assets)} should be different"
  end

  def build_step(rule, input_facts, options = {})
    step_type = FactoryGirl.create(:step_type, :n3_definition => rule)

    input_assets = SupportN3::parse_facts(input_facts, {}, false)
    fail if input_assets.nil?
    asset_group = FactoryGirl.create(:asset_group, {:assets => input_assets})

    FactoryGirl.create(:step, {
      :step_type => step_type,
      :asset_group => asset_group
    }.merge(options))
  end

  def check_inference(rule, input_facts, output_facts)
    fail if input_facts.nil? || output_facts.nil? || rule.nil?

    step = build_step(rule, input_facts)

    expected_output_assets = SupportN3::parse_facts(output_facts, {}, false)
    fail if expected_output_assets.nil?

    asset_group = step.asset_group
    asset_group.assets.reload
    obtained_output_assets = asset_group.assets

    obtained_output_assets.each {|a| a.facts.reload}
    assets_are_equal(expected_output_assets, obtained_output_assets)
  end

end

include InferencesHelper