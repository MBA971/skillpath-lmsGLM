<script setup>
import { ref, computed, onMounted } from 'vue'
import { inject } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import {
  IconFlame, IconCompass, IconBulb, IconTool, IconRosette,
  IconPlayerPlay, IconBooks, IconStar, IconCertificate,
  IconChartPie, IconTrendingUp, IconRefresh, IconRoute,
  IconBolt, IconCalendarEvent, IconAward, IconLock,
  IconMessage, IconMicrophone, IconHeart, IconTable,
  IconCode, IconClipboardList, IconCoin, IconExchange,
  IconUsers, IconVideo, IconMapPin, IconClock, IconLoader2, IconAlertTriangle
} from '@tabler/icons-vue'

const auth = useAuthStore()
const store = useDataStore()
const router = useRouter()
const toast = inject('toast')

const ICON_MAP = {
  flame: IconFlame, compass: IconCompass, bulb: IconBulb, tool: IconTool,
  rosette: IconRosette, 'player-play': IconPlayerPlay, books: IconBooks,
  star: IconStar, certificate: IconCertificate, 'chart-pie': IconChartPie,
  'trending-up': IconTrendingUp, refresh: IconRefresh, route: IconRoute,
  bolt: IconBolt, 'calendar-event': IconCalendarEvent, award: IconAward,
  lock: IconLock, message: IconMessage, microphone: IconMicrophone,
  heart: IconHeart, table: IconTable, code: IconCode,
  'clipboard-list': IconClipboardList, coin: IconCoin, handshake: IconExchange,
  users: IconUsers, video: IconVideo, 'map-pin': IconMapPin, clock: IconClock,
}

const LVL_LBL = { deb: 'Débutant', int: 'Intermédiaire', avd: 'Avancé', exp: 'Expert' }
const LVL_CLS = { deb: 'level-deb', int: 'level-int', avd: 'level-avd', exp: 'level-exp' }

const daysUntil = (d) => {
  const now = new Date()
  now.setHours(0, 0, 0, 0)
  const dt = new Date(d)
  dt.setHours(0, 0, 0, 0)
  return Math.round((dt - now) / 86400000)
}

const fmtDate = (d) => new Date(d).toLocaleDateString('fr-FR', { weekday: 'short', day: 'numeric', month: 'short' })

const recBg = (color) => {
  if (color === 'var(--co)') return 'var(--co-lt)'
  if (color === 'var(--am)') return 'var(--am-lt)'
  return 'var(--em-lt)'
}

const recPill = (color) => {
  if (color === 'var(--co)') return 'pill-coral'
  if (color === 'var(--am)') return 'pill-amber'
  return 'pill-green'
}

const radarScores = computed(() => {
  const map = {}
  for (const c of store.competencies) {
    const s = store.competencyScores[c.id]
    map[c.id] = s ? s.score : 0
  }
  return map
})

const SESSIONS = computed(() => store.sessions)

const ACTIVITIES = computed(() => {
  const acts = []
  for (const a of store.quizAttempts.slice(0, 2)) {
    acts.push({ text: `Quiz — ${a.quiz_id}`, time: 'Récent', color: 'var(--em)' })
  }
  for (const b of store.badges.slice(0, 2)) {
    acts.push({ text: `Badge obtenu — ${b.title}`, time: 'Récent', color: 'var(--am)' })
  }
  return acts.length ? acts : [
    { text: 'Quiz réussi — SCRUM Fondamentaux', time: 'Il y a 2h', color: 'var(--em)' },
    { text: 'Module terminé — Leadership E2', time: 'Hier', color: 'var(--blue)' },
    { text: 'Session formateur planifiée', time: 'Demain 14h', color: 'var(--am)' },
    { text: 'Certification obtenue — Excel', time: '12 mai', color: 'var(--co)' },
  ]
})

const DOMAINS = computed(() => {
  const cats = {}
  for (const c of store.courses) {
    if (!cats[c.cat]) cats[c.cat] = { total: 0, done: 0 }
    cats[c.cat].total++
    if (c.prg === 100) cats[c.cat].done++
  }
  const colMap = { 'Soft Skills': 'var(--pu)', 'Technical Skills': 'var(--blue)', 'Functional Skills': 'var(--em)', 'Management': 'var(--am)' }
  return Object.entries(cats).map(([label, v]) => ({
    label,
    pct: v.total > 0 ? Math.round((v.done / v.total) * 100) : 0,
    color: colMap[label] || 'var(--blue)',
  }))
})

const RECS = computed(() => {
  const weak = store.competencies.filter(c => {
    const s = store.competencyScores[c.id]
    return s && s.score < 50
  }).sort((a, b) => (store.competencyScores[a.id]?.score || 0) - (store.competencyScores[b.id]?.score || 0)).slice(0, 3)

  if (weak.length === 0) {
    return [
      { title: 'Cybersécurité fondamentaux', score: 12, color: 'var(--co)', type: 'module', icon: 'lock' },
      { title: 'Techniques de négociation', score: 33, color: 'var(--am)', type: 'module', icon: 'handshake' },
      { title: 'Finance pour non-financiers', score: 22, color: 'var(--co)', type: 'video', icon: 'coin' },
    ]
  }

  return weak.map(c => ({
    title: c.name,
    score: store.competencyScores[c.id]?.score || 0,
    color: (store.competencyScores[c.id]?.score || 0) < 30 ? 'var(--co)' : 'var(--am)',
    type: 'module',
    icon: 'lock',
  }))
})

const COURSES = computed(() => {
  if (store.courses.length) return store.courses
  return [
    { title: 'Leadership & Influence', cat: 'Soft Skills', lvl: 'exp', icon: 'users', col: '#7B6FEE', dur: '12h', sc: 4.8, prg: 0 },
    { title: 'Python Data Science', cat: 'Technical Skills', lvl: 'avd', icon: 'code', col: '#1E6FFF', dur: '20h', sc: 4.9, prg: 0 },
    { title: 'Communication CNV', cat: 'Soft Skills', lvl: 'int', icon: 'message', col: '#FF9B21', dur: '6h', sc: 4.6, prg: 23 },
    { title: 'Excel Avancé', cat: 'Technical Skills', lvl: 'deb', icon: 'table', col: '#00D4A1', dur: '5h', sc: 4.5, prg: 100 },
    { title: 'Gestion de projet', cat: 'Functional Skills', lvl: 'int', icon: 'clipboard-list', col: '#FF4D6A', dur: '15h', sc: 4.6, prg: 0 },
    { title: 'Gestion du stress', cat: 'Soft Skills', lvl: 'deb', icon: 'heart', col: '#7B6FEE', dur: '4h', sc: 4.4, prg: 0 },
  ]
})

const BADGES = computed(() => {
  if (store.badges.length) return store.badges
  return [
    { icon: 'refresh', title: 'Agiliste', sub: 'SCRUM validé', color: 'var(--blue)' },
    { icon: 'bulb', title: 'Innovateur', sub: '3 idées déposées', color: 'var(--am)' },
    { icon: 'star', title: 'Top Learner', sub: 'Semaine du 12/05', color: 'var(--pu)' },
    { icon: 'flame', title: '7j Streak', sub: 'Connexion quotidienne', color: 'var(--co)' },
    { icon: 'table', title: 'Data Lover', sub: 'Module Excel fini', color: 'var(--em)' },
    { icon: 'microphone', title: 'Speaker', sub: 'Animation réussie', color: 'var(--blue)' },
  ]
})

const PATH_STEPS = computed(() => {
  if (store.pathPhases.length) {
    return store.pathPhases.map((p, i) => {
      const acts = p.path_activities || []
      const allDone = acts.length > 0 && acts.every(a => completedActs.value.has(a.id))
      const hasCur = !allDone && acts.some(a => completedActs.value.has(a.id))
      return {
        label: p.label,
        state: allDone ? 'done' : hasCur || i <= 2 ? 'cur' : 'locked',
      }
    })
  }
  return [
    { label: 'Intro Agilité', state: 'done' },
    { label: 'Leadership', state: 'done' },
    { label: 'Outils PM', state: 'cur' },
    { label: 'Communication', state: 'locked' },
    { label: 'Négociation', state: 'locked' },
    { label: 'Certification', state: 'locked' },
  ]
})

const completedActs = ref(new Set())

const radarSvg = computed(() => {
  const keys = store.competencies.length
    ? store.competencies.map(c => c.id)
    : ['lead', 'comm', 'data', 'agil', 'nego', 'cyber', 'innov', 'mgmt']
  const labs = store.competencies.length
    ? store.competencies.map(c => c.name.length > 6 ? c.name.slice(0, 5) + '.' : c.name)
    : ['Lead.', 'Comm.', 'Data', 'Agil.', 'Négo.', 'Cyber', 'Innov.', 'Mgmt']
  const scores = keys.map(k => radarScores.value[k] || 0)
  const n = keys.length, size = 180, cx = size / 2, cy = size / 2, r = size / 2 - 26
  const dark = auth.isDark
  const bdCol = dark ? '#283B58' : '#E2E8F5'
  const txCol = dark ? '#7A8FAE' : '#526080'
  const sfCol = dark ? '#0F1829' : '#fff'
  const txMain = dark ? '#EFF3FF' : '#0B1628'

  const pts = keys.map((k, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    const d = ((scores[i] || 0) / 100) * r
    return `${(cx + d * Math.cos(a)).toFixed(1)},${(cy + d * Math.sin(a)).toFixed(1)}`
  }).join(' ')

  const grid = [0.25, 0.5, 0.75, 1].map(f =>
    keys.map((_, i) => {
      const a = (i / n) * Math.PI * 2 - Math.PI / 2
      return `${(cx + f * r * Math.cos(a)).toFixed(1)},${(cy + f * r * Math.sin(a)).toFixed(1)}`
    }).join(' ')
  )

  const avg = scores.length > 0 ? Math.round(scores.reduce((s, v) => s + v, 0) / scores.length) : 0

  const axLines = keys.map((_, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    return `<line x1="${cx}" y1="${cy}" x2="${(cx + r * Math.cos(a)).toFixed(1)}" y2="${(cy + r * Math.sin(a)).toFixed(1)}" stroke="${bdCol}" stroke-width="0.5"/>`
  }).join('')

  const labelEls = labs.map((l, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    const lx = (cx + (r + 18) * Math.cos(a)).toFixed(1)
    const ly = (cy + (r + 18) * Math.sin(a)).toFixed(1)
    return `<text x="${lx}" y="${ly}" text-anchor="middle" dominant-baseline="central" font-size="9.5" fill="${txCol}" font-family="Epilogue,sans-serif">${l}</text>`
  }).join('')

  const dots = keys.map((k, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    const d = ((scores[i] || 0) / 100) * r
    return `<circle cx="${(cx + d * Math.cos(a)).toFixed(1)}" cy="${(cy + d * Math.sin(a)).toFixed(1)}" r="3.5" fill="#1E6FFF" stroke="${sfCol}" stroke-width="1.5"/>`
  }).join('')

  return `<svg width="${size}" height="${size}" viewBox="0 0 ${size} ${size}" style="overflow:visible">
  ${grid.map(g => `<polygon points="${g}" fill="none" stroke="${bdCol}" stroke-width="0.5"/>`).join('\n')}
  ${axLines}
  <polygon points="${pts}" fill="rgba(30,111,255,0.12)" stroke="#1E6FFF" stroke-width="1.8"/>
  ${dots}
  ${labelEls}
  <text x="${cx}" y="${cy - 7}" text-anchor="middle" font-size="18" font-weight="800" fill="${txMain}" font-family="Sora,sans-serif">${avg}</text>
  <text x="${cx}" y="${cy + 10}" text-anchor="middle" font-size="10" fill="${txCol}">/ 100</text>
  </svg>`
})

const fiveESteps = [
  { key: 'E1', label: 'E1 Engager', icon: IconFlame, state: 'done', sub: '✓ Terminée', color: 'var(--em)' },
  { key: 'E2', label: 'E2 Explorer', icon: IconCompass, state: 'done', sub: '✓ Terminée', color: 'var(--em)' },
  { key: 'E3', label: 'E3 Expliquer', icon: IconBulb, state: 'cur', sub: '● En cours', color: '#fff' },
  { key: 'E4', label: 'E4 Élaborer', icon: IconTool, state: 'locked', sub: 'Verrouillé', color: 'var(--tx3)' },
  { key: 'E5', label: 'E5 Évaluer', icon: IconRosette, state: 'locked', sub: 'Verrouillé', color: 'var(--tx3)' },
]

const pageLoading = ref(false)
const pageError = ref(null)

onMounted(async () => {
  if (!auth.profile?.id) return
  pageLoading.value = true
  pageError.value = null
  try {
    const uid = auth.profile.id
    await Promise.all([
      store.fetchSessions(),
      store.fetchCourses(),
      store.fetchBadges(uid),
      store.fetchQuizAttempts(uid),
    ])
    const firstFormation = store.formations[0]
    if (firstFormation) {
      await store.fetchPathPhases(firstFormation.id)
      const comps = await store.fetchActivityCompletions(uid, firstFormation.id)
      if (comps.data) completedActs.value = comps.data
    }
  } catch (e) {
    pageError.value = e?.message || 'Erreur lors du chargement'
  } finally {
    pageLoading.value = false
  }
})
</script>

<template>
  <div class="page">
  <div v-if="pageLoading" class="card fade-in" style="text-align:center;padding:60px 20px">
    <IconLoader2 :size="32" style="color:var(--blue);animation:spin 1s linear infinite" />
    <div style="margin-top:12px;color:var(--tx2);font-size:13px">Chargement…</div>
  </div>
  <div v-else-if="pageError" class="card fade-in" style="text-align:center;padding:40px 20px;border:1px solid var(--co)">
    <IconAlertTriangle :size="28" style="color:var(--co)" />
    <div style="margin-top:10px;font-size:13px;color:var(--co)">{{ pageError }}</div>
    <button class="btn btn-sm btn-primary" style="margin-top:14px" @click="pageError=null;$router.go()">Réessayer</button>
  </div>
  <template v-else>
  <!-- WELCOME -->
    <div class="welcome mb-20 fade-in">
      <div class="welcome-text">
        <div class="welcome-tag">Bon retour, Sophie 👋</div>
        <div class="welcome-title">Continuez sur votre lancée !</div>
        <div class="welcome-sub">Vous êtes à <strong>78 %</strong> de votre objectif mensuel — plus que 3 modules pour atteindre votre cible !</div>
<div class="flex gap-10 fw">
      <button class="btn btn-primary btn-sm" @click="router.push('/parcours')">
        <IconPlayerPlay :size="14" /> Reprendre la formation
      </button>
      <button class="btn btn-ghost btn-sm" @click="router.push('/catalogue')">
        <IconBooks :size="14" /> Explorer le catalogue
      </button>
    </div>
      </div>
      <div class="radar-wrap" style="flex-shrink:0;position:relative;z-index:1">
        <div style="text-align:center">
          <div v-html="radarSvg" />
          <div style="font-size:10px;color:rgba(255,255,255,.4);margin-top:5px">Radar de maturité</div>
        </div>
      </div>
    </div>

    <!-- KPI GRID -->
    <div class="grid-4 mb-20 fade-in-2">
<div class="kpi" @click="router.push('/catalogue')">
      <div class="kpi-label"><IconPlayerPlay :size="13" style="color:var(--blue)" /> Formations</div>
      <div class="kpi-value" style="color:var(--blue)">12</div>
      <div class="kpi-delta up"><IconTrendingUp :size="11" /> +3 ce mois</div>
    </div>
    <div class="kpi" @click="router.push('/cartographie')">
      <div class="kpi-label"><IconChartPie :size="13" style="color:var(--em)" /> Complétion</div>
      <div class="kpi-value" style="color:var(--em)">84 %</div>
      <div class="kpi-delta up"><IconTrendingUp :size="11" /> +6 % vs M-1</div>
    </div>
    <div class="kpi" @click="router.push('/parcours')">
      <div class="kpi-label"><IconCertificate :size="13" style="color:var(--am)" /> Certifications</div>
      <div class="kpi-value" style="color:var(--am)">7</div>
      <div class="kpi-delta up"><IconTrendingUp :size="11" /> 2 en cours</div>
    </div>
    <div class="kpi" @click="router.push('/parcours')">
        <div class="kpi-label"><IconStar :size="13" style="color:var(--pu)" /> Points XP</div>
        <div class="kpi-value" style="color:var(--pu)">248</div>
        <div class="kpi-delta up"><IconTrendingUp :size="11" /> +42 cette sem.</div>
      </div>
    </div>

    <!-- MAIN GRID -->
    <div class="grid-main mb-20 fade-in-3">

      <!-- LEFT COL -->
      <div class="flex flex-col gap-14">

        <!-- Formation en cours + 5E -->
        <div class="card">
          <div class="card-title"><IconPlayerPlay :size="13" style="color:var(--blue)" /> Formation en cours — Parcours 5E</div>
          <div class="flex gap-12 items-center mb-14" style="cursor:pointer" @click="router.push('/parcours')">
            <div style="width:52px;height:52px;border-radius:13px;background:rgba(0,212,161,.12);border:1px solid rgba(0,212,161,.3);display:flex;align-items:center;justify-content:center;flex-shrink:0">
              <IconRefresh :size="26" style="color:var(--em)" />
            </div>
            <div style="flex:1">
              <div style="font-family:var(--fh);font-size:14px;font-weight:700;margin-bottom:5px">Management Agile</div>
              <div class="flex gap-6 fw items-center mb-8">
                <span class="pill level-int">Intermédiaire</span>
                <span style="font-size:11px;color:var(--tx2)">Module 3/5 · Phase Expliquer</span>
              </div>
              <div class="bar mb-4"><div class="bf" style="width:67%;background:var(--blue)"></div></div>
              <div style="font-size:11px;color:var(--tx2)">67 % · 3h restantes</div>
            </div>
            <button class="btn btn-primary btn-sm" @click.stop="router.push('/parcours')">▶ Reprendre</button>
          </div>

          <!-- 5E stepper -->
          <div class="five-e">
            <div
              v-for="step in fiveESteps"
              :key="step.key"
              class="fe-step"
              :class="step.state"
              @click="step.state !== 'locked' && router.push('/parcours')"
            >
              <component :is="step.icon" :size="16" :style="{ color: step.color, display: 'block', margin: '0 auto 3px' }" />
              <div class="fe-label" :style="{ color: step.color }">{{ step.label }}</div>
              <div class="fe-sub" :class="{ pulsing: step.state === 'cur' }" :style="{ color: step.state === 'cur' ? 'rgba(255,255,255,.7)' : step.color }">{{ step.sub }}</div>
            </div>
          </div>
        </div>

        <!-- Mon parcours -->
        <div class="card">
          <div class="card-title"><IconRoute :size="13" style="color:var(--pu)" /> Mon parcours — Chef de projet Digital</div>
          <div class="flex gap-10 items-center mb-10">
            <div class="bar" style="flex:1"><div class="bf" style="width:67%;background:var(--pu)"></div></div>
            <span style="font-size:12px;font-weight:700;color:var(--pu)">67 %</span>
            <span style="font-size:11px;color:var(--tx2)">4/6 modules</span>
          </div>
          <div style="display:flex;align-items:center;gap:0">
            <div
              v-for="(step, i) in PATH_STEPS"
              :key="i"
              style="flex:1;display:flex;flex-direction:column;align-items:center"
            >
              <div style="display:flex;align-items:center;width:100%">
                <div v-if="i > 0" style="flex:1;height:2px" :style="{ background: step.state === 'done' || PATH_STEPS[i-1].state === 'done' ? 'var(--blue)' : 'var(--bd)' }"></div>
                <div v-else style="flex:1"></div>
                <div
                  style="width:32px;height:32px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;flex-shrink:0;transition:all .2s"
                  :style="{
                    background: step.state === 'done' ? 'var(--em)' : step.state === 'cur' ? 'var(--blue)' : 'var(--surf2)',
                    border: step.state === 'done' ? '2px solid var(--em)' : step.state === 'cur' ? '2px solid var(--blue)' : '2px solid var(--bd)',
                    color: step.state === 'done' || step.state === 'cur' ? '#fff' : 'var(--tx2)',
                    cursor: step.state === 'locked' ? 'default' : 'pointer'
                  }"
                  @click="step.state !== 'locked' && toast(step.label)"
                  :title="step.label"
                >
                  <template v-if="step.state === 'done'">✓</template>
                  <template v-else>{{ i + 1 }}</template>
                </div>
                <div v-if="i < PATH_STEPS.length - 1" style="flex:1;height:2px" :style="{ background: step.state === 'done' ? 'var(--blue)' : 'var(--bd)' }"></div>
                <div v-else style="flex:1"></div>
              </div>
              <div
                style="font-size:10px;margin-top:6px;text-align:center"
                :style="{
                  fontWeight: step.state === 'cur' ? '700' : '400',
                  color: step.state === 'cur' ? 'var(--blue)' : step.state === 'done' ? 'var(--tx)' : 'var(--tx2)'
                }"
              >{{ step.label }}</div>
            </div>
          </div>
        </div>

        <!-- Recommandé -->
        <div class="card">
          <div class="card-title"><IconBolt :size="13" style="color:var(--am)" /> Recommandé depuis votre cartographie</div>
          <div
            v-for="r in RECS"
            :key="r.title"
            class="rec-card"
            @click="router.push('/cartographie')"
          >
            <div class="rec-icon" :style="{ background: recBg(r.color) }">
              <component :is="ICON_MAP[r.icon]" :size="16" :style="{ color: r.color }" />
            </div>
            <div style="flex:1;min-width:0">
              <div style="font-size:12px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ r.title }}</div>
              <div style="font-size:10px;color:var(--tx2)">Score actuel : <strong :style="{ color: r.color }">{{ r.score }} / 100</strong></div>
            </div>
            <div>
              <span class="pill" :class="recPill(r.color)">{{ r.type }}</span>
            </div>
            <IconRoute :size="14" style="color:var(--tx3)" />
          </div>
        </div>

      </div>

      <!-- RIGHT COL -->
      <div class="flex flex-col gap-14">

        <!-- Prochaines sessions -->
        <div class="card">
          <div class="card-title"><IconCalendarEvent :size="13" style="color:var(--pu)" /> Prochaines sessions</div>
          <div
            v-for="s in SESSIONS"
            :key="s.title"
            class="sess-row"
            @click="router.push('/parcours')"
          >
            <div class="sess-day" :class="{ soon: daysUntil(s.date) >= 0 && daysUntil(s.date) <= 3 }">
              <div style="font-family:var(--fh);font-size:18px;font-weight:800" :style="{ color: daysUntil(s.date) >= 0 && daysUntil(s.date) <= 3 ? 'var(--am)' : 'var(--blue)' }">
                {{ daysUntil(s.date) < 0 ? '✓' : daysUntil(s.date) }}
              </div>
              <div style="font-size:8px;color:var(--tx2)">{{ daysUntil(s.date) < 0 ? 'passée' : 'jours' }}</div>
            </div>
            <div style="flex:1;min-width:0">
              <div style="font-size:12px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ s.title }}</div>
              <div style="font-size:11px;color:var(--tx2)">{{ fmtDate(s.date) }} · {{ s.hD }}–{{ s.hF }}</div>
              <div style="font-size:11px;font-weight:600;margin-top:2px" :style="{ color: s.mode === 'En ligne' ? 'var(--blue)' : 'var(--em)' }">
                <component :is="s.mode === 'En ligne' ? IconVideo : IconMapPin" :size="10" style="vertical-align:middle" /> {{ s.mode }} · {{ s.loc }}
              </div>
            </div>
            <button v-if="daysUntil(s.date) >= 0" class="btn btn-primary btn-xs" @click.stop="router.push('/parcours')">
              <component :is="s.mode === 'En ligne' ? IconVideo : IconMapPin" :size="11" /> Rejoindre
            </button>
          </div>
          <button class="btn btn-sm" style="width:100%;justify-content:center;margin-top:10px;border:1px solid transparent;background:transparent;color:var(--blue)" @click="router.push('/parcours')">
            Voir toutes mes sessions →
          </button>
        </div>

        <!-- Activité récente -->
        <div class="card">
          <div class="card-title"><IconTrendingUp :size="13" style="color:var(--em)" /> Activité récente</div>
          <div class="tl">
            <div v-for="a in ACTIVITIES" :key="a.text" class="tli">
              <div class="tl-dot" :style="{ background: a.color }"></div>
              <div style="font-size:12px;font-weight:600">{{ a.text }}</div>
              <div style="font-size:11px;color:var(--tx2)">{{ a.time }}</div>
            </div>
          </div>
        </div>

        <!-- Progression par domaine -->
        <div class="card">
          <div class="card-title"><IconChartPie :size="13" style="color:var(--blue)" /> Progression par domaine</div>
          <div v-for="d in DOMAINS" :key="d.label" style="margin-bottom:12px">
            <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:5px">
              <span style="font-weight:500">{{ d.label }}</span>
              <span style="font-weight:700" :style="{ color: d.color }">{{ d.pct }} %</span>
            </div>
            <div class="bar bar-lg"><div class="bf" :style="{ width: d.pct + '%', background: d.color }"></div></div>
          </div>
        </div>

      </div>
    </div>

    <!-- CATALOGUE RECOMMANDÉ -->
    <div class="fade-in-4">
      <div class="sec-hdr">
        <div class="sec-title">Catalogue — Recommandé pour vous</div>
        <button class="btn btn-sm" @click="router.push('/catalogue')">Voir tout →</button>
      </div>
      <div class="grid-3">
        <div
          v-for="c in COURSES.slice(0, 3)"
          :key="c.title"
          class="ccard"
          @click="router.push('/catalogue')"
        >
          <div class="cthumb" :style="{ background: c.col + '18' }">
            <component :is="ICON_MAP[c.icon]" :size="36" :style="{ color: c.col }" />
            <span class="pill c-level" :class="LVL_CLS[c.lvl]">{{ LVL_LBL[c.lvl] }}</span>
            <div v-if="c.prg === 100" class="c-done">✓ Terminé</div>
          </div>
          <div style="padding:14px">
            <div style="font-size:10px;color:var(--tx2);margin-bottom:4px">{{ c.cat }}</div>
            <div style="font-size:13px;font-weight:700;margin-bottom:6px;line-height:1.35">{{ c.title }}</div>
            <template v-if="c.prg > 0 && c.prg < 100">
              <div class="bar bar-sm mb-4"><div class="bf" :style="{ width: c.prg + '%', background: c.col }"></div></div>
              <div style="font-size:10px;color:var(--tx2);margin-bottom:6px">{{ c.prg }} %</div>
            </template>
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px">
              <span style="font-size:11px;color:var(--tx2)"><IconClock :size="11" style="vertical-align:middle" /> {{ c.dur }}</span>
              <span style="font-size:11px;color:var(--am)">★ {{ c.sc }}</span>
            </div>
            <button class="btn btn-primary btn-sm" style="width:100%;justify-content:center" @click.stop="async () => { const res = await store.createEnrollment({ user_id: auth.profile.id, course_id: c.id }); if (res.error) toast('Erreur : ' + res.error.message, 'err'); else { toast((c.prg === 100 ? 'Revoir' : 'Démarrer') + ' : ' + c.title); router.push('/parcours') } }">
              {{ c.prg === 100 ? 'Revoir' : c.prg > 0 ? '▶ Reprendre' : '▶ Commencer' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- BADGES -->
    <div class="card" style="margin-top:16px">
      <div class="card-title"><IconAward :size="13" style="color:var(--am)" /> Mes badges & récompenses</div>
      <div class="flex gap-10 fw">
        <div
          v-for="b in BADGES"
          :key="b.title"
          class="badge-item"
          @click="router.push('/parcours')"
        >
          <div class="badge-icon-wrap" :style="{ background: b.color + '18', border: '1px solid ' + b.color + '44' }">
            <component :is="ICON_MAP[b.icon]" :size="20" :style="{ color: b.color }" />
          </div>
          <div style="font-size:11px;font-weight:700">{{ b.title }}</div>
          <div style="font-size:10px;color:var(--tx2);margin-top:2px">{{ b.sub }}</div>
        </div>
      </div>
    </div>

    <!-- FOOTER -->
    <div style="text-align:center;padding:28px 0 8px;font-size:12px;color:var(--tx3)">
      SkillPath Pro — Module 1/7 : Tableau de bord Apprenant
    </div>
  </template>
  </div>
</template>

<style scoped>
.page {
  max-width: 1320px;
  margin: 0 auto;
  padding: 26px 28px 40px;
}

.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
.grid-4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.grid-main { display: grid; grid-template-columns: minmax(0,1.55fr) minmax(0,1fr); gap: 18px; }

.gap-6 { gap: 6px; }
.gap-8 { gap: 8px; }
.gap-10 { gap: 10px; }
.gap-12 { gap: 12px; }
.gap-14 { gap: 14px; }
.mb-4 { margin-bottom: 4px; }
.mb-8 { margin-bottom: 8px; }
.mb-10 { margin-bottom: 10px; }
.mb-14 { margin-bottom: 14px; }
.mb-16 { margin-bottom: 16px; }
.mb-20 { margin-bottom: 20px; }

.flex { display: flex; }
.items-center { align-items: center; }
.flex-col { flex-direction: column; }
.fw { flex-wrap: wrap; }

.card {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 18px 20px;
  box-shadow: var(--shadow-sm);
  transition: border-color .2s;
}
.card:hover { border-color: var(--bd2); }

.card-title {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: .9px;
  color: var(--tx2);
  margin-bottom: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.welcome {
  background: var(--navy);
  border-radius: var(--rl);
  padding: 26px 28px;
  display: flex;
  align-items: center;
  gap: 28px;
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255,255,255,.06);
}
.welcome::before {
  content: '';
  position: absolute;
  right: -60px;
  top: -60px;
  width: 260px;
  height: 260px;
  border-radius: 50%;
  background: var(--blue);
  opacity: .07;
}
.welcome::after {
  content: '';
  position: absolute;
  right: 60px;
  bottom: -80px;
  width: 180px;
  height: 180px;
  border-radius: 50%;
  background: var(--em);
  opacity: .06;
}
.welcome-text { flex: 1; position: relative; z-index: 1; }
.welcome-tag {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.8px;
  text-transform: uppercase;
  color: var(--em);
  margin-bottom: 8px;
}
.welcome-title {
  font-family: var(--fh);
  font-size: 22px;
  font-weight: 800;
  color: #fff;
  line-height: 1.25;
  margin-bottom: 8px;
  letter-spacing: -.4px;
}
.welcome-sub {
  font-size: 13px;
  color: rgba(255,255,255,.55);
  margin-bottom: 20px;
  line-height: 1.6;
}
.welcome-sub strong { color: var(--em); }

.kpi {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 16px 18px;
  box-shadow: var(--shadow-sm);
  transition: all .2s;
  cursor: default;
}
.kpi:hover { border-color: var(--bd2); transform: translateY(-1px); box-shadow: var(--shadow-md); }
.kpi-label { font-size: 11px; color: var(--tx2); display: flex; align-items: center; gap: 5px; }
.kpi-value { font-family: var(--fh); font-size: 26px; font-weight: 800; margin: 5px 0 3px; }
.kpi-delta { font-size: 11px; display: flex; align-items: center; gap: 3px; }
.up { color: var(--em); }
.dn { color: var(--co); }

.bar { height: 6px; background: var(--surf2); border-radius: 4px; overflow: hidden; }
.bar-sm { height: 4px; }
.bar-lg { height: 8px; }
.bf { height: 100%; border-radius: 4px; transition: width .6s cubic-bezier(.4,0,.2,1); }

.pill {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  font-size: 10px;
  font-weight: 700;
  padding: 3px 9px;
  border-radius: 20px;
}
.pill-blue { background: var(--blue-lt); color: #1A4AAA; border: 1px solid var(--blue-md); }
.pill-green { background: var(--em-lt); color: #005A42; border: 1px solid #A8EDD8; }
.pill-amber { background: var(--am-lt); color: #6B3B00; border: 1px solid #FFD280; }
.pill-coral { background: var(--co-lt); color: #7A0020; border: 1px solid #FFB3C0; }
.pill-purple { background: var(--pu-lt); color: #3C3480; border: 1px solid #C8C4F5; }
.pill-gray { background: var(--surf2); color: var(--tx2); border: 1px solid var(--bd); }

.level-deb { background: var(--em-lt); color: #005A42; border: 1px solid #A8EDD8; }
.level-int { background: var(--am-lt); color: #6B3B00; border: 1px solid #FFD280; }
.level-avd { background: var(--pu-lt); color: #3C3480; border: 1px solid #C8C4F5; }
.level-exp { background: var(--co-lt); color: #7A0020; border: 1px solid #FFB3C0; }

.btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: var(--rs);
  border: 1px solid var(--bd);
  background: var(--surf);
  color: var(--tx);
  font-size: 13px;
  font-weight: 600;
  font-family: var(--fb);
  cursor: pointer;
  transition: all .18s;
  white-space: nowrap;
}
.btn:hover { border-color: var(--blue); color: var(--blue); }
.btn-primary { background: var(--blue); color: #fff; border-color: var(--blue); box-shadow: var(--shadow-blue); }
.btn-primary:hover { background: #1658D8; border-color: #1658D8; color: #fff; }
.btn-ghost { background: rgba(255,255,255,.07); color: rgba(255,255,255,.85); border-color: rgba(255,255,255,.14); }
.btn-ghost:hover { background: rgba(255,255,255,.14); color: #fff; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
.btn-xs { padding: 3px 9px; font-size: 11px; }

.five-e { display: flex; border-radius: var(--rs); overflow: hidden; border: 1px solid var(--bd); }
.fe-step {
  flex: 1;
  padding: 10px 6px;
  text-align: center;
  cursor: pointer;
  transition: all .2s;
  border-right: 1px solid var(--bd);
}
.fe-step:last-child { border-right: none; }
.fe-step.done { background: rgba(0,212,161,.1); }
.fe-step.cur { background: var(--blue); }
.fe-step.locked { opacity: .4; cursor: default; }
.fe-step .fe-label { font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; }
.fe-step .fe-sub { font-size: 9px; margin-top: 1px; }

.ccard {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  overflow: hidden;
  cursor: pointer;
  transition: all .22s;
  box-shadow: var(--shadow-sm);
}
.ccard:hover { border-color: var(--blue); transform: translateY(-3px); box-shadow: var(--shadow-md); }
.cthumb { height: 108px; display: flex; align-items: center; justify-content: center; position: relative; }
.cthumb .c-level { position: absolute; top: 10px; right: 10px; }
.cthumb .c-done { position: absolute; top: 10px; left: 10px; background: var(--em); color: #fff; font-size: 9px; font-weight: 700; padding: 2px 8px; border-radius: 10px; }

.sess-row {
  display: flex;
  gap: 12px;
  align-items: flex-start;
  padding: 10px 0;
  border-bottom: 1px solid var(--bd);
  cursor: pointer;
  transition: all .15s;
}
.sess-row:last-child { border-bottom: none; }
.sess-row:hover { padding-left: 4px; }
.sess-day {
  min-width: 44px;
  text-align: center;
  background: var(--surf2);
  border-radius: var(--rs);
  padding: 6px 4px;
  flex-shrink: 0;
  border: 1px solid var(--bd);
}
.sess-day.soon { background: var(--am-lt); border-color: #FFD280; }

.tl { position: relative; padding-left: 22px; }
.tl::before {
  content: '';
  position: absolute;
  left: 7px;
  top: 6px;
  bottom: 6px;
  width: 2px;
  background: var(--bd);
  border-radius: 2px;
}
.tli { position: relative; padding-bottom: 14px; }
.tli:last-child { padding-bottom: 0; }
.tl-dot {
  position: absolute;
  left: -18px;
  top: 4px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  border: 2px solid var(--surf);
}

.rec-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border: 1px solid var(--bd);
  border-radius: var(--rs);
  cursor: pointer;
  transition: all .18s;
  margin-bottom: 8px;
  background: var(--surf);
}
.rec-card:hover { border-color: var(--blue); background: var(--blue-lt); }
.rec-card:last-child { margin-bottom: 0; }
.rec-icon {
  width: 34px;
  height: 34px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.sec-hdr {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}
.sec-title { font-family: var(--fh); font-size: 15px; font-weight: 700; }

.radar-wrap { display: flex; justify-content: center; align-items: center; }

.badge-item {
  text-align: center;
  min-width: 88px;
  padding: 12px 8px;
  background: var(--surf2);
  border-radius: 12px;
  border: 1px solid var(--bd);
  cursor: pointer;
  transition: all .18s;
}
.badge-item:hover { transform: translateY(-2px); }
.badge-icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 7px;
}

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}
.fade-in { animation: fadeUp .35s ease forwards; }
.fade-in-2 { animation: fadeUp .35s ease .08s forwards; opacity: 0; }
.fade-in-3 { animation: fadeUp .35s ease .16s forwards; opacity: 0; }
.fade-in-4 { animation: fadeUp .35s ease .24s forwards; opacity: 0; }

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: .5; }
}
.pulsing { animation: pulse 2s infinite; }

@media (max-width: 1100px) {
  .grid-main { grid-template-columns: 1fr; }
}
@media (max-width: 900px) {
  .grid-4 { grid-template-columns: 1fr 1fr; }
  .grid-3 { grid-template-columns: 1fr 1fr; }
}
@media (max-width: 600px) {
  .grid-4, .grid-3, .grid-2 { grid-template-columns: 1fr; }
  .page { padding: 16px; }
  .welcome { flex-direction: column; gap: 16px; }
}
</style>
