<template>
  <div class="product-card" @click="goToDetail">
    <div v-if="product.tag" :class="['product-tag', getTagClass(product.tag)]">
      {{ product.tag === 'new' ? 'NEW' : product.tag }}
    </div>
    
    <div class="product-image-container">
      <img 
        v-if="mainImage" 
        :src="mainImage" 
        :alt="product.name" 
        loading="lazy"
      />
      <div v-else class="placeholder-image">
        <span>Image Not Available</span>
      </div>
    </div>

    <div class="product-info">
      <h3 class="product-name" :title="product.name">{{ product.name }}</h3>
      
      <div class="product-actions">
        <div class="product-price-group">
          <span class="currency">NT$</span>
          <span class="price-number">{{ product.price.toLocaleString() }}</span>
        </div>
        <button class="buy-btn" @click.stop="$emit('add-to-cart', product)">
          加入購物車
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';

const props = defineProps({
  product: {
    type: Object,
    required: true,
  },
});

defineEmits(['add-to-cart']);

const router = useRouter();

const mainImage = computed(() => {
  // 假設從 API 獲取的 product 物件會直接包含主圖的路徑
  // 例如：product.image_path 或 product.main_image_url
  return props.product.image_path || null;
});

const goToDetail = () => {
  router.push({ name: 'ProductDetail', params: { id: props.product.id } });
};

const getTagClass = (tag) => {
  if (tag === 'new') return 'tag-new';
  if (tag === '預購') return 'tag-preorder';
  if (tag === '現貨') return 'tag-instock';
  return '';
};
</script>

<style scoped>
.product-card {
  /* ★★★ 修改 3：移除死板的邊框，改用現代感的陰影 ★★★ */
  border: none;
  background: #fff;
  border-radius: 12px; /* 圓角更大一點 */
  overflow: hidden;
  cursor: pointer;
  position: relative;
  display: flex;
  flex-direction: column;
  /* 預設狀態就有淡淡的陰影，增加立體感 */
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); /* 更滑順的動畫 */
}

.product-card:hover {
  /* 滑鼠移上去時，浮起來並加深陰影 */
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0,0,0,0.15);
}

/* 圖片區塊 (維持 3:4 比例與置頂對齊) */
.product-image-container {
  position: relative;
  width: 100%;
  aspect-ratio: 3 / 4;
  overflow: hidden;
  background-color: #fff; 
  /* 移除底部邊框，讓圖片跟內容融合 */
  /* border-bottom: 1px solid #f0f0f0; */ 
  display: flex;
  align-items: flex-start; 
  justify-content: center;
}

.product-image-container img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: top center;
  display: block;
  transition: transform 0.5s ease; /* 圖片放大速度慢一點比較有質感 */
}

.product-card:hover .product-image-container img {
  transform: scale(1.08); /* 稍微放大多一點 */
}

/* 標籤樣式優化 */
.product-tag {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 0.85rem;
  font-weight: 800; /* 字體更粗 */
  z-index: 10;
  box-shadow: 0 2px 6px rgba(0,0,0,0.2);
  letter-spacing: 1px;
  text-transform: uppercase;
}
.tag-new { background-color: #D32F2F; color: white; } /* 更飽和的紅 */
.tag-preorder { background-color: #FFC107; color: #212121; } /* 更亮的黃 */
.tag-instock { background-color: #388E3C; color: white; } /* 更飽和的綠 */

/* 資訊區塊 */
.product-info {
  padding: 20px; /* 增加內距，讓版面呼吸 */
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  background: #fff; /* 確保背景純白 */
}

/* ★★★ 修改 1 的樣式：商品名稱加大加粗 ★★★ */
.product-name {
  font-size: 1.2rem; /* 加大 */
  font-weight: 800;  /* 加粗 */
  color: #1a1a1a;    /* 近似黑色的深灰，比純黑有質感 */
  margin: 0 0 15px 0;
  line-height: 1.4;
  /* 限制最多顯示兩行，超過變... */
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 底部動作區 */
.product-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto; /* 推到底部 */
  gap: 10px;
}

/* ★★★ 修改 2 的樣式：價格組合 ★★★ */
.product-price-group {
  display: flex;
  align-items: baseline; /* 讓幣別跟數字底部對齊 */
  color: #D32F2F; /* 使用更搶眼的紅色 */
}

.currency {
  font-size: 1rem;
  font-weight: 700;
  margin-right: 4px;
}

.price-number {
  font-size: 1.5rem; /* 數字加大 */
  font-weight: 900;  /* 數字極粗 */
  letter-spacing: -0.5px; /* 數字緊湊一點更有力 */
}

/* 按鈕優化 */
.buy-btn {
  padding: 10px 18px;
  background-color: #1976D2; /* 使用更飽和、專業的藍色 */
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 0.95rem;
  font-weight: 700;
  white-space: nowrap;
  flex-shrink: 0;
  box-shadow: 0 2px 6px rgba(25, 118, 210, 0.3); /* 按鈕自帶淺淺藍色陰影 */
}

.buy-btn:hover {
  background-color: #1565C0; /* 深藍色 */
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(25, 118, 210, 0.4);
}

/* 缺圖佔位符 */
.placeholder-image {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #999;
  font-weight: bold;
}

/* 手機版 RWD 微調 */
@media (max-width: 768px) {
  .product-info {
    padding: 15px;
  }
  .product-name {
    font-size: 1.1rem; /* 手機版字體稍微縮回來一點，避免太擠 */
  }
  .price-number {
    font-size: 1.3rem;
  }
}
</style>