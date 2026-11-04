# Sprint 1 – Identification of Major Functionalities

## Overview

For the DESD project, I selected **Use Case 2: Customer Multi-Vendor Order, Checkout and Payment**.

I identified two major functionalities covering the customer ordering process, from checkout and stock validation to simulated payment and order confirmation.

---

## Functionality 1: Multi-Vendor Checkout and Order Management

### Description

This functionality manages customer checkout, validates product availability and creates orders involving multiple producers.

### Key Responsibilities

- Check product availability and stock quantities.
- Allow customers to amend their basket if stock is insufficient.
- Determine delivery or collection arrangements.
- Allow customers to review and confirm their order.
- Create an overall order with separate producer-specific elements.

### How It Works

When a customer proceeds to checkout, the system checks whether the requested products are available.

If stock is insufficient, the customer must amend their basket. Otherwise, the system determines delivery or collection arrangements and allows the customer to confirm their purchase.

The marketplace then creates the order and separates it into producer-specific elements before passing it to the payment process.

### Planned Implementation

I plan to use **Camunda Forms** for order confirmation, **service tasks** for stock validation and order creation, and **gateways** to handle unavailable products.

**Input:** Customer's basket and checkout request.

**Output:** Validated marketplace order ready for payment.

---

## Functionality 2: Simulated Payment Processing and Order Confirmation

### Description

This functionality calculates payment allocations and the marketplace's 5% commission, processes simulated payments and confirms successful orders.

### Key Responsibilities

- Calculate each producer's payment allocation.
- Calculate the marketplace's **5% commission**.
- Process payments using a simulated payment service.
- Handle successful, declined and unavailable payments.
- Allow payment retries and exception handling.
- Confirm orders, update inventory and notify producers and customers.

### How It Works

The system receives the validated order from Functionality 1 and calculates the total amount, producer allocations and marketplace commission.

A payment request is sent to a simulated payment service, which can return three outcomes:

- **Success:** Confirm the order, update inventory and send notifications.
- **Declined:** Inform the customer and allow another payment attempt.
- **Unavailable:** Follow an exception or retry process.

For example, a £100 multi-vendor order would generate a £5 marketplace commission.

### Planned Implementation

I plan to use **Camunda service tasks** for commission calculations and simulated payment processing, **gateways** for payment decisions, and **Forms** for customer interaction and retries.

**Input:** Validated marketplace order ready for payment.

**Output:** Confirmed order with updated inventory and notifications, or a payment failure requiring further action.

---

## Relationship Between the Two Functionalities

**Functionality 1** handles checkout, stock validation and order creation.

**Functionality 2** receives the validated order, processes simulated payment and finalises the purchase.

