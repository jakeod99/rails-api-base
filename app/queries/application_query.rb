class ApplicationQuery
  def self.query(scope: nil, filters: {})
    Rails.logger.info "#{name}: Build query with filters ".cyan + filters.to_s.yellow unless filters.empty?
    if scope
      new(scope: scope).query(filters: filters)
    else
      new.query(filters: filters)
    end
  end

  def self.raw(scope: nil, filters: {}, columns: [])
    Rails.logger.info "#{name}: Pluck with filters ".cyan + filters.to_s.yellow unless filters.empty?
    if scope
      new(scope: scope).raw(filters: filters, columns: columns)
    else
      new.raw(filters: filters, columns: columns)
    end
  end

  def initialize(scope: nil)
    raise ArgumentError, "Scope must be ActiveRecord::Relation" unless is_relation? scope
    @scope = scope
  end

  def query(filters: {})
    raise NotImplementedError
  end

  def raw(filters: {}, columns: [])
    raise ArgumentError, "Columns array cannot be empty" if columns.empty?
    query(filters).pluck(*columns).map { |row| columns.zip(row).to_h }
  end

  private

  def is_relation?(scope)
    scope.class.to_s.split("::").last == "ActiveRecord__Relation"
  end
end
