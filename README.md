# Customer Dimension Model

## Overview
This project contains the **dbt models** and tests that define and validate our customer dimension data, with a primary focus on processing and handling customer demographics information. This model is designed to enable seamless integration with existing data platforms and provides configurable tests to ensure the reliability of demographic insights.

## Demographics Coverage
In our customer data model, not all customers are expected to have associated demographic information. This is purposefully designed to accommodate various real-world data scenarios, such as when demographic data is unavailable or inapplicable. The demographic data is represented within the `customer_dim` model as follows:

- **Customers with `C_CURRENT_CDEMO_SK ≤ 480200`**: These customers have full demographic data, such as age, location, and income information.
- **Customers with `C_CURRENT_CDEMO_SK > 480200`**: These customers do not have demographic data, which is handled by null values or default entries (e.g., ‘Unknown’).

To monitor demographic completeness, we use custom tests that measure the proportion of customers with missing demographics. We allow up to **20%** of customers to have null or default demographics; if this threshold is exceeded, the test will fail, prompting further investigation.

## Key Files and Directories
- `dbt_project/models/customer_dim.sql`: The primary model for customer dimension data, transforming raw data into a format suitable for analytics.
- `dbt_project/models/staging/sources.yml`: Defines the data sources and associated tests to ensure data integrity before transformation.
- `dbt_project/models/schema.yml`: Contains schema-level configurations and column-level tests to validate data types, uniqueness, and referential integrity.
- `dbt_project/tests/test_customer_demographics_coverage.sql`: Custom SQL test that monitors demographics coverage across the customer dataset, validating that the demographic null rate does not exceed the acceptable 20% threshold.

## Installation
Clone the repository and navigate to the project directory:

```bash
git clone https://github.com/Mitchell-MC/phase1WeCloudProject.git
cd phase1WeCloudProjectCustomer Dimension Model
Overview
This project contains the dbt models and tests that define and validate our customer dimension data, with a primary focus on processing and handling customer demographics information. This model is designed to enable seamless integration with existing data platforms and provides configurable tests to ensure the reliability of demographic insights.

Demographics Coverage
In our customer data model, not all customers are expected to have associated demographic information. This is purposefully designed to accommodate various real-world data scenarios, such as when demographic data is unavailable or inapplicable. The demographic data is represented within the customer_dim model as follows:

Customers with C_CURRENT_CDEMO_SK ≤ 480200: These customers have full demographic data, such as age, location, and income information.
Customers with C_CURRENT_CDEMO_SK > 480200: These customers do not have demographic data, which is handled by null values or default entries (e.g., ‘Unknown’).
To monitor demographic completeness, we use custom tests that measure the proportion of customers with missing demographics. We allow up to 20% of customers to have null or default demographics; if this threshold is exceeded, the test will fail, prompting further investigation.

Key Files and Directories
dbt_project/models/customer_dim.sql: The primary model for customer dimension data, transforming raw data into a format suitable for analytics.
dbt_project/models/staging/sources.yml: Defines the data sources and associated tests to ensure data integrity before transformation.
dbt_project/models/schema.yml: Contains schema-level configurations and column-level tests to validate data types, uniqueness, and referential integrity.
dbt_project/tests/test_customer_demographics_coverage.sql: Custom SQL test that monitors demographics coverage across the customer dataset, validating that the demographic null rate does not exceed the acceptable 20% threshold.
Installation
Clone the repository and navigate to the project directory:
bash
Copy code
git clone https://github.com/Mitchell-MC/phase1WeCloudProject.git
cd phase1WeCloudProject
Ensure dbt is installed, and all dependencies are met as specified in the packages.yml.
Configure your dbt profile to match your environment settings for the weCloudPipe profile.
Running Models
After configuration, you can run the models to build the customer dimension data:

bash
Copy code
dbt run --models customer_dim
This command executes the transformations and loads the customer_dim model into the designated target.

Running Tests
To validate the data model and ensure quality control, execute the following:

bash
Copy code
dbt test
This command will run all predefined tests, including custom tests on demographic data coverage.

Data Quality and Validation
Data quality is managed through dbt’s built-in and custom tests:

Built-in Tests: Validates uniqueness, referential integrity, and column data types for all models.
Custom Demographic Test: Ensures that customers lacking demographic data do not exceed the acceptable 20% threshold, preventing data quality degradation.
Troubleshooting
Profile Issues: Ensure your dbt profile configuration matches the weCloudPipe project profile.
Failed Tests: For any test failures, review logs in the target/logs directory to identify discrepancies or potential data issues.
License
This project is licensed under the MIT License
