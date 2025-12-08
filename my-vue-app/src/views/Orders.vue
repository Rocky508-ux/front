<template>
  <section class="content-section">
    <h2 class="section-title">我的訂單</h2>
    <div class="order-list">
      <div class="order-item" v-for="order in orders" :key="order.id">
        <div class="order-header">
          <div>
            <h3>訂單編號: {{ order.id }}</h3>
            <p class="order-date">{{ order.date }}</p>
          </div>
          <span class="order-status" :class="getStatusClass(order.status)">
            {{ order.status }}
          </span>
        </div>
        <div class="order-total">
          總金額: <strong>NT$ {{ order.amount.toLocaleString() }}</strong>
        </div>
      </div>
      <div v-if="!orders || orders.length === 0" style="text-align: center; padding: 20px; color: #666;">
        目前沒有訂單紀錄
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../services/api.js';

const orders = ref([]);

onMounted(async () => {
  try {
    const response = await api.getOrders();
    // 在真實應用中，這裡應該是獲取當前登入用戶的訂單
    // 例如: const response = await api.getMyOrders();
    // 但目前我們先獲取所有訂單作為示範
    orders.value = response.data;
  } catch (error) {
    console.error("無法獲取訂單列表:", error);
  }
});

function getStatusClass(status) {
  const map = {
    '已完成': 'status-completed',
    '已送達': 'status-completed',
    '已出貨': 'status-shipping',
    '配送中': 'status-shipping',
    '處理中': 'status-pending',
    '待付款': 'status-pending'
  };
  return map[status] || '';
}
</script>

<style scoped>
</style>