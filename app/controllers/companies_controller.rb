class CompaniesController < ApplicationController
  require 'memcache'
  def org_number
    config   = Rails.configuration.database_configuration
    host     = config[Rails.env]["host"]
    database = config[Rails.env]["database"]
    username = config[Rails.env]["user"]
    password = config[Rails.env]["password"]
    client = MysqlDatabase.new_client(host, username, password)
    client.select_db(database)
    client.query("CREATE TABLE IF NOT EXISTS companies (identification_no varchar(30), name varchar(30))")
    company_org_number = nil
    memcache = MemCacheWrapper.get_memcache(host)
    company_org_number = memcache.get(params[:company].gsub(" ", "_"))
    if company_org_number == nil
      result = client.query("SELECT * FROM companies")
      result.each do |row|
        if row['name'] == params[:company].gsub(' ', '_')
          memcache.set(row['identification_no'], row['name'], 1.hour)
          memcache.set(row['name'], row['identification_no'], 1.hour)
          company_org_number = row['identification_no']
          break
        end
      end
      if company_org_number == nil
        companies = CompanySearcher.search(params[:company])
        companies.each do |key, value|
          if value == params[:company]
            temp_value = params[:company].gsub(' ', '_')
            memcache.set(key, temp_value, 1.hour)
            memcache.set(temp_value, key, 1.hour)
            company_org_number = memcache.get(temp_value)
            client.query("INSERT INTO companies VALUES('#{key}', '#{temp_value}')")
            break
          end
        end
      end
    end
    string = (company_org_number || "Couldn't find the company called #{params[:company]}")
    render text: string
  end
end
