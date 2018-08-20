#! /usr/bin/env ruby

require 'bundler/setup'
Bundler.require

require_relative 'food_client'
require_relative 'amica_client'
require_relative 'dylan_client'
require_relative 'tastory_client'
require_relative 'fazer_client'

clients = [
  TastoryClient.new('q4a'),
  DylanClient.new('lepuski'),
  AmicaClient.new('quartetto_plus')
]

clients.each do |client|
  client.load_menus_with_rescue
  client.post_to_slack
end
