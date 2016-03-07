require 'active_support/concern'

module Encryption
	extend ActiveSupport::Concern
	def encryption_key
		if Rails.env.production?
			raise 'Must set token key!!' unless ENV[ 'TOKEN_KEY' ]
			ENV[ 'TOKEN_KEY' ]
		else
			ENV['TOKEN_KEY'] ? ENV['TOKEN_KEY'] : 'b\xBC\xB0k\xFB\xB9\x12\xA3\x15uT\xE3U\xC7\x84\n\O\xD24\x83\x16\xE8j\x9AU\xC3w\xDB\xE2\xCEP'
		end
	end

end
