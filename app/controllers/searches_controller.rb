class SearchesController < ApplicationController
  def index 
  end
    
  def show
    query_type =  Queries.detect {|q| q[:action] == params[:query_action].to_sym }
    params[query_type[:input][:name]] = params[:sql_string]

    @result = eval(query_type[:query])

    @previous_params = params
     rescue => e
          @error = e
  end
end
