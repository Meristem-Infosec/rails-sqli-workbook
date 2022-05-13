class SessionsController < ApplicationController
  def new
    # No action.  Just render the view.
  end
  
  def create
    dbid = params[:session][:dbid]
    # debugger
    ActiveRecord::Base.establish_connection(options)
    if session[:dbid] == params[:session][:dbid]
      redirect_to searches_index_path
    else 
      ActiveRecord::Base.establish_connection(options(dbid: dbid))
      ActiveRecord::Tasks::DatabaseTasks::create(options(dbid: dbid))
      ActiveRecord::Tasks::DatabaseTasks::migrate()
      ActiveRecord::Tasks::DatabaseTasks::load_seed()
      session[:dbid] = dbid
      redirect_to queries_path, notice: "Database with id \"#{dbid}\" established"
    end
  end

  def reset
    ActiveRecord::Tasks::DatabaseTasks::drop(options)
    ActiveRecord::Tasks::DatabaseTasks::create(options)
    ActiveRecord::Tasks::DatabaseTasks::migrate()
    ActiveRecord::Tasks::DatabaseTasks::load_seed()
    redirect_to queries_path, notice: "Database cleaned and reseeded"
  end

  def destroy
  end 

  private

  def dbid_ref
    session[:dbid]
  end

  def options(dbid: dbid_ref)
    {
      :adapter => "postgresql",
      :database => dbid,
      :host => "127.0.0.1",
      :username => "sqlinjector",
      :password => Rails.application.credentials.database.password
    }
  end
end