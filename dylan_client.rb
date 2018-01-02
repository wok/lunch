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
    page = Nokogiri::HTML(content)
    container = page.css('.sqs-block-html .sqs-block-content').first
    return unless container
    items = container.css('p.text-align-center')
    current = items.detect do |item|
      title = item.css('strong')
      title && title.text.include?(date.strftime('%-d.%-m.'))
    end
    return unless current
    actual_menus = current.inner_html.split('<br>')[1..-1]
    @menus = actual_menus.map do |text|
      text = text.split('/').first.strip
      text.gsub(/ [a-z](,[a-z])*\z/, '')
    end
  end
end