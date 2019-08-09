# frozen_string_literal: true

describe Ecertic::Client, ".tokens" do
  subject { described_class.new(apikey: "apikey", secret: "secret").tokens }

  describe "#retrieve" do
    let(:token) { "XYZ" }

    before do
      stub_request(:post, %r{/token})
        .to_return(read_http_fixture("tokens/valid_token.http"))
    end

    it "builds the correct request" do
      subject.retrieve(token)

      expect(WebMock).to have_requested(:post, "https://api.otpsecure.net/token")
        .with(body: { token: token }.to_json)
        .with(headers: { "Accept" => "application/json" })
    end

    it "returns the token" do
      instance = subject.retrieve(token)

      expect(instance).to be_a(Ecertic::Resource::Token::Instance)
      expect(instance.html).to match(/Al introducir/)
      expect(instance.checks).to be_kind_of(Array)
      expect(instance.uuid).to eq("BJ5CYudmS")
    end

    context "when the token does not exist" do
      it "raises Ecertic::InvalidRequestError" do
        stub_request(:post, %r{/token})
          .to_return(read_http_fixture("tokens/not_found_token.http"))

        expect { subject.retrieve(token) }.to raise_error(Ecertic::InvalidRequestError)
      end
    end
  end
  describe "#validate" do
    let(:token) { "XYZ" }
    let(:otp) { "000000" }

    before do
      stub_request(:post, %r{/validate})
        .to_return(read_http_fixture("tokens/validate_ok.http"))
    end

    it "builds the correct request" do
      subject.validate(token, otp)

      expect(WebMock).to have_requested(:post, "https://api.otpsecure.net/validate")
        .with(body: { token: token, otp: otp }.to_json)
        .with(headers: { "Accept" => "application/json" })
    end

    it "validates the token" do
      validation = subject.validate(token, otp)
      expect(validation).to be_a(Ecertic::Resource::Token::Validation)
      expect(validation.message).to eq("OTP CORRECTA")
      expect(validation.msg).to eq("OTP CORRECTA")
      expect(validation.status).to eq("OTP_OK")
      expect(validation.ok?).to be(true)
      expect(validation.error?).to be(false)
    end

    context "when the otp is wrong" do
      it "returns a no OK validation" do
        stub_request(:post, %r{/validate})
          .to_return(read_http_fixture("tokens/validate_wrong.http"))
        validation = subject.validate(token, otp)
        expect(validation.message).to eq("OTP INCORRECTA")
        expect(validation.msg).to eq("OTP INCORRECTA")
        expect(validation.status).to eq("OTP_NOK")
        expect(validation.ok?).to be(false)
        expect(validation.error?).to be(true)
      end
    end
  end
end
