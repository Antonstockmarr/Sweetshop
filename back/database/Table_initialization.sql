-- DDL generated by Postico 1.5.13
-- Not all database features are supported. Do not use for backup.

-- Table Definition ----------------------------------------------

CREATE TABLE "Users" (
    id integer DEFAULT nextval('"Users_id_seq"'::regclass) PRIMARY KEY,
    name character varying(50),
    email character varying(50) NOT NULL UNIQUE
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX "Users_pkey" ON "Users"(id int4_ops);
CREATE UNIQUE INDEX "Users_email_key" ON "Users"(email text_ops);



-- DDL generated by Postico 1.5.13
-- Not all database features are supported. Do not use for backup.

-- Table Definition ----------------------------------------------

CREATE TABLE "Items" (
    id integer DEFAULT nextval('"Items_id_seq"'::regclass) PRIMARY KEY,
    name character varying(50),
    description character varying(200),
    price integer,
    currency character varying(10),
    quantity integer CHECK (quantity >= 0),
    archived boolean NOT NULL DEFAULT false
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX "Items_pkey" ON "Items"(id int4_ops);

-- DDL generated by Postico 1.5.13
-- Not all database features are supported. Do not use for backup.

-- Table Definition ----------------------------------------------

CREATE TABLE "Orders" (
    id integer DEFAULT nextval('"Orders_id_seq"'::regclass) PRIMARY KEY,
    "user" integer REFERENCES "Users"(id) ON DELETE SET NULL ON UPDATE CASCADE,
    order_time date
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX "Orders_pkey" ON "Orders"(id int4_ops);



CREATE TABLE "Order_Items" (
    "orderId" integer REFERENCES "Orders"(id) ON DELETE CASCADE ON UPDATE CASCADE,
    "itemId" integer REFERENCES "Items"(id) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity text,
    PRIMARY KEY ("orderId","itemId")
);


CREATE UNIQUE INDEX "Order_Items_pkey" ON "Order_Items"("orderId" int4_ops);
CREATE UNIQUE INDEX "Order_Items_itemId_key" ON "Order_Items"("itemId" int4_ops);


-- DDL generated by Postico 1.5.13
-- Not all database features are supported. Do not use for backup.

-- Table Definition ----------------------------------------------

CREATE TABLE "Temporary_Order" (
    "itemId" integer PRIMARY KEY,
    amount integer NOT NULL
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX "Temporary_Order_pkey" ON "Temporary_Order"("itemId" int4_ops);


-- DDL generated by Postico 1.5.13
-- Not all database features are supported. Do not use for backup.

-- Table Definition ----------------------------------------------

CREATE VIEW "User_Orders" AS  SELECT "Users".id AS userid,
    "Orders".id AS orderid,
    "Orders".order_time,
    string_agg("Items".name::text, ','::text) AS items,
    string_agg("Order_Items".quantity::text, ','::text) AS amounts,
    sum("Order_Items".quantity * "Items".price)::integer AS total_price
   FROM "Users"
     JOIN "Orders" ON "Users".id = "Orders"."user"
     JOIN "Order_Items" ON "Order_Items"."orderId" = "Orders".id
     JOIN "Items" ON "Order_Items"."itemId" = "Items".id
  GROUP BY "Users".id, "Orders".id
  ORDER BY "Users".id;

