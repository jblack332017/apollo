class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end


# Rails 5 disables autoloading in production. See: http://blog.bigbinary.com/2...
#
# The three options are:
#
# 1) Move lib/json_web_token.rb into app/lib/ so rails loads it automatically
# 2) Use eager loading instead of autoloading: config.eager_load_paths << Rails.root.join('lib')
# 3) Force rails to allow autoloading: config.enable_dependency_loading = true
#
# I personally just moved the class into app/
