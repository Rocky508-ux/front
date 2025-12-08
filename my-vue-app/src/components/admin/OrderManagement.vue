<template>
  <div class="admin-card">
    <div class="header">
      <h1>訂單管理</h1>
    </div>
    <div class="admin-table-wrapper">
      <table class="admin-table">
        <thead>
          <tr>
            <th>訂單編號</th>
            <th>顧客</th>
            <th>日期</th>
            <th>總金額</th>
            <th>狀態</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.id">
            <td>{{ order.id }}</td>
            <td>{{ order.customer }}</td>
            <td>{{ order.date }}</td>
            <td>NT$ {{ order.amount.toLocaleString() }}</td>
            <td>
              <select v-model="order.status" @change="updateStatus(order)" class="styled-select">
                <option value="處理中">處理中</option>
                <option value="已出貨">已出貨</option>
                <option value="已送達">已送達</option>
                <option value="已取消">已取消</option>
              </select>
            </td>
            <td class="actions">
              <button class="admin-btn view-btn" @click="viewOrder(order)">查看詳情</button>
            </td>
          </tr>
          <tr v-if="orders.length === 0">
            <td colspan="6" style="text-align: center; padding: 20px;">目前沒有訂單</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="showDetailModal" class="modal-overlay" @click.self="closeDetailModal">
      <div class="modal-content">
        <h2>訂單詳情 #{{ selectedOrder?.id }}</h2>
        <div class="order-details">
          <p><strong>顧客:</strong> {{ selectedOrder?.customer }}</p>
          <p><strong>日期:</strong> {{ selectedOrder?.date }}</p>
          <p><strong>總金額:</strong> NT$ {{ selectedOrder?.amount.toLocaleString() }}</p>
          <p><strong>狀態:</strong> <span :class="['status-badge', selectedOrder?.status]">{{ selectedOrder?.status }}</span></p>
          <h3>訂購商品:</h3>
          <ul class="order-items-list">
            <li v-for="item in selectedOrder?.items" :key="item.productId">
              {{ item.productName }} (x{{ item.quantity }}) - NT$ {{ item.price.toLocaleString() }}
            </li>
          </ul>
        </div>
        <div class="modal-actions">
          <button type="button" class="admin-btn cancel-btn" @click="closeDetailModal">關閉</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../../services/api.js';

const orders = ref([]);
const showDetailModal = ref(false);
const selectedOrder = ref(null);

const fetchOrders = async () => {
  try {
    const response = await api.getOrders();
    orders.value = response.data;
  } catch (error) {
    console.error("無法獲取訂單列表:", error);
  }
};

onMounted(fetchOrders);

const updateStatus = async (order) => {
  try {
    // 假設 api.js 中有 updateOrder 方法
    // 我們只發送需要更新的 status 欄位
    await api.updateOrder(order.id, { status: order.status });
    // 可以選擇性地顯示成功訊息
    console.log(`訂單 ${order.id} 狀態已更新為 ${order.status}`);
    // 無需重新 fetchOrders，因為我們是直接修改 orders ref 內的物件，UI 會自動更新
  } catch (error) {
    console.error(`更新訂單 ${order.id} 失敗:`, error);
    // 如果更新失敗，最好是將狀態還原，並提示使用者
    alert("更新失敗，請稍後再試");
    fetchOrders(); // 或者重新拉取一次列表以確保資料同步
  }
};

const viewOrder = (order) => {
  // 為了看到詳細的訂購商品，我們假設 getOrders 回傳的資料已包含 items
  // 如果沒有，則應在此處呼叫 api.getOrder(order.id)
  selectedOrder.value = order;
  showDetailModal.value = true;
};

const closeDetailModal = () => {
  showDetailModal.value = false;
  selectedOrder.value = null;
};
</script>

<style scoped>
.order-details p {
  margin: 8px 0;
  line-height: 1.6;
  display: flex; /* Align items vertically */
  align-items: center; /* Center badge vertically with text */
  gap: 10px;
}
.order-details h3 {
  margin-top: 20px;
  margin-bottom: 10px;
  border-bottom: 1px solid #eee;
  padding-bottom: 5px;
}
.order-items-list {
  list-style-type: none;
  padding-left: 0;
}
.order-items-list li {
  padding: 8px;
  background-color: #f9f9f9;
  border-radius: 4px;
  margin-bottom: 5px;
}
</style>