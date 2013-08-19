class TagsController < ApplicationController
  before_filter :authenticate_person!

  def index
    render :text => ["foo", "bar", "baz"].collect { |autocomplete|
      {
        :value => "#{autocomplete}",
          :caption => "#{autocomplete}"
      }
    }.to_json
  end
end
