uri = ENV["REDIS_TLS_URL"] || "redis://localhost:6379/"
REDIS = Redis.new(:url => uri, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })