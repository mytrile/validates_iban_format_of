require "#{File.expand_path(File.dirname(__FILE__))}/spec_helper"
if defined?(ActiveModel)
  require "validates_iban_format_of/rspec_matcher"

  class Person
    attr_accessor :iban
    include ::ActiveModel::Validations
    validates_iban_format_of :iban
  end

  describe Person do
    it { should validate_iban_format_of(:iban) }
  end
end
