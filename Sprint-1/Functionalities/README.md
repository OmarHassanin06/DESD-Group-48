# Sprint 1 – Identification of Major Functionalities

## Overview

For the DESD project, I have selected **Use Case 2: Customer Multi-Vendor Order, Checkout and Payment**.

I have identified two major functionalities that cover the customer ordering process, from checkout and stock validation to payment processing and order confirmation.

---

## Functionality 1: Multi-Vendor Checkout and Order Management

### Description
This functionality allows customers to purchase products from multiple producers in a single order. It ensures that products are available, determines delivery or collection arrangements, and organises the order for each producer.

### Key Responsibilities
- Validate product availability and requested quantities.
- Inform customers if products are unavailable or stock is insufficient.
- Determine delivery or collection arrangements.
- Allow customers to review and confirm their purchase.
- Create the overall marketplace order.
- Separate the order into producer-specific order elements.

### Input
Customer's shopping basket and checkout request.

### Output
A validated marketplace order containing the relevant producer-specific order elements, ready for payment.

---

## Functionality 2: Simulated Payment Processing and Order Confirmation

### Description
This functionality manages the financial side of the order. It calculates producer payment allocations and the marketplace commission, communicates with an external payment service, and handles order confirmation.

### Key Responsibilities
- Calculate each producer's payment allocation.
- Calculate the marketplace's **5% commission**.
- Submit payment requests to an external or simulated payment service.
- Handle successful, declined and unavailable payment responses.
- Allow payment retries or appropriate exception handling.
- Confirm orders after successful payment.
- Update product inventory quantities.
- Notify the relevant producers and customer of successful orders.

### Input
A validated marketplace order ready for payment.

### Output
- **Successful payment:** Confirmed order, updated inventory and relevant notifications.
- **Failed payment:** Payment failure information with an opportunity to retry or follow an exception process.

---

## Relationship Between the Two Functionalities

The two functionalities work together to complete the customer purchasing process.

**Functionality 1** handles checkout, stock validation and order creation.

**Functionality 2** receives the validated order, processes payment and finalises the purchase.

Both functionalities will be developed into detailed operational BPMN models and automated using Camunda in later sprints, subject to tutor approval.
