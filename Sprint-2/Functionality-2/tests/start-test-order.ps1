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
    "orderId": "ORD-1001",
    "customerId": "C-1",
    "customerEmail": "test@example.com",
    "totalAmount": 100,
    "producerOrders": [
      {"producerId": "P1", "producerName": "Farm A", "subtotal": 60,
       "items": [{"productId": "PR1", "name": "Tomatoes", "qty": 2, "unitPrice": 30}]},
      {"producerId": "P2", "producerName": "Bakery B", "subtotal": 40,
       "items": [{"productId": "PR2", "name": "Bread", "qty": 4, "unitPrice": 10}]}
    ]
  }
}
'@

Invoke-RestMethod -Method Post `
  -Uri "http://localhost:8080/v2/process-instances" `
  -ContentType "application/json" `
  -Body $body