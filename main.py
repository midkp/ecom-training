from app.core.database import initialize_database, insert_test_data

if __name__ == "__main__":
    print("Initializing database...")
    initialize_database()
    
    print("Inserting test data...")
    insert_test_data()
    
    print("Process completed. Verify data using:")
    print("1. SQLite Viewer extension in VSCode")
    print("2. Or run: python verify_data.py")