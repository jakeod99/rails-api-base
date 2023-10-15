RSpec.describe ApplicationService do
  subject { ApplicationService.new }

  describe "#log" do
    let(:message) { "I should be logged!" }
    let(:legit_log_levels) { [:debug, :info, :warn, :error, :fatal, :unknown] }

    it "logs the provided message at the expected level" do
      legit_log_levels.each do |level|
        expected_message = "#{subject.class.name}: ".cyan + message
        expect(Rails.logger).to receive(level).with(expected_message)
        subject.send(:log, level, message)
      end
    end
  end

  describe "#success" do
    let(:response_content) { "content" }

    it "logs a success message and returns a successful ServiceResponse object" do
      expect(subject).to receive(:log).with(:info, "Succeeded".green)
      response = subject.send(:success, response_content)
      expect(response.class).to eq(ServiceResponse)
      expect(response.success?).to be true
      expect(response.content).to eq(response_content)
    end
  end

  describe "#failure" do
    let(:response_content) { "content" }

    it "logs a failure message and returns a failed ServiceResponse object" do
      expect(subject).to receive(:log).with(:info, "Failed".red)
      response = subject.send(:failure, response_content)
      expect(response.class).to eq(ServiceResponse)
      expect(response.failure?).to be true
      expect(response.content).to eq(response_content)
    end
  end
end
