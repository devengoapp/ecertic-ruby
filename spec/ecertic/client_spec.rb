# frozen_string_literal: true

RSpec.describe Ecertic::Client do
  describe "initialization" do
    it "accepts :base_url option" do
      subject = described_class.new(base_url: "https://sandbox.otpsecure.com")
      expect(subject.base_url).to eq("https://sandbox.otpsecure.com")
    end

    it "access :apikey and :secret option" do
      subject = described_class.new(apikey: "apikey", secret: "secret")
      expect(subject.apikey).to eq("apikey")
      expect(subject.secret).to eq("secret")
    end

    it "normalizes :base_url trailing slash" do
      subject = described_class.new(base_url: "https://sandbox.otpsecure.com/")
      expect(subject.base_url).to eq("https://sandbox.otpsecure.com")
    end

    it "defaults :base_url to production API" do
      subject = described_class.new
      expect(subject.base_url).to eq("https://api.otpsecure.net")
    end
  end

  describe "#get" do
    it "delegates to #request" do
      expect(subject).to receive(:execute).with(:get, "path", nil, foo: "bar").and_return(:returned)
      expect(subject.get("path", foo: "bar")).to eq(:returned)
    end
  end

  describe "#post" do
    it "delegates to #request" do
      expect(subject).to receive(:execute).with(:post, "path", { foo: "bar" }, {}).and_return(:returned)
      expect(subject.post("path", foo: "bar")).to eq(:returned)
    end
  end

  describe "#execute" do
    subject { described_class.new(apikey: "apikey", secret: "secret") }

    it "raises Ecertic::InvalidRequestError for unknown endpoints" do
      stub_request(:post, %r{/foo}).to_return(read_http_fixture("unknown_endpoint.http"))

      expect {
        subject.execute(:post, "/foo", {})
      }.to raise_error(Ecertic::InvalidRequestError)
    end
  end
end
