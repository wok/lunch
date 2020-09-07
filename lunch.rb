#! /usr/bin/env ruby

require 'bundler/setup'
Bundler.require

require_relative 'food_client'
require_relative 'food_co_client'
require_relative 'dylan_client'
require_relative 'tastory_client'
require_relative 'bad_client'

clients = [
  TastoryClient.new('q4a'),
  DylanClient.new('lepuski'),
  BadClient.new,
  # FoodCoClient.new('quartetto_plus'),
  # FoodCoClient.new('gongi')
]

clients.each do |client|
  client.load_menus_with_rescue
  client.post_to_slack
  # client.to_stdout
end
