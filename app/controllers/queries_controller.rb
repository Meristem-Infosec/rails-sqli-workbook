class QueriesController < ApplicationController
  def index 
    payload = query_params
    if payload[:query_action].present?
      begin
      query_type = Queries.detect {|q| q[:action] == payload[:query_action].to_sym }
      payload[query_type[:input][:name]] = payload[:sql_string]
      
      @results = eval(query_type[:query])
      eval(@results.to_sql) if @results.is_a? ActiveRecord::Relation
      rescue Exception => e
            @error = e
            @results = nil
      end
    end
    if query_type
      @sql_string = query_type[:sql].gsub("'REPLACE'", payload[:sql_string])
      @previous_params = payload
    end
    @queries = Queries
    @query_collection ||= Queries.collect{|q| [q[:name], q[:action]] }
  end

  private

  def query_params
    params.permit(:query_action, :sql_string, :commit)
  end
end
