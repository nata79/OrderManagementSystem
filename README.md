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
  + Each time an order change status, it should record the transition for future data analysis
  + An order can't change to the CANCELLED status without a reason
  + An order (including line items) can only be edited while in the DRAFT status
  + An order can only change state according to the following state machine diagram:


<img align="center" src="http://i.imgur.com/OxAULiU.jpg" alt="Order State Machine Model">

## Class Model


<img align="center" src="http://i.imgur.com/DrdJnZr.jpg" alt="Class Model">