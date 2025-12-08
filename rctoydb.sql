-- ==========================================
-- 1. 初始化資料庫 (每次執行都會重置)
-- ==========================================
DROP DATABASE IF EXISTS rc_toy_shop;
CREATE DATABASE rc_toy_shop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE rc_toy_shop;

-- ==========================================
-- 2. 建立資料表結構 (Schema)
-- ==========================================

-- (1) 使用者 (Users)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- 暫存明文，未來接 Spring Security 改存 Hash
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    birthday DATE,
    role ENUM('ADMIN', 'USER') DEFAULT 'USER', -- 權限控管
    status ENUM('ACTIVE', 'DISABLED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- (2) 商品 (Products) - 包含 GK 模型專用欄位
CREATE TABLE products (
    id VARCHAR(50) PRIMARY KEY, -- 商品 ID (如 'gundam-rx-78-2')
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    stock INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'available', -- 上架狀態
    category_id VARCHAR(50), -- 分類 (gundam, onepiece...)
    
    -- ★★★ 前端篩選用欄位 ★★★
    tag VARCHAR(20),         -- 標籤 (new, 預購, 現貨)
    type VARCHAR(20),        -- 類型 (model, figure, prize, blindbox)
    
    -- ★★★ GK / 公仔詳情專用欄位 ★★★
    studio VARCHAR(100),     -- 工作室 (e.g. Bandai, YZ Studio)
    scale VARCHAR(50),       -- 比例 (e.g. 1/6, MG 1/100)
    dimensions VARCHAR(100), -- 尺寸 (e.g. H:45cm W:38cm)
    material VARCHAR(100),   -- 材質 (e.g. PU, 樹脂, PVC)
    estimated_arrival VARCHAR(50), -- 預計出貨 (e.g. 2025 Q3)

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- (3) 商品圖片 (Product Images) - 支援多圖輪播
CREATE TABLE product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL,
    image_path VARCHAR(255) NOT NULL, -- 圖片路徑 (如 /image/xxx.jpg)
    is_main BOOLEAN DEFAULT FALSE,    -- 是否為主圖 (封面)
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- (4) 訂單 (Orders)
CREATE TABLE orders (
    id VARCHAR(50) PRIMARY KEY, -- 訂單編號 (如 'ORD001')
    user_id INT NOT NULL,
    total_amount INT NOT NULL,
    status VARCHAR(20) DEFAULT '處理中', -- 處理中, 已出貨, 已送達, 已取消
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- (5) 訂單明細 (Order Items) - 符合 2NF/3NF
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 單一主鍵
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    product_name VARCHAR(255), -- 歷史快照：紀錄購買當下的商品名
    quantity INT NOT NULL,
    price INT NOT NULL,        -- 歷史快照：紀錄購買當下的單價
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ==========================================
-- 3. 插入測試資料 (Mock Data)
-- ==========================================

-- (1) 使用者
INSERT INTO users (name, email, password, phone, birthday, role, status) VALUES 
('Admin', 'admin@rc.com', 'admin123', '0900000000', '2000-01-01', 'ADMIN', 'ACTIVE'),
('User', 'user@example.com', '123456', '0912345678', '1995-05-05', 'USER', 'ACTIVE'),
('張三', 'chang3@example.com', '123456', '0911222333', '1990-10-10', 'USER', 'ACTIVE');

-- (2) 商品 (包含詳細 GK 資訊)
INSERT INTO products (id, name, description, price, stock, category_id, tag, type, studio, scale, dimensions, material, estimated_arrival) VALUES
('gundam-rx-78-2', '鋼彈 RX-78-2 Ver.Ka', '由知名設計師 Katoki Hajime 監修，追求極致的機械結構與可動性。全機標誌採用水貼設計，還原度極高。', 3200, 10, 'gundam', 'new', 'model', 'Bandai Namco', '1/100 (MG)', 'H:18cm', 'PS, ABS, PVC', '現貨'),

('dbz-broly', '七龍珠超 布羅利 (Broly) 傳說超級賽亞人', '傳說中的超級賽亞人，擁有無窮無盡的破壞力。肌肉線條與氣場特效件完美呈現，SCC玩具屋熱門預購款。', 18800, 3, 'dbz', '預購', 'figure', 'Deyin Studio', '1/6', 'H:45cm W:38cm D:30cm', '進口樹脂 + PU + 透明特效件', '2025年 第3季'),

('one-piece-luffy', 'ONE PIECE 魯夫', '草帽海賊團的船長，夢想是找到傳說中的大秘寶「ONE PIECE」。', 2200, 20, 'onepiece', 'new', 'figure', 'Banpresto', 'N/A', 'H:16cm', 'PVC', '現貨'),

('naruto-uzumaki', '火影忍者 鳴人', '木葉忍者村的英雄，體內封印著九尾妖狐。', 2800, 15, 'naruto', '現貨', 'figure', 'MegaHouse', '1/8', 'H:20cm', 'PVC', '現貨'),

('pokemon-pikachu', '寶可夢 皮卡丘', '小智最親密的夥伴，擅長使用十萬伏特。', 2000, 50, 'pokemon', NULL, 'prize', 'Pokemon Center', 'N/A', 'H:10cm', '布偶', '現貨'),

('demon-slayer-tanjiro', '鬼滅之刃 炭治郎', '為了讓變成鬼的妹妹復原而加入鬼殺隊的少年。', 2400, 10, 'other', '現貨', 'figure', 'Aniplex', '1/8', 'H:18cm', 'PVC', '現貨'),

('aot-eren', '進擊的巨人 艾連', '追求自由的少年，擁有變身為進擊的巨人的能力。', 2800, 5, 'other', '預購', 'figure', 'Good Smile Company', 'N/A', 'H:17cm', 'PVC', '2024 Q4'),

('star-rail-yue', '崩壞星穹鐵道 歌月君', '仙舟「羅浮」的持明族，丹鼎司的醫士。', 16500, 2, 'other', '現貨', 'figure', 'Apex Toys', '1/7', 'H:28cm', 'PVC, ABS', '現貨'),

('batman-prime1', '蝙蝠俠 (Batman)', '高譚市的黑暗騎士，以恐懼打擊罪犯。', 4500, 1, 'other', '預購', 'figure', 'Prime 1 Studio', '1/3', 'H:80cm', 'Polystone', '2025 Q2'),

('dbz-goku', '七龍珠 悟空', '來自《七龍珠》的主角，傳說中的超級賽亞人。', 3500, 8, 'dbz', NULL, 'blindbox', 'Banpresto', 'N/A', 'H:15cm', 'PVC', '現貨');

-- (3) 商品圖片 (設定主圖與附圖)
INSERT INTO product_images (product_id, image_path, is_main) VALUES
-- 鋼彈 (多張圖)
('gundam-rx-78-2', '/image/羅莉1.jpg', TRUE),
('gundam-rx-78-2', '/image/羅莉.jpg', FALSE),

-- 布羅利 (多張圖)
('dbz-broly', '/image/image_fe8cff.jpg', TRUE),
('dbz-broly', '/image/野獸.webp', FALSE),

-- 其他單張圖
('one-piece-luffy', '/image/羅莉.jpg', TRUE),
('naruto-uzumaki', '/image/naruto_figure.jpg', TRUE),
('pokemon-pikachu', '/image/pokemon_pika.jpg', TRUE),
('demon-slayer-tanjiro', '/image/kimetsu_tanjiro.jpg', TRUE),
('aot-eren', '/image/aot_eren.jpg', TRUE),
('star-rail-yue', '/image/star_rail_yue.jpg', TRUE),
('batman-prime1', '/image/batman.jpg', TRUE),
('dbz-goku', '/image/野獸.webp', TRUE);

-- (4) 訂單資料
INSERT INTO orders (id, user_id, total_amount, status, order_date) VALUES
('ORD001', 3, 5400, '已出貨', '2024-11-25 10:30:00'),
('ORD002', 2, 2800, '處理中', '2024-11-25 14:20:00'),
('ORD003', 3, 4400, '已送達', '2024-11-24 09:15:00'),
('ORD004', 2, 2800, '已取消', '2024-11-24 18:45:00');

-- (5) 訂單明細
INSERT INTO order_items (order_id, product_id, product_name, quantity, price) VALUES
('ORD001', 'gundam-rx-78-2', '鋼彈 RX-78-2 Ver.Ka', 1, 3200),
('ORD001', 'one-piece-luffy', 'ONE PIECE 魯夫', 1, 2200),
('ORD002', 'naruto-uzumaki', '火影忍者 鳴人', 1, 2800),
('ORD003', 'pokemon-pikachu', '寶可夢 皮卡丘', 1, 2000),
('ORD003', 'demon-slayer-tanjiro', '鬼滅之刃 炭治郎', 1, 2400),
('ORD004', 'aot-eren', '進擊的巨人 艾連', 1, 2800);