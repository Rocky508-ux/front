<template>
  <div class="member-center-container">
    <h2 class="page-title">會員中心</h2>

    <!-- 會員資訊 -->
    <div class="member-section">
      <h3 class="section-title">會員資訊</h3>
      <div v-if="!isEditing" class="info-grid">
        <div class="info-item"><label>姓名</label><p>{{ userInfo.name }}</p></div>
        <div class="info-item"><label>電子郵件</label><p>{{ userInfo.email }}</p></div>
        <div class="info-item"><label>手機</label><p>{{ userInfo.phone }}</p></div>
        <div class="info-item"><label>生日</label><p>{{ userInfo.birthday }}</p></div>
      </div>
      <form v-else @submit.prevent="saveUserInfo" class="info-grid">
        <div class="info-item"><label for="name">姓名</label><input id="name" type="text" v-model="editableUserInfo.name" required></div>
        <div class="info-item"><label for="email">電子郵件</label><input id="email" type="email" v-model="editableUserInfo.email" required></div>
        <div class="info-item"><label for="phone">手機</label><input id="phone" type="tel" v-model="editableUserInfo.phone" required></div>
        <div class="info-item"><label for="birthday">生日</label><input id="birthday" type="date" v-model="editableUserInfo.birthday" required></div>
      </form>
      <div class="section-actions">
        <button v-if="!isEditing" @click="startEditing" class="action-btn">編輯資料</button>
        <template v-else>
          <button @click="cancelEditing" class="action-btn secondary">取消</button>
          <button @click="saveUserInfo" class="action-btn primary">儲存變更</button>
        </template>
      </div>
    </div>

    <!-- 修改密碼 -->
    <div class="member-section">
      <h3 class="section-title">修改密碼</h3>
      <form @submit.prevent="changePassword" class="password-form">
        <div class="form-group"><label for="current-password">目前密碼</label><input type="password" id="current-password" v-model="passwords.current" required></div>
        <div class="form-group"><label for="new-password">新密碼</label><input type="password" id="new-password" v-model="passwords.new" required></div>
        <div class="form-group"><label for="confirm-password">確認新密碼</label><input type="password" id="confirm-password" v-model="passwords.confirm" required></div>
        <div class="section-actions"><button type="submit" class="action-btn primary">更新密碼</button></div>
      </form>
    </div>

    <!-- 訂單查詢 -->
    <div class="member-section">
      <h3 class="section-title">訂單查詢</h3>
      <p>點擊下方按鈕查看您的歷史訂單紀錄。</p>
      <div class="section-actions"><router-link to="/orders" class="action-btn">查看訂單</router-link></div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, watch, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const props = defineProps({
  isLoggedIn: Boolean
});

const emit = defineEmits(['show-notification']);

const router = useRouter();
const isEditing = ref(false);

const userInfo = reactive({
  name: 'RC_Player_1',
  email: 'rc.player@example.com',
  phone: '0912-345-678',
  birthday: '1990-01-01'
});

const editableUserInfo = reactive({ ...userInfo });

const passwords = reactive({
  current: '',
  new: '',
  confirm: ''
});

function checkLoginStatus() {
  if (!props.isLoggedIn) {
    emit('show-notification', '請先登入會員！');
    router.push('/login');
  }
}

function startEditing() {
  Object.assign(editableUserInfo, userInfo);
  isEditing.value = true;
}

function saveUserInfo() {
  Object.assign(userInfo, editableUserInfo);
  isEditing.value = false;
  emit('show-notification', '會員資料已更新！');
}

function cancelEditing() {
  isEditing.value = false;
}

function changePassword() {
  if (passwords.new !== passwords.confirm) {
    emit('show-notification', '新密碼與確認密碼不相符！');
    return;
  }
  emit('show-notification', '密碼已成功修改！(模擬)');
  passwords.current = '';
  passwords.new = '';
  passwords.confirm = '';
}

watch(() => props.isLoggedIn, (newValue) => {
  if (!newValue) {
    checkLoginStatus();
  }
});

onMounted(() => {
  checkLoginStatus();
});
</script>

<style scoped>
.member-center-container { max-width: 800px; margin: 2rem auto; padding: 2rem; background-color: #fff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.page-title { text-align: center; margin-bottom: 2rem; font-size: 2rem; color: #333; }
.member-section { margin-bottom: 2.5rem; padding-bottom: 1.5rem; border-bottom: 1px solid #eee; }
.member-section:last-child { border-bottom: none; margin-bottom: 0; }
.section-title { font-size: 1.5rem; margin-bottom: 1.5rem; color: #0056b3; }
.info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.5rem; }
.info-item label, .form-group label { font-weight: bold; color: #555; display: block; margin-bottom: 0.5rem; }
.info-item p { background-color: #f9f9f9; padding: 0.75rem; border-radius: 4px; border: 1px solid #ddd; margin: 0; }
.info-item input, .form-group input { width: 100%; padding: 0.75rem; border: 1px solid #ccc; border-radius: 4px; font-size: 1rem; box-sizing: border-box; }
.password-form .form-group { margin-bottom: 1.5rem; }
.section-actions { margin-top: 1.5rem; text-align: center; }
.section-actions > .action-btn:only-child, .section-actions > .router-link.action-btn:only-child { width: 50%; }
.action-btn { padding: 0.75rem 1.5rem; border-radius: 5px; border: none; cursor: pointer; font-weight: bold; transition: all 0.3s ease; background-color: #6c757d; color: white; text-decoration: none; display: inline-block; text-align: center; margin: 0 5px; box-sizing: border-box; }
.action-btn:hover { opacity: 0.85; }
.action-btn.primary { background-color: #007bff; }
.action-btn.secondary { background-color: #f44336; }
</style>
