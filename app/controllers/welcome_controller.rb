class WelcomeController < ApplicationController
  def index
  end

  def register
    # Find or create Account
    email = params[:email]
    account = Account.find_or_create_by(email: email) do |account|
      account.domain ||= email.split('@')[0].downcase
    end

    url = ENV['BASE_URL'] + "/auth?token=#{account.perishable_token}"

    # Send auth email
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]

    # Define your message parameters
    message_params =  { 
      from: 'danielx@whimsy.space',
      to: email,
      subject: 'Your ticket to whimsy',
      html: '<a href="#{url}">Click 2 log in</a> or use this link ' + url
    }

    # Send your message through the client
    mg_client.send_message 'whimsy.space', message_params

    logger.info "Email sent to #{email}"

    # Render email sent
    render "check-your-email"
  end

  def auth
    # Returning from auth email link
    # Look up user by perishable token
    account = Account.find_by!(perishable_token: params[:token])

    # Set verified => true
    account.update verified: true

    # Find or create API Key
    if account.tokens.where(expired: false).size == 0
      account.tokens.create(account: account)
    end

    @api_token = account.tokens.where(expired: false).first.id

  end
end
