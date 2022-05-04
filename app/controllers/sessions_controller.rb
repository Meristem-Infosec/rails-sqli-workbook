class SessionsController < ApplicationController
  def new
    # No action.  Just render the view.
  end
  
  def create
    dbid = params[:session][:dbid]
    # debugger
    options = {
      :adapter => "postgresql", :database => dbid, :host => "127.0.0.1", :username => "sqlinjector", :password => Rails.application.credentials.database.password
    }
    ActiveRecord::Base.establish_connection(options)
    if session[:dbid] == params[:session][:dbid]
      redirect_to searches_index_path
    else 
      ActiveRecord::Base.establish_connection(options)
      # ActiveRecord::Tasks::DatabaseTasks::drop(options)
      ActiveRecord::Tasks::DatabaseTasks::create(options)
      ActiveRecord::Tasks::DatabaseTasks::migrate()
      ActiveRecord::Tasks::DatabaseTasks::load_seed()
      session[:dbid] = dbid
      redirect_to searches_index_path
    end
  end
  
  def destroy
  end 
end