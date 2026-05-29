<script setup>
import { computed, inject, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import { IconSparkles, IconBell, IconMoon, IconSun } from '@tabler/icons-vue'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const store = useDataStore()
const notifOpen = ref(false)
const notifs = ref([])
const toast = inject('toast', (msg) => {
  const el = document.getElementById('app-toast')
  if (!el) return
  el.querySelector('.toast-msg').textContent = msg
  el.classList.add('show')
  clearTimeout(el._t)
  el._t = setTimeout(() => el.classList.remove('show'), 2800)
})

const allNavItems = [
  { route: 'dashboard', label: 'Tableau de bord', roles: ['apprenant', 'formateur', 'rh'] },
  { route: 'catalogue', label: 'Catalogue', roles: ['apprenant', 'formateur', 'rh'] },
  { route: 'cartographie', label: 'Cartographie', roles: ['apprenant', 'formateur', 'rh'] },
  { route: 'parcours', label: 'Formation en cours', roles: ['apprenant', 'formateur'] },
  { route: 'quiz', label: 'Évaluations', roles: ['apprenant', 'formateur'] },
  { route: 'formateur', label: 'Formateur', roles: ['formateur'] },
  { route: 'reporting', label: 'Reporting', roles: ['rh'] },
]

const navItems = computed(() => allNavItems.filter(i => i.roles.includes(auth.role)))
</script>

<template>
  <header class="header">
    <div class="logo" @click="router.push('/')">
      <div class="logo-icon">
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M4 15L10 5L16 15" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
          <path d="M6.5 11.5H13.5" stroke="white" stroke-width="2" stroke-linecap="round" />
          <circle cx="16" cy="15" r="2.2" fill="#00D4A1" />
        </svg>
      </div>
      <div class="logo-name">SkillPath<span>.</span></div>
    </div>
    <nav class="header-nav">
      <button
        v-for="item in navItems"
        :key="item.route"
        :class="['hn', { on: route.name === item.route }]"
        @click="router.push({ name: item.route })"
      >
        {{ item.label }}
      </button>
    </nav>
    <div class="header-right">
<div class="icon-btn" title="Assistant IA" @click="toast('IA — Posez votre question !')">
      <IconSparkles :size="16" style="color:var(--blue)" />
    </div>
    <div class="icon-btn" title="Notifications" @click="async () => { if (auth.profile?.id) { const res = await store.fetchNotifications(auth.profile.id); notifs.value = res.data || [] }; notifOpen = !notifOpen; toast(notifs.value.length ? notifs.value.length + ' notifications' : 'Aucune notification') }">
        <IconBell :size="16" />
        <div class="notif-dot"></div>
      </div>
      <div class="icon-btn" title="Thème" @click="auth.toggleDark()">
        <IconSun v-if="auth.isDark" :size="16" />
        <IconMoon v-else :size="16" />
      </div>
      <div class="avatar" @click="toast('Profil — ' + auth.user.name); router.push('/dashboard')">
        {{ auth.initials }}
      </div>
    </div>
  </header>
</template>

<style scoped>
.header {
  display: flex;
  align-items: center;
  height: 52px;
  padding: 0 20px;
  background: var(--navy);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  position: sticky;
  top: 0;
  z-index: 100;
}
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  margin-right: 28px;
}
.logo-icon {
  width: 30px;
  height: 30px;
  border-radius: 8px;
  background: var(--blue);
  display: flex;
  align-items: center;
  justify-content: center;
}
.logo-name {
  font-size: 16px;
  font-weight: 700;
  color: #fff;
  letter-spacing: -0.3px;
}
.logo-name span {
  color: var(--em);
}
.header-nav {
  display: flex;
  align-items: center;
  gap: 2px;
  flex: 1;
}
.hn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.5);
  font-size: 13px;
  font-weight: 500;
  padding: 6px 12px;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.15s ease;
  white-space: nowrap;
}
.hn:hover {
  color: rgba(255, 255, 255, 0.8);
  background: rgba(255, 255, 255, 0.05);
}
.hn.on {
  color: #fff;
  background: rgba(0, 212, 161, 0.12);
}
.header-right {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-left: auto;
}
.icon-btn {
  position: relative;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.55);
  transition: all 0.15s ease;
}
.icon-btn:hover {
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
}
.notif-dot {
  position: absolute;
  top: 5px;
  right: 5px;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #f44;
  border: 1.5px solid var(--navy);
}
.avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: var(--blue);
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  margin-left: 4px;
  transition: opacity 0.15s ease;
}
.avatar:hover {
  opacity: 0.85;
}
</style>
