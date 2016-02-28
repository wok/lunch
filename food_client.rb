class FoodClient

  attr_accessor :restaurant_name
  attr_accessor :restaurant_url
  attr_accessor :menus
  attr_accessor :date
  
  def post_to_slack
    webhook = ENV['FOOD_SLACK_URL']

    if menus.any?
      menu_items = menus.map { |n| "> #{n}" }.join("\n")
    else
      menu_items = '> No menu available'
    end

    data = {
      text: "<#{restaurant_url}|#{restaurant_name}>\n" + menu_items
    }

    RestClient.post webhook, data.to_json, content_type: :json
  end
  
end