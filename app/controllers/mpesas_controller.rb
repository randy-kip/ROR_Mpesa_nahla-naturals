# ROR_Mpesa\app\controllers\mpesas_controller.rb
class MpesasController < ApplicationController
    require 'rest-client' # Include the rest-client gem for making HTTP requests
    rescue_from SocketError, with: :OfflineMode # Rescue from SocketError and handle it with the OfflineMode method

    mpesa_consumer_key: 'RfqDHYVDbtAyM31p0o1XJoMdtGrQxRpQzxoAGAJ07tublVBk'
    mpesa_consumer_secret: 'axcsqZ3G0up1bYArba2vmlO7ss4N0tkCsn7KRFHj53GjtZWnEseDIGR8GzcvYh25'
    mpesa_passkey= 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919'
    mpesa_initiator_username: 'nahla-api'
    mpesa_initiator_security_credential: 'Safaricom999!*!'
    callback_url: 'https://3199-41-139-192-167.ngrok-free.app'
    query_url: 'https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query'
    register_url: 'https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl'
    mpesa_shortcode: '174379'
  
    def stkpush
      phoneNumber = params[:phoneNumber] # Get the phone number from the request parameters
      amount = params[:amount] # Get the amount from the request parameters
  
      url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest" # URL for initiating an STK push
      timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}" # Generate a timestamp
      business_short_code = mpesa_shortcode # Get the Mpesa business short code from environment variables
      password = Base64.strict_encode64("#{business_short_code}#{mpesa_passkey}#{timestamp}") # Generate the password for the request
  
      # Payload for the STK push request
      payload = {
        'BusinessShortCode': business_short_code,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': "CustomerPayBillOnline",
        'Amount': amount,
        'PartyA': phoneNumber,
        'PartyB': business_short_code,
        'PhoneNumber': phoneNumber,
        'CallBackURL': "#{callback_url}/callback_url", # URL for receiving callback from Mpesa
        'AccountReference': 'Nahla Naturals',
        'TransactionDesc': "Nahla Naturals Essentials"
      }.to_json
  
      # Headers for the STK push request
      headers = {
        content_type: 'application/json',
        Authorization: "Bearer #{get_access_token}" # Get the access token
      }
  
      # Make the STK push request and handle the response
      response = RestClient::Request.new({
        method: :post,
        url: url,
        payload: payload,
        headers: headers
      }).execute do |response, request|
        case response.code
        when 500
          [:error, JSON.parse(response.to_str)]
        when 400
          [:error, JSON.parse(response.to_str)]
        when 200
          [:success, JSON.parse(response.to_str)]
        else
          fail "Invalid response #{response.to_str} received."
        end
      end
  
      render json: response # Render the response as JSON
    end
  
    def polling_payment
      # Check if payment has been paid
      checkoutId = params[:checkoutRequestID] # Get the checkout request ID from the request parameters
  
      timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}" # Generate a timestamp
      business_short_code = mpesa_shortcode # Get the Mpesa business short code from environment variables
      password = Base64.strict_encode64("#{business_short_code}#{mpesa_passkey}#{timestamp}") # Generate the password for the request
  
      url = query_url # URL for querying payment status
  
      # Headers for the query request
      headers = {
        content_type: 'application/json',
        Authorization: "Bearer #{get_access_token}" # Get the access token
      }
  
      # Payload for the query request
      payload = {
        'BusinessShortCode' => business_short_code,
        'Password' => password,
        'Timestamp' => timestamp,
        'CheckoutRequestID' => checkoutId
      }.to_json
  
      # Make the query request and handle the response
      response = RestClient::Request.new({
        method: :post,
        url: url,
        payload: payload,
        headers: headers
      }).execute do |response, request|
        puts response
        case response.code
        when 500
          [:error, JSON.parse(response.to_str)]
        when 400
          [:error, JSON.parse(response.to_str)]
        when 200
          [:success, JSON.parse(response.to_str)]
        else
          fail "Invalid response #{response.to_str} received."
        end
      end
  
      render json: response # Render the response as JSON
    end
  
    private
  
    def generate_access_token_request
      @url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials" # URL for generating access token
  
      @consumer_key = mpesa_consumer_key # Get the consumer key from environment variables
      @consumer_secret = mpesa_consumer_secret # Get the consumer secret from environment variables
      @userpass = Base64::strict_encode64("#{@consumer_key}:#{@consumer_secret}") # Generate the base64 encoded user:pass
      @headers = {
        Authorization: "Bearer #{@userpass}" # Set the Authorization header
      }
  
      # Make the request to generate the access token
      res = RestClient::Request.execute(url: @url, method: :get, headers: { Authorization: "Basic #{@userpass}" })
      res
    end
  
    def get_access_token
      res = generate_access_token_request() # Get the response from the access token request
      if res.code != 200 # Check if the request was successful
        r = generate_access_token_request()
        if res.code != 200
          raise MpesaError('Unable to generate access token') # Raise an error if unable to generate access token
        end
      end
      body = JSON.parse(res, { symbolize_names: true }) # Parse the response body
      token = body[:access_token] # Extract the access token from the response
      AccessToken.destroy_all() # Remove all existing access tokens
      AccessToken.create!(token: token) # Create a new access token record
      token
    end
  
    # Errors returned
  
    def OfflineMode
      render json: { errors: ['You are Offline Do Connect to the Internet'] } # Render an error message if the user is offline
    end
end