class ApplicationService 
  def self.call(**args)
    Rails.logger.info "#{self.class.name}: Started"
    new(**args).call
  end

  private

  LOG_LEVELS = [:debug, :info, :warn, :error, :fatal, :unknown]

  def log(level, message)
    level = :unknown unless LOG_LEVELS.include? level
    Rails.logger.send(level, "#{self.class.name}: #{message}")
  end

  def success(content = nil)
    log(:info, "Succeeded")
    ServiceResponse.new(status: :success, content: content)
  end

  def failure(content = nil)
    log(:info, "Failed")
    ServiceResponse.new(status: :failure, content: content)
  end
end
