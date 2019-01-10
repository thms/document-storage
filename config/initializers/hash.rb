Hash.class_eval do
  def encode_timestamps
    self.each_with_object({}) { |(k,v),g|
      g[k] = (Hash === v) ?  v.encode_timestamps : (Array === v && Hash === v.first) ? v.map {|item| item.encode_timestamps} : (v.is_a?(ActiveSupport::TimeWithZone) || v.is_a?(Time)) ? v.iso8601 : v }
  end
end  