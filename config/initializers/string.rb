class String
  def safe_encoding
    Iconv.new('UTF-8//IGNORE', 'UTF-8').iconv( self + ' ')[0..-2]
  end
end
