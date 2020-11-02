# frozen_string_literal: true

class SendgridService
  KEY = ENV['SENDGRID_SMTP_PASSWORD']

  def initialize
    @base_url = "https://api.sendgrid.com"
  end

  def update_contact(user)
    conn = Faraday.new(
      :url => @base_url,
      headers: {'Content-Type' => 'application/json'}
      )

    update_contact = conn.put "/v3/marketing/contacts" do |req|
      req.headers["Authorization"] = "Bearer #{KEY}"
      req.body = {
        list_ids: [
          list_id(user)
        ],
        contacts: [
          { 
            email: "#{user.email}",
            first_name: "#{user.name}",
            last_name: "#{user.last_name}",
            phone_number: "#{user.phone}",
            custom_fields: {
              "e4_T": "#{user.profile_url}",
              "e5_T": "#{user.current_position}",
              "e6_T": "#{user.user_type.name}",
              "e7_T": "#{user.description}",
              "e8_T": "#{user.personal_website}",
              "e9_T": "#{user.github}",
              "e10_T": "#{user.pinterest}",
              "e11_T": "#{user.behance}"
            },
          }
        ]
      }.to_json
    end
  end

  private

  def list_id(user)
    return if !user

    return "ebec45ba-a56b-43fe-b281-58b4c93a24b6" if user.is_candidate?
    return "13f2530e-9018-493b-95a5-5b4a48cc76aa" if user.is_company?
    return "b7a0acb0-f99a-47ad-8aeb-8d6cd796900a" if user.is_ambassador?
  end
end

  

