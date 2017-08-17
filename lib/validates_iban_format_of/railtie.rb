module ValidatesIbanFormatOf
  class Railtie < Rails::Railtie
    initializer 'validates_iban_format_of.load_i18n_locales' do |app|
      ValidatesIbanFormatOf::load_i18n_locales
    end
  end
end
