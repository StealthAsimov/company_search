require 'spec_helper'

describe MysqlDatabase do
  it 'shall make sure the client can connect to the mysql server and create database, create table and add and get values to the table and drop the database at the end' do
    @db_host = "127.0.0.1"
    @db_user = "root"
    @db_pass = "NCHNk85"
    @db_name = "test_database"
    @client = MysqlDatabase.new_client(@db_host, @db_user, @db_pass)
    @client.instance_of?(Mysql2::Client).should eql true
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
    @client.select_db(@db_name)
    @client.query("CREATE TABLE IF NOT EXISTS companies (identification_no varchar(30), name varchar(30))")
    @result = @client.query("SHOW TABLES")
    @result.each do |row|
      row['Tables_in_' + @db_name].should eql 'companies'
    end
    @companies = CompanySearcher.search("ApoEx AB")
    @companies.each do |key, value|
      if value == "ApoEx AB"
        @client.query("INSERT INTO companies VALUES('#{key}', '#{value}')")
        break
      end
    end
    @result = @client.query("SELECT name FROM companies")
    @result.each do |row|
      row['name'].should eql "ApoEx AB"
      break
    end
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
