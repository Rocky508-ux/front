<template>
  <template v-if="filteredProducts.length > 0">
    <product-card
      v-for="product in filteredProducts"
      :key="product.id"
      :product="product"
      @add-to-cart="$emit('add-to-cart', $event)"
    ></product-card>
  </template>
  
  <div v-else class="empty-state">
    <div class="icon-container">
      <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8"></circle>
        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
      </svg>
    </div>
    <h3>找不到符合「{{ route.query.search }}」的商品</h3>
    <p>試試看調整關鍵字，或是瀏覽所有商品。</p>
    <button class="reset-btn" @click="clearSearch">清除搜尋條件</button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import ProductCard from '../components/ProductCard.vue';
import api from '../services/api.js';

defineEmits(['add-to-cart']);

const route = useRoute();
const router = useRouter();

const allProducts = ref([]); // 用於儲存從 API 獲取的原始商品列表

// onMounted 會在元件掛載到 DOM 後執行
onMounted(async () => {
  try {
    const response = await api.getProducts();
    allProducts.value = response.data; // 將 API 回傳的商品資料存入 allProducts
  } catch (error) {
    console.error('無法獲取商品列表:', error);
    // 可以在這裡添加一些錯誤處理邏輯，例如顯示一個錯誤訊息
  }
});

const clearSearch = () => {
  router.push('/');
};

const filteredProducts = computed(() => {
  let currentProducts = allProducts.value || [];

  const searchTerm = (route.query.search || '').toLowerCase();
  if (searchTerm) {
    currentProducts = currentProducts.filter(product => 
      (product.name || '').toLowerCase().includes(searchTerm)
    );
  }

  const tagFilter = route.query.tag;
  if (tagFilter) {
    currentProducts = currentProducts.filter(product => product.tag === tagFilter);
  }

  const categoryFilter = route.query.category;
  if (categoryFilter === 'prize_blindbox') {
    currentProducts = currentProducts.filter(product => 
      product.type === 'prize' || product.type === 'blindbox'
    );
  } else if (categoryFilter) {
    currentProducts = currentProducts.filter(product => product.category_id === categoryFilter);
  }

  return currentProducts;
});
</script>

<style scoped>
/* ★★★ 關鍵修正：讓空狀態橫跨所有 Grid 欄位 ★★★ */
.empty-state {
  grid-column: 1 / -1; /* 從第 1 條線跨到最後一條線 (佔滿整行) */
  width: 100%;
  
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  background-color: #fff;
  border-radius: 12px;
  text-align: center;
  min-height: 400px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02); /* 加一點點陰影讓它不要太平面 */
  margin-top: 20px;
}

.icon-container {
  margin-bottom: 20px;
  background-color: #f3f4f6;
  padding: 20px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-state h3 {
  font-size: 1.5rem;
  color: #374151;
  margin-bottom: 10px;
  font-weight: 700;
}

.empty-state p {
  color: #6b7280;
  margin-bottom: 25px;
  font-size: 1rem;
}

.reset-btn {
  padding: 10px 24px;
  background-color: #4285F4;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 5px rgba(66, 133, 244, 0.3);
}

.reset-btn:hover {
  background-color: #3367d6;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(66, 133, 244, 0.4);
}
</style>