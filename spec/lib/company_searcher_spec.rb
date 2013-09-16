require 'spec_helper'

describe CompanySearcher do
  def valid_attributes 
    {:identification_no => "556633-4149", :name => "ApoEx AB"}
  end
  it 'shall parse the web page correctly' do
    @companies = CompanySearcher.search("ApoEx AB")
    @companies[valid_attributes[:identification_no]].should eql valid_attributes[:name]
  end
end
