<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import { IconSchool, IconPresentation, IconBuilding, IconLoader2 } from '@tabler/icons-vue'

const router = useRouter()
const auth = useAuthStore()
const store = useDataStore()

const selectedRole = ref(null)
const userName = ref('Sophie Laurent')
const loggingIn = ref(false)
const loginError = ref('')

const roles = [
  {
    key: 'apprenant',
    label: 'Apprenant',
    desc: 'Accédez à vos parcours, évaluations et cartographie de compétences.',
    icon: IconSchool,
    accent: 'var(--blue)',
    name: 'Sophie Laurent',
    email: 'sophie@skillpath.demo',
  },
  {
    key: 'formateur',
    label: 'Formateur',
    desc: 'Créez et gérez vos formations, suivez les apprenants.',
    icon: IconPresentation,
    accent: 'var(--em)',
    name: 'Marc Dupont',
    email: 'marc@skillpath.demo',
  },
  {
    key: 'rh',
    label: 'RH',
    desc: 'Pilotez le reporting, la conformité et les indicateurs clés.',
    icon: IconBuilding,
    accent: 'var(--purple)',
    name: 'Admin LMS',
    email: 'admin@skillpath.demo',
  },
]

function selectRole(role) {
  selectedRole.value = role.key
  userName.value = role.name
  loginError.value = ''
}

async function login() {
  if (!selectedRole.value) return
  loggingIn.value = true
  loginError.value = ''

  try {
    const { error } = await auth.loginAsDemo(selectedRole.value)
    if (error) {
      loginError.value = error.message || 'Erreur de connexion'
      return
    }

    if (auth.profile?.id) {
      await store.bootstrapApp(auth.profile.id)
    }

    router.push('/')
  } catch (e) {
    loginError.value = 'Connexion Supabase requise — configurez VITE_SUPABASE_URL et VITE_SUPABASE_ANON_KEY dans .env'
  } finally {
    loggingIn.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-deco">
      <div class="circle c1"></div>
      <div class="circle c2"></div>
      <div class="circle c3"></div>
    </div>
    <div class="login-card">
      <div class="login-logo">
        <div class="logo-icon">
          <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M4 15L10 5L16 15" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
            <path d="M6.5 11.5H13.5" stroke="white" stroke-width="2" stroke-linecap="round" />
            <circle cx="16" cy="15" r="2.2" fill="#00D4A1" />
          </svg>
        </div>
        <span class="logo-text">SkillPath<span>.</span></span>
      </div>
      <h1 class="login-title">Bienvenue sur SkillPath</h1>
      <p class="login-subtitle">Sélectionnez votre profil pour accéder à la plateforme</p>

      <div class="role-grid">
        <div
          v-for="role in roles"
          :key="role.key"
          class="role-card"
          :class="{ selected: selectedRole === role.key }"
          :style="{ '--accent': role.accent }"
          @click="selectRole(role)"
        >
          <div class="role-icon-wrap" :style="{ background: role.accent }">
            <component :is="role.icon" :size="22" color="#fff" />
          </div>
          <div class="role-label">{{ role.label }}</div>
          <div class="role-desc">{{ role.desc }}</div>
          <div v-if="selectedRole === role.key" class="role-check">✓</div>
        </div>
      </div>

      <div v-if="selectedRole" class="name-field">
        <label class="name-label">Nom d'utilisateur</label>
        <input v-model="userName" class="name-input" type="text" placeholder="Votre nom" @keyup.enter="login" />
      </div>

  <div v-if="loginError" class="login-error">{{ loginError }}</div>

  <button class="login-btn" :disabled="!selectedRole || loggingIn" @click="login">
    <IconLoader2 v-if="loggingIn" :size="16" class="spin" />
    <span v-else>Connexion</span>
  </button>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--navy);
  position: relative;
  overflow: hidden;
}
.login-deco {
  position: absolute;
  inset: 0;
  pointer-events: none;
}
.circle {
  position: absolute;
  border-radius: 50%;
  border: 1px solid rgba(0, 212, 161, 0.08);
}
.c1 {
  width: 600px;
  height: 600px;
  top: -180px;
  right: -120px;
}
.c2 {
  width: 400px;
  height: 400px;
  bottom: -100px;
  left: -80px;
}
.c3 {
  width: 250px;
  height: 250px;
  top: 50%;
  left: 10%;
  border-color: rgba(0, 150, 255, 0.06);
}
.login-card {
  position: relative;
  z-index: 1;
  background: #111528;
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-radius: 16px;
  padding: 40px 36px 32px;
  width: 100%;
  max-width: 520px;
  margin: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
}
.login-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-bottom: 24px;
}
.logo-icon {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  background: var(--blue);
  display: flex;
  align-items: center;
  justify-content: center;
}
.logo-text {
  font-size: 20px;
  font-weight: 700;
  color: #fff;
  letter-spacing: -0.5px;
}
.logo-text span {
  color: var(--em);
}
.login-title {
  text-align: center;
  font-size: 22px;
  font-weight: 700;
  color: #fff;
  margin: 0 0 6px;
}
.login-subtitle {
  text-align: center;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.45);
  margin: 0 0 28px;
}
.role-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 12px;
  margin-bottom: 20px;
}
.role-card {
  position: relative;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-radius: 12px;
  padding: 20px 14px 16px;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s ease;
}
.role-card:hover {
  background: rgba(255, 255, 255, 0.06);
  border-color: rgba(255, 255, 255, 0.1);
}
.role-card.selected {
  border-color: var(--accent);
  background: rgba(255, 255, 255, 0.05);
  box-shadow: 0 0 0 1px var(--accent), 0 4px 16px rgba(0, 0, 0, 0.2);
}
.role-icon-wrap {
  width: 42px;
  height: 42px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 12px;
}
.role-label {
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  margin-bottom: 6px;
}
.role-desc {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.4);
  line-height: 1.4;
}
.role-check {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: var(--accent);
  color: #fff;
  font-size: 10px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}
.name-field {
  margin-bottom: 20px;
}
.name-label {
  display: block;
  font-size: 12px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 6px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.name-input {
  width: 100%;
  padding: 10px 14px;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(255, 255, 255, 0.04);
  color: #fff;
  font-size: 14px;
  outline: none;
  transition: border-color 0.15s ease;
  box-sizing: border-box;
}
.name-input:focus {
  border-color: var(--blue);
}
.name-input::placeholder {
  color: rgba(255, 255, 255, 0.25);
}
.login-btn {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 8px;
  background: var(--blue);
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s ease;
}
.login-btn:hover:not(:disabled) {
  opacity: 0.9;
  transform: translateY(-1px);
}
.login-btn:disabled {
  opacity: 0.35;
  cursor: not-allowed;
}
.login-btn .spin {
  animation: spin 0.8s linear infinite;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
.login-error {
  background: rgba(255, 77, 106, 0.1);
  border: 1px solid rgba(255, 77, 106, 0.3);
  color: var(--co);
  font-size: 12px;
  padding: 10px 14px;
  border-radius: 8px;
  margin-bottom: 16px;
  text-align: center;
}
</style>
