Dir[File.expand_path(File.join(File.dirname(__FILE__), 'lib/*.rb'))].sort.each { |lib|
  require lib
}
