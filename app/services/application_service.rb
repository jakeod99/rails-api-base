class ApplicationService
  def self.call(**)
    Rails.logger.info "#{name}: Started".cyan
    new(**).call
  end

  def call
    raise NotImplementedError
  end

  private

  LOG_LEVELS = [:debug, :info, :warn, :error, :fatal, :unknown]

  def log(level, message)
    level = :unknown unless LOG_LEVELS.include? level
    Rails.logger.send(level, "#{self.class.name}: ".cyan + message)
  end

  def success(content = nil)
    log(:info, "Succeeded".green)
    ServiceResponse.new(status: :success, content: content)
  end

  def failure(content = nil)
    log(:info, 'Failed'.red)
    ServiceResponse.new(status: :failure, content: content)
  end
end
