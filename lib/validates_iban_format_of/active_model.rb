require 'validates_iban_format_of'
require 'active_model'

module ActiveModel
  module Validations
    class IbanFormatValidator < EachValidator
      def validate_each(record, attribute, value)
        (ValidatesIbanFormatOf::validate_iban_format(value, options.merge(generate_message: true)) || []).each do |error|
          record.errors.add(attribute, error)
        end
      end
    end

    module HelperMethods
      def validates_iban_format_of(*attr_names)
        validates_with IbanFormatValidator, _merge_attributes(attr_names)
      end
    end
  end
end
