# Functionality 1 – Multi-Vendor Checkout and Order Management

**Owner:** Chetan
**Sprint:** 2 (initial executable process)
**Use case:** Use Case 2 – Customer Multi-Vendor Order, Checkout and Payment

## What this process does

This process handles a customer's checkout, from clicking "checkout" to having a validated order ready for payment. It:

1. Checks the stock for every item in the customer's basket.
2. If stock is short, shows the customer which items are unavailable and lets them remove those items or cancel.
3. Lets the customer choose home delivery or collection from the farm.
4. Calculates the delivery fee (£3.50 per producer, because each farm delivers separately; £0 for collection).
5. Splits the order into producer-specific parts, each with its own items and subtotal.
6. Calculates the order total and asks the customer to confirm.
7. Creates the order with an `orderId`, ready to be passed to **Functionality 2 (Payment Processing and Order Confirmation)**.

## Files

| File | What it is |
|---|---|
| `bpmn/checkout.bpmn` | Executable BPMN process (process ID `checkout_order`) |
| `forms/review_unavailable_items.form` | Shown when stock is insufficient – remove items or cancel |
| `forms/fulfilment_choice.form` | Delivery or collection, with address or time slot |
| `forms/confirm_order.form` | Order summary per producer, delivery fee and total – confirm or cancel |
| `Evidence/` | Screenshots from Camunda Operate for each test case |

## How the process is modelled

**Pool:** Multi-Vendor Checkout
**Lanes:**
- **Customer** – the start event and the 3 user tasks (things the customer does)
- **Marketplace System** – script tasks and gateways (things the system does automatically)

| Step | Element | What happens |
|---|---|---|
| Customer proceeds to checkout | Start event | Process starts with the basket, stock levels and customer email |
| Check stock availability | Script task | Finds basket items where the quantity wanted is more than the stock available → `unavailableItems` |
| Stock sufficient? | Exclusive gateway | No items short → continue; otherwise → review unavailable items |
| Review unavailable items | User task + form | Customer chooses to remove the items or cancel |
| Continue with available items? | Exclusive gateway | Cancel → end "Order cancelled – stock unavailable" |
| Remove unavailable items | Script task | Removes the short items from `basket` |
| Basket empty? | Exclusive gateway | Empty → end "Order cancelled – basket empty"; otherwise → back to the stock check |
| Choose delivery or collection | User task + form | Customer picks a fulfilment method |
| Delivery or collection? | Exclusive gateway | Routes to the matching fee calculation |
| Calculate delivery fee / Arrange collection | Script tasks | Sets `deliveryFee` |
| (merge) | Exclusive gateway | Joins both paths |
| Split order by producer | Script task | Builds `producerOrders` |
| Calculate order total | Script task | `totalAmount` = sum of producer subtotals + delivery fee |
| Review and confirm order | User task + form | Customer confirms or cancels |
| Order confirmed? | Exclusive gateway | Cancel → end "Order cancelled by customer" |
| Create order | Script task | Generates `orderId` |
| Order ready for payment | End event | Order is ready to hand over to Functionality 2 |

## Process variables

**Input (given when the process starts):**
- `customerEmail` – customer's email
- `basket` – list of items, each with `productId`, `name`, `producerId`, `producerName`, `price`, `qty`
- `stock` – stock level per product (simulated for Sprint 2)

**Created during the process:**
- `unavailableItems`, `stockDecision`, `fulfilmentMethod`, `deliveryAddress`, `collectionSlot`, `deliveryFee`, `orderDecision`

**Output (the contract with Functionality 2):**

| Variable | Description |
|---|---|
| `orderId` | Unique order reference, e.g. `ORD-20261118010846301` |
| `totalAmount` | Total to pay, including delivery |
| `customerEmail` | Passed through from the start |
| `producerOrders` | List of producer-specific orders: `producerId`, `producerName`, `subtotal`, `items` |

These names and structures match what `payment_confirmation.bpmn` (Functionality 2) expects, so the two processes can be connected without changes.

## How to run it

**Requirements:** Camunda 8 Run (8.10) and Camunda Desktop Modeler.

1. Start Camunda 8 Run from the `c8run` folder:
   ```
   .\c8run.exe start
   ```
2. Open `checkout.bpmn` and the 3 `.form` files in the Desktop Modeler.
3. Deploy **all 4 files** (rocket icon → Camunda 8 Self-Managed → `http://localhost:26500`, authentication None).
4. Click **Run** on the BPMN and paste the test data below as variables.
5. Complete the user tasks in Tasklist: `http://localhost:8080/tasklist`
6. Check the result and variables in Operate: `http://localhost:8080/operate`

### Test data

```json
{
  "customerEmail": "test@example.com",
  "basket": [
    {"productId": "egg", "name": "Free-range eggs (6)", "producerId": "P1", "producerName": "Farm A", "price": 3.5, "qty": 2},
    {"productId": "milk", "name": "Whole milk 1L", "producerId": "P2", "producerName": "Farm B", "price": 1.2, "qty": 1}
  ],
  "stock": {"egg": 10, "milk": 5}
}
```

## Test cases

| # | Scenario | Stock | Customer choices | Expected result | Evidence |
|---|---|---|---|---|---|
| 1 | Delivery | egg 10, milk 5 | Delivery → Confirm | Ends at "Order ready for payment", fee 7, total 15.2 | `Test Case 1 - Delivery.png` |
| 2 | Collection | egg 10, milk 5 | Collection → Confirm | Fee 0, total 8.2 | `Test Case 2 - Collection.png` |
| 3 | Item missing, continue | egg 10, milk 0 | Continue → Delivery → Confirm | Milk removed, stock re-checked, fee 3.5, total 10.5 | `Test Case 3 - Item missing in Stock.png` |
| 4 | Item missing, cancel | egg 10, milk 0 | Cancel | Ends at "Order cancelled – stock unavailable" | `Test Case 4 - Cancellation because of missing item in stock.png` |
| 5 | Everything out of stock | egg 0, milk 0 | Continue | Basket empty, ends at "Order cancelled – basket empty" | `Test Case 5 - Everything Out of stock.png` |
| 6 | Cancelled at review | egg 10, milk 5 | Delivery → Cancel | Ends at "Order cancelled by customer" | `Test Case 6 - Cancelled by Customer.png` |

All 6 test cases passed.

## Design decisions

- **Delivery fee per producer:** each farm delivers its own items, so the fee is £3.50 × the number of producers in the order.
- **Stock re-check after removing items:** the process goes back to the stock check instead of trusting the removal step, so the order is always validated before it continues.
- **Empty basket check:** stops the process from creating an order with no items.
- **Default flows on every gateway:** the cancel paths are defaults, so the process always has a safe way out.

## Known limitations (planned for Sprint 3)

- **Stock is simulated** – it's passed in as a start variable. In Sprint 3 the stock check will become a service task that calls a mock inventory service.
- **Partial stock isn't handled** – if a customer wants 5 and only 3 are available, the whole item is removed instead of reducing the quantity.
- **A product missing from `stock` isn't flagged** – the check assumes every basket item has a stock entry.
- **Not yet connected to Functionality 2** – in Sprint 3 the end event "Order ready for payment" will become a call activity to `payment_confirmation`.
- **No error handling for failing services yet** – will be added with the service task (error boundary event).

## Legal, ethical, social and professional considerations

- **GDPR / data minimisation:** the process collects a delivery address only when the customer chooses delivery, and a collection slot only for collection. Customer email and address are personal data and should not be kept longer than needed.
- **Transparency to customers:** customers are shown exactly which items are unavailable and the full cost breakdown (per producer and delivery) before confirming, in line with consumer protection expectations.
- **Fairness to producers:** each producer's part of the order is kept separate, so every farm sees only its own items and subtotal.

## Use of generative AI

In line with UWE's guidance on generative AI, AI use for this functionality is declared below.

**Tool used:** Claude (Anthropic)

**Used for:**
- Guidance on the process structure and which BPMN elements to use
- Writing the FEEL expressions in the script tasks and gateway conditions
- Test data and test scenarios
- Drafting this README

<!-- Chetan: complete the line below accurately before committing. -->
**How the BPMN diagram and forms were created:** _[describe how you built them]_

I have reviewed all AI-assisted logic and can explain how each part of the process works.
