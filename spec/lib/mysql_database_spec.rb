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
    @client.close
  end
  it 'shall drop the database if it exist' do
    @db_host = "127.0.0.1"
    @db_user = "root"
    @db_pass = "NCHNk85"
    @db_name = "test_database"
    @client = MysqlDatabase.new_client(@db_host, @db_user, @db_pass)
    @client.query("DROP DATABASE IF EXISTS #{@db_name}")
    @client.close
  end
end
