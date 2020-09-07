class DylanClient < FoodClient
  
  def initialize(restaurant, date = Date.today)
    @date = date
    @restaurant_name = "Dylan #{restaurant}"
    @restaurant_url = "https://www.dylan.fi/#{restaurant}"
  end
  
  def load_menus
    @menus = []
    content = RestClient.get(restaurant_url).body.force_encoding('utf-8')
    regex = Regexp.new('\<body.*\<\/body\>', Regexp::IGNORECASE | Regexp::MULTILINE)
    if (matches = regex.match(content))
      content = matches[0]
    else
      return
    end
    content = content.gsub('&nbsp;', '').gsub('&shy;', '')
    page = Nokogiri::HTML(content)
    container = page.at('//div[contains(.//span, "LOUNAS")]').next

    @menus = []
    container.xpath('//div[@role="gridcell"]').each do |cell|
      rows = cell.css('p').map(&:text)
      next unless rows&.first&.start_with?(local_weekday)
      @menus = rows.drop(1).select{ |row| row.strip.length > 1 }
    end
  end
end