-- SQLite Schema for Ecommerce Database

-- 1) discount
CREATE TABLE IF NOT EXISTS discount (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  name             TEXT NOT NULL,
  "desc"           TEXT,
  discount_percent REAL DEFAULT 0.00,
  active           BOOLEAN DEFAULT TRUE,
  created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at       TIMESTAMP NULL
);

-- 2) product_category
CREATE TABLE IF NOT EXISTS product_category (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  "desc"      TEXT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at  TIMESTAMP NULL
);

-- 3) product_inventory
CREATE TABLE IF NOT EXISTS product_inventory (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  quantity    INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at  TIMESTAMP NULL
);

-- 4) users
CREATE TABLE IF NOT EXISTS users (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  username    TEXT NOT NULL UNIQUE,
  "password"  TEXT NOT NULL,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  telephone   TEXT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5) user_payment
CREATE TABLE IF NOT EXISTS user_payment (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id      INTEGER NOT NULL,
  payment_type TEXT NOT NULL,
  provider     TEXT,
  account_no   TEXT,
  expiry       DATE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6) user_address
CREATE TABLE IF NOT EXISTS user_address (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id       INTEGER NOT NULL,
  address_line1 TEXT,
  address_line2 TEXT,
  city          TEXT,
  postal_code   TEXT,
  country       TEXT,
  telephone     TEXT,
  mobile        TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 7) shopping_session
CREATE TABLE IF NOT EXISTS shopping_session (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER NOT NULL,
  total       REAL DEFAULT 0.00,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 8) product
CREATE TABLE IF NOT EXISTS product (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  name         TEXT NOT NULL,
  "desc"       TEXT,
  SKU          TEXT UNIQUE,
  category_id  INTEGER NOT NULL,
  inventory_id INTEGER NOT NULL,
  price        REAL DEFAULT 0.00,
  discount_id  INTEGER,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at   TIMESTAMP NULL,
  FOREIGN KEY (category_id) REFERENCES product_category(id) ON DELETE RESTRICT,
  FOREIGN KEY (inventory_id) REFERENCES product_inventory(id) ON DELETE RESTRICT,
  FOREIGN KEY (discount_id) REFERENCES discount(id) ON DELETE SET NULL
);

-- 9) cart_item
CREATE TABLE IF NOT EXISTS cart_item (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id  INTEGER NOT NULL,
  product_id  INTEGER NOT NULL,
  quantity    INTEGER NOT NULL DEFAULT 1,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES shopping_session(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE RESTRICT
);

-- 10) order_details
CREATE TABLE IF NOT EXISTS order_details (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER NOT NULL,
  total       REAL DEFAULT 0.00,
  payment_id  INTEGER,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at  TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (payment_id) REFERENCES user_payment(id) ON DELETE SET NULL
);

-- 11) payment_details
CREATE TABLE IF NOT EXISTS payment_details (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id    INTEGER NOT NULL,
  amount      REAL NOT NULL,
  provider    TEXT,
  status      TEXT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES order_details(id) ON DELETE CASCADE
);

-- 12) order_items
CREATE TABLE IF NOT EXISTS order_items (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id    INTEGER NOT NULL,
  product_id  INTEGER NOT NULL,
  quantity    INTEGER NOT NULL DEFAULT 1,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES order_details(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE RESTRICT
);