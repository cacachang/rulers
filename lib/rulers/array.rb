class Array
  def blank?
    empty? || all?(&:empty?)
  end

  def present?
    !empty? || !all?(&:nil?)
  end
end