require 'spec_helper'

describe MysqlDatabase do
  it 'shall make sure the client can connect to the mysql server' do
    @db_host = "127.0.0.1"
    @db_user = "root"
    @db_pass = "NCHNk85"
    @db_name = "test_database"
    @client = MysqlDatabase.new_client(@db_host, @db_user, @db_pass)
    @client.instance_of?(Mysql2::Client).should eql true
    @client.close
  end
  it 'shall create a new database' do
    @db_host = "127.0.0.1"
    @db_user = "root"
    @db_pass = "NCHNk85"
    @db_name = "test_database"
    @client = MysqlDatabase.new_client(@db_host, @db_user, @db_pass)
    @client.query("CREATE DATABASE IF NOT EXISTS #{@db_name}")
    @result = @client.query("SHOW DATABASES")
    @database_exist = false
    @result.each do |row|
      if row['Database'] == @db_name
        @database_exist = true
        break
      end
    end
    @database_exist.should eql true
    @client.close
  end
  it 'shall create table if database exist' do
    @db_host = "127.0.0.1"
    @db_user = "root"
    @db_pass = "NCHNk85"
    @db_name = "test_database"
    @client = MysqlDatabase.new_client(@db_host, @db_user, @db_pass)
    @client.select_db(@db_name)
    @client.query("CREATE TABLE IF NOT EXISTS companies (identification_no varchar(30), name varchar(30))")
    @result = @client.query("SHOW TABLES")
    @result.each do |row|
      row['Tables_in_' + @db_name].should eql 'companies'
      break
    end
  end
  it 'shall drop the database if it exist' do
    @db_host = "127.0.0.1"
    @db_user = "root"
    @db_pass = "NCHNk85"
    @db_name = "test_database"
    @client = MysqlDatabase.new_client(@db_host, @db_user, @db_pass)
    @client.query("DROP DATABASE IF EXISTS #{@db_name}")
    @result = @client.query("SHOW DATABASES")
    @database_exist = false
    @result.each do |row|
      if row['Database'] == @db_name
        @database_exist = true
        break
      end
    end
    @database_exist.should eql false
    @client.close
  end
end
