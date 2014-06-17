# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Scrooge::Application.config.secret_key_base = 'a863c63de09e432c1319c7cd6cb437e914a89645ea129b367a5484b4d05112ebbca19d4ad65e57ba1d881a477bccaaf3c1754be8c7955c1753ca75ae5d06e17c'
Scrooge::Application.config.secret_token = 'bd348b5fd16ffd2cf8e8dbf57e4af3fe6ebd2dd8946d88658c0f4346236e1ea53e0ea93066e0954aa991a5d7fe591444d5d34548943d5e1c9fa59b3bf8fee6fa'
