import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const routes = [
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/LoginView.vue'),
    meta: { public: true }
  },
  {
    path: '/',
    name: 'dashboard',
    component: () => import('../views/DashboardView.vue')
  },
  {
    path: '/catalogue',
    name: 'catalogue',
    component: () => import('../views/CatalogueView.vue')
  },
  {
    path: '/cartographie',
    name: 'cartographie',
    component: () => import('../views/CartographieView.vue')
  },
  {
    path: '/parcours',
    name: 'parcours',
    component: () => import('../views/ParcoursView.vue'),
    meta: { roles: ['apprenant', 'formateur'] }
  },
  {
    path: '/quiz',
    name: 'quiz',
    component: () => import('../views/QuizView.vue'),
    meta: { roles: ['apprenant', 'formateur'] }
  },
  {
    path: '/formateur',
    name: 'formateur',
    component: () => import('../views/FormateurView.vue'),
    meta: { roles: ['formateur'] }
  },
  {
    path: '/reporting',
    name: 'reporting',
    component: () => import('../views/ReportingView.vue'),
    meta: { roles: ['rh'] }
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to) => {
  const auth = useAuthStore()
  if (!to.meta.public && !auth.isAuthenticated) return { name: 'login' }
  if (to.meta.roles && !to.meta.roles.includes(auth.role)) return { name: 'dashboard' }
})

export default router
