<script setup>
import { provide, watch } from 'vue'
import { useAuthStore } from './stores/auth'
import AppHeader from './components/AppHeader.vue'

const auth = useAuthStore()

function toast(msg, type = 'ok') {
  const el = document.getElementById('app-toast')
  if (!el) return
  el.querySelector('.toast-msg').textContent = msg
  const ico = el.querySelector('.toast-ico')
  ico.textContent = type === 'err' ? '✗' : '✓'
  el.style.borderLeftColor = type === 'err' ? 'var(--co)' : 'var(--em)'
  el.classList.add('show')
  clearTimeout(el._t)
  el._t = setTimeout(() => el.classList.remove('show'), 2800)
}

provide('toast', toast)

watch(() => auth.isDark, (v) => {
  if (v) document.body.setAttribute('data-dark', '')
  else document.body.removeAttribute('data-dark')
}, { immediate: true })
</script>

<template>
  <AppHeader v-if="auth.isAuthenticated" />
  <router-view />
  <div id="app-toast" class="toast">
    <span class="toast-ico" style="font-size:16px;color:var(--em)">✓</span>
    <span class="toast-msg">Action effectuée</span>
  </div>
</template>

<style>
.toast {
  position: fixed;
  bottom: 24px;
  right: 24px;
  display: flex;
  align-items: center;
  gap: 10px;
  background: #1a1e2e;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-left: 3px solid var(--em);
  border-radius: 8px;
  padding: 12px 18px;
  color: #fff;
  font-size: 13px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
  transform: translateY(80px);
  opacity: 0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 9999;
  pointer-events: none;
}
.toast.show {
  transform: translateY(0);
  opacity: 1;
  pointer-events: auto;
}
.toast-msg {
  font-weight: 500;
}
</style>
