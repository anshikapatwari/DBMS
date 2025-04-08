'''DBMS_Project BTech AI&DS 2nd Year
Whiskey & Wool (Men Clothing Store)
Anshika Patwari (A007)
Riyansh Saxena (A024)
Aarchi Porwal (A002)
'''
import mysql.connector
import random
import string
import datetime

def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="*******",
        database="project"
    )

def view_all_products(cursor):
    cursor.execute("SELECT * FROM products")
    rows = cursor.fetchall()
    print("\n--- All Products ---")
    for row in rows:
        print(f"ID: {row[0]} | Name: {row[1]} | Price: ₹{row[3]} | Size: {row[4]} | Color: {row[5]} | Desc: {row[2]}")

def search_product_by_name(cursor):
    name = input("Enter product name to search: ").strip()
    cursor.execute("SELECT * FROM products WHERE name LIKE %s", (f"%{name}%",))
    rows = cursor.fetchall()
    if not rows:
        print("❌ Sorry! we don't have this in stock.")
    else:
        for row in rows:
            print(f"ID: {row[0]} | Name: {row[1]} | Price: ₹{row[3]} | Size: {row[4]} | Color: {row[5]} | Desc: {row[2]}")

def add_to_cart(cursor, conn, user_id):
    cursor.execute("SELECT cart_id FROM cart WHERE user_id = %s", (user_id,))
    cart = cursor.fetchone()
    if not cart:
        cursor.execute("INSERT INTO cart (user_id) VALUES (%s)", (user_id,))
        conn.commit()
        cursor.execute("SELECT cart_id FROM cart WHERE user_id = %s", (user_id,))
        cart = cursor.fetchone()
    cart_id = cart[0]

    while True:
        product_name = input("Enter product name to add: ").strip()
        cursor.execute("SELECT product_id, name, description, price, size, color FROM products WHERE name LIKE %s", (f"%{product_name}%",))
        result = cursor.fetchone()

        if not result:
            print("❌ Sorry! we don't have this in stock.")
        else:
            product_id, name, description, price, sizes, color = result
            print(f"✔️ Found: {name} | ₹{price} | Sizes: {sizes} | Color: {color}")

            if sizes.lower() == "standard":
                size = "Standard"
                print("ℹ️ Size is standard, adding directly to cart.")
            else:
                size = input(f"Enter size to add (from available: {sizes}): ").strip()

            cursor.execute("""
                INSERT INTO cart_item (cart_id, product_id, size, price)
                VALUES (%s, %s, %s, %s)
            """, (cart_id, product_id, size, price))
            conn.commit()
            print("✅ Item added to cart.")

        more = input("Add more? (y/n): ").lower()
        if more != 'y':
            break

def view_cart(cursor, user_id):
    cursor.execute("SELECT cart_id FROM cart WHERE user_id = %s", (user_id,))
    cart = cursor.fetchone()
    if not cart:
        print("🛒 Your cart is empty.")
        return

    cart_id = cart[0]
    cursor.execute("""
        SELECT p.name, p.description, c.price, c.size, p.color
        FROM cart_item c
        JOIN products p ON c.product_id = p.product_id
        WHERE c.cart_id = %s
    """, (cart_id,))
    items = cursor.fetchall()
    print("\n🛒 Cart Items:")
    if not items:
        print("Your cart is empty.")
    else:
        for item in items:
            print(f"{item[0]} | ₹{item[2]} | Size: {item[3]} | Color: {item[4]} | {item[1]}")

def is_cart_empty(cursor, cart_id):
    cursor.execute("SELECT COUNT(*) FROM cart_item WHERE cart_id = %s", (cart_id,))
    return cursor.fetchone()[0] == 0

def place_order(cursor, conn, user_id):
    cursor.execute("SELECT cart_id FROM cart WHERE user_id = %s", (user_id,))
    cart = cursor.fetchone()
    if not cart:
        print("🛒 No cart found.")
        return
    cart_id = cart[0]

    if is_cart_empty(cursor, cart_id):
        print("❌ Cannot place order. Cart is empty.")
        return

    cursor.execute("SELECT SUM(price) FROM cart_item WHERE cart_id = %s", (cart_id,))
    total_amount = cursor.fetchone()[0] or 0

    order_time = datetime.datetime.now()
    order_status = "Order Placed"

    # Step 1: Temporarily insert the order with delivery_id as NULL
    cursor.execute("""
        INSERT INTO orders (user_id, total_amount, order_date_time, status)
        VALUES (%s, %s, %s, %s)
    """, (user_id, total_amount, order_time, order_status))
    conn.commit()

    cursor.execute("SELECT LAST_INSERT_ID()")
    order_id = cursor.fetchone()[0]

    # Step 2: Create delivery info
    status_options = ["shipped", "out for delivery", "in process"]
    status = random.choice(status_options)
    tracking_number = ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))

    cursor.execute("""
        INSERT INTO delivery (order_id, delivery_status, tracking_number)
        VALUES (%s, %s, %s)
    """, (order_id, status, tracking_number))
    conn.commit()

    cursor.execute("SELECT LAST_INSERT_ID()")
    delivery_id = cursor.fetchone()[0]

    # Step 3: Update the order to link the delivery_id
    cursor.execute("""
        UPDATE orders SET delivery_id = %s WHERE order_id = %s
    """, (delivery_id, order_id))
    conn.commit()

    print(f"📦 Order placed successfully! Order ID: {order_id}, Total: ₹{total_amount}")

    # Payment
    print("\nChoose a payment method:")
    print("1. UPI")
    print("2. Credit Card")
    print("3. Debit Card")
    print("4. Cash on Delivery")
    pay_choice = input("Enter choice (1-4): ")

    methods = {"1": "UPI", "2": "Credit Card", "3": "Debit Card", "4": "Cash on Delivery"}
    payment_method = methods.get(pay_choice, "UPI")
    payment_status = "Successful"

    cursor.execute("""
        INSERT INTO payment (order_id, payment_method, payment_status)
        VALUES (%s, %s, %s)
    """, (order_id, payment_method, payment_status))
    conn.commit()

    print(f"💳 Payment Done via {payment_method} | Status: {payment_status}")

    # Clear cart
    cursor.execute("DELETE FROM cart_item WHERE cart_id = %s", (cart_id,))
    conn.commit()
    print("🛒 Cart has been emptied.")

    view_cart(cursor, user_id)

def view_orders(cursor, user_id):
    cursor.execute("SELECT name FROM user WHERE user_id = %s", (user_id,))
    user_name = cursor.fetchone()[0]
    cursor.execute("SELECT order_id, order_date_time, total_amount, status FROM orders WHERE user_id = %s", (user_id,))
    orders = cursor.fetchall()
    print("\n📋 Your Orders:")
    for order in orders:
        print(f"Order ID: {order[0]} | User ID: {user_id} | Name: {user_name} | Date: {order[1]} | Total: ₹{order[2]} | Status: {order[3]}")

def view_payment_status(cursor, user_id):
    cursor.execute("""
        SELECT p.order_id, p.payment_method, p.payment_status
        FROM payment p
        JOIN orders o ON p.order_id = o.order_id
        WHERE o.user_id = %s
    """, (user_id,))
    payments = cursor.fetchall()
    print("\n💳 Payment Status:")
    for payment in payments:
        print(f"Order ID: {payment[0]} | Method: {payment[1]} | Status: {payment[2]}")

def track_order(cursor, conn, user_id):
    order_id = input("Enter your Order ID: ").strip()
    cursor.execute("SELECT * FROM delivery WHERE order_id = %s", (order_id,))
    existing = cursor.fetchone()

    if existing:
        print(f"🚚 Order {order_id} is '{existing[2]}' | Tracking Number: {existing[3]} | Delivery ID: {existing[0]}")
    else:
        status_options = ["shipped", "out for delivery", "in process"]
        status = random.choice(status_options)
        tracking_number = ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))

        # Insert delivery record
        cursor.execute("""
            INSERT INTO delivery (order_id, delivery_status, tracking_number)
            VALUES (%s, %s, %s)
        """, (order_id, status, tracking_number))
        conn.commit()

        # Get the delivery_id just inserted
        cursor.execute("SELECT delivery_id FROM delivery WHERE order_id = %s", (order_id,))
        delivery_id = cursor.fetchone()[0]

        # 🔁 Update orders table with delivery_id
        cursor.execute("UPDATE orders SET delivery_id = %s WHERE order_id = %s", (delivery_id, order_id))
        conn.commit()

        print(f"🚚 Order {order_id} is '{status}' | Tracking Number: {tracking_number} | Delivery ID: {delivery_id}")

def products_menu(cursor, conn, user_id):
    while True:
        print("\n--- Products Menu ---")
        print("1. View All Products")
        print("2. Search Product")
        print("3. Add to Cart")
        print("4. Back to Main Menu")
        choice = input("Enter choice: ")

        if choice == '1':
            view_all_products(cursor)
        elif choice == '2':
            search_product_by_name(cursor)
        elif choice == '3':
            add_to_cart(cursor, conn, user_id)
        elif choice == '4':
            break
        else:
            print("Invalid option.")

def cart_menu(cursor, conn, user_id):
    while True:
        print("\n--- Cart Menu ---")
        print("1. View Cart")
        print("2. Place Order")
        print("3. Back to Main Menu")
        choice = input("Enter choice: ")

        if choice == '1':
            view_cart(cursor, user_id)
        elif choice == '2':
            place_order(cursor, conn, user_id)
        elif choice == '3':
            break
        else:
            print("Invalid option.")

def main():
    conn = connect_db()
    cursor = conn.cursor()

    user_id = 10001
    while True:
        print("\n====== Main Menu ======")
        print("1. View Products")
        print("2. View Orders")
        print("3. Track Orders")
        print("4. Payment Status")
        print("5. Go to Cart")
        print("6. Exit")
        choice = input("Enter choice: ")

        if choice == '1':
            products_menu(cursor, conn, user_id)
        elif choice == '2':
            view_orders(cursor, user_id)
        elif choice == '3':
            track_order(cursor, conn, user_id)
        elif choice == '4':
            view_payment_status(cursor, user_id)
        elif choice == '5':
            cart_menu(cursor, conn, user_id)
        elif choice == '6':
            print("Thank you for visiting Whiskey & Wool!")
            break
        else:
            print("Invalid choice.")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    print("Welcome To Whiskey & Wool")
    main()
