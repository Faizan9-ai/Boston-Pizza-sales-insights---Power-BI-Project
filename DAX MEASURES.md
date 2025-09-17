
# DAX Measures – Boston Pizza Dashboard

##  Total Customers
```DAX
Total Customers = DISTINCTCOUNT('orders'[customer_id])


## Returning customers

Returning Customers = 
CALCULATE(
    DISTINCTCOUNT('orders'[customer_id]),
    FILTER(
        VALUES('orders'[customer_id]),
        CALCULATE(COUNT('orders'[order_id])) > 1
    )
)


## Average order value 

Avg Order Value = DIVIDE([Total Revenue], [Total Orders], 0)



