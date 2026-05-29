import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '../lib/supabase'

const DEMO_ACCOUNTS = {
  apprenant: { email: 'sophie@skillpath.demo', password: 'demo2025' },
  formateur: { email: 'marc@skillpath.demo', password: 'demo2025' },
  rh: { email: 'admin@skillpath.demo', password: 'demo2025' },
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const profile = ref(null)
  const dark = ref(localStorage.getItem('sp-dark') === 'true')

  const isAuthenticated = computed(() => !!user.value)
  const role = computed(() => profile.value?.role || '')
  const initials = computed(() => profile.value?.name?.split(' ').map(w => w[0]).join('') || '')
  const isDark = computed(() => dark.value)

  async function fetchProfile(userId) {
    const { data, error } = await supabase
      .from('profiles')
      .select('id, name, role')
      .eq('id', userId)
      .single()

    if (error) {
      console.error('[Auth] fetchProfile error:', error.message)
      return null
    }
    return data
  }

  supabase.auth.onAuthStateChange(async (event, session) => {
    if (event === 'SIGNED_IN' && session?.user) {
      user.value = session.user
      const p = await fetchProfile(session.user.id)
      profile.value = p
    } else if (event === 'SIGNED_OUT') {
      user.value = null
      profile.value = null
    }
  })

  async function login(name, r) {
    const demo = DEMO_ACCOUNTS[r]
    if (demo) {
      return loginAsDemo(r)
    }

    user.value = { name, role: r }
    profile.value = { name, role: r }
    localStorage.setItem('sp-user', JSON.stringify({ name, role: r }))
  }

  async function loginAsDemo(role) {
    const demo = DEMO_ACCOUNTS[role]
    if (!demo) {
      console.error('[Auth] Unknown demo role:', role)
      return { data: null, error: { message: `Rôle demo inconnu : ${role}` } }
    }

    const { data, error } = await supabase.auth.signInWithPassword({
      email: demo.email,
      password: demo.password,
    })

    if (error) {
      console.error('[Auth] loginAsDemo error:', error.message)
      return { data: null, error }
    }

    user.value = data.user
    const p = await fetchProfile(data.user.id)
    profile.value = p
    return { data, error: null }
  }

  async function loginWithEmail(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) {
      console.error('[Auth] loginWithEmail error:', error.message)
      return { data: null, error }
    }

    user.value = data.user
    const p = await fetchProfile(data.user.id)
    profile.value = p
    return { data, error: null }
  }

  async function logout() {
    const { error } = await supabase.auth.signOut()
    if (error) console.error('[Auth] logout error:', error.message)

    user.value = null
    profile.value = null
    localStorage.removeItem('sp-user')
    localStorage.removeItem('sp-dark')
  }

  function toggleDark() {
    dark.value = !dark.value
    localStorage.setItem('sp-dark', String(dark.value))
  }

  return {
    user,
    profile,
    dark,
    isAuthenticated,
    role,
    initials,
    isDark,
    login,
    loginAsDemo,
    loginWithEmail,
    logout,
    toggleDark,
  }
})
