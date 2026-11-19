# Starts a test order for the payment_confirmation process (Functionality 2).
# Prerequisite: Camunda 8 Run is running on localhost:8080 and the process and forms
# are deployed. Afterwards open Tasklist (http://localhost:8080/tasklist) and
# complete "Enter payment details".
# Test cards: 4242 4242 4242 4242 = success, 4000 0000 0000 0002 = declined,
# 1111 1111 1111 1111 = service unavailable.

$body = @'
{
  "processDefinitionId": "payment_confirmation",
  "variables": {
    "orderId": "ORD-20261119120000000",
    "customerEmail": "test@example.com",
    "totalAmount": 15.2,
    "producerOrders": [
      {"producerId": "P1", "producerName": "Farm A", "subtotal": 7,
       "items": [{"productId": "egg", "name": "Free-range eggs (6)", "producerId": "P1", "producerName": "Farm A", "price": 3.5, "qty": 2}]},
      {"producerId": "P2", "producerName": "Farm B", "subtotal": 1.2,
       "items": [{"productId": "milk", "name": "Whole milk 1L", "producerId": "P2", "producerName": "Farm B", "price": 1.2, "qty": 1}]}
    ]
  }
}
'@

Invoke-RestMethod -Method Post `
  -Uri "http://localhost:8080/v2/process-instances" `
  -ContentType "application/json" `
  -Body $body