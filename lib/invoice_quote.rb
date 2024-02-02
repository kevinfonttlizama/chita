require 'httparty' #libs
require 'date'

# This class is designed to calculate invoice financing quotes using an external API.
class InvoiceQuote
  # Constants for the API endpoint and the API key
  API_URL = "https://chita.cl/api/v1/pricing/simple_quote".freeze
  API_KEY = "pZX5rN8qAdgzCe0cAwpnQQtt".freeze

  def initialize(issuer_rut, debtor_rut, invoice_amount, folio, expiration_date)
    @issuer_rut = issuer_rut
    @debtor_rut = debtor_rut
    @invoice_amount = invoice_amount
    @folio = folio
    @expiration_date = expiration_date
  end

  def fetch_quote
    response = HTTParty.get(API_URL, query: request_params, headers: request_headers)

    # If the response is successful, processes the returned data.
    if response.success?
      process_response(response.parsed_response)
    else
      raise "Error fetching quote: #{response.body}"
    end
  rescue StandardError => e
        # Prints any caught StandardErrors to the console
    puts e.message
  end

  private
  # Prepares the request parameters for the API call
  def request_params
    {
      client_dni: @issuer_rut,
      debtor_dni: @debtor_rut,
      document_amount: @invoice_amount,
      folio: @folio,
      expiration_date: @expiration_date
    }
  end

  def request_headers   # Prepares the headers for the API call, including the API key.
    { "X-Api-Key" => API_KEY }
  end

  def process_response(data)
  # Extracts and converts necessary values from the response.
    document_rate = data["document_rate"].to_f / 100.0  
    commission = data["commission"].to_f  prueba.
    advance_percent = data["advance_percent"].to_f / 100.0  

    # Logs the received values for debugging.
    puts "Received from API - Document Rate: #{document_rate * 100}%, Commission: #{commission}, Advance Percent: #{advance_percent * 100}%"
    
    # Calculates the number of days until the invoice expiration
    days_term = (Date.parse(@expiration_date) - Date.parse("2024-02-01")).to_i + 1  # 31 days
    
    # Calculates the financing cost, amount to receive, and excess amount
    financing_cost = (1000000 * advance_percent * (document_rate / 30 * days_term)).to_i
    amount_to_receive = (1000000 * advance_percent - financing_cost - commission).round
    excess_amount = (1000000 - 1000000 * advance_percent).round
    
    # Returns the calculated values
    { financing_cost: financing_cost, amount_to_receive: amount_to_receive, excess_amount: excess_amount }
  end
  
  
  
  
end
