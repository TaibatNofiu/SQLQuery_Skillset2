USE CommercialDB

/* 1. Display in descending order of seniority the male employees whose net salary (salary + commission) is greater 
than or equal to 8000. The resulting table should include the following columns: Employee Number, First Name 
and Last Name (using LPAD or RPAD for formatting), Age, and Seniority.*/
	SELECT
		EMPLOYEE_NUMBER,
		LEFT (FIRST_NAME + REPLICATE(' ', 20), 20) AS FirstName,
		LEFT (LAST_NAME + REPLICATE(' ', 20), 20) AS LastName,
		Title,
		Salary,
		DATEDIFF(YEAR, BIRTH_DATE, GETDATE()) AS AGE,
		DATEDIFF(DAY, HIRE_DATE, GETDATE()) AS SENIORITY
	FROM
		EMPLOYEES
	WHERE
		TITLE = 'Dr.' OR TITLE = 'Mr.'
		AND
		(ISNULL(SALARY,0) + ISNULL(COMMISSION, 0)) >= 8000
	GROUP BY EMPLOYEE_NUMBER, FIRST_NAME, LAST_NAME, TITLE, SALARY, BIRTH_DATE, HIRE_DATE
	ORDER BY 
		SENIORITY DESC;

/*2.Display products that meet the following criteria: (C1) quantity is packaged in bottle(s), (C2) the third character in the product name
	is 't' or 'T', (C3) supplied by suppliers 1, 2, or 3, (C4) unit price ranges between 70 and 200, and (C5) units ordered are specified (not null). 
	The resulting table should include the following columns: product number, product name, supplier number, units ordered, and unit price.*/
	SELECT 
		PRODUCT_REF AS [Product Number],
		PRODUCT_NAME AS [Product Name],
		SUPPLIER_NUMBER AS [Supplier Number],
		UNITS_ON_ORDER AS [Units Ordered],
		UNIT_PRICE AS [Unit Price],
		QUANTITY
	FROM PRODUCTS
	WHERE 
		QUANTITY LIKE '%bottle '
		AND	
		PRODUCT_NAME LIKE ('__t%')
		AND 
		SUPPLIER_NUMBER IN (1,2,3)
		AND 
		UNIT_PRICE BETWEEN 70 AND 200
		AND 
		UNITS_ON_ORDER IS NOT NULL;
	
/*3.	Display customers who reside in the same region as supplier 1, meaning they share the same country, city, and the last three digits of the postal code. 
		The query should utilize a single subquery. The resulting table should include all columns from the customer table.*/
	SELECT * FROM 
		CUSTOMERS
	WHERE EXISTS 
	 (SELECT * FROM SUPPLIERS WHERE SUPPLIER_NUMBER = 1
		AND SUPPLIERS.COUNTRY = CUSTOMERS.COUNTRY
		AND SUPPLIERS.CITY = CUSTOMERS.CITY
		AND	RIGHT (SUPPLIERS.POSTAL_CODE, 3) = RIGHT(CUSTOMERS.POSTAL_CODE, 3));

/*4.	For each order number between 10998 and 11003, do the following:  
		-Display the new discount rate, which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000,
		5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise.
		-Display the message "apply old discount rate" if the order number is between 10000 and 10999, and "apply new discount rate" otherwise. 
		The resulting table should display the columns: order number, new discount rate, and discount rate application note.*/

		SELECT 
			ORDER_NUMBER AS [Order Number],
		CASE
			WHEN (UNIT_PRICE * QUANTITY) BETWEEN 0 AND 2000 THEN '0%'
			WHEN (UNIT_PRICE * QUANTITY) BETWEEN 2001 AND 10000 THEN '5%'
			WHEN (UNIT_PRICE * QUANTITY) BETWEEN 10001 AND 40000 THEN '10%'
			WHEN (UNIT_PRICE * QUANTITY) BETWEEN 40001 AND 80000 THEN '15%'
			ELSE '20%'
		END AS [New Discount Rate],
		CASE
			WHEN ORDER_NUMBER BETWEEN 10000 AND 10999 THEN 'Apply Old Discount Rate'
			ELSE 'Apply New Discount Rate'
		END AS [Discount Rate Application Note]
		FROM 
			ORDER_DETAILS
		WHERE 
			ORDER_NUMBER BETWEEN 10998 AND 11003;
		
--5.	Display suppliers of beverage products. The resulting table should display the columns: supplier number, company, address, and phone number.
		SELECT 
			PRODUCTS.SUPPLIER_NUMBER, 
			COMPANY,
			ADDRESS,
			PHONE,
			CATEGORY_NAME 
		FROM 
			SUPPLIERS
			JOIN 
			PRODUCTS 
		ON 
			SUPPLIERS.SUPPLIER_NUMBER = PRODUCTS.SUPPLIER_NUMBER
			JOIN 
			CATEGORIES 
		ON 
			CATEGORIES.CATEGORY_CODE = PRODUCTS.CATEGORY_CODE
		WHERE
			CATEGORY_NAME = 'Beverages'

--6.	Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product. The resulting table should display the column: customer code.
		SELECT 
			CUSTOMERS.CUSTOMER_CODE
		FROM
			CUSTOMERS
			LEFT JOIN
			ORDERS
		ON
			CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
			LEFT JOIN
			ORDER_DETAILS
		ON
			ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
			LEFT JOIN
			PRODUCTS
		ON
			ORDER_DETAILS.PRODUCT_REF = PRODUCTS.PRODUCT_REF
			LEFT JOIN
			CATEGORIES
		ON
			PRODUCTS.CATEGORY_CODE = CATEGORIES.CATEGORY_CODE
		WHERE
			CUSTOMERS.CITY = 'Berlin' 
		GROUP BY CUSTOMERS.CUSTOMER_CODE
		HAVING SUM(CASE WHEN CATEGORIES.CATEGORY_NAME = 'Desserts' THEN 1 ELSE 0 END) <= 1;

/*7.	Display customers who reside in France and the total amount of orders they placed every Monday in April 1998 (considering customers 
		who haven't placed any orders yet). The resulting table should display the columns: customer number, company name, phone number,
		total amount, and country.*/
		SELECT 
			CUSTOMERS.CUSTOMER_CODE AS [Customer Number],
			COMPANY AS [Company Name],
			PHONE AS [Phone Number],
			ORDERS.ORDER_NUMBER AS [Total Orders],
			COUNTRY
		FROM 
			CUSTOMERS
			LEFT JOIN
			ORDERS
		ON
			CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
		WHERE
			COUNTRY = 'France'
			AND
			(ORDER_DATE IS NULL
			OR
			(YEAR(ORDER_DATE) = 1998
			AND MONTH(ORDER_DATE) = 4
			AND DATENAME(WEEKDAY, ORDER_DATE) = 'Monday'))
		GROUP BY CUSTOMERS.CUSTOMER_CODE, COMPANY, PHONE, COUNTRY, ORDERS.ORDER_NUMBER
		ORDER BY CUSTOMERS.CUSTOMER_CODE;

			SELECT * FROM PRODUCTS

--8.	Display customers who have ordered all products. The resulting table should display the columns: customer code, company name, and telephone number.
		SELECT 
			CUSTOMERS.CUSTOMER_CODE AS [Customer Code],
			COMPANY AS [Company Name],
			PHONE AS [Telephone Number]
		FROM 
			CUSTOMERS
		CUSTOMERS
			JOIN
			ORDERS
		ON
			CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
			JOIN
			ORDER_DETAILS
		ON
			ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
		GROUP BY 
			CUSTOMERS.CUSTOMER_CODE,
			CUSTOMERS.COMPANY,
			PHONE
		HAVING
			COUNT(DISTINCT ORDER_DETAILS.PRODUCT_REF) = (SELECT COUNT(DISTINCT PRODUCT_REF) FROM PRODUCTS);

/*9.	 Display for each customer from France the number of orders they have placed. The resulting table should display the columns: 
		 customer code and number of orders.*/
		 SELECT 
			ORDERS.CUSTOMER_CODE AS [Customer Code],
			COUNT (ORDER_DETAILS.QUANTITY) AS [Number of Orders]
		FROM 
			CUSTOMERS
			LEFT JOIN
			ORDERS
		ON
			CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
			LEFT JOIN
			ORDER_DETAILS
		ON
			ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
		WHERE 
			COUNTRY = 'FRANCE'
		GROUP BY
			ORDERS.CUSTOMER_CODE
		ORDER BY
			COUNT (ORDER_DETAILS.QUANTITY) DESC;

/*10.	Display the number of orders placed in 1996, the number of orders placed in 1997, and the difference between these two numbers. 
		The resulting table should display the columns: orders in 1996, orders in 1997, and Difference.*/
		SELECT 
			SUM(CASE WHEN YEAR(order_date) = 1996 THEN 1 ELSE 0 END) AS [Orders in 1996],
			SUM(CASE WHEN YEAR(order_date) = 1997 THEN 1 ELSE 0 END) AS [Orders in 1997],
			ABS(SUM(CASE WHEN YEAR(order_date) = 1996 THEN 1 ELSE 0 END) - 
			SUM(CASE WHEN YEAR(order_date) = 1997 THEN 1 ELSE 0 END)) AS Difference
		FROM 
			ORDERS;
