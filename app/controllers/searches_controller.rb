class SearchesController < ApplicationController
  def index 
    if params[:query_action].present?
      begin
      query_type =  Queries.detect {|q| q[:action] == params[:query_action].to_sym }
      params[query_type[:input][:name]] = params[:sql_string]

      @result = eval(query_type[:query])

      rescue => e
            @error = e
      end
    end
    @previous_params = params
    @queries ||= Queries.collect do |q|
      [q[:name], q[:action]]
    end
  end
end
