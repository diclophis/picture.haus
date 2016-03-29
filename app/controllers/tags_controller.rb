class TagsController < ApplicationController
  before_filter :authenticate_person!

  def index
    render :text => Tag.all.collect { |tag| tag.name }.collect { |autocomplete|
      {
        :value => "#{autocomplete}",
        :caption => "#{autocomplete}"
      }
    }.to_json
  end
end
