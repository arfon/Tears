class HomeAction < Cramp::Action
  def start
    render "Hello World!"
    finish
  end
end
