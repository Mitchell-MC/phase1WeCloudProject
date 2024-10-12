# Customer Dimension Model

## Overview
This project contains the dbt models and tests for our customer dimension, with a focus on handling customer demographics data.

## Demographics Coverage

In our customer data model, we have intentionally designed it so that not all customers have associated demographic information. This is represented in the `customer_dim` model as follows:

- Customers with a `C_CURRENT_CDEMO_SK` value <= 480200 have associated demographic data.
- Customers with a `C_CURRENT_CDEMO_SK` value > 480200 do not have associated demographic data.

This design allows for scenarios where demographic information may not be available or applicable for certain customers. When analyzing customer data, be aware that demographic fields will be null or set to 'Unknown' for customers without demographic information.

We monitor the proportion of customers without demographics through our data tests, and consider it normal for up to 20% of customers to lack demographic data. If this proportion exceeds 20%, it will trigger a test failure for further investigation.

## Key Files
- `dbt_project/models/customer_dim.sql`: The main customer dimension model
- `dbt_project/models/staging/sources.yml`: Source definitions and tests
- `dbt_project/tests/test_customer_demographics_coverage.sql`: Custom test for demographics coverage
- `dbt_project/models/schema.yml`: Schema definitions and column-level tests

## Running Tests
To run the dbt tests, use the following command:
```
dbt test
```

This will run all tests, including the custom demographics coverage test.
