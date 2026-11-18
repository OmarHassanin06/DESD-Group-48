# Functionality 2: Simulated Payment Processing and Order Confirmation

The process that is dedicated to processing payment confirmations is called payment_confirmation.Executable process in
Camunda 8.10 is payment_confirmation.
The forms are used in the following bpmns: (`bpmn/payment_confirmation.bpmn`).

## What it does
1. Work out how much should be paid to each producer and to the commission that the marketplace pays (5%)
   (commission is rounded per producer, the total is the sum).
Collects payment information using a Camunda Form (`payment_details`).
3. Simulates an external payment service (no actual transactions).
4. Handles three outcomes:
   - **Success:** makes the order confirmation, creates the list of inventory updates,
     Notifies each producer and confirms order to the customer.
   - Declined: customer may try with a different card or cancel
     Sleep for `retry_decision` with a maximum of 3 times.
   This service is unavailable/automatic retries after delay (timer), then a manual
     Marketplace administrator follow up user task.

## How to run
Start Camunda 8 Run (`c8run start`) and open Operate/Tasklist at http://localhost:8080 (demo/demo).
3. Open `bpmn/payment_confirmation.bpmn` and the two forms from Camunda Modeler, deploy them
   To http://localhost:8080/v2/ with authentication None we use together (rocket icon).
3. Run a test order using tests/start-test-order.ps1, and follow the steps in Tasklist.

## Test cards (simulated)
Card number           Result
4242 4242 4242 4242   SUCCESS
4000 0000 0000 0002   DECLINED
1111 1111 1111 1111   UNAVAILABLE

The variables that go into the function (from Functionality 1).
This data includes orderId, customerId, customerEmail, totalAmount and producerOrders.
(Each: producerId, producerName, subtotal,
`items[{productId, name, qty, unitPrice}]`).

## Output variables
These are the key terms included in the order information.The main terms in the order information are:
`producerNotifications`, `customerNotification`, `retryCounters`.

## Notes
The payment service is emulated by a script task, a real implementation would be a
  service task calling a payment provider.
- The data stored on the cards are only used for simulation purposes and need not be saved in a real system.
  (PCI DSS, GDPR).
Traceability: The process clarifies the strategic BPMN subprocess
  Process Payments & Confirm Orders.