module MysqlDatabase
  require 'mysql2'
  def self.new_client(host, username, password)
    return Mysql2::Client.new(:host => host, :username => username, :password => password)
  end
end
