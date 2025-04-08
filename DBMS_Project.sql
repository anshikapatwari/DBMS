create database project;
use project;

create table user(user_id int(5) primary key, name varchar(20) not null, email varchar(50) not null,phone_no int(10) not null,address varchar(100) not null);
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    size VARCHAR(50),
    color VARCHAR(50),
    stock_quantity INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date_time DATETIME,
    total_amount DECIMAL(10, 2),
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE delivery (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    delivery_status VARCHAR(50),
    tracking_number VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE cart_item (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT,
    product_id INT,
    size VARCHAR(50),
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

ALTER TABLE user
MODIFY phone_no VARCHAR(15);

INSERT INTO user (user_id, name, email, phone_no, address)
VALUES (10001, 'Aurthur Morgan', 'arthur.morgan1899@vanhornmail.com', '9876543210', 'Cabin #3, Horseshoe Overlook , Grizzlies East, NH 34201 New Hanover, USA');

INSERT INTO category (category_id, category_name) VALUES
(1, 'Shirt'),
(2, 'T-Shirt'),
(3, 'Hoodies'),
(4, 'Jeans'),
(5, 'Trousers'),
(6, 'Shorts'),
(7, 'Sneakers'),
(8, 'Sport Shoes'),
(9, 'Boots'),
(10, 'Watches'),
(11, 'Belts'),
(12, 'Wallet');

INSERT INTO products (product_id, name, description, price, size, color, stock_quantity, category_id) VALUES
(1, 'Formal Shirt', 'Classic formal shirt for men', 1199.00, 'M,L,XL', 'White', 50, 1),
(2, 'Casual Shirt', 'Cotton casual shirt for daily wear', 999.00, 'M,L,XL', 'Blue', 60, 1),
(3, 'Striped Shirt', 'Striped pattern shirt', 1299.00, 'S,M,L', 'Black', 40, 1),
(4, 'Slim Fit Shirt', 'Slim fit party shirt', 1399.00, 'M,L,XL', 'Maroon', 30, 1),
(5, 'Printed T-Shirt', 'Printed cotton t-shirt', 799.00, 'M,L,XL', 'Red', 70, 2),
(6, 'Basic T-Shirt', 'Everyday t-shirt for comfort', 599.00, 'S,M,L,XL,XXL', 'Grey', 80, 2),
(7, 'Graphic T-Shirt', 'Cool graphic tee for teens', 899.00, 'M,L,XL', 'Black', 55, 2),
(8, 'Round Neck T-Shirt', 'Comfy round neck tee', 699.00, 'M,L,XL', 'Green', 45, 2),
(9, 'Zipper Hoodie', 'Warm fleece zipper hoodie', 1499.00, 'M,L,XL', 'Navy Blue', 40, 3),
(10, 'Pullover Hoodie', 'Soft pullover hoodie', 1399.00, 'S,M,L', 'Green', 35, 3),
(11, 'Oversized Hoodie', 'Trendy oversized hoodie', 1599.00, 'M,L,XL', 'Beige', 25, 3),
(12, 'Winter Hoodie', 'Thick winter wear hoodie', 1799.00, 'M,L', 'Grey', 30, 3),
(13, 'Skinny Jeans', 'Stretchy skinny-fit jeans', 1699.00, '28,30,32,34', 'Dark Blue', 45, 4),
(14, 'Straight Jeans', 'Straight cut denim jeans', 1899.00, '30,32,34,36', 'Blue', 38, 4),
(15, 'Ripped Jeans', 'Ripped look denim', 1999.00, '30,32,34', 'Black', 28, 4),
(16, 'Slim Fit Jeans', 'Modern slim fit jeans', 1599.00, '30,32,34', 'Grey', 36, 4),
(17, 'Formal Trousers', 'Classic office trousers', 1499.00, '30,32,34,36', 'Black', 50, 5),
(18, 'Casual Trousers', 'Casual cotton trousers', 1299.00, '30,32,34', 'Olive', 45, 5),
(19, 'Chinos', 'Smart chinos for work & casual', 1399.00, '30,32,34', 'Khaki', 40, 5),
(20, 'Slim Fit Trousers', 'Slim cut comfortable trousers', 1499.00, '30,32,34,36', 'Navy', 35, 5),
(21, 'Cargo Shorts', 'Multi-pocket cargo shorts', 999.00, '30,32,34', 'Army Green', 25, 6),
(22, 'Denim Shorts', 'Classic denim shorts', 1099.00, 'S,M,L', 'Blue', 30, 6),
(23, 'Sports Shorts', 'Lightweight gym shorts', 799.00, 'S,M,L', 'Black', 40, 6),
(24, 'Cotton Shorts', 'Casual soft shorts', 899.00, 'M,L', 'Grey', 20, 6),
(25, 'Running Sneakers', 'Lightweight running shoes', 2499.00, '7,8,9,10', 'Black', 50, 7),
(26, 'White Sneakers', 'Casual white sneakers', 2199.00, '6,7,8,9', 'White', 60, 7),
(27, 'High Top Sneakers', 'Trendy high top sneakers', 2699.00, '8,9,10', 'Red', 25, 7),
(28, 'Canvas Sneakers', 'Classic canvas shoes', 1899.00, '6,7,8,9', 'Navy', 30, 7),
(29, 'Running Sport Shoes', 'Performance running shoes', 2999.00, '7,8,9,10', 'Grey', 45, 8),
(30, 'Training Sport Shoes', 'Shoes for training/gym', 2799.00, '7,8,9', 'Black', 40, 8),
(31, 'Outdoor Sport Shoes', 'All-terrain sport shoes', 3199.00, '8,9,10', 'Brown', 20, 8),
(32, 'Cushioned Sport Shoes', 'Extra cushioned sole shoes', 2899.00, '7,8,9,10', 'Blue', 35, 8),
(33, 'Leather Boots', 'Genuine leather boots', 3499.00, '7,8,9,10', 'Brown', 30, 9),
(34, 'Ankle Boots', 'Stylish ankle-length boots', 3299.00, '6,7,8,9', 'Black', 28, 9),
(35, 'Combat Boots', 'Rugged outdoor boots', 3799.00, '8,9,10', 'Army Green', 20, 9),
(36, 'Chelsea Boots', 'Slip-on chelsea boots', 3599.00, '7,8,9', 'Tan', 18, 9),
(37, 'Digital Watch', 'Waterproof digital watch', 1999.00, 'Standard', 'Black', 45, 10),
(38, 'Analog Watch', 'Leather strap analog watch', 2499.00, 'Standard', 'Brown', 40, 10),
(39, 'Smart Watch', 'Bluetooth-enabled smart watch', 3999.00, 'Standard', 'Black', 30, 10),
(40, 'Luxury Watch', 'Premium dial luxury watch', 5999.00, 'Standard', 'Gold', 10, 10),
(41, 'Leather Belt', 'Genuine leather formal belt', 799.00, 'M,L,XL', 'Black', 50, 11),
(42, 'Canvas Belt', 'Casual canvas belt', 599.00, 'M,L', 'Beige', 45, 11),
(43, 'Braided Belt', 'Braided texture belt', 699.00, 'M,L,XL', 'Brown', 35, 11),
(44, 'Double Pin Belt', 'Rugged belt with double pin buckle', 899.00, 'L,XL', 'Tan', 25, 11),
(45, 'Leather Wallet', 'Bi-fold leather wallet', 999.00, 'Standard', 'Brown', 60, 12),
(46, 'Slim Wallet', 'Slim wallet with card slots', 799.00, 'Standard', 'Black', 50, 12),
(47, 'Zip Wallet', 'Wallet with zipper compartment', 1099.00, 'Standard', 'Navy', 40, 12),
(48, 'RFID Wallet', 'RFID-blocking anti-theft wallet', 1199.00, 'Standard', 'Grey', 30, 12),
(49, 'Vintage Watch', 'Old-style analog dial watch', 2699.00, 'Standard', 'Brown', 20, 10),
(50, 'Classic Jeans', 'Classic straight fit jeans', 1799.00, '30,32,34,36', 'Blue', 50, 4),
(51, 'Graphic Hoodie', 'Cool hoodie with printed design', 1699.00, 'M,L,XL', 'Red', 35, 3),
(52, 'Thermal Hoodie', 'Thermal hoodie for winter', 1899.00, 'M,L', 'Charcoal', 30, 3),
(53, 'Basic Shirt', 'Solid color shirt for daily wear', 1099.00, 'S,M,L', 'Grey', 55, 1),
(54, 'Muscle Fit T-Shirt', 'T-shirt for gym wear', 799.00, 'M,L,XL', 'White', 60, 2),
(55, 'Wide-Leg Trousers', 'Casual wide-leg trousers', 1399.00, '30,32,34', 'Brown', 25, 5),
(56, 'Camouflage Shorts', 'Camo pattern cargo shorts', 999.00, '30,32,34', 'Camouflage', 22, 6),
(57, 'Slip-On Sneakers', 'Slip-on comfort shoes', 1999.00, '6,7,8,9', 'Grey', 30, 7),
(58, 'Trail Sport Shoes', 'Trail running shoes', 3199.00, '7,8,9', 'Orange', 15, 8),
(59, 'Hiking Boots', 'Boots for hiking adventures', 3699.00, '7,8,9,10', 'Olive', 12, 9),
(60, 'Fitness Watch', 'Tracks steps and heart rate', 3499.00, 'Standard', 'Black', 20, 10),
(61, 'Metal Strap Watch', 'Metal strap designer watch', 4599.00, 'Standard', 'Silver', 15, 10),
(62, 'Fabric Belt', 'Stretchable fabric belt', 699.00, 'M,L,XL', 'Navy Blue', 40, 11),
(63, 'Studded Belt', 'Decorative studded belt', 999.00, 'L,XL', 'Black', 20, 11),
(64, 'Card Holder Wallet', 'Slim card holder', 599.00, 'Standard', 'Black', 25, 12),
(65, 'Money Clip Wallet', 'Wallet with money clip', 899.00, 'Standard', 'Brown', 18, 12),
(66, 'Mandarin Shirt', 'Shirt with mandarin collar', 1399.00, 'M,L,XL', 'Olive', 30, 1),
(67, 'Henley T-Shirt', 'Three-button Henley tee', 999.00, 'M,L', 'Blue', 40, 2),
(68, 'Denim Hoodie', 'Hoodie with denim finish', 1899.00, 'L,XL', 'Blue', 25, 3),
(69, 'Bootcut Jeans', 'Bootcut fit denim', 1699.00, '30,32,34', 'Blue', 20, 4),
(70, 'Linen Trousers', 'Light linen summer trousers', 1599.00, '30,32,34', 'White', 18, 5),
(71, 'Sports Shorts 2.0', 'Upgraded gym shorts', 899.00, 'S,M,L', 'Maroon', 30, 6),
(72, 'Streetwear Sneakers', 'Stylish street shoes', 2599.00, '7,8,9', 'White', 20, 7),
(73, 'Pro Running Shoes', 'High-performance runners', 3299.00, '8,9,10', 'Blue', 22, 8),
(74, 'Trekking Boots', 'Durable trekking boots', 3899.00, '8,9,10', 'Brown', 15, 9),
(75, 'Classic Analog Watch', 'Minimal analog wristwatch', 2299.00, 'Standard', 'Black', 30, 10),
(76, 'Double Buckle Belt', 'Unique two-buckle belt', 999.00, 'L,XL', 'Tan', 10, 11),
(77, 'Vintage Wallet', 'Old-school vintage leather wallet', 1299.00, 'Standard', 'Dark Brown', 20, 12),
(78, 'Pop Art T-Shirt', 'Bright pop art design', 1099.00, 'M,L', 'Yellow', 35, 2),
(79, 'Lounge Shorts', 'Comfortable lounge wear', 799.00, 'M,L', 'Teal', 25, 6),
(80, 'Mesh Sneakers', 'Sneakers with breathable mesh', 2099.00, '7,8,9', 'White', 30, 7),
(81, 'Smart Running Shoes', 'Smart features for tracking runs', 3499.00, '8,9,10', 'Black', 18, 8),
(82, 'Urban Boots', 'Trendy city boots', 2999.00, '7,8,9', 'Grey', 12, 9),
(83, 'Modern Analog Watch', 'Elegant analog design', 2699.00, 'Standard', 'Blue', 15, 10),
(84, 'Woven Belt', 'Woven style belt for men', 799.00, 'M,L', 'Brown', 20, 11),
(85, 'Slim RFID Wallet', 'Slim RFID safe wallet', 999.00, 'Standard', 'Navy Blue', 18, 12),
(86, 'Flannel Shirt', 'Warm winter flannel shirt', 1499.00, 'M,L,XL', 'Red', 28, 1),
(87, 'Dry Fit T-Shirt', 'Dry-fit sports tee', 1199.00, 'M,L', 'Green', 25, 2),
(88, 'Zip Hoodie', 'Zip-up comfy hoodie', 1599.00, 'M,L', 'Grey', 20, 3),
(89, 'Distressed Jeans', 'Rugged distressed denim', 1899.00, '30,32,34', 'Black', 15, 4),
(90, 'Pleated Trousers', 'Stylish pleated pants', 1699.00, '30,32,34', 'Beige', 22, 5);

ALTER TABLE cart_item ADD price DECIMAL(10,2);

ALTER TABLE cart_item ADD COLUMN color VARCHAR(50);

ALTER TABLE delivery DROP PRIMARY KEY;
select * from products;
select * from cart_item;
select * from delivery;
select * from payment;
select * from orders;

