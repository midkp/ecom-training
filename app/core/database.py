import sqlite3
import os
from dotenv import load_dotenv


load_dotenv()

DB_PATH = os.getenv("DB_NAME")

def get_db_connection():
    """Create and return a SQLite database connection"""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")  # Enable foreign key constraints
    return conn

def initialize_database():
    """Create database tables from schema.sql"""
    conn = get_db_connection()
    try:
        with open('app/core/schema.sql', 'r') as f:
            schema = f.read()
        conn.executescript(schema)
        conn.commit()
        print("Database tables created successfully!")
    except Exception as e:
        print(f"Error initializing database: {str(e)}")
    finally:
        conn.close()

def insert_test_data():
    """Insert sample data for testing"""
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
         # List of parameterized SQL queries
        queries = [
            ('''INSERT INTO discount (name, "desc", discount_percent, active)
                VALUES (?, ?, ?, ?)''',
             ('Thanksgiving Sale', 'TG offers 2024', 25.00, True)),
            
            ('''INSERT INTO product_category (name, "desc")
                VALUES (?, ?)''',
             ('Books', 'All books')),
            
            ('''INSERT INTO product_inventory (quantity) VALUES (?)''',
             (100,)),
            
            ('''INSERT INTO users (username, "password", first_name, last_name, telephone)
                VALUES (?, ?, ?, ?, ?)''',
             ('midkp', '1234', 'mid', 'kp', '423-653-7595')),
            
            ('''INSERT INTO user_payment (user_id, payment_type, provider, account_no, expiry)
                VALUES (?, ?, ?, ?, ?)''',
             (1, 'Credit Card', 'VISA', '1111-2222-3333-4444', '2030-01-01')),
            
            ('''INSERT INTO user_address (user_id, address_line1, address_line2, city, postal_code, country, telephone, mobile)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)''',
             (1, '100 main st', 'Greenville', 'SC', '29306', 'USA', '123-123-1234', '321-321-3210')),
            
            ('''INSERT INTO shopping_session (user_id, total) VALUES (?, ?)''',
             (1, 10.00)),
            
            ('''INSERT INTO product (name, "desc", SKU, category_id, inventory_id, price, discount_id)
                VALUES (?, ?, ?, ?, ?, ?, ?)''',
             ('Lord of the flies', 'Novel', 'SKU1', 1, 1, 99.99, 1)),  # Fixed discount_id
            
            ('''INSERT INTO cart_item (session_id, product_id, quantity) VALUES (?, ?, ?)''',
             (1, 1, 1)),
            
            ('''INSERT INTO order_details (user_id, total, payment_id) VALUES (?, ?, ?)''',
             (1, 99.99, 1)),
            
            ('''INSERT INTO payment_details (order_id, amount, provider, status)
                VALUES (?, ?, ?, ?)''',
             (1, 99.99, 'VISA', 'Completed')),
            
            ('''INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)''',
             (1, 1, 1))
        ]

        for query, params in queries:
            cursor.execute(query, params)
            
        conn.commit()
        print("Test data inserted successfully!")
    except sqlite3.Error as e:
        conn.rollback()
        print(f"Error inserting test data: {str(e)}")
    finally:
        cursor.close()
        conn.close()