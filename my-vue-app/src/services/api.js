import axios from 'axios';

// 建立一個 Axios instance，用於向後端 API 發送請求
const apiClient = axios.create({
  // 我們假設後端 API 的基礎 URL 為 http://localhost:3000/api
  // 當您完成後端開發後，請確保此 URL 是正確的
  baseURL: 'http://localhost:3000/api', 
  headers: {
    'Content-Type': 'application/json',
  },
});

// ===============================================
//                  使用者 (Users) API
// ===============================================

// 獲取所有使用者
export const getUsers = () => apiClient.get('/users');
// 根據 ID 獲取單一使用者
export const getUser = (id) => apiClient.get(`/users/${id}`);
// 創建新使用者
export const createUser = (data) => apiClient.post('/users', data);
// 更新使用者資料
export const updateUser = (id, data) => apiClient.put(`/users/${id}`, data);
// 刪除使用者
export const deleteUser = (id) => apiClient.delete(`/users/${id}`);

// ===============================================
//                  產品 (Products) API
// ===============================================

// 獲取所有產品
export const getProducts = () => apiClient.get('/products');
// 根據 ID 獲取單一產品（假設會一併返回 product_images）
export const getProduct = (id) => apiClient.get(`/products/${id}`);
// 創建新產品
export const createProduct = (data) => apiClient.post('/products', data);
// 更新產品資料
export const updateProduct = (id, data) => apiClient.put(`/products/${id}`, data);
// 刪除產品
export const deleteProduct = (id) => apiClient.delete(`/products/${id}`);

// ===============================================
//                  訂單 (Orders) API
// ===============================================

// 獲取所有訂單
export const getOrders = () => apiClient.get('/orders');
// 根據 ID 獲取單一訂單（假設會一併返回 orders_items）
export const getOrder = (id) => apiClient.get(`/orders/${id}`);
// 創建新訂單
export const createOrder = (data) => apiClient.post('/orders', data);
// 更新訂單資料 (例如更新狀態)
export const updateOrder = (id, data) => apiClient.put(`/orders/${id}`, data);
// (根據需求可以添加更新和刪除訂單的 API)


// 為了方便，我們將 apiClient 也匯出，以便在需要時可以直接使用
export default {
  getUsers,
  getUser,
  createUser,
  updateUser,
  deleteUser,
  getProducts,
  getProduct,
  createProduct,
  updateProduct,
  deleteProduct,
  getOrders,
  getOrder,
  createOrder,
  updateOrder,
};