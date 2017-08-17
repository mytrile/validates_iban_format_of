require "active_model" if Gem.loaded_specs.keys.include?("activemodel")

RSpec::Matchers.define :have_errors_on_iban do
  match do |actual|
    expect(actual).not_to be_nil, "#{actual} should not be nil"
    expect(actual).not_to be_empty, "#{actual} should not be empty"
    expect(actual.size).to eq(@reasons.size), "#{actual} should have #{@reasons.size} elements"
    @reasons.each do |reason|
      reason = "#{"IBAN " if defined?(ActiveModel)}#{reason}"
      expect(actual).to include(reason), "#{actual} should contain #{reason}"
    end
  end
  chain :because do |reason|
    (@reasons ||= []) << reason
  end
  chain :and_because do |reason|
    (@reasons ||= []) << reason
  end
  match_when_negated do |actual|
    expect(actual).to (defined?(ActiveModel) ? be_empty : be_nil)
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    ValidatesIbanFormatOf.load_i18n_locales
    I18n.enforce_available_locales = false
  end
end
