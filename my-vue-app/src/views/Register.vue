<template>
  <div class="register-page-container">
    <h2>會員註冊</h2>
    <form @submit.prevent="register">
      <div class="form-group">
        <label>姓名 <span style="color: red;">*</span></label>
        <input type="text" v-model="registerForm.name" required>
      </div>
      <div class="form-group">
        <label>電子郵件 <span style="color: red;">*</span></label>
        <input type="email" v-model="registerForm.email" required>
      </div>
      <div class="form-group">
        <label>手機 <span style="color: red;">*</span></label>
        <input type="tel" v-model="registerForm.phone" required>
      </div>
      <div class="form-group">
        <label>生日</label>
        <input type="date" v-model="registerForm.birthday" required>
      </div>
      <div class="form-group">
        <label>密碼 <span style="color: red;">*</span></label>
        <input type="password" v-model="registerForm.password" required>
      </div>
      <div class="form-group">
        <label>確認密碼 <span style="color: red;">*</span></label>
        <input type="password" v-model="registerForm.confirmPassword" required>
      </div>
      <button type="submit">註冊</button>
      <p class="login-footer">已有帳號？ <a @click="$emit('navigate-to-login')">立即登入</a></p>
    </form>
  </div>
</template>

<script setup>
import { reactive } from 'vue';

// ★★★ 修改：加入 'show-notification' ★★★
const emit = defineEmits(['navigate-to-login', 'registration-notification', 'show-notification']);

const registerForm = reactive({
  name: '',
  email: '',
  phone: '',
  birthday: '',
  password: '',
  confirmPassword: ''
});

function register() {
  if (registerForm.password !== registerForm.confirmPassword) {
    // ★★★ 修改：用 show-notification 取代 alert ★★★
    emit('show-notification', '密碼不一致！');
    return;
  }
  emit('registration-notification', '註冊功能需串接後端 API');
  emit('navigate-to-login');
}
</script>

<style scoped>
/* (樣式保持不變) */
.register-page-container { width: 90%; max-width: 500px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); background: #fff; }
h2 { text-align: center; margin-bottom: 20px; }
.form-group { margin-bottom: 15px; }
.form-group label { display: block; margin-bottom: 5px; }
.form-group input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
button { width: 100%; padding: 10px; background-color: #42b983; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
button:hover { background-color: #369f72; }
.login-footer { text-align: center; margin-top: 15px; }
.login-footer a { color: #42b983; cursor: pointer; text-decoration: none; }
.login-footer a:hover { text-decoration: underline; }
</style>