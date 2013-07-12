# Order Management System

This is an application to manage products and orders. It doesn't have a GUI. The only interface is public REST Api.

The system should implement the following list of requirements:

* Products
  + Create/Edit/Delete/Show/List
  + Each product has a unique name and a price
  + A product can only be deleted if its not part of any order

* Orders
  + Create/Edit/Show/List
  + Each order has a date (not in the past, defaults to current date), a VAT (default is 20%), a status, and multiple line items  
  + Create/Edit Line Items  
  + Each line item should reference a product, a quantity (> 0) and a price (price of the product when the line item was created)
  + Each order can have the following statuses: DRAFT (default), PLACED, PAID, CANCELLED
  + An order can't change to the CANCELLED status without a reason
  + An order (including line items) can only be edited while in the DRAFT status
  + An order can only change state according to the following state machine diagram:



![Order State Machine Model](http://i.imgur.com/OxAULiU.jpg)

## Class Model

The following image represents the entities of the system.



![Class Model](http://i.imgur.com/z9c2XAJ.jpg)


## API

### Products

`GET /products` Get all products

`POST /products` Create a product

`GET /products/:id` Get a product

`PUT /products/:id` Update a product

`DELETE /products/:id` Delete a product

### Orders

`GET /orders` Get all orders

`POST /orders` Create a order

`GET /orders/:id` Get a order

`PUT /orders/:id` Update a order

### Status Transitions

`POST /orders:id/status_transitions` Create a status transition (change the status of an order)

### Line Items

`GET /orders/:id/line_items` Get all the orders line items

`POST /orders/:id/line_items` Create a line item

`GET /orders/:id/line_items/:id` Get a line item

`PUT /orders/:id/line_items/:id` Update a line item

`DELETE /orders/:id/line_items/:id` Delete a line item
