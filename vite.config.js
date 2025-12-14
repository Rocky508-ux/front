import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },

  server: {
    proxy: {
      // 把 zenquotes.io 提供的 Public API 掛在 /api/zen
      // 所以要設定一個針對 /api/zen 這個 Prefix 的代理規則
      '/api/zen': {
        // 目標位址是 zenquotes.io 的 Base URL
        target: 'https://zenquotes.io',
        // changeOrigin 必須為 true，這樣 3rd-Party API Server 才能正確處理 Request
        changeOrigin: true,
        // Rewrite 是關鍵：
        // 它會將前端發送的 '/api/zen/image' Path
        // 改寫成後端需要的 '/api/image' Path，再轉送給 zenquotes.io
        rewrite: (path) => path.replace(/^\/api\/zen/, '/api'),
      },

      // 後端自己開發的 Spring Boot API (/authors, /books) 乾脆也一樣轉送
      // 為了區別就掛在 /api/data
      // 所以要設定一個針對 /api/data 這個 Prefix 的代理規則
      '/api/data': {
        target: 'http://localhost:8080', // Spring Boot API 的位址
        changeOrigin: true,
        // 假設後端 API 已經掛在 Root Context (/authors)，這裡就不需要 Rewrite
        // rewrite: (path) => path.replace(/^\/api\/data/, ''), 
      },
    }
  }
})
