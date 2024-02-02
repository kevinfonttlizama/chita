require_relative 'lib/invoice_quote'

# Example input data
issuer_rut = '76329692-K'
debtor_rut = '77360390-1'
invoice_amount = 1000000
folio = 75
expiration_date = '2024-03-02'

quote = InvoiceQuote.new(issuer_rut, debtor_rut, invoice_amount, folio, expiration_date)
result = quote.fetch_quote

if result
  puts "Financing Cost: $#{result[:financing_cost]}"
  puts "Amount to Receive: $#{result[:amount_to_receive]}"
  puts "Excess Amount: $#{result[:excess_amount]}"
end
