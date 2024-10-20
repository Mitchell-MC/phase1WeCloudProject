{{
      config(
          materialized = 'incremental',
          incremental_strategy='merge',
          unique_key = ['prod_key', 'prod_name', 'vol', 'wgt', 'brand_name', 'status_code', 'status_code_name', 'category_key', 'category_name', 'subcategory_key', 'subcategory_name']
      )
  }}

  {% if is_incremental() %}

    {% set MAX_START_DATE_query %}
      select ifnull(max(start_date), '1900-01-01') from {{this}} as MAX_START_DT
    {% endset %}

    {% if execute %}
      {% set MAX_START_DT = run_query(MAX_START_DATE_query).columns[0][0] %}
    {% endif %}

  {% endif %}

  select 
      prod_key,
      prod_name,
      vol,
      wgt,
      brand_name,
      status_code,
      status_code_name,
      category_key,
      category_name,
      subcategory_key,
      subcategory_name,
      sysdate() as start_date
  from 
      {{ source('raw', 'product') }}
  where 1=1
      {% if is_incremental() %}
          and start_date >= '{{ MAX_START_DT }}'
      {% endif %}