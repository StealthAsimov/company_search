module CompanySearcher
  require 'open-uri'
  require 'uri'
  require 'nokogiri'
  def self.search(string, url = "http://www.allabolag.se?what=#{URI.escape(string)}")
    if string.empty? or string.nil?
      return nil
    end
    if url =~ URI::regexp
      companies = Hash.new
      count = 0
      doc = Nokogiri::HTML(open(url))
      doc.css('.hitlistLink').each do |name|
        identification_no = doc.css('.text11grey6')[count].content.match(/Org\.nummer: ([0-9]+\-[0-9ORX]+)/)[1]
        count += 1
        companies[identification_no] = name.content
      end
      return companies
    else
      return nil
    end
  end
end
