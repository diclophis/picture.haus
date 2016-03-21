# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Centerology::Application.config.secret_key_base = ENV["RAILS_SECRET_KEY_BASE"] || ((Rails.env.development? || Rails.env.test?) ? "af8238243a2c5f32292e3aab8d9fb4749711737ec7fd6bf5edb973898dab7a31986d47b00a97b706f2f5339218b977eeec0b2c642b96bac3dbd93aa738b7b8b8" : (raise "please set RAILS_SECRET_KEY_BASE in your ENV"))
