from app.core.database import get_db_connection

def print_table_contents(table_name):
    """Print all rows from a specified table"""
    with get_db_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(f"SELECT * FROM {table_name}")
            rows = cursor.fetchall()
            
            print(f"\n📋 Table: {table_name}")
            print("-" * 40)
            
            if not rows:
                print("No data found")
                return
                
            # Print column headers
            columns = [description[0] for description in cursor.description]
            print("|".join(columns))
            print("-" * 40)
            
            # Print rows
            for row in rows:
                print("|".join(str(x) for x in row))
                
        except sqlite3.Error as e:
            print(f"Error reading table {table_name}: {str(e)}")

if __name__ == "__main__":
    tables = [
        'users',
        'product',
        'order_details',
        'payment_details',
        'discount',
        'cart_item'
    ]
    
    print("🛒 Ecommerce Database Contents 🛒")
    for table in tables:
        print_table_contents(table)