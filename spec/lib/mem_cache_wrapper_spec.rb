require 'spec_helper'

describe MemCacheWrapper do
  it 'shall create a new MemCache object' do
    @mem_host = "127.0.0.1"
    @memcache = MemCacheWrapper.get_memcache(@mem_host)
    @memcache.instance_of?(MemCache).should eql true
  end
  it 'shall create a new memcache object and load data from database table' do
    @db_host = "127.0.0.1"
    @db_user = "root"
    @db_pass = "NCHNk85"
    @db_name = "test_database"
    @client = MysqlDatabase.new_client(@db_host, @db_user, @db_pass)
    @client.query("CREATE DATABASE IF NOT EXISTS #{@db_name}")
    @client.select_db(@db_name)
    @client.query("CREATE TABLE IF NOT EXISTS companies (identification_no varchar(30), name varchar(30))")
    @companies = CompanySearcher.search("ApoEx AB")
    @companies.each do |key, value|
      if value == "ApoEx AB"
        temp_value = value.gsub(" ", "_")
        @client.query("INSERT INTO companies VALUES('#{key}', '#{temp_value}')")
        break
      end
    end
    @mem_host = "127.0.0.1"
    @memcache = MemCacheWrapper.get_memcache(@mem_host)
    @memcache.get("556633-4149").should eql nil
    @memcache.get("ApoEx AB".gsub(" ", "_")).should eql nil
    @result = @client.query("SELECT * FROM companies")
    @result.each do |row|
      if row['name'] == 'ApoEx_AB'
        @memcache.set(row['identification_no'], row['name'], 1.hour)
        @memcache.set(row['name'], row['identification_no'], 1.hour)
        break
      end
    end
    @memcache.get("556633-4149").should eql 'ApoEx_AB'
    @memcache.get("ApoEx AB".gsub(" ", "_")).should eql '556633-4149'
    @memcache.delete '556633-4149'
    @memcache.delete 'ApoEx_AB'
    @client.query("DROP DATABASE IF EXISTS #{@db_name}")
    @client.close
  end
end
