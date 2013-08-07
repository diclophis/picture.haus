# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# poltergeist phantomjs enabled for all capybara features
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end

class Router
  include Rails.application.routes.url_helpers
  #delegate :asset_path, :to => ActionController::Base.helpers
  #Rails.application.routes.default_url_options[:host]
  def self.default_url_options
    ActionMailer::Base.default_url_options.merge({:host => "foo"})
  end
end

def valid_person
  @_valid_person_id ||= 0
  @_valid_person_id += 1
  person = Person.new
  person.username = "foo"
  person.email = "foo-#{Time.now.to_i}-#{@_valid_person_id}@foo.com"
  person.password = "qwerty123"
  person.should be_valid
  person
end

def valid_friendship
  person = valid_person
  person.save!
  friend = valid_person
  friend.save!
  friendship = Friendship.new
  friendship.friendshipped_for_me = friend
  friendship.friendshipped_by_me = person
  friendship
end

def valid_image #(router = Router.new)
  all_images = Dir.glob("app/assets/images/image-*")
  @_first_random_image ||= all_images[rand * all_images.length]

  image = Image.new
  image.title = "title"
  image.src = File.basename(@_first_random_image) #.gsub("app/assets/images/", "") #ActionController::Base.helpers.asset_path("noise.png") #"http://google.com"
  image
end

def valid_finding
  finding = Finding.new
  finding.person = valid_person
  finding.image = valid_image
  finding
end

def valid_similarity
  similarity = Similarity.new
  similarity.image = valid_image
  similarity.similar_image = valid_image
  similarity.rating = 0
  similarity.join_type = ""
  similarity
end
