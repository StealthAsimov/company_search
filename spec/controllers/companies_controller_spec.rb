require 'spec_helper'

describe CompaniesController do

  describe "GET 'org_number'" do
    it "returns http success" do
      get 'org_number'
      response.should be_success
    end
  end

end
