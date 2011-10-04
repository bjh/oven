
class TrimFilter < Oven::Filter
  def call(text)
    if not text.is_a?(String)
      raise ArgumentError.new, "TrimFilter.call expecting a String"
    end
    
    text.strip()
  end
end