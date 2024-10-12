WITH valid_demographics AS (
    SELECT *
    FROM {{source('airbyte_raw', 'customer_demographics')}}
    WHERE cd_demo_sk <= 480200  -- Only include valid demographic records
),
customer_with_demo_status AS (
    SELECT 
        c.*,
        CASE 
            WHEN c.C_CURRENT_CDEMO_SK > 480200 THEN 'No Demographics'
            ELSE 'Has Demographics'
        END as demo_status
    FROM {{ref('customer_snapshot')}} c
)
SELECT 
    c.C_SALUTATION,
    c.C_PREFERRED_CUST_FLAG,
    c.C_FIRST_SALES_DATE_SK,
    c.C_CUSTOMER_SK,
    c.C_LOGIN,
    c.C_CURRENT_CDEMO_SK,
    c.demo_status,
    c.C_FIRST_NAME,
    c.C_CURRENT_HDEMO_SK,
    c.C_CURRENT_ADDR_SK,
    c.C_LAST_NAME,
    c.C_CUSTOMER_ID,
    c.C_LAST_REVIEW_DATE_SK,
    c.C_BIRTH_MONTH,
    c.C_BIRTH_COUNTRY,
    c.C_BIRTH_YEAR,
    c.C_BIRTH_DAY,
    c.C_EMAIL_ADDRESS,
    c.C_FIRST_SHIPTO_DATE_SK,
    ca.CA_STREET_NAME,
    ca.CA_SUITE_NUMBER,
    ca.CA_STATE,
    ca.CA_LOCATION_TYPE,
    ca.CA_COUNTRY,
    ca.CA_ADDRESS_ID,
    ca.CA_COUNTY,
    ca.CA_STREET_NUMBER,
    ca.CA_ZIP,
    ca.CA_CITY,
    ca.CA_GMT_OFFSET,
    cd.CD_DEP_EMPLOYED_COUNT,
    cd.CD_DEP_COUNT,
    COALESCE(cd.CD_CREDIT_RATING, 'Unknown') as CD_CREDIT_RATING,
    COALESCE(cd.CD_EDUCATION_STATUS, 'Unknown') as CD_EDUCATION_STATUS,
    cd.CD_PURCHASE_ESTIMATE,
    COALESCE(cd.CD_MARITAL_STATUS, 'Unknown') as CD_MARITAL_STATUS,
    cd.CD_DEP_COLLEGE_COUNT,
    COALESCE(cd.CD_GENDER, 'Unknown') as CD_GENDER,
    hd.HD_BUY_POTENTIAL,
    hd.HD_DEP_COUNT,
    hd.HD_VEHICLE_COUNT,
    hd.HD_INCOME_BAND_SK,
    ib.IB_LOWER_BOUND,
    ib.IB_UPPER_BOUND,
    c.dbt_valid_from as valid_from,
    c.dbt_valid_to as valid_to 
FROM customer_with_demo_status c
LEFT JOIN {{source('airbyte_raw','customer_address')}} ca ON c.C_CURRENT_ADDR_SK = ca.CA_ADDRESS_SK
LEFT JOIN valid_demographics cd ON c.C_CURRENT_CDEMO_SK = cd.CD_DEMO_SK
LEFT JOIN {{source('airbyte_raw', 'household_demographics')}} hd ON c.C_CURRENT_HDEMO_SK = hd.HD_DEMO_SK
LEFT JOIN {{source('airbyte_raw', 'income_band')}} ib ON hd.HD_INCOME_BAND_SK = ib.IB_INCOME_BAND_SK
WHERE c.dbt_valid_to is null