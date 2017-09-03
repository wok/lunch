require 'bundler/setup'
Bundler.require

require_relative 'food_client'

class DylanClient < FoodClient
  
  def initialize(restaurant, date = Date.today)
    @date = date
    @restaurant_name = restaurant
    @restaurant_url = "https://www.dylan.fi/#{restaurant}-lunch-menu/"
    load_menus
  end
  
  def load_menus
    @menus = []
    page = Nokogiri::HTML(File.read('index.html'))
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
      text = text.split('/').first
      text = text.sub(' g', '')
      text = text.sub(' l,g', '')
      text
    end
  end
end

c = DylanClient.new('lepuski', Date.parse('2017-09-01'))
puts c.menus