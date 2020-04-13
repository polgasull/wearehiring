Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_SECRET'], 
  scope: 'r_liteprofile',
  fields: ['id', 'first-name', 'last-name', 'location', 'picture-url', 'public-profile-url']
end