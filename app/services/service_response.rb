class ServiceResponse
  attr_reader :status, :content

  STATUSES = [:success, :failure]

  def initialize(status:, content: nil)
    unless STATUSES.include? status
      raise ArgumentError.new("ServiceResponse#initialize: unexpected status #{status.inspect}")
    end
    @status = status
    @content = content
  end

  def success?
    @status == :success
  end

  def failure?
    @status == :success
  end
end