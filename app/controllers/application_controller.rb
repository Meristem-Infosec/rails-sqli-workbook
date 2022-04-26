class ApplicationController < ActionController::Base
  before_action :query_methods
  
  def query_methods
    @queries ||= Queries.collect do |q|
      [q[:name], q[:action]]
    end
  end
end
