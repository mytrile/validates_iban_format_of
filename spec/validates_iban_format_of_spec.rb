require "#{File.expand_path(File.dirname(__FILE__))}/spec_helper"
require "validates_iban_format_of"

describe ValidatesIbanFormatOf do
  subject do |example|
    if defined?(ActiveModel)
      user = Class.new do
        def initialize(iban)
          @iban = iban.freeze
        end
        attr_reader :iban
        include ActiveModel::Validations
        validates_iban_format_of :iban, example.example_group_instance.options
      end
      example.example_group_instance.class::User = user
      user.new(example.example_group_instance.iban).tap(&:valid?).errors.full_messages
    else
      ValidatesIbanFormatOf::validate_iban_format(iban.freeze, options)
    end
  end
  let(:options) { {} }
  let(:iban) { |example| example.example_group.description }

  shared_examples_for :all_specs do
    # Taken directly from iban-tools gem
    # Samples from http://www.tbg5-finance.org/?ibandocs.shtml/
    [
      "AD1200012030200359100100",
      "AE070331234567890123456",
      "AL47212110090000000235698741",
      "AT611904300234573201",
      "AZ21NABZ00000000137010001944",
      "BA391290079401028494",
      "BE68539007547034",
      "BG80BNBG96611020345678",
      "BH67BMAG00001299123456",
      "BR9700360305000010009795493P1",
      "CH9300762011623852957",
      "CY17002001280000001200527600",
      "CZ6508000000192000145399",
      "DE89370400440532013000",
      "DK5000400440116243",
      "DO28BAGR00000001212453611324",
      "EE382200221020145685",
      "ES9121000418450200051332",
      "FI2112345600000785",
      "FO7630004440960235",
      "FR1420041010050500013M02606",
      "GB29NWBK60161331926819",
      "GE29NB0000000101904917",
      "GI75NWBK000000007099453",
      "GL4330003330229543",
      "GR1601101250000000012300695",
      "HR1210010051863000160",
      "HU42117730161111101800000000",
      "IE29AIBK93115212345678",
      "IL620108000000099999999",
      "IS140159260076545510730339",
      "IT60X0542811101000000123456",
      "JO94CBJO0010000000000131000302",
      "KW81CBKU0000000000001234560101",
      "KZ86125KZT5004100100",
      "LB62099900000001001901229114",
      "LI21088100002324013AA",
      "LT121000011101001000",
      "LU280019400644750000",
      "LV80BANK0000435195001",
      "MC1112739000700011111000h79",
      "MD24AG000225100013104168",
      "ME25505000012345678951",
      "MK07300000000042425",
      "MR1300020001010000123456753",
      "MT84MALT011000012345MTLCAST001S",
      "MU17BOMM0101101030300200000MUR",
      "NL91ABNA0417164300",
      "NO9386011117947",
      "PL27114020040000300201355387",
      "PK36SCBL0000001123456702",
      "PT50000201231234567890154",
      "QA58DOHB00001234567890ABCDEFG",
      "RO49AAAA1B31007593840000",
      "RS35260005601001611379",
      "SA0380000000608010167519",
      "SE3550000000054910000003",
      "SI56191000000123438",
      "SK3112000000198742637541",
      "SM86U0322509800000000270100",
      "TN5914207207100707129648",
      "TR330006100519786457841326",
      "UA173052990006762462622943782"
    ].each do |address|
      describe address do
        it { should_not have_errors_on_iban }
      end
    end

    [
      "random string",
      12345698765432,
      "gb99 %BC",
      "NOW9386011117947",
      "GB69 7654 1234 5698 7654 32",
      "GB99 WEST 1234 5698 7654 32",
      "RO7999991B31007593840000"
    ].each do |address|
      describe address do
        it { should have_errors_on_iban.because("is invalid") }
      end
    end

    describe "" do
      it { should have_errors_on_iban.because("is missing") }
    end

    describe nil do
      it { should have_errors_on_iban.because("is missing") }
    end

    describe "with optional config" do
      let(:options) { { optional: true } }
      describe "" do
        it { should_not have_errors_on_iban }
      end

      describe nil do
        it { should_not have_errors_on_iban }
      end
    end

    describe "custom error messages" do
      describe "invalid example" do
        let(:options) { { message_for_invalid: "just because it's invalid" } }
        it { should have_errors_on_iban.because("just because it's invalid") }
      end
      describe "" do
        let(:options) { { message_for_missing: "is blank" } }
        it { should have_errors_on_iban.because("is blank") }
      end
      describe nil do
        let(:options) { { message_for_missing: "is blank" } }
        it { should have_errors_on_iban.because("is blank") }
      end
    end

    describe "i18n" do
      before(:each) do
        allow(I18n.config).to receive(:locale).and_return(locale)
      end

      unless defined?(ActiveModel)
        describe "missing locale" do
          let(:locale) { :ir }
          describe "invalid exmaple" do
            it { should have_errors_on_iban.because("is invalid") }
          end
        end
      end
    end
    unless defined?(ActiveModel)
      describe "without i18n" do
        before(:each) { hide_const("I18n") }
        describe "invalid@exmaple." do
          it { should have_errors_on_iban.because("is invalid") }
        end
      end
    end
  end

  it_should_behave_like :all_specs

  if defined?(ActiveModel)
    describe "shorthand ActiveModel validation" do
      subject do |example|
        user = Class.new do
          def initialize(iban)
            @iban = iban.freeze
          end
          attr_reader :iban
          include ActiveModel::Validations
          validates :iban, iban_format: example.example_group_instance.options
        end
        example.example_group_instance.class::User = user
        user.new(example.example_group_instance.iban).tap(&:valid?).errors.full_messages
      end

      it_should_behave_like :all_specs
    end
  end
end
