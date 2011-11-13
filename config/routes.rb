
Rack::Builder.new do
 
  file_server = Rack::File.new(File.join(File.dirname(__FILE__), 'public'))


 routes = HttpRouter.new do
   add('/').to(HomeAction)
   add('/misery').to(MiseryAction)
 end
  run Rack::Cascade.new([file_server, routes])
  
  
  
end


