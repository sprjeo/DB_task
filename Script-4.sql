CREATE SCHEMA IF NOT EXISTS Sales;

CREATE TABLE Sales.Customers 
( 
  custid       SERIAL       NOT NULL, 
  companyname  VARCHAR(40)  NOT NULL, 
  contactname  VARCHAR(30)  NOT NULL, 
  city         VARCHAR(15)  NOT NULL, 
  region       VARCHAR(15)  NULL, 
  postalcode   VARCHAR(10)  NULL, 
  country      VARCHAR(15)  NOT NULL, 
  CONSTRAINT PK_Customers PRIMARY KEY(custid) 
);


CREATE TABLE Sales.Shippers 
( 
  shipperid   SERIAL       NOT NULL, 
  companyname VARCHAR(40)  NOT NULL, 
  phone       VARCHAR(24)  NOT NULL, 
  CONSTRAINT PK_Shippers PRIMARY KEY(shipperid) 
);

CREATE TABLE Sales.Orders 
( 
  orderid        SERIAL       NOT NULL, 
  custid         INTEGER      NULL, 
  empid          INTEGER      NOT NULL, 
  orderdate      TIMESTAMP    NOT NULL, 
  requireddate   TIMESTAMP    NOT NULL, 
  shippeddate    TIMESTAMP    NULL, 
  shipperid      INTEGER      NOT NULL, 
  freight        NUMERIC(10,2) NOT NULL,
  shippostalcode VARCHAR(10)  NULL, 
  shipcountry    VARCHAR(15)  NOT NULL, 
  CONSTRAINT PK_Orders PRIMARY KEY(orderid), 
  CONSTRAINT FK_Orders_Customers FOREIGN KEY(custid) 
    REFERENCES Sales.Customers(custid),
  CONSTRAINT FK_Orders_Shippers FOREIGN KEY(shipperid)
    REFERENCES Sales.Shippers(shipperid)
);


CREATE TABLE Sales.OrderDetails 
( 
  orderid   INTEGER       NOT NULL, 
  productid INTEGER       NOT NULL, 
  unitprice NUMERIC(10,2) NOT NULL,
  qty       INTEGER       NOT NULL DEFAULT 1, 
  discount  NUMERIC(4, 3) NOT NULL DEFAULT 0, 
  CONSTRAINT PK_OrderDetails PRIMARY KEY(orderid, productid), 
  CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(orderid) 
    REFERENCES Sales.Orders(orderid)
);


SELECT *
FROM Sales.Orders
WHERE orderdate BETWEEN '2024-02-02' AND '2024-07-07';

SELECT 
    shipcountry,
    AVG(freight) AS avg_freight
FROM 
    Sales.Orders
WHERE 
    orderdate >= '2023-01-01' AND orderdate < '2024-01-01'
GROUP BY 
    shipcountry
ORDER BY 
    avg_freight DESC
LIMIT 5;


SELECT 
    c.custid,
    c.companyname,
    c.contactname,
    COUNT(DISTINCT o.orderid) AS total_orders,
    SUM(od.qty) AS total_products
FROM 
    Sales.Customers c
LEFT JOIN 
    Sales.Orders o ON c.custid = o.custid
LEFT JOIN 
    Sales.OrderDetails od ON o.orderid = od.orderid
WHERE 
    c.country = 'China'
GROUP BY 
    c.custid, c.companyname, c.contactname
ORDER BY 
    total_orders DESC, total_products DESC;


SELECT 
    c.custid,
    c.companyname,
    c.contactname,
    o.orderid,
    o.orderdate,
    o.freight
FROM 
    Sales.Customers c
LEFT JOIN 
    Sales.Orders o ON c.custid = o.custid
ORDER BY 
    c.companyname, o.orderdate DESC;



SELECT *
FROM Sales.Orders
WHERE orderdate = (SELECT MAX(orderdate) FROM Sales.Orders);



SELECT DISTINCT c.custid, c.companyname, c.contactname
FROM Sales.Customers c
JOIN Sales.Orders o2024 ON c.custid = o2024.custid
WHERE EXTRACT(YEAR FROM o2024.orderdate) = 2024
  AND c.custid NOT IN (
      SELECT DISTINCT custid
      FROM Sales.Orders
      WHERE EXTRACT(YEAR FROM orderdate) = 2023
  )
ORDER BY c.companyname;



DELETE FROM sales.orders
WHERE orderdate < '2020-08-01'
AND custid IN (
    SELECT custid 
    FROM sales.customers 
    WHERE country = 'Canada'
);









