# frozen_string_literal: true

describe Ecertic::Client, ".otps" do
  subject { described_class.new(apikey: "apikey", secret: "secret").otps }

  describe "#status" do
    let(:token) { "XYZ" }

    before do
      stub_request(:post, %r{/status})
        .to_return(read_http_fixture("otps/status_sent.http"))
    end

    it "builds the correct request" do
      subject.status(token)

      expect(WebMock).to have_requested(:post, "https://api.otpsecure.net/status")
        .with(body: { token: token }.to_json)
        .with(headers: { "Accept" => "application/json" })
    end

    it "gets the status of an operation" do
      status = subject.status(token)
      expect(status).to be_a(Ecertic::Resource::OTP::Status)
      expect(status.status).to eq("ENVIADO")
      expect(status.sent?).to be(true)
    end

    context "when using the sandbox" do
      it "returns a sanbox status" do
        stub_request(:post, %r{/status})
          .to_return(read_http_fixture("otps/status_sandbox.http"))
        status = subject.status(token)
        expect(status.status).to eq("SANDBOX")
        expect(status.sandbox?).to be(true)
      end
    end
  end
end
