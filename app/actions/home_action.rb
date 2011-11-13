class HomeAction < Cramp::Action
  @@template = ERB.new(File.read(Tears::Application.root('app/views/index.html.erb')))
  
  def start
    render "Hello World!"
    finish
  end
end
