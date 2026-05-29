<script setup>
import { inject, ref, computed, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import { Bar, Doughnut } from 'vue-chartjs'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler,
} from 'chart.js'
import {
  IconLayoutDashboard,
  IconBooks,
  IconChartRadar,
  IconBuilding,
  IconTrendingUp,
  IconUsers,
  IconChartPie,
  IconCertificate,
  IconStar,
  IconChartBar,
  IconTrophy,
  IconAlertTriangle,
  IconDownload,
  IconFileDescription,
  IconTable,
  IconMail,
  IconPresentation,
  IconCalendar,
  IconBrandSlack,
  IconArrowsDiff,
  IconList,
  IconClock,
  IconCircleCheck,
  IconHeart,
  IconBulb,
  IconFileAnalytics,
  IconChartLine,
  IconChartPie2,
  IconInfoCircle,
  IconAlertCircle,
  IconArrowRight,
  IconLoader2,
} from '@tabler/icons-vue'

ChartJS.register(CategoryScale, LinearScale, BarElement, LineElement, PointElement, ArcElement, Title, Tooltip, Legend, Filler)

const auth = useAuthStore()
const store = useDataStore()
const toast = inject('toast')

const pageLoading = ref(false)
const pageError = ref(null)
const tab = ref('global')
const period = ref('trimestre')
const company = ref('all')

const STATIC_COMPANIES = [
  { id: 'acme', name: 'Acme Corp', users: 82, active: 74, cp: 88, sat: 4.6, h: 1240, budget: 24600, plan: 'Premium', color: '#1E6FFF' },
  { id: 'tech', name: 'TechStart SAS', users: 45, active: 38, cp: 79, sat: 4.4, h: 580, budget: 9800, plan: 'Starter', color: '#00D4A1' },
  { id: 'finance', name: 'Global Finance', users: 120, active: 112, cp: 91, sat: 4.7, h: 2100, budget: 42000, plan: 'Enterprise', color: '#7B6FEE' },
]

const COMPANIES = computed(() => store.companies.length ? store.companies : STATIC_COMPANIES)

const STATIC_FORMATIONS = [
  { name: 'Management Agile', cat: 'Functional', cp: 92, sat: 4.8, ins: 234, cert: 189, h: 8, col: '#00D4A1' },
  { name: 'Leadership & Influence', cat: 'Soft Skills', cp: 88, sat: 4.8, ins: 187, cert: 143, h: 12, col: '#7B6FEE' },
  { name: 'Excel Avancé', cat: 'Technical', cp: 81, sat: 4.5, ins: 312, cert: 287, h: 5, col: '#1E6FFF' },
  { name: 'Communication CNV', cat: 'Soft Skills', cp: 85, sat: 4.6, ins: 143, cert: 98, h: 6, col: '#FF9B21' },
  { name: 'Python Data Science', cat: 'Technical', cp: 76, sat: 4.9, ins: 98, cert: 61, h: 20, col: '#FF4D6A' },
  { name: 'Cybersécurité', cat: 'Technical', cp: 73, sat: 4.3, ins: 85, cert: 52, h: 6, col: '#FF9B21' },
  { name: 'Gestion de projet', cat: 'Functional', cp: 69, sat: 4.6, ins: 120, cert: 74, h: 15, col: '#7B6FEE' },
  { name: 'Finance non-financiers', cat: 'Functional', cp: 82, sat: 4.6, ins: 76, cert: 55, h: 12, col: '#1E6FFF' },
]

const FORMATIONS = computed(() => store.formations.length ? store.formations : STATIC_FORMATIONS)

const COMPS_BEFORE_AFTER = [
  { name: 'Leadership', avant: 52, apres: 78, col: '#1E6FFF' },
  { name: 'Communication', avant: 61, apres: 83, col: '#00D4A1' },
  { name: 'Agilité', avant: 45, apres: 82, col: '#7B6FEE' },
  { name: 'Data', avant: 38, apres: 61, col: '#FF9B21' },
  { name: 'Management', avant: 49, apres: 72, col: '#FF4D6A' },
  { name: 'Négociation', avant: 41, apres: 68, col: '#00D4A1' },
]

const MONTHLY = [
  { m: 'Sep', v: 58 }, { m: 'Oct', v: 62 }, { m: 'Nov', v: 61 },
  { m: 'Dec', v: 65 }, { m: 'Jan', v: 68 }, { m: 'Fév', v: 72 },
  { m: 'Mar', v: 71 }, { m: 'Avr', v: 76 }, { m: 'Mai', v: 84 },
]

const HEATMAP_DATA = {
  rows: ['Leadership', 'Comm.', 'Data', 'Agilité', 'Négo.', 'Cyber', 'Innov.', 'Mgmt'],
  cols: ['Acme', 'TechStart', 'Finance'],
  vals: [
    [78, 62, 81], [83, 71, 86], [61, 88, 74], [86, 79, 90],
    [55, 48, 62], [42, 68, 55], [74, 58, 80], [62, 40, 70],
  ],
}

const scColor = v => v >= 75 ? 'var(--em)' : v >= 50 ? 'var(--am)' : 'var(--co)'
const scHex = v => v >= 75 ? '#00D4A1' : v >= 50 ? '#FF9B21' : '#FF4D6A'

const chartOpts = computed(() => {
  const dark = auth.isDark
  return {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        labels: {
          color: dark ? '#7A8FAE' : '#526080',
          font: { family: 'Epilogue', size: 11 },
          boxWidth: 12,
          padding: 14,
        },
      },
      tooltip: {
        backgroundColor: '#0B1628',
        titleFont: { family: 'Sora', size: 12 },
        bodyFont: { family: 'Epilogue', size: 11 },
        padding: 10,
        cornerRadius: 8,
      },
    },
    scales: {
      x: {
        ticks: { color: dark ? '#7A8FAE' : '#526080', font: { family: 'Epilogue', size: 11 } },
        grid: { color: dark ? 'rgba(255,255,255,.07)' : 'rgba(0,0,0,.06)' },
        border: { color: dark ? '#1E2C44' : '#E2E8F5' },
      },
      y: {
        ticks: { color: dark ? '#7A8FAE' : '#526080', font: { family: 'Epilogue', size: 11 } },
        grid: { color: dark ? 'rgba(255,255,255,.07)' : 'rgba(0,0,0,.06)' },
        border: { color: dark ? '#1E2C44' : '#E2E8F5' },
      },
    },
  }
})

const noScalesOpts = computed(() => {
  const dark = auth.isDark
  return {
    responsive: true,
    maintainAspectRatio: false,
    cutout: '70%',
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: '#0B1628',
        titleFont: { family: 'Sora', size: 12 },
        bodyFont: { family: 'Epilogue', size: 11 },
        padding: 10,
        cornerRadius: 8,
      },
    },
  }
})

const noLegendOpts = computed(() => ({
  ...chartOpts.value,
  plugins: { ...chartOpts.value.plugins, legend: { display: false } },
}))

const monthlyChartData = computed(() => ({
  labels: MONTHLY.map(m => m.m),
  datasets: [{
    label: 'Complétion (%)',
    data: MONTHLY.map(m => m.v),
    backgroundColor: MONTHLY.map((_, i) => i === MONTHLY.length - 1 ? '#1E6FFF' : '#1E6FFF44'),
    borderColor: '#1E6FFF',
    borderRadius: 6,
    borderSkipped: false,
  }],
}))

const satDonutData = computed(() => ({
  labels: ['Très satisfait', 'Satisfait', 'Neutre', 'Insatisfait'],
  datasets: [{
    data: [45, 38, 12, 5],
    backgroundColor: ['#00D4A1', '#1E6FFF', '#FF9B21', '#FF4D6A'],
    borderWidth: 0,
    hoverOffset: 6,
  }],
}))

const topFormationsData = computed(() => ({
  labels: FORMATIONS.map(f => f.name.length > 20 ? f.name.slice(0, 20) + '…' : f.name),
  datasets: [{
    label: 'Complétion (%)',
    data: FORMATIONS.map(f => f.cp),
    backgroundColor: FORMATIONS.map(f => f.col),
    borderRadius: 6,
    borderSkipped: false,
  }],
}))

const topFormationsOpts = computed(() => ({
  ...noLegendOpts.value,
  indexAxis: 'y',
}))

const formationsBarData = computed(() => ({
  labels: FORMATIONS.map(f => f.name.length > 18 ? f.name.slice(0, 18) + '…' : f.name),
  datasets: [
    {
      label: 'Complétion (%)',
      data: FORMATIONS.map(f => f.cp),
      backgroundColor: '#1E6FFF99',
      borderColor: '#1E6FFF',
      borderWidth: 1,
      borderRadius: 4,
    },
    {
      label: 'Satisfaction (×20)',
      data: FORMATIONS.map(f => Math.round(f.sat * 20)),
      backgroundColor: '#FF9B2199',
      borderColor: '#FF9B21',
      borderWidth: 1,
      borderRadius: 4,
    },
  ],
}))

const catDonutData = computed(() => ({
  labels: ['Soft Skills', 'Technical Skills', 'Functional Skills'],
  datasets: [{
    data: [3, 3, 3],
    backgroundColor: ['#7B6FEE', '#1E6FFF', '#00D4A1'],
    borderWidth: 0,
    hoverOffset: 6,
  }],
}))

const catDonutOpts = computed(() => ({
  ...noScalesOpts.value,
  cutout: '65%',
}))

const beforeAfterData = computed(() => ({
  labels: COMPS_BEFORE_AFTER.map(c => c.name),
  datasets: [
    {
      label: 'Avant formation',
      data: COMPS_BEFORE_AFTER.map(c => c.avant),
      backgroundColor: '#FF4D6A44',
      borderColor: '#FF4D6A',
      borderWidth: 1,
      borderRadius: 4,
    },
    {
      label: 'Après formation',
      data: COMPS_BEFORE_AFTER.map(c => c.apres),
      backgroundColor: COMPS_BEFORE_AFTER.map(c => c.col + 'BB'),
      borderColor: COMPS_BEFORE_AFTER.map(c => c.col),
      borderWidth: 1,
      borderRadius: 4,
    },
  ],
}))

const beforeAfterOpts = computed(() => ({
  ...chartOpts.value,
  scales: {
    ...chartOpts.value.scales,
    y: { ...chartOpts.value.scales.y, max: 100 },
  },
}))

const coBarData = computed(() => ({
  labels: COMPANIES.map(c => c.name),
  datasets: [{
    label: 'Complétion (%)',
    data: COMPANIES.map(c => c.cp),
    backgroundColor: COMPANIES.map(c => c.color + 'BB'),
    borderColor: COMPANIES.map(c => c.color),
    borderWidth: 2,
    borderRadius: 8,
    borderSkipped: false,
  }],
}))

const coBarOpts = computed(() => ({
  ...noLegendOpts.value,
  scales: {
    ...noLegendOpts.value.scales,
    y: { ...noLegendOpts.value.scales.y, max: 100 },
  },
}))

const licensesDonutData = computed(() => ({
  labels: COMPANIES.map(c => c.name),
  datasets: [{
    data: COMPANIES.map(c => c.users),
    backgroundColor: COMPANIES.map(c => c.color),
    borderWidth: 0,
    hoverOffset: 6,
  }],
}))

const licensesDonutOpts = computed(() => ({
  ...catDonutOpts.value,
}))

const roiDecompData = computed(() => ({
  labels: ['Productivité', 'Rétention collab.', 'Réduct. erreurs', 'Innovation'],
  datasets: [{
    label: 'Valeur générée (k€)',
    data: [68, 42, 21, 11],
    backgroundColor: ['#1E6FFF', '#00D4A1', '#7B6FEE', '#FF9B21'],
    borderRadius: 10,
    borderSkipped: false,
  }],
}))

const globalKpis = [
  { val: '247', lbl: 'Utilisateurs actifs', ico: IconUsers, c: 'var(--blue)', d: '↑ 23 ce mois', up: true },
  { val: '84%', lbl: 'Taux de complétion', ico: IconChartPie, c: 'var(--em)', d: '↑ 6% vs M-1', up: true },
  { val: '618', lbl: 'Certifications', ico: IconCertificate, c: 'var(--am)', d: '↑ 48 ce trim.', up: true },
  { val: '4.6', lbl: 'Satisfaction moy.', ico: IconStar, c: 'var(--pu)', d: '↑ 0.1 vs M-1', up: true },
]

const satLegend = [
  { l: 'Très satisfait (5/5)', v: 45, c: 'var(--em)' },
  { l: 'Satisfait (4/5)', v: 38, c: 'var(--blue)' },
  { l: 'Neutre (3/5)', v: 12, c: 'var(--am)' },
  { l: 'Insatisfait (1-2/5)', v: 5, c: 'var(--co)' },
]

const alerts = [
  { t: 'danger', m: 'TechStart SAS — taux de complétion en baisse de 8% ce mois' },
  { t: 'warning', m: '12 apprenants inactifs depuis plus de 7 jours' },
  { t: 'info', m: '3 formations sous le seuil de satisfaction 4.0/5' },
  { t: 'success', m: 'Global Finance — objectif 91% dépassé ce trimestre' },
  { t: 'warning', m: '2 sessions sans formateur assigné en juin' },
]

const alertConfig = {
  danger: { bg: 'var(--co-lt)', c: 'var(--co)', ico: IconAlertCircle },
  warning: { bg: 'var(--am-lt)', c: 'var(--am)', ico: IconAlertTriangle },
  info: { bg: 'var(--blue-lt)', c: 'var(--blue)', ico: IconInfoCircle },
  success: { bg: 'var(--em-lt)', c: 'var(--em)', ico: IconCircleCheck },
}

const exports = [
  { ico: IconFileDescription, l: 'Rapport mensuel complet', sub: 'PDF · Toutes entreprises' },
  { ico: IconTable, l: 'Export apprenants', sub: 'CSV · 247 lignes' },
  { ico: IconMail, l: 'Email récap. DRH', sub: 'Envoi automatique lundi 8h' },
  { ico: IconPresentation, l: 'Synthèse COMEX 5 slides', sub: 'PowerPoint · Format direction' },
  { ico: IconCalendar, l: 'Planifier rapport automatique', sub: 'Mensuel / Trimestriel' },
  { ico: IconBrandSlack, l: 'Alertes Slack / Teams', sub: 'Webhook · Configurable' },
]

const tabs = [
  { id: 'global', ico: IconLayoutDashboard, lbl: 'Global' },
  { id: 'formations', ico: IconBooks, lbl: 'Formations' },
  { id: 'competences', ico: IconChartRadar, lbl: 'Compétences' },
  { id: 'entreprises', ico: IconBuilding, lbl: 'Entreprises' },
  { id: 'roi', ico: IconTrendingUp, lbl: 'ROI & KPIs' },
]

const formationsKpis = computed(() => {
  const totalCert = FORMATIONS.reduce((s, f) => s + f.cert, 0)
  const totalIns = FORMATIONS.reduce((s, f) => s + f.ins, 0)
  const avgSat = (FORMATIONS.reduce((s, f) => s + f.sat, 0) / FORMATIONS.length).toFixed(1)
  return [
    { v: String(FORMATIONS.length), l: 'Formations actives', c: 'var(--blue)', ico: IconBooks },
    { v: String(totalIns), l: 'Apprenants inscrits', c: 'var(--em)', ico: IconUsers },
    { v: String(totalCert), l: 'Certifications délivrées', c: 'var(--am)', ico: IconCertificate },
    { v: avgSat + '/5', l: 'Satisfaction moyenne', c: 'var(--pu)', ico: IconStar },
  ]
})

const catLegend = [
  { l: 'Soft Skills', n: '3 formations', c: 'var(--pu)' },
  { l: 'Technical', n: '3 formations', c: 'var(--blue)' },
  { l: 'Functional', n: '3 formations', c: 'var(--em)' },
]

const compsKpis = computed(() => {
  const avgGain = Math.round(COMPS_BEFORE_AFTER.reduce((s, c) => s + (c.apres - c.avant), 0) / COMPS_BEFORE_AFTER.length)
  return [
    { v: '10', l: 'Compétences suivies', c: 'var(--blue)', ico: IconList },
    { v: avgGain + ' pts', l: 'Gain moyen', c: 'var(--em)', ico: IconTrendingUp },
    { v: '3', l: 'Maîtrisées (≥75)', c: 'var(--am)', ico: IconCircleCheck },
    { v: '67%', l: 'Score maturité moy.', c: 'var(--pu)', ico: IconChartRadar },
  ]
})

const impactIndicators = [
  { ico: IconClock, l: 'Heures économisées', v: '3 200h', d: 'Montées en compétences accélérées', c: 'var(--blue)' },
  { ico: IconUsers, l: 'Taux de rétention', v: '94%', d: 'Collaborateurs formés restant', c: 'var(--em)' },
  { ico: IconTrendingUp, l: 'Promotions internes', v: '12', d: 'Obtenues après formation', c: 'var(--pu)' },
  { ico: IconHeart, l: 'Satisfaction employés', v: '87%', d: 'Score eNPS post-formation', c: 'var(--am)' },
  { ico: IconAlertTriangle, l: 'Réduction erreurs', v: '-32%', d: 'Incidents liés aux compétences', c: 'var(--co)' },
  { ico: IconBulb, l: 'Idées soumises', v: '+41%', d: 'Hausse post-formation Innovation', c: 'var(--blue)' },
]

const roiTableData = [
  ['Management Agile', 234, 18720, 52000, 28000, 322],
  ['Leadership & Influence', 187, 28050, 42000, 35000, 241],
  ['Excel Avancé', 312, 9360, 38000, 5000, 460],
  ['Communication CNV', 143, 10725, 24000, 18000, 295],
  ['Python Data Science', 98, 23520, 31000, 8000, 166],
]

const roiReportBtns = [
  { ico: IconFileDescription, l: 'Rapport ROI complet PDF' },
  { ico: IconChartBar, l: 'Analyse ROI par formation' },
  { ico: IconMail, l: 'Email récap. DRH' },
  { ico: IconPresentation, l: 'Présentation COMEX' },
  { ico: IconCalendar, l: 'Rapport automatique mensuel' },
  { ico: IconDownload, l: 'Export données Excel' },
]

const roiStats = computed(() => {
  const invest = 48400
  const gain = 142000
  const roi = Math.round((gain - invest) / invest * 100)
  return { invest, gain, roi, net: gain - invest, ratio: (gain / invest).toFixed(1) }
})

const periodLabel = computed(() => {
  if (period.value === 'trimestre') return 'T2 2025'
  if (period.value === 'mois') return 'Mai 2025'
  return 'Année 2025'
})

function pillClass(cat) {
  if (cat === 'Soft Skills') return 'pill-purple'
  if (cat === 'Technical') return 'pill-blue'
  return 'pill-green'
}

function planClass(plan) {
  if (plan === 'Enterprise') return 'pill-purple'
  if (plan === 'Premium') return 'pill-blue'
  return 'pill-gray'
}

function ringStroke(r, pct) {
  const circ = 2 * Math.PI * r
  return { circ, offset: circ * (1 - pct / 100) }
}

onMounted(async () => {
  pageLoading.value = true
  pageError.value = null
  try {
    if (!auth.profile?.id) return
    await Promise.all([
      store.fetchFormations(),
      store.fetchCompanies(),
      store.fetchCompetencies(),
      store.fetchQuizAttempts(),
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
<div class="hero fi">
      <div class="hero-inner">
        <div>
          <div class="hero-tag">Reporting RH &amp; Analytics</div>
          <div class="hero-title">Pilotez la performance formation</div>
          <div class="hero-sub">Données consolidées · 3 entreprises · Mise à jour en temps réel</div>
        </div>
        <div class="hero-actions">
          <select v-model="period" class="sel hero-sel">
            <option value="trimestre">Ce trimestre</option>
            <option value="mois">Ce mois</option>
            <option value="annee">Cette année</option>
          </select>
          <select v-model="company" class="sel hero-sel">
            <option value="all">Toutes les entreprises</option>
            <option v-for="c in COMPANIES" :key="c.id" :value="c.id">{{ c.name }}</option>
          </select>
          <button class="btn btn-sm hero-btn-ghost" @click="async () => { await store.fetchGlobalReporting({ period: period.value }); toast('Rapport PDF généré et téléchargé !') }">
            <IconDownload :size="14" /> Exporter PDF
          </button>
          <button class="btn btn-sm hero-btn-em" @click="async () => { await store.sendMessage(auth.profile.id, null, { type: 'drh_report', period: period.value }); toast('Rapport envoyé aux DRH par email !') }">
            <IconMail :size="14" /> Envoyer DRH
          </button>
        </div>
      </div>
    </div>

    <div class="tab-row fi2">
      <button
        v-for="t in tabs"
        :key="t.id"
        :class="['tab-btn', { active: tab === t.id }]"
        @click="tab = t.id"
      >
        <component :is="t.ico" :size="14" />
        {{ t.lbl }}
      </button>
    </div>

    <div class="fi3">
      <!-- ════════════ GLOBAL ════════════ -->
      <template v-if="tab === 'global'">
        <div class="g4" style="margin-bottom:20px">
          <div v-for="(k, i) in globalKpis" :key="i" class="kpi">
            <div class="kpi-bg"><component :is="k.ico" :size="64" /></div>
            <div class="kpi-lbl"><component :is="k.ico" :size="13" :style="{ color: k.c }" />{{ k.lbl }}</div>
            <div class="kpi-val" :style="{ color: k.c }">{{ k.val }}</div>
            <div :class="['kpi-delta', k.up ? 'up' : 'dn']">
              <IconTrendingUp v-if="k.up" :size="11" />
              <IconTrendingUp v-else :size="11" style="transform:rotate(180deg)" />
              {{ k.d }}
            </div>
          </div>
        </div>

        <div class="gm" style="margin-bottom:20px">
          <div class="card">
            <div class="ct"><IconChartBar :size="14" style="color:var(--blue)" /> Taux de complétion — évolution mensuelle (%)</div>
            <div style="position:relative;height:220px">
              <Bar :data="monthlyChartData" :options="noLegendOpts" />
            </div>
          </div>
          <div class="card">
            <div class="ct"><IconChartPie2 :size="14" style="color:var(--am)" /> Satisfaction globale</div>
            <div style="position:relative;height:180px;margin-bottom:12px">
              <Doughnut :data="satDonutData" :options="noScalesOpts" />
            </div>
            <div style="display:flex;flex-direction:column;gap:6px">
              <div v-for="(s, i) in satLegend" :key="i" style="display:flex;align-items:center;gap:8px">
                <div class="dot" :style="{ background: s.c }"></div>
                <span style="flex:1;font-size:12px">{{ s.l }}</span>
                <span style="font-size:12px;font-weight:700" :style="{ color: s.c }">{{ s.v }}%</span>
              </div>
            </div>
          </div>
        </div>

        <div class="g2" style="margin-bottom:20px">
          <div class="card">
            <div class="ct"><IconTrophy :size="14" style="color:var(--am)" /> Top formations par taux de complétion</div>
            <div style="position:relative;height:240px">
              <Bar :data="topFormationsData" :options="topFormationsOpts" />
            </div>
          </div>
          <div class="card">
            <div class="ct"><IconBuilding :size="14" style="color:var(--blue)" /> Performance par entreprise</div>
            <div v-for="c in COMPANIES" :key="c.id" class="co-row">
              <div class="ring" style="width:78px;height:78px">
                <svg width="78" height="78" viewBox="0 0 78 78">
                  <circle cx="39" cy="39" r="34" fill="none" stroke="var(--surf2)" stroke-width="8" />
                  <circle cx="39" cy="39" r="34" fill="none" :stroke="scHex(c.cp)" stroke-width="8"
                    :stroke-dasharray="ringStroke(34, c.cp).circ"
                    :stroke-dashoffset="ringStroke(34, c.cp).offset"
                    stroke-linecap="round" class="ring-arc" />
                </svg>
                <div class="ring-label">
                  <div style="font-size:14px;font-weight:800" :style="{ color: scColor(c.cp) }">{{ c.cp }}%</div>
                </div>
              </div>
              <div style="flex:1;min-width:0">
                <div style="display:flex;align-items:center;gap:6px;margin-bottom:4px">
                  <span style="font-size:13px;font-weight:700">{{ c.name }}</span>
                  <span :class="['pill', planClass(c.plan)]" style="font-size:9px">{{ c.plan }}</span>
                </div>
                <div style="font-size:11px;color:var(--tx2);display:flex;gap:12px;flex-wrap:wrap">
                  <span><IconUsers :size="11" /> {{ c.active }}/{{ c.users }} actifs</span>
                  <span><IconStar :size="11" style="color:var(--am)" /> {{ c.sat }}/5</span>
                  <span><IconClock :size="11" /> {{ c.h }}h</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="g2">
          <div class="card">
            <div class="ct"><IconAlertTriangle :size="14" style="color:var(--co)" /> Alertes système</div>
            <div v-for="(a, i) in alerts" :key="i" class="alert-row" :style="{ background: alertConfig[a.t].bg }">
              <component :is="alertConfig[a.t].ico" :size="15" :style="{ color: alertConfig[a.t].c, flexShrink: 0 }" />
              <span style="flex:1;font-size:12px">{{ a.m }}</span>
              <button class="btn btn-xs" @click="toast('Traitement en cours...')">Traiter</button>
            </div>
          </div>
          <div class="card">
            <div class="ct"><IconDownload :size="14" style="color:var(--em)" /> Exports &amp; rapports automatisés</div>
            <div v-for="(e, i) in exports" :key="i" class="export-row" @click="toast('Génération : ' + e.l + '...')">
              <div class="export-ico"><component :is="e.ico" :size="15" style="color:var(--blue)" /></div>
              <div style="flex:1;min-width:0">
                <div style="font-size:12px;font-weight:600">{{ e.l }}</div>
                <div style="font-size:10px;color:var(--tx2)">{{ e.sub }}</div>
              </div>
              <IconArrowRight :size="13" style="color:var(--tx3)" />
            </div>
          </div>
        </div>
      </template>

      <!-- ════════════ FORMATIONS ════════════ -->
      <template v-if="tab === 'formations'">
        <div class="g4" style="margin-bottom:20px">
          <div v-for="(k, i) in formationsKpis" :key="i" class="kpi">
            <div class="kpi-lbl"><component :is="k.ico" :size="13" :style="{ color: k.c }" />{{ k.l }}</div>
            <div class="kpi-val" :style="{ color: k.c, fontSize: '24px' }">{{ k.v }}</div>
          </div>
        </div>

        <div class="gm" style="margin-bottom:20px">
          <div class="card">
            <div class="ct"><IconChartBar :size="14" style="color:var(--blue)" /> Taux de complétion &amp; satisfaction par formation</div>
            <div style="position:relative;height:280px">
              <Bar :data="formationsBarData" :options="chartOpts" />
            </div>
          </div>
          <div class="card">
            <div class="ct"><IconChartPie :size="14" style="color:var(--pu)" /> Répartition par catégorie</div>
            <div style="position:relative;height:200px;margin-bottom:14px">
              <Doughnut :data="catDonutData" :options="catDonutOpts" />
            </div>
            <div v-for="(cat, i) in catLegend" :key="i" style="display:flex;align-items:center;gap:8px;margin-bottom:6px">
              <div class="dot" :style="{ background: cat.c }"></div>
              <span style="flex:1;font-size:12px">{{ cat.l }}</span>
              <span style="font-size:12px;font-weight:700" :style="{ color: cat.c }">{{ cat.n }}</span>
            </div>
          </div>
        </div>

        <div class="card">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;flex-wrap:wrap;gap:10px">
            <div class="ct" style="margin-bottom:0"><IconList :size="14" style="color:var(--blue)" /> Détail par formation</div>
            <div style="display:flex;gap:8px">
              <button class="btn btn-sm" @click="toast('Export CSV généré !')"><IconTable :size="14" /> Export CSV</button>
              <button class="btn btn-primary btn-sm" @click="toast('Rapport formations PDF généré !')"><IconDownload :size="14" /> PDF</button>
            </div>
          </div>
          <div style="overflow-x:auto">
            <table class="dt">
              <thead>
                <tr>
                  <th>Formation</th>
                  <th>Catégorie</th>
                  <th style="min-width:120px">Complétion</th>
                  <th>Inscrits</th>
                  <th>Certifiés</th>
                  <th style="min-width:80px">Taux certif.</th>
                  <th>Durée</th>
                  <th>Satisfaction</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="f in FORMATIONS" :key="f.name">
                  <td>
                    <div style="display:flex;align-items:center;gap:8px">
                      <div :style="{ width:'8px', height:'32px', borderRadius:'4px', background:f.col, flexShrink:0 }"></div>
                      <span style="font-weight:600">{{ f.name }}</span>
                    </div>
                  </td>
                  <td><span :class="['pill', pillClass(f.cat)]">{{ f.cat }}</span></td>
                  <td>
                    <div style="display:flex;align-items:center;gap:6px">
                      <div class="bar" style="flex:1;margin:0"><div class="bf" :style="{ width: f.cp+'%', background: scHex(f.cp) }"></div></div>
                      <span style="font-size:11px;font-weight:700;min-width:28px" :style="{ color: scColor(f.cp) }">{{ f.cp }}%</span>
                    </div>
                  </td>
                  <td style="font-weight:600">{{ f.ins }}</td>
                  <td style="color:var(--em);font-weight:600">{{ f.cert }}</td>
                  <td>
                    <div style="display:flex;align-items:center;gap:4px">
                      <div class="bar" style="width:50px;margin:0"><div class="bf" :style="{ width: Math.round(f.cert/f.ins*100)+'%', background:'var(--em)' }"></div></div>
                      <span style="font-size:11px;font-weight:700;color:var(--em)">{{ Math.round(f.cert/f.ins*100) }}%</span>
                    </div>
                  </td>
                  <td style="color:var(--tx2)">{{ f.h }}h</td>
                  <td><span style="color:var(--am);font-weight:700">★ {{ f.sat }}</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </template>

      <!-- ════════════ COMPÉTENCES ════════════ -->
      <template v-if="tab === 'competences'">
        <div class="g4" style="margin-bottom:20px">
          <div v-for="(k, i) in compsKpis" :key="i" class="kpi">
            <div class="kpi-lbl"><component :is="k.ico" :size="13" :style="{ color: k.c }" />{{ k.l }}</div>
            <div class="kpi-val" :style="{ color: k.c, fontSize: '24px' }">{{ k.v }}</div>
          </div>
        </div>

        <div class="gm" style="margin-bottom:20px">
          <div class="card">
            <div class="ct"><IconArrowsDiff :size="14" style="color:var(--blue)" /> Évolution avant / après formation — Score moyen (/100)</div>
            <div style="position:relative;height:260px">
              <Bar :data="beforeAfterData" :options="beforeAfterOpts" />
            </div>
          </div>
          <div class="card">
            <div class="ct"><IconTrendingUp :size="14" style="color:var(--em)" /> Progression par compétence</div>
            <div v-for="c in COMPS_BEFORE_AFTER" :key="c.name" style="margin-bottom:13px">
              <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:5px;align-items:center">
                <span style="font-weight:600">{{ c.name }}</span>
                <div style="display:flex;align-items:center;gap:8px">
                  <span style="font-size:11px;color:var(--tx2)">{{ c.avant }} → {{ c.apres }}</span>
                  <span class="gain-badge">+{{ c.apres - c.avant }}</span>
                </div>
              </div>
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:5px">
                <div>
                  <div style="font-size:9px;color:var(--tx3);margin-bottom:2px">Avant</div>
                  <div class="bar"><div class="bf" :style="{ width: c.avant+'%', background: '#FF4D6A55' }"></div></div>
                </div>
                <div>
                  <div style="font-size:9px;color:var(--tx3);margin-bottom:2px">Après</div>
                  <div class="bar"><div class="bf" :style="{ width: c.apres+'%', background: c.col }"></div></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="ct"><IconTable :size="14" style="color:var(--pu)" /> Heatmap des compétences par entreprise — Score moyen (/100)</div>
          <div style="overflow-x:auto">
            <table class="hm-table">
              <thead>
                <tr>
                  <th style="text-align:left">Compétence</th>
                  <th v-for="col in HEATMAP_DATA.cols" :key="col" style="text-align:center;min-width:80px">{{ col }}</th>
                  <th style="text-align:center">Moy. globale</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, ri) in HEATMAP_DATA.rows" :key="row">
                  <td style="font-weight:600;white-space:nowrap">{{ row }}</td>
                  <td v-for="(v, ci) in HEATMAP_DATA.vals[ri]" :key="ci" style="padding:4px;text-align:center">
                    <div class="hm-cell" :style="{ background: scHex(v)+'22', border: '1px solid '+scHex(v)+'44', color: scHex(v) }">{{ v }}</div>
                  </td>
                  <td style="padding:4px;text-align:center">
                    <div class="hm-cell hm-cell-bold" :style="{ background: scHex(Math.round(HEATMAP_DATA.vals[ri].reduce((s,v)=>s+v,0)/HEATMAP_DATA.vals[ri].length))+'33', border: '1px solid '+scHex(Math.round(HEATMAP_DATA.vals[ri].reduce((s,v)=>s+v,0)/HEATMAP_DATA.vals[ri].length))+'66', color: scHex(Math.round(HEATMAP_DATA.vals[ri].reduce((s,v)=>s+v,0)/HEATMAP_DATA.vals[ri].length)) }">{{ Math.round(HEATMAP_DATA.vals[ri].reduce((s,v)=>s+v,0)/HEATMAP_DATA.vals[ri].length) }}</div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="hm-legend">
            <div class="hm-legend-item"><div class="hm-legend-swatch" style="background:#00D4A133;border:1px solid #00D4A166"></div> Maîtrisé ≥ 75</div>
            <div class="hm-legend-item"><div class="hm-legend-swatch" style="background:#FF9B2133;border:1px solid #FF9B2166"></div> Progression 50–74</div>
            <div class="hm-legend-item"><div class="hm-legend-swatch" style="background:#FF4D6A33;border:1px solid #FF4D6A66"></div> À renforcer &lt; 50</div>
          </div>
        </div>
      </template>

      <!-- ════════════ ENTREPRISES ════════════ -->
      <template v-if="tab === 'entreprises'">
        <div class="g2" style="margin-bottom:20px">
          <div class="card">
            <div class="ct"><IconChartBar :size="14" style="color:var(--blue)" /> Complétion par entreprise (%)</div>
            <div style="position:relative;height:220px">
              <Bar :data="coBarData" :options="coBarOpts" />
            </div>
          </div>
          <div class="card">
            <div class="ct"><IconUsers :size="14" style="color:var(--em)" /> Répartition des licences</div>
            <div style="position:relative;height:200px;margin-bottom:12px">
              <Doughnut :data="licensesDonutData" :options="licensesDonutOpts" />
            </div>
            <div style="display:flex;flex-direction:column;gap:6px">
              <div v-for="c in COMPANIES" :key="c.id" style="display:flex;align-items:center;gap:8px">
                <div class="dot" :style="{ background: c.color }"></div>
                <span style="flex:1;font-size:12px">{{ c.name }}</span>
                <span style="font-size:12px;font-weight:700">{{ c.users }} licences</span>
              </div>
            </div>
          </div>
        </div>

        <div style="display:flex;flex-direction:column;gap:14px">
          <div v-for="c in COMPANIES" :key="c.id" class="co-card">
            <div style="display:flex;align-items:flex-start;gap:16px;flex-wrap:wrap">
              <div class="ring" style="width:88px;height:88px;flex-shrink:0">
                <svg width="88" height="88" viewBox="0 0 88 88">
                  <circle cx="44" cy="44" r="36" fill="none" stroke="var(--surf2)" stroke-width="9" />
                  <circle cx="44" cy="44" r="36" fill="none" :stroke="scHex(c.cp)" stroke-width="9"
                    :stroke-dasharray="ringStroke(36, c.cp).circ"
                    :stroke-dashoffset="ringStroke(36, c.cp).offset"
                    stroke-linecap="round" class="ring-arc" />
                </svg>
                <div class="ring-label">
                  <div style="font-size:15px;font-weight:800" :style="{ color: scColor(c.cp) }">{{ c.cp }}%</div>
                  <div style="font-size:9px;color:var(--tx2)">complétion</div>
                </div>
              </div>
              <div style="flex:1;min-width:200px">
                <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:8px">
                  <span style="font-family:var(--fh);font-size:16px;font-weight:800">{{ c.name }}</span>
                  <span :class="['pill', planClass(c.plan)]">{{ c.plan }}</span>
                  <span class="pill pill-green"><IconCircleCheck :size="10" /> Actif</span>
                </div>
                <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin-bottom:12px">
                  <div class="metric-box">
                    <div style="font-size:13px;font-weight:700">{{ c.users }}</div>
                    <div style="font-size:9px;color:var(--tx2);margin-top:1px">Licences totales</div>
                  </div>
                  <div class="metric-box">
                    <div style="font-size:13px;font-weight:700">{{ c.active }} ({{ Math.round(c.active/c.users*100) }}%)</div>
                    <div style="font-size:9px;color:var(--tx2);margin-top:1px">Utilisateurs actifs</div>
                  </div>
                  <div class="metric-box">
                    <div style="font-size:13px;font-weight:700">{{ c.h }}h</div>
                    <div style="font-size:9px;color:var(--tx2);margin-top:1px">Heures formation</div>
                  </div>
                  <div class="metric-box">
                    <div style="font-size:13px;font-weight:700">{{ c.budget.toLocaleString('fr-FR') }}€</div>
                    <div style="font-size:9px;color:var(--tx2);margin-top:1px">Budget investi</div>
                  </div>
                </div>
                <div style="display:flex;align-items:center;gap:8px">
                  <div class="bar" style="flex:1"><div class="bf" :style="{ width: c.cp+'%', background: scHex(c.cp) }"></div></div>
                  <span style="font-size:11px;color:var(--tx2)">Taux complétion</span>
                </div>
              </div>
              <div style="display:flex;flex-direction:column;gap:6px;flex-shrink:0">
<button class="btn btn-primary btn-sm" @click="async () => { await store.fetchCompanyReporting(c.id); toast('Rapport ' + c.name + ' généré !') }"><IconFileDescription :size="14" /> Rapport</button>
    <button class="btn btn-sm" @click="async () => { await store.sendMessage(auth.profile.id, null, { type: 'drh_report', company_id: c.id }); toast('Email DRH envoyé à ' + c.name) }"><IconMail :size="14" /> Email DRH</button>
    <button class="btn btn-sm" @click="async () => { await store.fetchCompanyReporting(c.id); toast('Détail ' + c.name) }"><IconChartBar :size="14" /> Analytics</button>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- ════════════ ROI ════════════ -->
      <template v-if="tab === 'roi'">
        <div class="roi-hero">
          <div style="position:absolute;right:-40px;top:-40px;width:220px;height:220px;border-radius:50%;background:var(--em);opacity:.06;pointer-events:none"></div>
          <div class="ring" style="width:128px;height:128px;flex-shrink:0;position:relative;z-index:1">
            <svg width="128" height="128" viewBox="0 0 128 128">
              <circle cx="64" cy="64" r="56" fill="none" stroke="rgba(255,255,255,.1)" stroke-width="10" />
              <circle cx="64" cy="64" r="56" fill="none" stroke="#00D4A1" stroke-width="10"
                :stroke-dasharray="ringStroke(56, Math.min(roiStats.roi, 100)).circ"
                :stroke-dashoffset="ringStroke(56, Math.min(roiStats.roi, 100)).offset"
                stroke-linecap="round" class="ring-arc" />
            </svg>
            <div class="ring-label">
              <div style="font-size:22px;font-weight:800;color:#00D4A1;font-family:var(--fh)">{{ roiStats.roi }}%</div>
              <div style="font-size:10px;color:rgba(255,255,255,.5)">ROI net</div>
            </div>
          </div>
          <div style="position:relative;z-index:1">
            <div style="font-size:11px;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:var(--em);margin-bottom:8px">Retour sur investissement formation</div>
            <div style="font-family:var(--fh);font-size:22px;font-weight:800;color:#fff;margin-bottom:6px">Pour 1 € investi → {{ roiStats.ratio }} € générés</div>
            <div style="font-size:13px;color:rgba(255,255,255,.55)">Période : {{ periodLabel }}</div>
          </div>
          <div style="display:flex;gap:14px;margin-left:auto;flex-wrap:wrap;position:relative;z-index:1">
            <div class="roi-stat-box">
              <div style="font-family:var(--fh);font-size:18px;font-weight:800;color:rgba(255,255,255,.7)">{{ roiStats.invest.toLocaleString('fr-FR') }}€</div>
              <div class="roi-stat-lbl">Investissement</div>
            </div>
            <div class="roi-stat-box">
              <div style="font-family:var(--fh);font-size:18px;font-weight:800;color:#00D4A1">{{ roiStats.gain.toLocaleString('fr-FR') }}€</div>
              <div class="roi-stat-lbl">Valeur générée</div>
            </div>
            <div class="roi-stat-box">
              <div style="font-family:var(--fh);font-size:18px;font-weight:800;color:#FF9B21">{{ roiStats.net.toLocaleString('fr-FR') }}€</div>
              <div class="roi-stat-lbl">Bénéfice net</div>
            </div>
          </div>
        </div>

        <div class="gm" style="margin-bottom:20px">
          <div class="card">
            <div class="ct"><IconChartBar :size="14" style="color:var(--em)" /> Décomposition de la valeur générée (k€)</div>
            <div style="position:relative;height:220px">
              <Bar :data="roiDecompData" :options="noLegendOpts" />
            </div>
          </div>
          <div class="card">
            <div class="ct"><IconChartLine :size="14" style="color:var(--blue)" /> Indicateurs d'impact RH</div>
            <div style="display:flex;flex-direction:column;gap:0">
              <div v-for="(ind, i) in impactIndicators" :key="i" class="impact-row">
                <div class="impact-ico" :style="{ background: ind.c + '18', border: '1px solid ' + ind.c + '33' }">
                  <component :is="ind.ico" :size="18" :style="{ color: ind.c }" />
                </div>
                <div style="flex:1;min-width:0">
                  <div style="font-size:12px;font-weight:600">{{ ind.l }}</div>
                  <div style="font-size:11px;color:var(--tx2)">{{ ind.d }}</div>
                </div>
                <div style="font-family:var(--fh);font-size:17px;font-weight:800;flex-shrink:0" :style="{ color: ind.c }">{{ ind.v }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="card" style="margin-bottom:20px">
          <div class="ct"><IconTable :size="14" style="color:var(--blue)" /> ROI estimé par formation</div>
          <div style="overflow-x:auto">
            <table class="dt">
              <thead>
                <tr>
                  <th>Formation</th>
                  <th>Apprenants</th>
                  <th>Coût total</th>
                  <th>Gain productivité</th>
                  <th>Réduction turnover</th>
                  <th>ROI estimé</th>
                  <th>Tendance</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in roiTableData" :key="row[0]">
                  <td style="font-weight:600">{{ row[0] }}</td>
                  <td>{{ row[1] }}</td>
                  <td style="color:var(--tx2)">{{ row[2].toLocaleString('fr-FR') }}€</td>
                  <td style="color:var(--em);font-weight:600">+{{ row[3].toLocaleString('fr-FR') }}€</td>
                  <td style="color:var(--blue);font-weight:600">+{{ row[4].toLocaleString('fr-FR') }}€</td>
                  <td>
                    <span
                      style="font-family:var(--fh);font-size:14px;font-weight:800"
                      :style="{ color: Math.round((row[3]+row[4]-row[2])/row[2]*100) > 200 ? 'var(--em)' : Math.round((row[3]+row[4]-row[2])/row[2]*100) > 100 ? 'var(--am)' : 'var(--co)' }"
                    >{{ Math.round((row[3]+row[4]-row[2])/row[2]*100) }}%</span>
                  </td>
                  <td>
                    <span
                      style="font-size:16px;font-weight:700"
                      :style="{ color: Math.round((row[3]+row[4]-row[2])/row[2]*100) > 200 ? 'var(--em)' : Math.round((row[3]+row[4]-row[2])/row[2]*100) > 100 ? 'var(--am)' : 'var(--co)' }"
                    >{{ Math.round((row[3]+row[4]-row[2])/row[2]*100) > 200 ? '↑' : Math.round((row[3]+row[4]-row[2])/row[2]*100) > 100 ? '→' : '↓' }}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="card">
          <div class="ct"><IconFileAnalytics :size="14" style="color:var(--blue)" /> Générer des rapports ROI</div>
          <div style="display:flex;gap:8px;flex-wrap:wrap">
            <button
              v-for="(b, i) in roiReportBtns"
              :key="i"
              class="btn btn-sm"
              @click="toast(b.l + '...')"
            >
              <component :is="b.ico" :size="14" style="color:var(--blue)" />
              {{ b.l }}
            </button>
          </div>
        </div>
  </template>
  </div>
  </template>
  </div>
</template>

<style scoped>
.page {
  max-width: 1320px;
  margin: 0 auto;
  padding: 28px 28px 48px;
}

.hero {
  background: var(--navy);
  border-radius: var(--rl);
  padding: 28px 32px;
  margin-bottom: 24px;
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.06);
}
.hero::before {
  content: '';
  position: absolute;
  right: -60px;
  top: -60px;
  width: 280px;
  height: 280px;
  border-radius: 50%;
  background: var(--blue);
  opacity: 0.07;
}
.hero::after {
  content: '';
  position: absolute;
  left: 35%;
  bottom: -80px;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background: var(--em);
  opacity: 0.05;
}
.hero-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  flex-wrap: wrap;
  position: relative;
  z-index: 1;
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
  font-size: 24px;
  font-weight: 800;
  color: #fff;
  letter-spacing: -0.4px;
  margin-bottom: 6px;
}
.hero-sub {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
}
.hero-actions {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}
.hero-sel {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 255, 255, 0.15);
  color: #fff;
  font-size: 12px;
}
.hero-btn-ghost {
  background: rgba(255, 255, 255, 0.1);
  color: #fff;
  border-color: rgba(255, 255, 255, 0.2);
}
.hero-btn-em {
  background: var(--em);
  color: #fff;
  border-color: var(--em);
}

.tab-row {
  display: flex;
  gap: 2px;
  background: var(--surf2);
  border-radius: 10px;
  padding: 3px;
  margin-bottom: 22px;
}
.tab-btn {
  flex: 1;
  padding: 9px 12px;
  border-radius: 8px;
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
  justify-content: center;
  gap: 6px;
  white-space: nowrap;
}
.tab-btn.active {
  background: var(--surf);
  color: var(--tx);
  box-shadow: var(--shadow-sm);
}

.card {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 18px 20px;
  box-shadow: var(--shadow-sm);
}
.ct {
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

.g2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.g3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
.g4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.gm { display: grid; grid-template-columns: minmax(0, 1.5fr) minmax(0, 1fr); gap: 18px; }

.kpi {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 18px;
  box-shadow: var(--shadow-sm);
  transition: all 0.2s;
  cursor: default;
  position: relative;
  overflow: hidden;
}
.kpi:hover {
  border-color: var(--bd2);
  transform: translateY(-1px);
  box-shadow: var(--shadow-md);
}
.kpi-val {
  font-family: var(--fh);
  font-size: 28px;
  font-weight: 800;
  margin: 5px 0 4px;
  letter-spacing: -0.5px;
}
.kpi-lbl {
  font-size: 11px;
  color: var(--tx2);
  display: flex;
  align-items: center;
  gap: 5px;
}
.kpi-delta {
  font-size: 11px;
  display: flex;
  align-items: center;
  gap: 3px;
  margin-top: 4px;
}
.kpi-bg {
  position: absolute;
  right: -10px;
  top: -10px;
  opacity: 0.04;
  pointer-events: none;
}
.up { color: var(--em); }
.dn { color: var(--co); }

.pill {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  font-size: 10px;
  font-weight: 700;
  padding: 3px 9px;
  border-radius: 20px;
}
.pill-green { background: var(--em-lt); color: #005A42; border: 1px solid #A8EDD8; }
.pill-amber { background: var(--am-lt); color: #6B3B00; border: 1px solid #FFD280; }
.pill-blue { background: var(--blue-lt); color: #1A4AAA; border: 1px solid var(--blue-md); }
.pill-coral { background: var(--co-lt); color: #7A0020; border: 1px solid #FFB3C0; }
.pill-purple { background: var(--pu-lt); color: #3C3480; border: 1px solid #C8C4F5; }
.pill-gray { background: var(--surf2); color: var(--tx2); border: 1px solid var(--bd); }

.bar {
  height: 6px;
  background: var(--surf2);
  border-radius: 4px;
  overflow: hidden;
}
.bf {
  height: 100%;
  border-radius: 4px;
  transition: width 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

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
.btn:hover { border-color: var(--blue); color: var(--blue); }
.btn-primary { background: var(--blue); color: #fff; border-color: var(--blue); box-shadow: var(--shadow-blue); }
.btn-primary:hover { background: #1658D8; border-color: #1658D8; color: #fff; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
.btn-xs { padding: 3px 9px; font-size: 11px; }

.sel {
  padding: 8px 12px;
  border: 1px solid var(--bd);
  border-radius: var(--rs);
  background: var(--surf2);
  color: var(--tx);
  font-size: 13px;
  font-family: var(--fb);
  cursor: pointer;
  outline: none;
}

.dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}

.ring {
  position: relative;
  flex-shrink: 0;
}
.ring svg { transform: rotate(-90deg); }
.ring-arc {
  transform: rotate(-90deg);
  transform-origin: 50% 50%;
  transition: stroke-dashoffset 0.8s ease;
}
.ring-label {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-family: var(--fh);
}

.co-row {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 12px 0;
  border-bottom: 1px solid var(--bd);
}
.co-row:last-child { border-bottom: none; }

.co-card {
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 18px 20px;
  background: var(--surf);
  box-shadow: var(--shadow-sm);
  cursor: pointer;
  transition: all 0.22s;
}
.co-card:hover {
  border-color: var(--blue);
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

.metric-box {
  background: var(--surf2);
  border-radius: var(--rs);
  padding: 8px;
  text-align: center;
  border: 1px solid var(--bd);
}

.alert-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  border-radius: var(--rs);
  margin-bottom: 7px;
}

.export-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border-radius: var(--rs);
  border: 1px solid var(--bd);
  cursor: pointer;
  transition: all 0.18s;
  margin-bottom: 7px;
  background: var(--surf);
}
.export-row:hover {
  border-color: var(--blue);
  background: var(--blue-lt);
}
.export-ico {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: var(--blue-lt);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.gain-badge {
  font-size: 11px;
  font-weight: 800;
  color: var(--em);
  background: var(--em-lt);
  padding: 1px 7px;
  border-radius: 10px;
  border: 1px solid #A8EDD8;
}

.hm-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 4px;
  font-size: 12px;
}
.hm-table th {
  padding: 4px 8px;
  color: var(--tx2);
  font-size: 11px;
  font-weight: 600;
}
.hm-cell {
  width: 32px;
  height: 28px;
  border-radius: 5px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 700;
  cursor: default;
  transition: transform 0.15s;
  margin: 0 auto;
}
.hm-cell:hover { transform: scale(1.15); }
.hm-cell-bold { font-weight: 800; }
.hm-legend {
  display: flex;
  gap: 14px;
  margin-top: 12px;
  font-size: 11px;
  color: var(--tx2);
  flex-wrap: wrap;
}
.hm-legend-item {
  display: flex;
  align-items: center;
  gap: 5px;
}
.hm-legend-swatch {
  width: 12px;
  height: 12px;
  border-radius: 3px;
}

.roi-hero {
  background: var(--navy);
  border-radius: var(--rl);
  padding: 28px 32px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 28px;
  flex-wrap: wrap;
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.06);
}
.roi-stat-box {
  text-align: center;
  padding: 14px 18px;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.roi-stat-lbl {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.4);
  margin-top: 2px;
  text-transform: uppercase;
  letter-spacing: 0.8px;
}

.impact-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 11px 0;
  border-bottom: 1px solid var(--bd);
}
.impact-row:last-child { border-bottom: none; }
.impact-ico {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.dt {
  width: 100%;
  border-collapse: collapse;
  font-size: 12px;
}
.dt th {
  text-align: left;
  padding: 8px 12px;
  color: var(--tx2);
  font-weight: 600;
  font-size: 11px;
  border-bottom: 1px solid var(--bd);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  white-space: nowrap;
}
.dt td {
  padding: 10px 12px;
  border-bottom: 1px solid var(--bd);
  vertical-align: middle;
}
.dt tr:last-child td { border-bottom: none; }
.dt tr:hover td { background: var(--surf2); }

.fi { animation: fadeUp 0.3s ease forwards; }
.fi2 { animation: fadeUp 0.3s ease 0.08s forwards; opacity: 0; }
.fi3 { animation: fadeUp 0.3s ease 0.16s forwards; opacity: 0; }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 1100px) {
  .gm { grid-template-columns: 1fr; }
}
@media (max-width: 900px) {
  .g4, .g3 { grid-template-columns: 1fr 1fr; }
}
@media (max-width: 600px) {
  .g4, .g3, .g2 { grid-template-columns: 1fr; }
  .page { padding: 16px; }
  .hero-inner { flex-direction: column; align-items: flex-start; }
  .roi-hero { flex-direction: column; align-items: flex-start; }
}
@keyframes spin { from { transform: rotate(0deg) } to { transform: rotate(360deg) } }
</style>
