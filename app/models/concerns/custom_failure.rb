class CustomFailure < Devise::FailureApp
  def redirect_url
    root_path
  end

  def respond
    binding.pry
    http_auth? ? http_auth : redirect_back(fallback_location: root_path)
  end
end