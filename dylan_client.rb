class DylanClient < FoodClient
  
  def initialize(restaurant, date = Date.today)
    @date = date
    @restaurant_name = "Dylan #{restaurant}"
    @restaurant_url = "https://www.dylan.fi/#{restaurant}-lunch-menu/"
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
    lines = []
    page.css('.sqs-block-html .sqs-block-content').xpath('//p').each do |section|
      next if section.inner_html.start_with?('<a target=')
      lines = lines + section.inner_html.split('<br>')
    end
    
    # find current day
    is_current = false
    day_lines = []
    lines.each do |line|
      if line.start_with?('<strong>')
        is_current = line.start_with?("<strong>#{local_weekday}")
      else
        day_lines.push(line&.gsub('&nbsp;', '')) if is_current
      end
    end
    @menus = []
    day_lines.each do |line|
      line = line.split('/').first&.strip&.gsub('<\/em>', '')&.gsub('<em>', '')&.gsub('<', '')
      @menus.push(line) unless line.nil? || line.length <= 5
    end
  end
end