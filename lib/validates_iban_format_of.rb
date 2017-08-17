require 'validates_iban_format_of/version'
require 'iban-tools'

module ValidatesIbanFormatOf
  def self.load_i18n_locales
    require 'i18n'
    I18n.load_path += Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'locales', '*.yml')))
  end

  DEFAULT_MESSAGE_FOR_INVALID = 'is invalid'
  DEFAULT_MESSAGE_FOR_MISSING = 'is missing'
  ERROR_MESSAGE_INVALID_I18N_KEY = :invalid_iban
  ERROR_MESSAGE_MISSING_I18N_KEY = :missing_iban

  def self.default_message_for_invalid
    defined?(I18n) ? I18n.t(ERROR_MESSAGE_INVALID_I18N_KEY, scope: %i(activemodel errors messages), default: DEFAULT_MESSAGE_FOR_INVALID) : DEFAULT_MESSAGE_FOR_INVALID
  end

  def self.default_message_for_missing
    defined?(I18n) ? I18n.t(ERROR_MESSAGE_MISSING_I18N_KEY, scope: %i(activemodel errors messages), default: DEFAULT_MESSAGE_FOR_MISSING) : DEFAULT_MESSAGE_FOR_MISSING
  end

  # Validates whether the specified value is a valid IBAN. Returns nil if the value is valid, otherwise returns an array
  # containing one or more validation error messages.
  #
  # Configuration options:
  # * <tt>message_for_invalid</tt> - A custom error message for invalid (default is: 'is invalid')
  # * <tt>message_for_missing</tt> - A custom error message for missing (default is: 'is missing')
  # * <tt>optional</tt> - Flag to run valdiation ignoring blank/nil case
  # * <tt>generate_message</tt> Return the I18n key of the error message instead of the error message itself (default is false)
  def self.validate_iban_format(iban, options={})
      default_options = {
        message_for_invalid: options[:generate_message] ? ERROR_MESSAGE_INVALID_I18N_KEY : default_message_for_invalid,
        message_for_missing: options[:generate_message] ? ERROR_MESSAGE_MISSING_I18N_KEY : default_message_for_missing,
        generate_message: false,
        optional: false
      }

      opts = options.merge(default_options) {|key, old, new| old}  # merge the default options into the specified options, retaining all specified options

      if opts[:optional]
        return nil if iban.nil? || iban.empty?
      end

      return [ opts[:message_for_missing] ] if iban.nil? || iban.empty?

      return [ opts[:message_for_invalid] ] unless IBANTools::IBAN.valid?(iban)

      return nil
  end
end

require 'validates_iban_format_of/active_model' if defined?(::ActiveModel) && !(ActiveModel::VERSION::MAJOR < 2 || (2 == ActiveModel::VERSION::MAJOR && ActiveModel::VERSION::MINOR < 1))
require 'validates_iban_format_of/railtie' if defined?(::Rails)
