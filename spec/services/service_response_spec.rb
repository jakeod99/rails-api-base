RSpec.describe ServiceResponse do
  let(:status) { :invalid_status }
  let(:content) { "content" }

  subject { ServiceResponse.new(status: status, content: content) }

  it "fails to initialize with an invalid status value" do
    expect { subject }.to raise_error(ArgumentError)
  end

  describe "#success?" do
    context "with a successful ServiceResponse" do
      let(:status) { :success }
      it("responds true") { expect(subject.success?).to be true }
    end

    context "with a failed ServiceResponse" do
      let(:status) { :failure }
      it("responds false") { expect(subject.success?).to be false }
    end
  end

  describe "#failure?" do
    context "with a successful ServiceResponse" do
      let(:status) { :success }
      it("responds false") { expect(subject.failure?).to be false }
    end

    context "with a failed ServiceResponse" do
      let(:status) { :failure }
      it("responds true") { expect(subject.failure?).to be true }
    end
  end
end
