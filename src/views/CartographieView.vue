<script setup>
import { ref, computed, inject, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import {
  IconUsers,
  IconMessageCircle,
  IconChartBar,
  IconRefresh,
  IconExchange,
  IconLock,
  IconBulb,
  IconSitemap,
  IconDeviceLaptop,
  IconSpeakerphone,
  IconDownload,
  IconSend,
  IconChartRadar,
  IconInfoCircle,
  IconBooks,
  IconBookmark,
  IconList,
  IconClipboardList,
  IconX,
  IconPlus,
  IconCheck,
  IconPlayerPlay,
  IconRoute,
  IconAlertTriangle,
  IconLayersIntersect,
  IconTable,
  IconTarget,
  IconUser,
  IconLayoutList,
  IconHeadphones,
  IconPencil,
  IconHelp,
  IconCalendarEvent,
  IconSearch,
  IconLoader2,
} from '@tabler/icons-vue'

const auth = useAuthStore()
const store = useDataStore()
const toast = inject('toast')

const pageLoading = ref(false)
const pageError = ref(null)
const view = ref('individual')
const selectedComp = ref(null)
const compTab = ref('catalogue')
const selectedMember = ref('sl')
const assignedResources = computed(() => {
  if (Object.keys(store.developmentPlanResources).length) return store.developmentPlanResources
  return { lead: ['r1', 'r2'], comm: ['r5'], agil: ['r13', 'r15'], nego: [], cyber: ['r19'], data: [], innov: [], mgmt: [], digit: [], mktg: [] }
})

const STATIC_COMPETENCIES = [
  { id: 'lead', name: 'Leadership', icon: IconUsers, score: 87, status: 'mastered' },
  { id: 'comm', name: 'Communication', icon: IconMessageCircle, score: 72, status: 'progress' },
  { id: 'data', name: 'Data & Analyse', icon: IconChartBar, score: 45, status: 'weak' },
  { id: 'agil', name: 'Agilité', icon: IconRefresh, score: 91, status: 'mastered' },
  { id: 'nego', name: 'Négociation', icon: IconExchange, score: 33, status: 'weak' },
  { id: 'cyber', name: 'Cybersécurité', icon: IconLock, score: 12, status: 'weak' },
  { id: 'innov', name: 'Innovation', icon: IconBulb, score: 68, status: 'progress' },
  { id: 'mgmt', name: 'Management', icon: IconSitemap, score: 40, status: 'progress' },
  { id: 'digit', name: 'Outils Digitaux', icon: IconDeviceLaptop, score: 78, status: 'mastered' },
  { id: 'mktg', name: 'Marketing', icon: IconSpeakerphone, score: 0, status: 'locked' },
]

const ICON_BY_COMP = {
  lead: IconUsers, comm: IconMessageCircle, data: IconChartBar, agil: IconRefresh,
  nego: IconExchange, cyber: IconLock, innov: IconBulb, mgmt: IconSitemap,
  digit: IconDeviceLaptop, mktg: IconSpeakerphone,
}

const COMPETENCIES = computed(() => {
  if (store.competencies.length) {
    return store.competencies.map(c => {
      const s = store.competencyScores[c.id]
      return {
        id: c.id,
        name: c.name,
        icon: ICON_BY_COMP[c.id] || IconTarget,
        score: s?.score || 0,
        status: s?.status || 'locked',
      }
    })
  }
  return STATIC_COMPETENCIES
})

const STATIC_RESOURCES = [
  { id: 'r1', type: 'module', title: 'Leadership situationnel — Module complet', level: 'avd', dur: '4h', comp: 'lead', score: 4.8 },
  { id: 'r2', type: 'video', title: 'Les 5 styles de leadership', level: 'int', dur: '22min', comp: 'lead', score: 4.6 },
  { id: 'r3', type: 'quiz', title: 'Quiz — Leadership niveau avancé', level: 'avd', dur: '15min', comp: 'lead', score: 4.5 },
  { id: 'r4', type: 'situation', title: "Gérer un conflit d'équipe — Simulation", level: 'avd', dur: '45min', comp: 'lead', score: 4.9 },
  { id: 'r5', type: 'elearning', title: 'Communication Non Violente — Parcours', level: 'int', dur: '3h', comp: 'comm', score: 4.7 },
  { id: 'r6', type: 'podcast', title: "Clés d'une communication efficace", level: 'deb', dur: '35min', comp: 'comm', score: 4.4 },
  { id: 'r7', type: 'exercice', title: 'Exercice — Reformulation active', level: 'int', dur: '30min', comp: 'comm', score: 4.3 },
  { id: 'r8', type: 'module', title: 'Storytelling professionnel', level: 'int', dur: '2h', comp: 'comm', score: 4.5 },
  { id: 'r9', type: 'module', title: 'Introduction à la Data Science', level: 'deb', dur: '6h', comp: 'data', score: 4.8 },
  { id: 'r10', type: 'video', title: 'Excel — Tableaux croisés dynamiques', level: 'int', dur: '40min', comp: 'data', score: 4.6 },
  { id: 'r11', type: 'exercice', title: 'TP — Analyse de données réelles', level: 'int', dur: '2h', comp: 'data', score: 4.7 },
  { id: 'r12', type: 'elearning', title: 'Power BI — Visualisation Data', level: 'int', dur: '8h', comp: 'data', score: 4.7 },
  { id: 'r13', type: 'module', title: 'Fondamentaux SCRUM', level: 'deb', dur: '3h', comp: 'agil', score: 4.7 },
  { id: 'r14', type: 'situation', title: 'Sprint planning — Simulation complète', level: 'int', dur: '1h', comp: 'agil', score: 4.8 },
  { id: 'r15', type: 'quiz', title: 'Quiz — Agilité & méthodes', level: 'avd', dur: '20min', comp: 'agil', score: 4.5 },
  { id: 'r16', type: 'module', title: 'Techniques de négociation avancée', level: 'avd', dur: '5h', comp: 'nego', score: 4.9 },
  { id: 'r17', type: 'video', title: 'La négociation raisonnée — Harvard', level: 'int', dur: '28min', comp: 'nego', score: 4.7 },
  { id: 'r18', type: 'situation', title: 'Négocier un contrat — Jeu de rôle', level: 'avd', dur: '1h', comp: 'nego', score: 4.8 },
  { id: 'r19', type: 'module', title: 'Cybersécurité fondamentaux', level: 'deb', dur: '4h', comp: 'cyber', score: 4.6 },
  { id: 'r20', type: 'quiz', title: 'Quiz — Bonnes pratiques sécurité', level: 'deb', dur: '15min', comp: 'cyber', score: 4.4 },
  { id: 'r21', type: 'video', title: 'Phishing & ingénierie sociale', level: 'deb', dur: '20min', comp: 'cyber', score: 4.3 },
  { id: 'r22', type: 'elearning', title: 'Design Thinking & Innovation', level: 'int', dur: '4h', comp: 'innov', score: 4.8 },
  { id: 'r23', type: 'exercice', title: 'Atelier — Brainstorming structuré', level: 'int', dur: '1h', comp: 'innov', score: 4.6 },
  { id: 'r24', type: 'module', title: "Management d'équipe — Parcours complet", level: 'avd', dur: '8h', comp: 'mgmt', score: 4.9 },
  { id: 'r25', type: 'podcast', title: 'Manager coach — Les fondamentaux', level: 'int', dur: '42min', comp: 'mgmt', score: 4.5 },
  { id: 'r26', type: 'elearning', title: 'Excel Avancé — Tableaux de bord', level: 'deb', dur: '5h', comp: 'digit', score: 4.5 },
  { id: 'r27', type: 'module', title: 'Automatiser avec Zapier — No-code', level: 'deb', dur: '4h', comp: 'digit', score: 4.4 },
]

const RESOURCES = computed(() => store.resources.length ? store.resources : STATIC_RESOURCES)

const RESOURCE_TYPES = {
  module: { label: 'Module', icon: IconLayoutList, bg: '#EEF4FF', tc: '#1A4AAA', bc: '#C5D9FF' },
  elearning: { label: 'E-learning', icon: IconDeviceLaptop, bg: '#F0EFFE', tc: '#3C3480', bc: '#C8C4F5' },
  video: { label: 'Vidéo', icon: IconPlayerPlay, bg: '#FFF0F2', tc: '#7A0020', bc: '#FFB3C0' },
  podcast: { label: 'Podcast', icon: IconHeadphones, bg: '#FFF4E0', tc: '#6B3B00', bc: '#FFD280' },
  exercice: { label: 'Exercice', icon: IconPencil, bg: '#E0F9F3', tc: '#005A42', bc: '#A8EDD8' },
  quiz: { label: 'Quiz', icon: IconHelp, bg: '#FFF3FB', tc: '#6B0050', bc: '#F5B3E8' },
  situation: { label: 'Mise en situation', icon: IconUsers, bg: '#F5F5F0', tc: '#444440', bc: '#CCCCC0' },
}

const LEVEL_LABELS = { deb: 'Débutant', int: 'Intermédiaire', avd: 'Avancé', exp: 'Expert' }
const LEVEL_PILLS = { deb: 'level-deb', int: 'level-int', avd: 'level-avd', exp: 'level-exp' }

const TEAM_MEMBERS = [
  { id: 'sl', name: 'Sophie Laurent', init: 'SL', role: 'Chef de projet', color: '#1E6FFF',
    scores: { lead: 87, comm: 72, data: 45, agil: 91, nego: 33, cyber: 12, innov: 68, mgmt: 40, digit: 78, mktg: 0 } },
  { id: 'tb', name: 'Thomas Bernard', init: 'TB', role: 'Dev. Senior', color: '#00D4A1',
    scores: { lead: 52, comm: 61, data: 88, agil: 79, nego: 25, cyber: 70, innov: 55, mgmt: 30, digit: 85, mktg: 0 } },
  { id: 'ep', name: 'Emma Petit', init: 'EP', role: 'Product Owner', color: '#FF4D6A',
    scores: { lead: 75, comm: 90, data: 62, agil: 95, nego: 68, cyber: 40, innov: 84, mgmt: 58, digit: 72, mktg: 45 } },
  { id: 'lm', name: 'Lucas Moreau', init: 'LM', role: 'Analyste Data', color: '#FF9B21',
    scores: { lead: 35, comm: 48, data: 91, agil: 55, nego: 42, cyber: 58, innov: 30, mgmt: 22, digit: 80, mktg: 20 } },
  { id: 'jd', name: 'Julie Durand', init: 'JD', role: 'UX Designer', color: '#7B6FEE',
    scores: { lead: 60, comm: 85, data: 50, agil: 73, nego: 55, cyber: 28, innov: 92, mgmt: 44, digit: 68, mktg: 60 } },
]

const scoreColor = v => v >= 75 ? 'var(--em)' : v >= 50 ? 'var(--am)' : 'var(--co)'
const scoreHex = v => v >= 75 ? '#00D4A1' : v >= 50 ? '#FF9B21' : '#FF4D6A'
const avg = obj => {
  const vals = Object.values(obj).filter(v => v > 0)
  return vals.length ? Math.round(vals.reduce((s, v) => s + v, 0) / vals.length) : 0
}

function toggleResource(compId, resId) {
  const arr = assignedResources.value[compId] || []
  const idx = arr.indexOf(resId)
  if (idx === -1) {
    if (auth.profile?.id) {
      store.assignResourceToPlan(auth.profile.id, compId, resId)
    }
    toast('Ressource assignée au plan de développement !')
  } else {
    if (auth.profile?.id) {
      store.removeResourceFromPlan(auth.profile.id, compId, resId)
    }
    toast('Ressource retirée du plan')
  }
}

function buildRadar(scores, size, color, showLabels = true, showCenter = true) {
  const keys = ['lead', 'comm', 'data', 'agil', 'nego', 'cyber', 'innov', 'mgmt']
  const labs = ['Lead.', 'Comm.', 'Data', 'Agil.', 'Négo.', 'Cyber', 'Innov.', 'Mgmt']
  const n = keys.length, cx = size / 2, cy = size / 2, r = size / 2 - (showLabels ? 26 : 10)
  const dark = auth.isDark
  const bdC = dark ? '#283B58' : '#E2E8F5'
  const txC = dark ? '#7A8FAE' : '#526080'
  const sfC = dark ? '#0F1829' : '#fff'
  const txMain = dark ? '#EFF3FF' : '#0B1628'

  const pts = keys.map((k, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    const d = ((scores[k] || 0) / 100) * r
    return `${(cx + d * Math.cos(a)).toFixed(1)},${(cy + d * Math.sin(a)).toFixed(1)}`
  }).join(' ')

  const grid = [0.25, 0.5, 0.75, 1].map(f =>
    keys.map((_, i) => {
      const a = (i / n) * Math.PI * 2 - Math.PI / 2
      return `${(cx + f * r * Math.cos(a)).toFixed(1)},${(cy + f * r * Math.sin(a)).toFixed(1)}`
    }).join(' ')
  )

  const axLines = keys.map((_, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    return `<line x1="${cx}" y1="${cy}" x2="${(cx + r * Math.cos(a)).toFixed(1)}" y2="${(cy + r * Math.sin(a)).toFixed(1)}" stroke="${bdC}" stroke-width="0.5"/>`
  }).join('')

  const labelEls = showLabels ? labs.map((l, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    return `<text x="${(cx + (r + 16) * Math.cos(a)).toFixed(1)}" y="${(cy + (r + 16) * Math.sin(a)).toFixed(1)}" text-anchor="middle" dominant-baseline="central" font-size="9.5" fill="${txC}" font-family="Epilogue,sans-serif">${l}</text>`
  }).join('') : ''

  const dots = keys.map((k, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2, d = ((scores[k] || 0) / 100) * r
    return `<circle cx="${(cx + d * Math.cos(a)).toFixed(1)}" cy="${(cy + d * Math.sin(a)).toFixed(1)}" r="3" fill="${color}" stroke="${sfC}" stroke-width="1.5"/>`
  }).join('')

  const centerAvg = avg({
    lead: scores.lead || 0, comm: scores.comm || 0, data: scores.data || 0,
    agil: scores.agil || 0, nego: scores.nego || 0, cyber: scores.cyber || 0,
    innov: scores.innov || 0, mgmt: scores.mgmt || 0,
  })

  const centerEl = showCenter
    ? `<text x="${cx}" y="${cy - 7}" text-anchor="middle" font-size="17" font-weight="800" fill="${txMain}" font-family="Sora,sans-serif">${centerAvg}</text>
       <text x="${cx}" y="${cy + 9}" text-anchor="middle" font-size="9" fill="${txC}">/ 100</text>`
    : ''

  return `<svg width="${size}" height="${size}" viewBox="0 0 ${size} ${size}" style="overflow:visible">
    ${grid.map(g => `<polygon points="${g}" fill="none" stroke="${bdC}" stroke-width="0.5"/>`).join('')}
    ${axLines}
    <polygon points="${pts}" fill="${color}18" stroke="${color}" stroke-width="1.8"/>
    ${dots}
    ${labelEls}
    ${centerEl}
  </svg>`
}

function buildComparisonRadar(selectedId) {
  const keys = ['lead', 'comm', 'data', 'agil', 'nego', 'cyber', 'innov', 'mgmt']
  const labs = ['Lead.', 'Comm.', 'Data', 'Agil.', 'Négo.', 'Cyber', 'Innov.', 'Mgmt']
  const n = keys.length, cx = 110, cy = 110, r = 84
  const dark = auth.isDark
  const bdC = dark ? '#283B58' : '#E2E8F5'
  const txC = dark ? '#7A8FAE' : '#526080'

  const grid = [0.25, 0.5, 0.75, 1].map(f =>
    keys.map((_, i) => {
      const a = (i / n) * Math.PI * 2 - Math.PI / 2
      return `${(cx + f * r * Math.cos(a)).toFixed(1)},${(cy + f * r * Math.sin(a)).toFixed(1)}`
    }).join(' ')
  )

  const axLines = keys.map((_, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    return `<line x1="${cx}" y1="${cy}" x2="${(cx + r * Math.cos(a)).toFixed(1)}" y2="${(cy + r * Math.sin(a)).toFixed(1)}" stroke="${bdC}" stroke-width="0.5"/>`
  }).join('')

  const labelEls = labs.map((l, i) => {
    const a = (i / n) * Math.PI * 2 - Math.PI / 2
    return `<text x="${(cx + (r + 16) * Math.cos(a)).toFixed(1)}" y="${(cy + (r + 16) * Math.sin(a)).toFixed(1)}" text-anchor="middle" dominant-baseline="central" font-size="9" fill="${txC}" font-family="Epilogue,sans-serif">${l}</text>`
  }).join('')

  const polygons = TEAM_MEMBERS.map(m => {
    const pts = keys.map((k, i) => {
      const a = (i / n) * Math.PI * 2 - Math.PI / 2
      const d = ((m.scores[k] || 0) / 100) * r
      return `${(cx + d * Math.cos(a)).toFixed(1)},${(cy + d * Math.sin(a)).toFixed(1)}`
    }).join(' ')
    const isSelected = m.id === selectedId
    return `<polygon points="${pts}" fill="${m.color}${isSelected ? '30' : '12'}" stroke="${m.color}" stroke-width="${isSelected ? 2 : 0.8}" ${isSelected ? '' : 'stroke-dasharray="4,2"'}/>`
  }).join('')

  return `<svg width="220" height="220" viewBox="0 0 220 220" style="overflow:visible">
    ${grid.map(g => `<polygon points="${g}" fill="none" stroke="${bdC}" stroke-width="0.5"/>`).join('')}
    ${axLines}
    ${polygons}
    ${labelEls}
  </svg>`
}

const currentMember = computed(() => TEAM_MEMBERS.find(m => m.id === selectedMember.value))
const memberScores = computed(() => currentMember.value?.scores || {})
const memberAvg = computed(() => avg(memberScores.value))
const totalAssigned = computed(() => Object.values(assignedResources.value).reduce((s, a) => s + a.length, 0))
const weakCount = computed(() => COMPETENCIES.filter(c => c.status === 'weak').length)
const coveredWeak = computed(() => COMPETENCIES.filter(c => c.status !== 'mastered' && c.status !== 'locked' && (assignedResources.value[c.id] || []).length > 0).length)
const totalWeak = computed(() => COMPETENCIES.filter(c => c.status !== 'mastered' && c.status !== 'locked').length)

const selComp = computed(() => selectedComp.value ? COMPETENCIES.find(c => c.id === selectedComp.value) : null)
const compResources = computed(() => {
  if (!selComp.value) return []
  return RESOURCES.filter(r =>
    r.comp === selComp.value.id &&
    (compTab.value === 'assigned'
      ? (assignedResources.value[selComp.value.id] || []).includes(r.id)
      : true)
  )
})
const assignedCount = computed(() => selComp.value ? (assignedResources.value[selComp.value.id] || []).length : 0)
const totalForComp = computed(() => selComp.value ? RESOURCES.filter(r => r.comp === selComp.value.id).length : 0)

const planCompetencies = computed(() =>
  COMPETENCIES.filter(c => c.status !== 'mastered' && c.status !== 'locked' && (assignedResources.value[c.id] || []).length > 0)
)

const sharedGaps = computed(() =>
  COMPETENCIES.filter(c => c.id !== 'mktg').filter(c => {
    const lowCount = TEAM_MEMBERS.filter(m => (m.scores[c.id] || 0) < 50).length
    return lowCount >= 3
  })
)

function isAssigned(compId, resId) {
  return (assignedResources.value[compId] || []).includes(resId)
}

function selectComp(compId) {
  if (COMPETENCIES.find(c => c.id === compId)?.status === 'locked') {
    toast("Compétence verrouillée — déverrouillez d'abord le module précédent")
    return
  }
  selectedComp.value = compId
  compTab.value = 'catalogue'
}

function planDurStr(resources) {
  const totalMin = resources.reduce((s, r) => {
    const m = r.dur.includes('h') ? parseInt(r.dur) * 60 : parseInt(r.dur)
    return s + m
  }, 0)
  return totalMin >= 60 ? `${Math.floor(totalMin / 60)}h${totalMin % 60 > 0 ? totalMin % 60 + 'min' : ''}` : totalMin + 'min'
}

function getResById(rid) {
  return RESOURCES.find(r => r.id === rid)
}

function goToCompResources(compId) {
  view.value = 'individual'
  selectedComp.value = compId
  compTab.value = 'catalogue'
}

function emptyMsg() {
  return compTab.value === 'assigned'
    ? 'Aucune ressource assignée.<br>Passez à l\u0027onglet Catalogue pour en ajouter.'
    : 'Aucune ressource disponible pour cette compétence.'
}

const heroStats = computed(() => [
  { label: 'Score global', value: memberAvg.value + ' / 100', color: 'var(--blue)' },
  { label: 'Maîtrisées', value: COMPETENCIES.filter(c => c.status === 'mastered').length + ' / ' + COMPETENCIES.length, color: 'var(--em)' },
  { label: 'Ressources assignées', value: totalAssigned.value, color: 'var(--am)' },
  { label: 'Plan couvert', value: coveredWeak.value + ' / ' + totalWeak.value, color: 'var(--pu)' },
])

const radarSvg = computed(() => buildRadar(memberScores.value, 220, '#1E6FFF', true, true))
const teamRadarSvg = computed(() => {
  const m = currentMember.value
  return m ? buildRadar(m.scores, 220, m.color, true, true) : ''
})
const comparisonSvg = computed(() => buildComparisonRadar(selectedMember.value))

const memberMiniRadars = computed(() => {
  const result = {}
  TEAM_MEMBERS.forEach(m => {
    result[m.id] = buildRadar(m.scores, 90, m.color, false, false)
  })
  return result
})

onMounted(async () => {
  pageLoading.value = true
  pageError.value = null
  try {
    if (!auth.profile?.id) return
    const uid = auth.profile.id
    await Promise.all([
      store.fetchCompetencies(),
      store.fetchCompetencyScores(uid),
      store.fetchResources(),
      store.fetchDevelopmentPlanResources(uid),
    ])
  } catch (e) {
    pageError.value = e?.message || 'Erreur lors du chargement'
  } finally {
    pageLoading.value = false
  }
})
</script>

<template>
  <div class="page">
    <div v-if="pageLoading" style="display:flex;flex-direction:column;align-items:center;justify-content:center;padding:80px 20px;gap:14px">
      <IconLoader2 :size="36" style="color:var(--blue);animation:spin 1s linear infinite" />
      <div style="font-size:14px;color:var(--tx2)">Chargement…</div>
    </div>
    <div v-else-if="pageError" style="display:flex;flex-direction:column;align-items:center;justify-content:center;padding:80px 20px;gap:14px">
      <IconAlertTriangle :size="36" style="color:var(--co)" />
      <div style="font-size:14px;color:var(--co)">{{ pageError }}</div>
    </div>
    <template v-else>
<!-- HERO -->
    <div class="hero">
      <div class="hero-content">
        <div class="hero-tag">Cartographie des compétences</div>
        <div class="hero-title">Visualisez vos forces et vos axes de progrès</div>
        <div class="hero-subtitle">Assignez des ressources sur chaque compétence pour générer votre plan de développement personnalisé.</div>
        <div class="hero-actions">
<button class="btn btn-sm hero-btn" @click="async () => { const res = await store.shareDevelopmentPlan(auth.profile.id, null, developmentPlanResources); toast(res.error ? 'Erreur : ' + res.error.message : 'Plan de développement exporté en PDF !') }">
      <IconDownload :size="15" /> Exporter mon plan
    </button>
    <button class="btn btn-sm hero-btn" @click="async () => { const res = await store.shareDevelopmentPlan(auth.profile.id, null, {}); toast(res.error ? 'Erreur : ' + res.error.message : 'Plan partagé au manager !') }">
            <IconSend :size="15" /> Partager au manager
          </button>
        </div>
      </div>
      <div class="hero-stats">
        <div v-for="stat in heroStats" :key="stat.label" class="hero-stat">
          <div class="hero-stat-val">{{ stat.value }}</div>
          <div class="hero-stat-lbl">{{ stat.label }}</div>
        </div>
      </div>
    </div>

    <!-- VIEW TOGGLE + PILLS -->
    <div class="toggle-row">
      <div class="view-toggle">
        <button :class="['vt-btn', { active: view === 'individual' }]" @click="view = 'individual'; selectedComp = null">
          <IconUser :size="15" /> Vue individuelle
        </button>
        <button :class="['vt-btn', { active: view === 'team' }]" @click="view = 'team'; selectedComp = null">
          <IconUsers :size="15" /> Vue Manager / Équipe
        </button>
      </div>
      <div class="pill-legend">
        <span class="pill pill-green">⬤ Maîtrisé ≥75</span>
        <span class="pill pill-amber">⬤ Progression 50–74</span>
        <span class="pill pill-coral">⬤ À renforcer &lt;50</span>
        <span class="pill pill-gray">⬤ Verrouillé</span>
      </div>
    </div>

    <!-- ═══════════════════════════ INDIVIDUAL VIEW ═══════════════════════════ -->
    <template v-if="view === 'individual'">
      <div class="grid-main">
        <!-- LEFT PANEL -->
        <div class="left-panel">
          <!-- Radar -->
          <div class="card">
            <div class="card-title">
              <IconChartRadar :size="15" style="color:var(--blue)" /> Radar de maturité — Sophie Laurent
            </div>
            <div class="radar-center">
              <div v-html="radarSvg"></div>
            </div>
            <div class="info-tip">
              <IconInfoCircle :size="14" style="color:var(--blue);flex-shrink:0" />
              Cliquez sur une compétence dans la grille pour voir les ressources et construire votre plan de développement.
            </div>
          </div>

          <!-- Selected competency -->
          <div v-if="selComp" class="card" style="border-color:var(--blue)">
            <div class="sel-header">
              <div class="sel-info">
                <div class="sel-icon-wrap" :style="{ background: scoreColor(selComp.score) + '18' }">
                  <component :is="selComp.icon" :size="18" :style="{ color: scoreColor(selComp.score) }" />
                </div>
                <div>
                  <div class="sel-name">{{ selComp.name }}</div>
                  <div class="sel-meta">
                    <span :class="['pill', selComp.status === 'mastered' ? 'pill-green' : selComp.status === 'progress' ? 'pill-amber' : 'pill-coral']">
                      {{ selComp.status === 'mastered' ? 'Maîtrisé' : selComp.status === 'progress' ? 'En progression' : 'À renforcer' }}
                    </span>
                    <span class="sel-score" :style="{ color: scoreColor(selComp.score) }">{{ selComp.score }}/100</span>
                  </div>
                </div>
                <div class="bar bar-lg" style="width:220px">
                  <div class="bf" :style="{ width: selComp.score + '%', background: scoreColor(selComp.score) }"></div>
                </div>
              </div>
              <button class="btn btn-sm" @click="selectedComp = null">
                <IconX :size="14" /> Fermer
              </button>
            </div>

            <!-- Resource tabs -->
            <div class="tabs">
              <div :class="['tab', { active: compTab === 'catalogue' }]" @click="compTab = 'catalogue'">
                <IconBooks :size="15" /> Catalogue ({{ totalForComp }})
              </div>
              <div :class="['tab', { active: compTab === 'assigned' }]" @click="compTab = 'assigned'">
                <IconBookmark :size="15" /> Mon plan ({{ assignedCount }})
              </div>
            </div>

            <div class="res-list">
              <template v-if="compResources.length">
                <div
                  v-for="r in compResources"
                  :key="r.id"
                  :class="['res-card', { assigned: isAssigned(selComp.id, r.id) }]"
                  @click="toggleResource(selComp.id, r.id)"
                >
                  <div class="res-type-icon" :style="{ background: RESOURCE_TYPES[r.type]?.bg }">
                    <component :is="RESOURCE_TYPES[r.type]?.icon" :size="15" :style="{ color: RESOURCE_TYPES[r.type]?.tc }" />
                  </div>
                  <div class="res-body">
                    <div class="res-title">{{ r.title }}</div>
                    <div class="res-meta">
                      <span class="pill" :style="{ background: RESOURCE_TYPES[r.type]?.bg, color: RESOURCE_TYPES[r.type]?.tc, border: '1px solid ' + RESOURCE_TYPES[r.type]?.bc }">
                        {{ RESOURCE_TYPES[r.type]?.label }}
                      </span>
                      <span :class="['pill', LEVEL_PILLS[r.level] || 'pill-gray']">{{ LEVEL_LABELS[r.level] || r.level }}</span>
                      <span style="font-size:10px;color:var(--tx2)">{{ r.dur }}</span>
                      <span style="font-size:10px;color:var(--am)">★ {{ r.score }}</span>
                    </div>
                  </div>
                  <button
                    :class="['btn', isAssigned(selComp.id, r.id) ? 'btn-success' : 'btn-primary', 'btn-xs']"
                    @click.stop="toggleResource(selComp.id, r.id)"
                  >
          <template v-if="isAssigned(selComp.id, r.id)"><IconCheck :size="12" /> Assigné</template>
          <template v-else><IconPlus :size="12" /> Assigner</template>
                  </button>
                </div>
              </template>
              <div v-else class="empty-state">
                <IconBookmark v-if="compTab === 'assigned'" :size="32" style="opacity:.3" />
                <IconSearch v-else :size="32" style="opacity:.3" />
                <div style="font-size:13px" v-html="emptyMsg()"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
          <!-- Competency grid -->
          <div class="card">
            <div class="card-header">
              <div class="card-title" style="margin-bottom:0">
                <IconList :size="15" style="color:var(--pu)" /> Mes compétences
              </div>
              <span style="font-size:11px;color:var(--tx2)">{{ COMPETENCIES.filter(c => c.status !== 'locked').length }} actives</span>
            </div>
            <div class="grid-comp">
      <div
        v-for="c in COMPETENCIES"
        :key="c.id"
        :class="['comp-node', c.status, { active: selectedComp === c.id }]"
        @click="selectComp(c.id)"
      >
      <div v-if="(assignedResources[c.id] || []).length > 0" class="res-badge">
        {{ (assignedResources[c.id] || []).length }}
      </div>
                <div class="comp-icon-row">
                  <component :is="c.icon" :size="15" :style="{ color: c.status === 'mastered' ? 'var(--em)' : c.status === 'progress' ? 'var(--am)' : c.status === 'weak' ? 'var(--co)' : 'var(--tx3)' }" />
                  <span class="comp-name">{{ c.name }}</span>
                </div>
                <div :class="['comp-score', c.status === 'locked' ? '' : '']" :style="{ color: c.status === 'mastered' ? 'var(--em)' : c.status === 'progress' ? 'var(--am)' : c.status === 'weak' ? 'var(--co)' : 'var(--tx3)' }">
                  {{ c.score > 0 ? c.score : '—' }}
                </div>
                <template v-if="c.score > 0">
                  <div style="font-size:9px;color:var(--tx2);margin-bottom:6px">/ 100</div>
                  <div class="bar">
                    <div class="bf" :style="{ width: c.score + '%', background: c.status === 'mastered' ? 'var(--em)' : c.status === 'progress' ? 'var(--am)' : 'var(--co)' }"></div>
                  </div>
                </template>
                <div v-else style="font-size:9px;color:var(--tx3)">Non démarré</div>
              </div>
            </div>
          </div>

          <!-- Development plan -->
          <div class="card">
            <div class="card-header">
              <div class="card-title" style="margin-bottom:0">
                <IconClipboardList :size="15" style="color:var(--em)" /> Plan de développement
              </div>
              <button v-if="totalAssigned > 0" class="btn btn-sm btn-primary" @click="async () => { await store.shareDevelopmentPlan(auth.profile.id, null, developmentPlanResources); toast('Plan exporté en PDF !') }">
                <IconDownload :size="14" /> Exporter
              </button>
            </div>

            <template v-if="planCompetencies.length">
              <div
                v-for="comp in planCompetencies"
                :key="comp.id"
                class="plan-item"
                :style="{ borderLeftColor: comp.status === 'progress' ? 'var(--am)' : 'var(--co)' }"
              >
                <div class="plan-item-header">
                  <div class="plan-item-left">
                    <component :is="comp.icon" :size="15" :style="{ color: comp.status === 'progress' ? 'var(--am)' : 'var(--co)' }" />
                    <span class="plan-comp-name">{{ comp.name }}</span>
                    <span class="plan-comp-score" :style="{ color: comp.status === 'progress' ? 'var(--am)' : 'var(--co)' }">{{ comp.score }}/100</span>
                  </div>
                  <span class="plan-meta-right">
                    {{ (assignedResources[comp.id] || []).length }} ressource{{ (assignedResources[comp.id] || []).length > 1 ? 's' : '' }} · {{ planDurStr((assignedResources[comp.id] || []).map(getResById).filter(Boolean)) }}
                  </span>
                </div>
                <div class="bar" style="margin-bottom:8px">
                  <div class="bf" :style="{ width: comp.score + '%', background: comp.status === 'progress' ? 'var(--am)' : 'var(--co)' }"></div>
                </div>
                <div
                  v-for="(r, i) in (assignedResources[comp.id] || []).map(getResById).filter(Boolean)"
                  :key="r.id"
                  class="plan-res-row"
                >
                  <span class="plan-res-num">{{ i + 1 }}.</span>
                  <div class="plan-res-type-icon" :style="{ background: RESOURCE_TYPES[r.type]?.bg }">
                    <component :is="RESOURCE_TYPES[r.type]?.icon" :size="11" :style="{ color: RESOURCE_TYPES[r.type]?.tc }" />
                  </div>
                  <span class="plan-res-title">{{ r.title }}</span>
                  <span class="plan-res-dur">{{ r.dur }}</span>
                  <button class="btn btn-xs" @click="async () => { await store.createEnrollment({ user_id: auth.profile.id, course_id: r.id }); toast('Formation lancée : ' + r.title) }">
                    <IconPlayerPlay :size="10" />
                  </button>
                </div>
              </div>
            </template>
            <div v-else class="empty-state">
              <IconBookmark :size="36" style="opacity:.3" />
              <div style="font-size:13px;font-weight:600;margin-bottom:4px">Aucune ressource assignée</div>
              <div style="font-size:12px">Cliquez sur une compétence à renforcer, puis assignez des ressources depuis le catalogue pour générer votre plan personnalisé.</div>
            </div>

            <div v-if="totalAssigned > 0" class="plan-actions">
<button class="btn btn-sm btn-primary" @click="async () => { await store.shareDevelopmentPlan(auth.profile.id, null, {}); toast('Plan partagé au manager !') }">
      <IconSend :size="14" /> Partager au manager
    </button>
    <button class="btn btn-sm" @click="async () => { await store.createFormation({ title: 'Nouveau parcours', created_by: auth.profile.id }); toast('Parcours LMS généré !') }">
                <IconRoute :size="14" /> Créer un parcours
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>

    <!-- ═══════════════════════════ TEAM VIEW ═══════════════════════════ -->
    <template v-if="view === 'team'">
      <!-- Team members row -->
      <div class="card" style="margin-bottom:16px">
        <div class="card-header">
          <div class="card-title" style="margin-bottom:0">
            <IconUsers :size="15" style="color:var(--blue)" /> Équipe — 5 membres
          </div>
          <span v-if="sharedGaps.length > 0" class="pill pill-amber">
            <IconAlertTriangle :size="10" />
            {{ sharedGaps.length }} gap{{ sharedGaps.length > 1 ? 's' : '' }} collectif{{ sharedGaps.length > 1 ? 's' : '' }} détecté{{ sharedGaps.length > 1 ? 's' : '' }}
          </span>
        </div>
        <div class="grid-team">
          <div
            v-for="m in TEAM_MEMBERS"
            :key="m.id"
            :class="['team-card', { selected: selectedMember === m.id }]"
            @click="selectedMember = m.id"
          >
            <div class="team-av" :style="{ background: m.color }">{{ m.init }}</div>
            <div class="team-name">{{ m.name.split(' ')[0] }}</div>
            <div class="team-role">{{ m.role }}</div>
            <div class="team-radar-center">
              <div v-html="memberMiniRadars[m.id]"></div>
            </div>
            <div class="team-score" :style="{ color: scoreColor(avg(m.scores)) }">{{ avg(m.scores) }}</div>
            <div style="font-size:9px;color:var(--tx2)">/ 100</div>
          </div>
        </div>
      </div>

      <!-- Shared gaps alert -->
      <div v-if="sharedGaps.length > 0" class="card" style="margin-bottom:16px;border-color:var(--am)">
        <div class="card-title" style="color:var(--am)">
          <IconAlertTriangle :size="15" /> Gaps collectifs — Formation groupée recommandée
        </div>
        <div class="shared-gaps-list">
          <div v-for="c in sharedGaps" :key="c.id" class="shared-gap-item">
            <component :is="c.icon" :size="15" style="color:var(--am)" />
            <span class="shared-gap-name">{{ c.name }}</span>
            <span class="shared-gap-count">{{ TEAM_MEMBERS.filter(m => (m.scores[c.id] || 0) < 50).length }}/5 membres &lt; 50</span>
          </div>
        </div>
        <button class="btn btn-sm btn-primary" @click="async () => { await store.createSession({ title: 'Formation collective', status: 'pending' }); toast('Proposition de formation collective créée et envoyée aux managers !') }">
          <IconCalendarEvent :size="14" /> Proposer une session collective
        </button>
      </div>

      <!-- Selected member detail -->
      <div class="grid-main">
        <div class="left-panel">
          <!-- Member radar -->
          <div class="card">
      <div class="card-title">
        <IconChartRadar :size="15" /> Radar — {{ currentMember.name }}
      </div>
            <div class="radar-center">
              <div v-html="teamRadarSvg"></div>
            </div>
            <div class="member-id-row">
              <div class="team-av team-av-sm" :style="{ background: currentMember.color }">{{ currentMember.init }}</div>
              <span style="font-size:12px;font-weight:600">{{ currentMember.name }}</span>
              <span class="pill pill-gray">{{ currentMember.role }}</span>
            </div>
          </div>

          <!-- Comparison radar -->
          <div class="card">
            <div class="card-title">
              <IconLayersIntersect :size="15" style="color:var(--pu)" /> Comparaison équipe
            </div>
            <div class="radar-center">
              <div v-html="comparisonSvg"></div>
            </div>
            <div class="legend-row">
              <div
                v-for="m in TEAM_MEMBERS"
                :key="m.id"
                class="legend-item"
                @click="selectedMember = m.id"
              >
                <div class="legend-dot" :style="{ background: m.color }"></div>
                <span :style="{ fontWeight: selectedMember === m.id ? '700' : '400', color: selectedMember === m.id ? 'var(--tx)' : 'var(--tx2)' }">
                  {{ m.name.split(' ')[0] }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <div class="right-panel">
          <!-- Heatmap -->
          <div class="card">
            <div class="card-title">
              <IconTable :size="15" style="color:var(--blue)" /> Heatmap des compétences — Équipe
            </div>
            <div style="overflow-x:auto">
              <table class="heatmap-table">
                <thead>
                  <tr>
                    <th>Compétence</th>
                    <th v-for="m in TEAM_MEMBERS" :key="m.id">
                      <div class="th-av" :style="{ background: m.color }" :title="m.name">{{ m.init }}</div>
                    </th>
                    <th class="th-avg">Moy.</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="c in COMPETENCIES.filter(cc => cc.id !== 'mktg')" :key="c.id">
                    <td class="td-comp">
                      <component :is="c.icon" :size="12" :style="{ color: scoreColor(Math.round(TEAM_MEMBERS.reduce((s,m) => s + (m.scores[c.id]||0), 0) / TEAM_MEMBERS.length)) }" />
                      {{ c.name }}
                    </td>
                    <td v-for="m in TEAM_MEMBERS" :key="m.id" class="td-score">
                      <div
                        class="heatmap-cell"
                        :style="{ background: scoreHex(m.scores[c.id] || 0) + '22', borderColor: scoreHex(m.scores[c.id] || 0) + '44', color: scoreHex(m.scores[c.id] || 0) }"
                      >
                        {{ m.scores[c.id] || 0 }}
                      </div>
                    </td>
                    <td class="td-avg" :style="{ color: scoreColor(Math.round(TEAM_MEMBERS.reduce((s,m) => s + (m.scores[c.id]||0), 0) / TEAM_MEMBERS.length)) }">
                      {{ Math.round(TEAM_MEMBERS.reduce((s,m) => s + (m.scores[c.id]||0), 0) / TEAM_MEMBERS.length) }}
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Individual gaps -->
          <div class="card">
            <div class="card-title">
              <IconTarget :size="15" style="color:var(--co)" /> Axes de progrès — {{ currentMember.name }}
            </div>
            <template v-if="COMPETENCIES.filter(c => (currentMember.scores[c.id] || 0) < 50 && c.status !== 'locked').slice(0, 4).length">
              <div
                v-for="c in COMPETENCIES.filter(cc => (currentMember.scores[cc.id] || 0) < 50 && cc.status !== 'locked').slice(0, 4)"
                :key="c.id"
                class="gap-row"
              >
                <div class="gap-icon" style="background:var(--co-lt)">
                  <component :is="c.icon" :size="16" style="color:var(--co)" />
                </div>
                <div class="gap-body">
                  <div class="gap-name">{{ c.name }}</div>
                  <div class="bar">
                    <div class="bf" :style="{ width: (currentMember.scores[c.id] || 0) + '%', background: 'var(--co)' }"></div>
                  </div>
                  <div class="gap-score-label">Score actuel : <strong style="color:var(--co)">{{ currentMember.scores[c.id] || 0 }}/100</strong></div>
                </div>
                <button class="btn btn-xs btn-primary" @click="goToCompResources(c.id)">
                  + Ressources
                </button>
              </div>
            </template>
            <div v-else class="empty-state" style="padding:16px">
              <div style="font-size:13px;color:var(--tx2)">Aucun axe critique détecté — profil solide !</div>
            </div>

            <button
              v-if="currentMember.id !== 'sl'"
              class="btn btn-sm"
              style="margin-top:12px;width:100%;justify-content:center"
              @click="async () => { await store.assignResourceToPlan(auth.profile.id, null, null); toast('Plan de développement personnalisé créé pour ' + currentMember.name + ' !') }"
            >
              <IconClipboardList :size="14" /> Créer le plan de développement
            </button>
</div>
</div>
</div>
</template>
</template>
</div>
</template>

<style scoped>
.page {
  max-width: 1320px;
  margin: 0 auto;
  padding: 28px 28px 48px;
}

.card {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 18px 20px;
  box-shadow: var(--shadow-sm);
}

.card-title {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.9px;
  color: var(--tx2);
  margin-bottom: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}

/* HERO */
.hero {
  background: var(--navy);
  border-radius: var(--rl);
  padding: 26px 32px;
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.06);
}
.hero::before {
  content: '';
  position: absolute;
  right: -40px;
  top: -40px;
  width: 220px;
  height: 220px;
  border-radius: 50%;
  background: var(--blue);
  opacity: 0.07;
}
.hero::after {
  content: '';
  position: absolute;
  left: 35%;
  bottom: -60px;
  width: 180px;
  height: 180px;
  border-radius: 50%;
  background: var(--em);
  opacity: 0.05;
}
.hero-content {
  position: relative;
  z-index: 1;
  flex: 1;
}
.hero-tag {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.8px;
  text-transform: uppercase;
  color: var(--em);
  margin-bottom: 8px;
}
.hero-title {
  font-family: var(--fh);
  font-size: 22px;
  font-weight: 800;
  color: #fff;
  letter-spacing: -0.4px;
  margin-bottom: 6px;
}
.hero-subtitle {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 18px;
}
.hero-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.hero-btn {
  background: rgba(255, 255, 255, 0.08);
  color: rgba(255, 255, 255, 0.85);
  border-color: rgba(255, 255, 255, 0.14);
}
.hero-stats {
  display: flex;
  gap: 20px;
  position: relative;
  z-index: 1;
  flex-shrink: 0;
}
.hero-stat {
  text-align: center;
  padding: 14px 16px;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.hero-stat-val {
  font-family: var(--fh);
  font-size: 20px;
  font-weight: 800;
  color: #fff;
}
.hero-stat-lbl {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.4);
  margin-top: 2px;
  text-transform: uppercase;
  letter-spacing: 0.8px;
}

/* TOGGLE ROW */
.toggle-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 12px;
}
.view-toggle {
  display: flex;
  background: var(--surf2);
  border: 1px solid var(--bd);
  border-radius: var(--rs);
  padding: 3px;
  gap: 2px;
}
.vt-btn {
  padding: 6px 14px;
  border-radius: 6px;
  border: none;
  font-size: 12px;
  font-weight: 600;
  font-family: var(--fb);
  cursor: pointer;
  background: transparent;
  color: var(--tx2);
  transition: all 0.18s;
  display: flex;
  align-items: center;
  gap: 6px;
}
.vt-btn.active {
  background: var(--surf);
  color: var(--tx);
  box-shadow: var(--shadow-sm);
}
.pill-legend {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

/* PILLS */
.pill {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  font-size: 10px;
  font-weight: 700;
  padding: 3px 9px;
  border-radius: 20px;
}
.pill-blue {
  background: var(--blue-lt);
  color: #1A4AAA;
  border: 1px solid var(--blue-md);
}
.pill-green {
  background: var(--em-lt);
  color: #005A42;
  border: 1px solid #A8EDD8;
}
.pill-amber {
  background: var(--am-lt);
  color: #6B3B00;
  border: 1px solid #FFD280;
}
.pill-coral {
  background: var(--co-lt);
  color: #7A0020;
  border: 1px solid #FFB3C0;
}
.pill-purple {
  background: var(--pu-lt);
  color: #3C3480;
  border: 1px solid #C8C4F5;
}
.pill-gray {
  background: var(--surf2);
  color: var(--tx2);
  border: 1px solid var(--bd);
}
.level-deb {
  background: var(--em-lt);
  color: #005A42;
  border: 1px solid #A8EDD8;
}
.level-int {
  background: var(--am-lt);
  color: #6B3B00;
  border: 1px solid #FFD280;
}
.level-avd {
  background: var(--pu-lt);
  color: #3C3480;
  border: 1px solid #C8C4F5;
}
.level-exp {
  background: var(--co-lt);
  color: #7A0020;
  border: 1px solid #FFB3C0;
}

/* BUTTONS */
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
  transition: all 0.18s;
  white-space: nowrap;
}
.btn:hover {
  border-color: var(--blue);
  color: var(--blue);
}
.btn-primary {
  background: var(--blue);
  color: #fff;
  border-color: var(--blue);
  box-shadow: var(--shadow-blue);
}
.btn-primary:hover {
  background: #1658D8;
  border-color: #1658D8;
  color: #fff;
}
.btn-success {
  background: var(--em-lt);
  color: #005A42;
  border-color: #A8EDD8;
}
.btn-success:hover {
  background: #C0EFE4;
}
.btn-sm {
  padding: 5px 12px;
  font-size: 12px;
}
.btn-xs {
  padding: 3px 9px;
  font-size: 11px;
}

/* LAYOUT */
.grid-main {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1.6fr);
  gap: 18px;
  margin-bottom: 24px;
}
.left-panel,
.right-panel {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* RADAR CENTER */
.radar-center {
  display: flex;
  justify-content: center;
  margin-bottom: 14px;
}

/* INFO TIP */
.info-tip {
  background: var(--surf2);
  border-radius: var(--rs);
  padding: 10px 14px;
  font-size: 12px;
  color: var(--tx2);
  display: flex;
  align-items: center;
  gap: 8px;
}

/* SELECTED COMPETENCY */
.sel-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 14px;
}
.sel-info {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  flex: 1;
  gap: 12px;
}
.sel-icon-wrap {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.sel-name {
  font-family: var(--fh);
  font-size: 15px;
  font-weight: 700;
}
.sel-meta {
  display: flex;
  gap: 6px;
  align-items: center;
  margin-top: 3px;
}
.sel-score {
  font-family: var(--fh);
  font-size: 16px;
  font-weight: 800;
}

/* TABS */
.tabs {
  display: flex;
  border-bottom: 1px solid var(--bd);
  margin-bottom: 16px;
}
.tab {
  padding: 8px 16px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  color: var(--tx2);
  transition: all 0.18s;
  margin-bottom: -1px;
  display: flex;
  align-items: center;
  gap: 6px;
}
.tab.active {
  color: var(--blue);
  border-bottom-color: var(--blue);
}
.tab:hover:not(.active) {
  color: var(--tx);
}

/* RESOURCE LIST */
.res-list {
  max-height: 280px;
  overflow-y: auto;
  padding-right: 2px;
}
.res-card {
  border: 1px solid var(--bd);
  border-radius: var(--rs);
  padding: 12px 14px;
  display: flex;
  gap: 10px;
  align-items: flex-start;
  cursor: pointer;
  background: var(--surf);
  transition: all 0.18s;
  margin-bottom: 8px;
}
.res-card:hover {
  border-color: var(--blue);
  background: var(--blue-lt);
}
.res-card.assigned {
  border-color: var(--em);
  background: var(--em-lt);
}
.res-card:last-child {
  margin-bottom: 0;
}
.res-type-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.res-body {
  flex: 1;
  min-width: 0;
}
.res-title {
  font-size: 12px;
  font-weight: 600;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.res-meta {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  align-items: center;
}

/* EMPTY STATE */
.empty-state {
  text-align: center;
  padding: 28px;
  color: var(--tx2);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

/* COMPETENCY GRID */
.grid-comp {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 10px;
}
.comp-node {
  border: 1px solid var(--bd);
  border-radius: var(--rs);
  padding: 14px 12px;
  cursor: pointer;
  transition: all 0.22s;
  position: relative;
  background: var(--surf);
}
.comp-node:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}
.comp-node.active {
  box-shadow: 0 0 0 2px var(--blue), var(--shadow-md);
}
.comp-node.mastered {
  border-left: 3px solid var(--em);
  background: #E0F9F310;
}
.comp-node.progress {
  border-left: 3px solid var(--am);
  background: #FFF4E010;
}
.comp-node.weak {
  border-left: 3px solid var(--co);
  background: #FFF0F210;
}
.comp-node.locked {
  opacity: 0.5;
  cursor: not-allowed;
}
.comp-icon-row {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 6px;
}
.comp-name {
  font-size: 11px;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.comp-score {
  font-family: var(--fh);
  font-size: 22px;
  font-weight: 800;
}
.res-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  font-size: 9px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 10px;
  background: var(--blue-lt);
  color: var(--blue);
  border: 1px solid var(--blue-md);
}

/* BARS */
.bar {
  height: 6px;
  background: var(--surf2);
  border-radius: 4px;
  overflow: hidden;
}
.bar-lg {
  height: 8px;
}
.bf {
  height: 100%;
  border-radius: 4px;
  transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

/* PLAN */
.plan-item {
  border: 1px solid var(--bd);
  border-radius: 0 var(--rs) var(--rs) 0;
  padding: 12px 14px;
  background: var(--surf);
  margin-bottom: 10px;
  border-left: 3px solid var(--co);
}
.plan-item:last-child {
  margin-bottom: 0;
}
.plan-item-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}
.plan-item-left {
  display: flex;
  align-items: center;
  gap: 8px;
}
.plan-comp-name {
  font-size: 13px;
  font-weight: 700;
}
.plan-comp-score {
  font-family: var(--fh);
  font-size: 14px;
  font-weight: 800;
}
.plan-meta-right {
  font-size: 11px;
  color: var(--tx2);
}
.plan-res-row {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 5px 0;
  border-top: 1px solid var(--bd);
}
.plan-res-num {
  font-size: 10px;
  font-weight: 700;
  color: var(--tx3);
  min-width: 16px;
}
.plan-res-type-icon {
  width: 20px;
  height: 20px;
  border-radius: 5px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.plan-res-title {
  flex: 1;
  font-size: 12px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.plan-res-dur {
  font-size: 10px;
  color: var(--tx2);
  flex-shrink: 0;
}
.plan-actions {
  display: flex;
  gap: 8px;
  margin-top: 12px;
  flex-wrap: wrap;
}

/* TEAM VIEW */
.grid-team {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 12px;
}
.team-card {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 16px;
  cursor: pointer;
  transition: all 0.22s;
  text-align: center;
  box-shadow: var(--shadow-sm);
}
.team-card:hover {
  border-color: var(--blue);
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}
.team-card.selected {
  border-color: var(--blue);
  box-shadow: 0 0 0 2px var(--blue-lt), var(--shadow-md);
}
.team-av {
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  margin: 0 auto 10px;
  width: 40px;
  height: 40px;
  color: #fff;
  font-size: 13px;
}
.team-av-sm {
  width: 28px;
  height: 28px;
  font-size: 10px;
  margin: 0;
}
.team-name {
  font-size: 12px;
  font-weight: 700;
  margin-bottom: 2px;
}
.team-role {
  font-size: 10px;
  color: var(--tx2);
  margin-bottom: 10px;
}
.team-radar-center {
  display: flex;
  justify-content: center;
}
.team-score {
  font-family: var(--fh);
  font-size: 18px;
  font-weight: 800;
  margin-top: 8px;
}
.member-id-row {
  display: flex;
  align-items: center;
  gap: 8px;
  justify-content: center;
}

/* SHARED GAPS */
.shared-gaps-list {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-bottom: 12px;
}
.shared-gap-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: var(--am-lt);
  border: 1px solid #FFD280;
  border-radius: var(--rs);
}
.shared-gap-name {
  font-size: 12px;
  font-weight: 600;
}
.shared-gap-count {
  font-size: 11px;
  color: var(--tx2);
}

/* COMPARISON LEGEND */
.legend-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 12px;
  justify-content: center;
}
.legend-item {
  display: flex;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  font-size: 11px;
}
.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 2px;
}

/* HEATMAP */
.heatmap-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 11px;
}
.heatmap-table th {
  padding: 6px 8px;
  border-bottom: 1px solid var(--bd);
  color: var(--tx2);
  font-weight: 600;
  text-align: center;
}
.heatmap-table th:first-child {
  text-align: left;
}
.th-av {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 9px;
  font-weight: 700;
  margin: 0 auto;
}
.th-avg {
  text-align: center;
}
.td-comp {
  padding: 6px 8px;
  font-weight: 500;
  border-bottom: 1px solid var(--bd);
  display: flex;
  align-items: center;
  gap: 6px;
}
.td-score {
  text-align: center;
  padding: 6px 8px;
  border-bottom: 1px solid var(--bd);
}
.td-avg {
  text-align: center;
  padding: 6px 8px;
  border-bottom: 1px solid var(--bd);
  font-weight: 700;
}
.heatmap-cell {
  width: 32px;
  height: 20px;
  border-radius: 4px;
  border-width: 1px;
  border-style: solid;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 700;
  margin: 0 auto;
}

/* GAPS */
.gap-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid var(--bd);
}
.gap-row:last-child {
  border-bottom: none;
}
.gap-icon {
  width: 34px;
  height: 34px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.gap-body {
  flex: 1;
  min-width: 0;
}
.gap-name {
  font-size: 12px;
  font-weight: 600;
  margin-bottom: 4px;
}
.gap-score-label {
  font-size: 10px;
  color: var(--tx2);
  margin-top: 2px;
}

/* RESPONSIVE */
@media (max-width: 1100px) {
  .grid-main {
    grid-template-columns: 1fr;
  }
}
@media (max-width: 900px) {
  .grid-team {
    grid-template-columns: 1fr 1fr;
  }
  .hero {
    flex-direction: column;
    align-items: flex-start;
  }
  .hero-stats {
    flex-wrap: wrap;
  }
}
@media (max-width: 600px) {
  .page {
    padding: 16px;
  }
  .grid-comp {
    grid-template-columns: 1fr 1fr;
  }
  .grid-team {
    grid-template-columns: 1fr;
  }
}
@keyframes spin { from { transform: rotate(0deg) } to { transform: rotate(360deg) } }
</style>
