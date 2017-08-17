require 'validates_iban_format_of'

RSpec::Matchers.define :validate_iban_format_of do |attribute|
  match do
    actual_class_name = subject.is_a?(Class) ? subject : subject.class
    actual = actual_class_name.new
    actual.send(:"#{attribute}=", 'GB82 WEST 1234')
    expect(actual).to be_invalid
    @expected_message ||= ValidatesIbanFormatOf.default_message_for_invalid
    actual.errors[attribute.to_sym].include?(@expected_message)
  end
  chain :with_message do |message|
    @expected_message = message
  end
end
