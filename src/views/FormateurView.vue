<script setup>
import { inject, ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import {
  IconLayoutDashboard,
  IconCalendarEvent,
  IconTool,
  IconUsers,
  IconMessage,
  IconChartBar,
  IconReportAnalytics,
  IconSchool,
  IconTrendingUp,
  IconTrendingDown,
  IconStar,
  IconCalendar,
  IconAlertTriangle,
  IconCircleCheck,
  IconClock,
  IconEdit,
  IconPlus,
  IconX,
  IconSend,
  IconMail,
  IconBell,
  IconCopy,
  IconDownload,
  IconSparkles,
  IconShare,
  IconFolder,
  IconLink,
  IconBookmark,
  IconBook,
  IconPresentation,
  IconFileText,
  IconPuzzle,
  IconClipboardCheck,
  IconUser,
  IconTableExport,
  IconFileDescription,
  IconChartPie,
  IconCertificate,
  IconTrophy,
  IconPaperclip,
  IconTarget,
  IconMapPin,
  IconVideo,
  IconDeviceFloppy,
  IconMailForward,
  IconPencil,
  IconLoader2,
} from '@tabler/icons-vue'

const auth = useAuthStore()
const store = useDataStore()
const toast = inject('toast')

const pageLoading = ref(false)
const pageError = ref(null)
const section = ref('dashboard')
const sessOpen = ref(false)
const selectedLearner = ref(null)
const chatInput = ref('')
const activeMsgThread = ref('sl')

const STATIC_SESSIONS = [
  { id: 's1', title: 'Leadership & Influence', level: 'avd', mode: 'Présentiel', loc: 'Paris 8e — Salle Voltaire', date: '2025-05-19', hD: '09:00', hF: '12:30', ins: 8, max: 12, status: 'confirmée', obj: 'Maîtriser les 5 styles de leadership situationnel', color: '#7B6FEE' },
  { id: 's2', title: 'Communication CNV', level: 'int', mode: 'En ligne', loc: 'meet.skillpath.io/cnv-052025', date: '2025-05-21', hD: '14:00', hF: '16:30', ins: 12, max: 15, status: 'confirmée', obj: 'Appliquer les 4 composantes CNV en contexte pro', color: '#FF9B21' },
  { id: 's3', title: 'Management Agile', level: 'int', mode: 'Présentiel', loc: 'Lyon — Centre IDEC', date: '2025-05-26', hD: '09:00', hF: '17:00', ins: 6, max: 8, status: 'en attente', obj: 'Fondamentaux Scrum et Kanban', color: '#00D4A1' },
  { id: 's4', title: 'Leadership & Influence', level: 'avd', mode: 'Présentiel', loc: 'Paris 8e — Salle Voltaire', date: '2025-06-03', hD: '09:00', hF: '12:30', ins: 2, max: 12, status: 'brouillon', obj: '', color: '#7B6FEE' },
]

const SESSIONS = computed(() => store.sessions.length ? store.sessions : STATIC_SESSIONS)

const STATIC_LEARNERS = [
  { id: 'sl', name: 'Sophie Laurent', init: 'SL', role: 'Chef de projet', prg: 67, quiz: 88, eng: 'Élevé', last: 'Il y a 2h', alert: false, color: '#1E6FFF', comp: 72, note: 'Excellente progression, à encourager' },
  { id: 'tb', name: 'Thomas Bernard', init: 'TB', role: 'Dev. Senior', prg: 45, quiz: 72, eng: 'Moyen', last: 'Hier', alert: false, color: '#00D4A1', comp: 58, note: 'Bon niveau technique, communication à travailler' },
  { id: 'ep', name: 'Emma Petit', init: 'EP', role: 'Product Owner', prg: 91, quiz: 95, eng: 'Très élevé', last: 'Il y a 3h', alert: false, color: '#FF4D6A', comp: 80, note: 'Meilleure apprenante du groupe — potentiel formateur' },
  { id: 'lm', name: 'Lucas Moreau', init: 'LM', role: 'Analyste Data', prg: 23, quiz: 54, eng: 'Faible', last: 'Il y a 5j', alert: true, color: '#FF9B21', comp: 38, note: 'Inactif depuis 5 jours. Relancer en direct.' },
  { id: 'jd', name: 'Julie Durand', init: 'JD', role: 'UX Designer', prg: 78, quiz: 81, eng: 'Élevé', last: 'Il y a 1h', alert: false, color: '#7B6FEE', comp: 67, note: 'Forte implication, questions pertinentes' },
  { id: 'mr', name: 'Maxime Roy', init: 'MR', role: 'Dev. Junior', prg: 34, quiz: 62, eng: 'Faible', last: 'Il y a 4j', alert: true, color: '#D85A30', comp: 42, note: 'Score quiz insuffisant. Revoir les bases avec lui.' },
]

const LEARNERS = computed(() => STATIC_LEARNERS)

const TOOLS = [
  { ico: IconBook, label: "Guide d'animation", type: 'PDF', size: '2.4 Mo', bg: '#EEF4FF', tc: '#1A4AAA', bc: '#C5D9FF', desc: "Déroulé heure par heure, consignes formateur, gestion des sous-groupes, variantes selon profil apprenant." },
  { ico: IconPresentation, label: 'Support de cours', type: 'PPTX', size: '12 Mo', bg: '#F0EFFE', tc: '#3C3480', bc: '#C8C4F5', desc: "85 diapositives HD avec notes formateur masquées, animations intégrées et schémas pédagogiques." },
  { ico: IconFileText, label: 'Synopsis pédagogique', type: 'PDF', size: '1.1 Mo', bg: '#E0F9F3', tc: '#005A42', bc: '#A8EDD8', desc: "Séquençage 5E complet, objectifs par phase, timing, évaluations associées et compétences ciblées." },
  { ico: IconPuzzle, label: 'Activités pédagogiques', type: 'ZIP', size: '3.7 Mo', bg: '#FFF4E0', tc: '#6B3B00', bc: '#FFD280', desc: "12 activités clé-en-main : jeux de rôle, études de cas, mises en situation, ateliers en sous-groupes." },
  { ico: IconClipboardCheck, label: "Grille d'évaluation", type: 'PDF', size: '0.6 Mo', bg: '#FFF0F2', tc: '#7A0020', bc: '#FFB3C0', desc: "Critères de compétences avec niveaux attendus (débutant→expert) et feedback type prêt à l'emploi." },
  { ico: IconBookmark, label: 'Fiche mémo apprenant', type: 'PDF', size: '0.4 Mo', bg: 'var(--surf2)', tc: 'var(--tx2)', bc: 'var(--bd)', desc: "Résumé tient sur 1 page A4, à distribuer en fin de session. Reprend les points clés mémorisables." },
]

const STATIC_MESSAGES = {
  sl: {
    name: 'Sophie Laurent', init: 'SL', color: '#1E6FFF', role: 'Chef de projet',
    thread: [
      { from: 'them', text: "Bonjour Marc, est-ce que vous pourriez partager les slides de la session de lundi avant vendredi ?", time: "Lun. 13:24" },
      { from: 'me', text: "Bien sûr Sophie ! Je vous envoie ça ce soir. Préparez aussi un cas réel de votre équipe pour l'exercice E4.", time: "Lun. 14:02" },
      { from: 'them', text: "Parfait ! J'ai justement un projet de migration Agile en cours. Ce sera parfait comme étude de cas.", time: "Lun. 14:18" },
    ],
  },
  lm: {
    name: 'Lucas Moreau', init: 'LM', color: '#FF9B21', role: 'Analyste Data',
    thread: [
      { from: 'me', text: "Bonjour Lucas, je voulais prendre de vos nouvelles. Vous êtes absent depuis 5 jours — tout va bien ?", time: "Jeu. 09:00" },
    ],
  },
  ep: {
    name: 'Emma Petit', init: 'EP', color: '#FF4D6A', role: 'Product Owner',
    thread: [
      { from: 'them', text: "Super session la semaine dernière ! J'ai pu appliquer le daily standup avec mon équipe dès le lendemain.", time: "Mar. 11:05" },
      { from: 'me', text: "C'est exactement ce qu'on cherche — bravo Emma ! Votre livrable E4 était également excellent.", time: "Mar. 11:32" },
],
},
}

const MESSAGES = computed(() => {
  if (Object.keys(store.messages).length) return store.messages
  return STATIC_MESSAGES
})

const QUICK_MSGS = [
  { label: 'Rappel de session', text: 'Rappel : votre session approche. Pensez à préparer un cas réel de votre entreprise à présenter.' },
  { label: 'Partage de supports', text: 'Les supports de la prochaine session sont maintenant disponibles dans votre espace apprenant.' },
  { label: 'Félicitations quiz', text: 'Félicitations pour votre résultat au quiz — excellent travail ! Continuez sur cette lancée.' },
  { label: 'Relance douce', text: "Bonjour, nous n'avons pas eu de vos nouvelles depuis quelque temps. Tout va bien ? N'hésitez pas à me contacter si vous avez des questions." },
  { label: 'Feedback livrable', text: 'Votre livrable E4 a été corrigé. Vous trouverez mes commentaires détaillés dans votre espace personnel.' },
]

const AVC = ['#1E6FFF', '#00D4A1', '#FF4D6A', '#FF9B21', '#7B6FEE', '#D85A30']
const ac = (i) => AVC[i % AVC.length]

const sc = (v) => (v >= 75 ? 'var(--em)' : v >= 50 ? 'var(--am)' : 'var(--co)')

const daysUntil = (d) => {
  const now = new Date()
  now.setHours(0, 0, 0, 0)
  const dt = new Date(d)
  dt.setHours(0, 0, 0, 0)
  return Math.round((dt - now) / 86400000)
}

const fmtDate = (d) =>
  new Date(d).toLocaleDateString('fr-FR', { weekday: 'short', day: 'numeric', month: 'short' })

function nav(sec) {
  section.value = sec
  sessOpen.value = false
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

async function sendMessage() {
  if (!chatInput.value.trim()) {
    toast("Rédigez un message avant d'envoyer", 'err')
    return
  }
  const thread = MESSAGES.value[activeMsgThread.value]
  const receiverId = thread?.user_id || null
  const res = await store.sendMessage(auth.profile.id, receiverId, chatInput.value.trim())
  if (res.error) toast('Erreur : ' + res.error.message, 'err')
  else {
    if (thread?.thread) thread.thread.push({ from: 'me', text: chatInput.value.trim(), time: "À l'instant" })
    chatInput.value = ''
    toast('Message envoyé !')
  }
}

const navItems = [
  { id: 'dashboard', ico: IconLayoutDashboard, lbl: 'Tableau de bord' },
  { id: 'planning', ico: IconCalendarEvent, lbl: 'Planning sessions' },
  { id: 'toolkit', ico: IconTool, lbl: 'Boîte à outils' },
  { id: 'learners', ico: IconUsers, lbl: 'Mes apprenants', badge: 2 },
  { id: 'messages', ico: IconMessage, lbl: 'Messagerie', badge: 2 },
]

const analysisItems = [
  { id: 'results', ico: IconChartBar, lbl: 'Résultats évals' },
  { id: 'reporting', ico: IconReportAnalytics, lbl: 'Reporting' },
]

const stConf = {
  confirmée: { pill: 'pill-green', ico: IconCircleCheck },
  'en attente': { pill: 'pill-amber', ico: IconClock },
  brouillon: { pill: 'pill-gray', ico: IconEdit },
}

const levelLabels = { deb: 'Débutant', int: 'Intermédiaire', avd: 'Avancé' }

const satBars = [
  { label: 'Qualité du contenu', val: 4.7, color: 'var(--em)' },
  { label: 'Animation formateur', val: 4.5, color: 'var(--blue)' },
  { label: 'Pertinence pédagogique', val: 4.3, color: 'var(--am)' },
  { label: 'Supports fournis', val: 4.6, color: 'var(--pu)' },
]

const iaPrompts = [
  { label: 'Adapter en distanciel', prompt: "Adapter le guide d'animation Leadership pour une session 100% en ligne de 2h30" },
  { label: 'Activité brise-glace', prompt: 'Créer une activité brise-glace originale de 10 min pour groupe mixte senior/junior' },
  { label: 'Quiz sur mesure', prompt: 'Générer 10 questions QCM sur le leadership situationnel niveau avancé' },
  { label: 'Fiche mémo v2', prompt: 'Mettre à jour la fiche mémo avec les nouveaux cas pratiques du groupe' },
  { label: 'Synopsis réduit', prompt: 'Créer un synopsis condensé pour une session de 3h au lieu de 8h' },
]

const perQ = [
  { q: 'Rôle du Product Owner', pct: 88, type: 'qcm', good: 41, bad: 6 },
  { q: 'Artefacts Scrum officiels', pct: 72, type: 'qcmm', good: 34, bad: 13 },
  { q: 'Daily Scrum 15 min', pct: 45, type: 'vf', good: 21, bad: 26 },
  { q: 'Ordre étapes sprint', pct: 91, type: 'order', good: 43, bad: 4 },
  { q: 'Fin de sprint partielle', pct: 33, type: 'situation', good: 15, bad: 30 },
  { q: 'Transition cycle V → Agile', pct: 60, type: 'open', good: 28, bad: 19 },
]

const QT_COLORS = { qcm: '#1A4AAA', qcmm: '#3C3480', vf: '#005A42', order: '#6B3B00', situation: '#444440', open: '#6B0050' }
const QT_BG = { qcm: '#EEF4FF', qcmm: '#F0EFFE', vf: '#E0F9F3', order: '#FFF4E0', situation: '#F5F5F0', open: '#FFF3FB' }
const QT_LABELS = { qcm: 'QCM', qcmm: 'QCM Multiple', vf: 'V/F', order: 'Ordre', situation: 'Situation', open: 'Ouvert' }

const monthlyBars = [
  { m: 'Jan', v: 62 },
  { m: 'Fév', v: 65 },
  { m: 'Mar', v: 68 },
  { m: 'Avr', v: 72 },
  { m: 'Mai', v: 76, cur: true },
]

const topFormations = [
  { name: 'Management Agile', pct: 92, color: '#00D4A1' },
  { name: 'Leadership', pct: 88, color: '#7B6FEE' },
  { name: 'Excel Avancé', pct: 81, color: '#1E6FFF' },
  { name: 'Communication CNV', pct: 85, color: '#FF9B21' },
  { name: 'Cybersécurité', pct: 73, color: '#FF4D6A' },
]

function engPill(eng) {
  if (eng === 'Très élevé' || eng === 'Élevé') return 'pill-green'
  if (eng === 'Moyen') return 'pill-amber'
  return 'pill-coral'
}

onMounted(async () => {
  pageLoading.value = true
  pageError.value = null
  try {
    if (!auth.profile?.id) return
    await Promise.all([
      store.fetchSessions(),
      store.fetchMessages(auth.profile.id),
    ])
  } catch (e) {
    pageError.value = e?.message || 'Erreur lors du chargement'
  } finally {
    pageLoading.value = false
  }
})
</script>

<template>
  <div class="fi formateur-layout">
    <div v-if="pageLoading" style="display:flex;flex-direction:column;align-items:center;justify-content:center;padding:80px 20px;gap:14px">
      <IconLoader2 :size="36" style="color:var(--blue);animation:spin 1s linear infinite" />
      <div style="font-size:14px;color:var(--tx2)">Chargement…</div>
    </div>
    <div v-else-if="pageError" style="display:flex;flex-direction:column;align-items:center;justify-content:center;padding:80px 20px;gap:14px">
      <IconAlertTriangle :size="36" style="color:var(--co)" />
      <div style="font-size:14px;color:var(--co)">{{ pageError }}</div>
    </div>
    <template v-else>
<div class="sidebar-nav">
      <div class="sidebar-profile">
        <div class="sidebar-profile-header">
          <div class="av sidebar-av" style="width:42px;height:42px;font-size:14px;background:linear-gradient(135deg,var(--em),var(--blue));color:#fff">MD</div>
          <div>
            <div class="sidebar-name">Marc Dupont</div>
            <div class="sidebar-role">Formateur Senior</div>
          </div>
        </div>
        <div class="sidebar-stats">
          <div class="sidebar-stat">
            <div class="sidebar-stat-val" :style="{ color: ac(0) }">6</div>
            <div class="sidebar-stat-lbl">Sessions</div>
          </div>
          <div class="sidebar-stat">
            <div class="sidebar-stat-val" :style="{ color: ac(1) }">47</div>
            <div class="sidebar-stat-lbl">Apprenants</div>
          </div>
        </div>
      </div>

      <div class="snav-section">Espace formateur</div>
      <div
        v-for="item in navItems"
        :key="item.id"
        class="snav-item"
        :class="{ active: section === item.id }"
        @click="nav(item.id)"
      >
        <component :is="item.ico" :size="17" />
        <span>{{ item.lbl }}</span>
        <span v-if="item.badge" class="snav-badge">{{ item.badge }}</span>
      </div>

      <div class="snav-section" style="margin-top:8px">Analyse</div>
      <div
        v-for="item in analysisItems"
        :key="item.id"
        class="snav-item"
        :class="{ active: section === item.id }"
        @click="nav(item.id)"
      >
        <component :is="item.ico" :size="17" />
        <span>{{ item.lbl }}</span>
      </div>
    </div>

    <div class="formateur-main">
      <!-- ══════════ DASHBOARD ══════════ -->
      <template v-if="section === 'dashboard'">
        <div class="si">
          <div class="grid-4 mb-20">
            <div class="kpi">
              <div class="kpi-lbl"><IconSchool :size="13" style="color:var(--blue)" /> Sessions animées</div>
              <div class="kpi-val" style="color:var(--blue)">6</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> 3 ce trimestre</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl"><IconUsers :size="13" style="color:var(--em)" /> Apprenants actifs</div>
              <div class="kpi-val" style="color:var(--em)">47</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> +5 ce mois</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl"><IconStar :size="13" style="color:var(--am)" /> Satisfaction moy.</div>
              <div class="kpi-val" style="color:var(--am)">4.5/5</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> +0.2 vs M-1</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl"><IconCalendar :size="13" style="color:var(--pu)" /> Cette semaine</div>
              <div class="kpi-val" style="color:var(--pu)">3</div>
              <div class="kpi-delta" style="color:var(--tx2)">2 présentiel · 1 ligne</div>
            </div>
          </div>

          <div class="grid-main mb-20">
            <div class="card">
              <div class="ct"><IconCalendarEvent :size="13" style="color:var(--blue)" /> Planning de la semaine</div>
              <div
                v-for="s in SESSIONS"
                :key="s.id"
                class="sess-week-row"
                :style="{ borderLeftColor: s.color }"
                @click="nav('planning')"
              >
                <div
                  class="sess-week-date"
                  :style="{ color: daysUntil(s.date) >= 0 && daysUntil(s.date) <= 2 ? 'var(--am)' : 'var(--tx2)' }"
                >
                  {{ fmtDate(s.date) }}
                </div>
                <div style="flex:1;min-width:0">
                  <div class="sess-week-title">{{ s.title }}</div>
                  <div class="sess-week-sub">{{ s.hD }}–{{ s.hF }} · {{ s.mode }} · {{ s.ins }} apprenants</div>
                </div>
                <span v-if="daysUntil(s.date) >= 0 && daysUntil(s.date) <= 2" class="pill pill-amber" style="flex-shrink:0">
                  Dans {{ daysUntil(s.date) }}j
                </span>
                <button class="btn btn-xs" @click.stop="toast('Préparation session : ' + s.title)">Préparer</button>
              </div>
              <button class="btn btn-primary btn-sm" style="width:100%;justify-content:center;margin-top:8px" @click="sessOpen = true; nav('planning')">
                <IconPlus :size="14" /> Planifier une session
              </button>
            </div>

            <div style="display:flex;flex-direction:column;gap:16px">
              <div class="card" :style="{ borderColor: LEARNERS.filter(l => l.alert).length ? '#FFB3C0' : 'var(--bd)' }">
                <div class="ct">
                  <IconAlertTriangle :size="13" style="color:var(--co)" />
                  Apprenants en alerte
                  <span class="pill pill-coral" style="margin-left:auto">{{ LEARNERS.filter(l => l.alert).length }}</span>
                </div>
                <div
                  v-for="l in LEARNERS.filter(l => l.alert)"
                  :key="l.id"
                  class="alert-row"
                >
                  <div class="av" :style="{ width:'32px',height:'32px',background:l.color,color:'#fff',fontSize:'11px' }">{{ l.init }}</div>
                  <div style="flex:1;min-width:0">
                    <div style="font-size:12px;font-weight:700">{{ l.name }}</div>
                    <div style="font-size:11px;color:var(--co)">Engagement faible · {{ l.last }}</div>
                  </div>
                  <button
                    class="btn btn-xs"
                    style="background:var(--co);color:#fff;border-color:var(--co);flex-shrink:0"
                    @click="activeMsgThread = l.id; nav('messages')"
                  >
                    <IconSend :size="12" /> Écrire
                  </button>
                </div>
                <div v-if="!LEARNERS.some(l => l.alert)" style="text-align:center;padding:14px;color:var(--tx2);font-size:13px">
                  ✓ Tous vos apprenants sont engagés
                </div>
              </div>

              <div class="card">
                <div class="ct"><IconStar :size="13" style="color:var(--am)" /> Satisfaction formations</div>
                <div v-for="bar in satBars" :key="bar.label" style="margin-bottom:10px">
                  <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:4px">
                    <span>{{ bar.label }}</span>
                    <span :style="{ fontWeight:700, color: bar.color }">{{ bar.val }}/5</span>
                  </div>
                  <div class="bar bar-lg">
                    <div class="bf" :style="{ width: (bar.val / 5 * 100) + '%', background: bar.color }"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="card">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;flex-wrap:wrap;gap:10px">
              <div class="ct" style="margin-bottom:0"><IconUsers :size="13" style="color:var(--blue)" /> Progression apprenants — Leadership & Influence</div>
              <button class="btn btn-sm" @click="nav('learners')">Voir le détail →</button>
            </div>
            <div style="overflow-x:auto">
              <table class="dt">
                <thead>
                  <tr>
                    <th>Apprenant</th>
                    <th style="min-width:120px">Progression</th>
                    <th>Quiz</th>
                    <th>Engagement</th>
                    <th>Dernière co.</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="l in LEARNERS" :key="l.id">
                    <td>
                      <div style="display:flex;align-items:center;gap:8px">
                        <div class="av" :style="{ width:'28px',height:'28px',fontSize:'10px',background:l.color,color:'#fff' }">{{ l.init }}</div>
                        <div>
                          <div style="font-weight:600">{{ l.name }}</div>
                          <div style="font-size:10px;color:var(--tx2)">{{ l.role }}</div>
                        </div>
                        <IconAlertTriangle v-if="l.alert" :size="13" style="color:var(--co)" />
                      </div>
                    </td>
                    <td>
                      <div style="display:flex;align-items:center;gap:6px">
                        <div class="bar" style="flex:1;margin:0"><div class="bf" :style="{ width: l.prg + '%', background:'var(--blue)' }"></div></div>
                        <span style="font-size:11px;font-weight:700;min-width:28px">{{ l.prg }}%</span>
                      </div>
                    </td>
                    <td :style="{ fontWeight:700, color: sc(l.quiz) }">{{ l.quiz }}%</td>
                    <td><span class="pill" :class="engPill(l.eng)">{{ l.eng }}</span></td>
                    <td style="color:var(--tx2);font-size:11px">{{ l.last }}</td>
                    <td>
                      <div style="display:flex;gap:4px">
                        <button class="btn btn-xs" title="Voir le détail" @click="selectedLearner = l.id; nav('learners')"><IconUser :size="12" /></button>
                        <button class="btn btn-xs" title="Envoyer un message" @click="activeMsgThread = l.id; nav('messages')"><IconMail :size="12" /></button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </template>

      <!-- ══════════ PLANNING ══════════ -->
      <template v-else-if="section === 'planning'">
        <div class="si">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;flex-wrap:wrap;gap:10px">
            <div>
              <div style="font-family:var(--fh);font-size:18px;font-weight:800;margin-bottom:4px">Planning des sessions</div>
              <div style="font-size:13px;color:var(--tx2)">{{ SESSIONS.length }} sessions · {{ SESSIONS.filter(s => s.status === 'confirmée').length }} confirmées</div>
            </div>
            <button class="btn btn-primary" @click="sessOpen = !sessOpen">
              <component :is="sessOpen ? IconX : IconPlus" :size="14" />
              {{ sessOpen ? 'Fermer' : 'Nouvelle session' }}
            </button>
          </div>

          <div v-if="sessOpen" class="card mb-20" style="border:1px solid var(--blue-md);background:var(--blue-lt)">
            <div style="font-size:13px;font-weight:700;color:var(--blue);margin-bottom:16px">
              <IconCalendarEvent :size="14" style="vertical-align:-2px" /> Planifier une nouvelle session
            </div>
            <div class="grid-2" style="gap:12px;margin-bottom:12px">
              <div>
                <label class="label">Formation *</label>
                <select class="sel">
                  <option>Leadership & Influence</option>
                  <option>Communication CNV</option>
                  <option selected>Management Agile</option>
                  <option>Cybersécurité</option>
                </select>
              </div>
              <div>
                <label class="label">Niveau</label>
                <select class="sel">
                  <option>Débutant</option>
                  <option selected>Intermédiaire</option>
                  <option>Avancé</option>
                </select>
              </div>
              <div>
                <label class="label">Modalité</label>
                <select class="sel">
                  <option>Présentiel</option>
                  <option>En ligne</option>
                  <option>Hybride</option>
                </select>
              </div>
              <div>
                <label class="label">Date</label>
                <input type="date" class="inp" value="2025-06-10">
              </div>
              <div>
                <label class="label">Heure début / fin</label>
                <div style="display:flex;gap:8px">
                  <input type="time" class="inp" value="09:00">
                  <input type="time" class="inp" value="17:00">
                </div>
              </div>
              <div>
                <label class="label">Lieu / Lien visio *</label>
                <input type="text" class="inp" placeholder="Adresse ou lien de réunion...">
              </div>
              <div>
                <label class="label">Places max</label>
                <input type="number" class="inp" value="12" min="1" max="50">
              </div>
              <div>
                <label class="label">Formateur</label>
                <input type="text" class="inp" value="Marc Dupont">
              </div>
            </div>
            <div style="margin-bottom:12px">
              <label class="label">Objectif pédagogique</label>
              <input type="text" class="inp" placeholder="Que seront capables de faire les apprenants à l'issue de la session ?">
            </div>
            <div style="margin-bottom:16px">
              <label class="label">Notes de préparation</label>
              <textarea class="ta" placeholder="Matériel à préparer, pré-requis, points de vigilance..."></textarea>
            </div>
            <div style="display:flex;gap:10px;flex-wrap:wrap">
              <button class="btn btn-primary" @click="async () => { const res = await store.createSession({ title: newSession.title, date: newSession.date, formateur_id: auth.profile.id }); sessOpen = false; toast(res.error ? 'Erreur : ' + res.error.message : 'Session créée ! Convocations envoyées automatiquement.') }">
                <IconDeviceFloppy :size="14" /> Enregistrer la session
              </button>
              <button class="btn btn-success" @click="async () => { const res = await store.sendSessionNotifications(null, 'convocation'); toast(res.error ? 'Erreur : ' + res.error.message : 'Convocations envoyées aux 12 apprenants inscrits !') }">
                <IconSend :size="14" /> Envoyer les convocations
              </button>
              <button class="btn btn-ghost-alt" @click="sessOpen = false">Annuler</button>
            </div>
          </div>

          <div>
            <div
              v-for="s in SESSIONS"
              :key="s.id"
              class="sess-card"
              :style="{ borderLeft: '4px solid ' + s.color, borderRadius: '0 var(--r) var(--r) 0' }"
            >
              <div style="display:flex;align-items:flex-start;gap:14px;flex-wrap:wrap">
                <div
                  class="sess-day-badge"
                  :style="{
                    background: daysUntil(s.date) <= 2 && daysUntil(s.date) >= 0 ? 'var(--am-lt)' : 'var(--surf2)',
                    borderColor: daysUntil(s.date) <= 2 && daysUntil(s.date) >= 0 ? '#FFD280' : 'var(--bd)',
                  }"
                >
                  <div
                    class="sess-day-num"
                    :style="{ color: daysUntil(s.date) <= 2 && daysUntil(s.date) >= 0 ? 'var(--am)' : daysUntil(s.date) < 0 ? 'var(--tx3)' : 'var(--tx)' }"
                  >
                    {{ daysUntil(s.date) < 0 ? '✓' : daysUntil(s.date) }}
                  </div>
                  <div style="font-size:9px;color:var(--tx2)">{{ daysUntil(s.date) < 0 ? 'passée' : 'jours' }}</div>
                </div>

                <div style="flex:1;min-width:200px">
                  <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:6px">
                    <span style="font-family:var(--fh);font-size:15px;font-weight:700">{{ s.title }}</span>
                    <span class="pill" :class="stConf[s.status]?.pill">
                      <component :is="stConf[s.status]?.ico" :size="10" />
                      {{ s.status }}
                    </span>
                    <span class="pill" :class="s.mode === 'Présentiel' ? 'pill-green' : 'pill-blue'">{{ s.mode }}</span>
                    <span class="pill" :class="'level-' + s.level">{{ levelLabels[s.level] }}</span>
                  </div>
                  <div style="font-size:12px;color:var(--tx2);display:flex;gap:16px;flex-wrap:wrap;margin-bottom:8px">
                    <span><IconCalendar :size="12" style="vertical-align:-2px" /> {{ fmtDate(s.date) }}</span>
                    <span><IconClock :size="12" style="vertical-align:-2px" /> {{ s.hD }} – {{ s.hF }}</span>
                    <span>
                      <component :is="s.mode === 'En ligne' ? IconVideo : IconMapPin" :size="12" style="vertical-align:-2px" />
                      {{ s.loc }}
                    </span>
                  </div>
                  <div style="display:flex;align-items:center;gap:8px">
                    <div class="bar" style="width:120px"><div class="bf" :style="{ width: Math.round(s.ins / s.max * 100) + '%', background: s.ins / s.max * 100 >= 80 ? 'var(--am)' : 'var(--blue)' }"></div></div>
                    <span style="font-size:11px;color:var(--tx2)">
                      {{ s.ins }}/{{ s.max }} inscrits
                      <span :style="{ color: s.ins / s.max * 100 >= 80 ? 'var(--am)' : 'var(--tx3)' }">({{ Math.round(s.ins / s.max * 100) }}%)</span>
                    </span>
                  </div>
                  <div v-if="s.obj" style="margin-top:8px;padding:7px 12px;background:var(--surf2);border-radius:var(--rs);font-size:12px;border-left:2px solid" :style="{ borderLeftColor: s.color }">
                    <IconTarget :size="12" :style="{ color: s.color, verticalAlign: '-2px' }" /> {{ s.obj }}
                  </div>
                </div>

                <div style="display:flex;flex-direction:column;gap:6px;flex-shrink:0">
                  <button class="btn btn-primary btn-xs" @click="nav('toolkit')"><IconTool :size="12" /> Outils</button>
<button class="btn btn-xs" @click="async () => { const res = await store.sendSessionNotifications(s.id, 'reminder'); toast(res.error ? 'Erreur' : 'Rappels envoyés aux inscrits !') }"><IconBell :size="12" /> Rappel</button>
    <button class="btn btn-xs" @click="async () => { const res = await store.createSession({ ...s, id: undefined, status: 'brouillon' }); toast(res.error ? 'Erreur' : 'Session dupliquée !') }"><IconCopy :size="12" /> Dupliquer</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- ══════════ TOOLKIT ══════════ -->
      <template v-else-if="section === 'toolkit'">
        <div class="si">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;flex-wrap:wrap;gap:10px">
            <div>
              <div style="font-family:var(--fh);font-size:18px;font-weight:800;margin-bottom:4px">Boîte à outils pédagogiques</div>
              <div style="font-size:13px;color:var(--tx2)">Tous vos supports organisés par formation</div>
            </div>
            <select class="sel" style="width:auto">
              <option>Leadership & Influence — Avancé</option>
              <option>Communication CNV — Intermédiaire</option>
              <option>Management Agile — Intermédiaire</option>
              <option>Cybersécurité — Débutant</option>
            </select>
          </div>

          <div class="grid-2 mb-20">
            <div
              v-for="t in TOOLS"
              :key="t.label"
              class="tool-card"
              :style="{ background: t.bg, borderColor: t.bc }"
            >
              <div style="display:flex;align-items:flex-start;gap:12px;margin-bottom:12px">
                <div class="tool-icon-wrap" :style="{ borderColor: t.bc }">
                  <component :is="t.ico" :size="22" :style="{ color: t.tc }" />
                </div>
                <div style="flex:1">
                  <div style="font-size:14px;font-weight:700;margin-bottom:2px" :style="{ color: t.tc }">{{ t.label }}</div>
                  <div :style="{ fontSize:'11px', color: t.tc, opacity: .7 }">{{ t.type }} · {{ t.size }}</div>
                </div>
              </div>
              <div style="font-size:12px;color:var(--tx2);line-height:1.6;margin-bottom:14px">{{ t.desc }}</div>
              <div style="display:flex;gap:8px">
                <button class="btn btn-sm" :style="{ flex:1, justifyContent:'center', background: t.tc + '18', color: t.tc, borderColor: t.bc }" @click="toast('Téléchargement : ' + t.label)">
                  <IconDownload :size="14" /> Télécharger
                </button>
                <button class="btn btn-sm" :style="{ flex:1, justifyContent:'center', background: t.tc + '18', color: t.tc, borderColor: t.bc }" @click="toast(t.label + ' partagé avec les apprenants inscrits !')">
                  <IconSend :size="14" /> Partager
                </button>
              </div>
            </div>
          </div>

          <div class="card mb-20" style="border:1px solid var(--blue-md)">
            <div class="ct"><IconSparkles :size="13" style="color:var(--blue)" /> Générer des supports avec l'IA</div>
            <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px">
              <button
                v-for="p in iaPrompts"
                :key="p.label"
                class="btn btn-sm"
                @click="toast('Génération en cours : ' + p.label + '...')"
              >
                <IconSparkles :size="14" style="color:var(--blue)" /> {{ p.label }}
              </button>
            </div>
            <div style="display:flex;gap:8px">
              <input type="text" class="inp" style="flex:1" placeholder="Ou décrivez votre besoin librement...">
              <button class="btn btn-primary btn-sm" @click="toast('Génération IA lancée !')"><IconSend :size="14" /> Générer</button>
            </div>
          </div>

          <div class="card">
            <div class="ct"><IconShare :size="13" style="color:var(--pu)" /> Partage groupé</div>
            <div style="font-size:13px;color:var(--tx2);margin-bottom:12px">Envoyez plusieurs supports d'un coup à votre groupe</div>
            <div style="display:flex;gap:8px;flex-wrap:wrap">
              <button class="btn btn-sm btn-primary" @click="toast('Guide + Slides partagés aux 8 inscrits de la prochaine session !')"><IconSend :size="14" /> Partager guide + slides</button>
              <button class="btn btn-sm" @click="toast('Tous les supports partagés !')"><IconFolder :size="14" /> Partager tout le dossier</button>
              <button class="btn btn-sm" @click="navigator.clipboard.writeText(window.location.href); toast('Lien de partage copié !')"><IconLink :size="14" /> Copier le lien</button>
            </div>
          </div>
        </div>
      </template>

      <!-- ══════════ LEARNERS ══════════ -->
      <template v-else-if="section === 'learners'">
        <div class="si">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;flex-wrap:wrap;gap:10px">
            <div>
              <div style="font-family:var(--fh);font-size:18px;font-weight:800;margin-bottom:4px">Mes apprenants</div>
              <div style="font-size:13px;color:var(--tx2)">{{ LEARNERS.length }} apprenants · {{ LEARNERS.filter(l => l.alert).length }} en alerte</div>
            </div>
            <div style="display:flex;gap:8px;flex-wrap:wrap">
              <button class="btn btn-sm" @click="toast('Export Excel généré !')"><IconTableExport :size="14" /> Exporter</button>
              <button class="btn btn-primary btn-sm" @click="toast('Rapport de suivi généré et envoyé !')"><IconFileDescription :size="14" /> Rapport de suivi</button>
            </div>
          </div>

          <div
            v-if="selectedLearner && LEARNERS.find(l => l.id === selectedLearner)"
            class="card mb-16"
            :style="{ border: '1px solid ' + LEARNERS.find(l => l.id === selectedLearner).color + '44' }"
          >
            <div v-if="LEARNERS.find(l => l.id === selectedLearner)" :key="selectedLearner">
              <div style="display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:16px;gap:12px;flex-wrap:wrap">
                <div style="display:flex;align-items:center;gap:12px">
                  <div class="av" :style="{ width:'52px',height:'52px',fontSize:'16px',background: LEARNERS.find(l => l.id === selectedLearner).color, color:'#fff' }">
                    {{ LEARNERS.find(l => l.id === selectedLearner).init }}
                  </div>
                  <div>
                    <div style="font-family:var(--fh);font-size:16px;font-weight:800;margin-bottom:4px">
                      {{ LEARNERS.find(l => l.id === selectedLearner).name }}
                    </div>
                    <div style="display:flex;gap:6px;flex-wrap:wrap;align-items:center">
                      <span class="pill pill-gray">{{ LEARNERS.find(l => l.id === selectedLearner).role }}</span>
                      <span class="pill" :class="engPill(LEARNERS.find(l => l.id === selectedLearner).eng)">
                        {{ LEARNERS.find(l => l.id === selectedLearner).eng }}
                      </span>
                      <span v-if="LEARNERS.find(l => l.id === selectedLearner).alert" class="pill pill-coral">
                        <IconAlertTriangle :size="10" /> Alerte
                      </span>
                      <span style="font-size:11px;color:var(--tx2)">
                        Dernière co : {{ LEARNERS.find(l => l.id === selectedLearner).last }}
                      </span>
                    </div>
                  </div>
                </div>
                <div style="display:flex;gap:8px">
                  <button class="btn btn-primary btn-sm" @click="activeMsgThread = selectedLearner; nav('messages')">
                    <IconMail :size="14" /> Envoyer un message
                  </button>
                  <button class="btn btn-sm" @click="selectedLearner = null"><IconX :size="14" /> Fermer</button>
                </div>
              </div>

              <div class="grid-4" style="margin-bottom:16px">
                <div
                  v-for="m in [
                    { label: 'Progression parcours', val: LEARNERS.find(l => l.id === selectedLearner).prg + '%', color: sc(LEARNERS.find(l => l.id === selectedLearner).prg) },
                    { label: 'Score quiz', val: LEARNERS.find(l => l.id === selectedLearner).quiz + '%', color: sc(LEARNERS.find(l => l.id === selectedLearner).quiz) },
                    { label: 'Score maturité', val: LEARNERS.find(l => l.id === selectedLearner).comp + '/100', color: sc(LEARNERS.find(l => l.id === selectedLearner).comp) },
                    { label: 'Engagement', val: LEARNERS.find(l => l.id === selectedLearner).eng, color: 'var(--blue)' },
                  ]"
                  :key="m.label"
                  class="learner-metric"
                >
                  <div class="learner-metric-val" :style="{ color: m.color }">{{ m.val }}</div>
                  <div class="learner-metric-lbl">{{ m.label }}</div>
                </div>
              </div>

              <div class="grid-2" style="margin-bottom:14px">
                <div>
                  <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:4px;font-weight:600">
                    <span>Progression parcours</span>
                    <span :style="{ color: sc(LEARNERS.find(l => l.id === selectedLearner).prg) }">{{ LEARNERS.find(l => l.id === selectedLearner).prg }}%</span>
                  </div>
                  <div class="bar bar-lg">
                    <div class="bf" :style="{ width: LEARNERS.find(l => l.id === selectedLearner).prg + '%', background: sc(LEARNERS.find(l => l.id === selectedLearner).prg) }"></div>
                  </div>
                </div>
                <div>
                  <div style="display:flex;justify-content:space-between;font-size:12px;margin-bottom:4px;font-weight:600">
                    <span>Score quiz</span>
                    <span :style="{ color: sc(LEARNERS.find(l => l.id === selectedLearner).quiz) }">{{ LEARNERS.find(l => l.id === selectedLearner).quiz }}%</span>
                  </div>
                  <div class="bar bar-lg">
                    <div class="bf" :style="{ width: LEARNERS.find(l => l.id === selectedLearner).quiz + '%', background: sc(LEARNERS.find(l => l.id === selectedLearner).quiz) }"></div>
                  </div>
                </div>
              </div>

              <div
                class="learner-note"
                :style="{ borderLeftColor: LEARNERS.find(l => l.id === selectedLearner).color }"
              >
                <div style="font-size:11px;font-weight:700;color:var(--tx2);margin-bottom:3px;text-transform:uppercase;letter-spacing:.7px">Note du formateur</div>
                <div style="font-size:13px;color:var(--tx)">{{ LEARNERS.find(l => l.id === selectedLearner).note }}</div>
                <button class="btn btn-xs btn-ghost-alt" style="margin-top:8px" @click="async () => { const l = LEARNERS.value.find(l => l.id === selectedLearner.value); const res = await store.updateEnrollment(l?.enrollment_id, { note: l?.note }); toast(res.error ? 'Erreur' : 'Note mise à jour !') }"><IconEdit :size="12" /> Modifier</button>
              </div>
            </div>
          </div>

          <div style="display:flex;flex-direction:column;gap:10px">
            <div
              v-for="l in LEARNERS"
              :key="l.id"
              class="card learner-list-card"
              :style="{ borderColor: selectedLearner === l.id ? l.color : 'var(--bd)' }"
              @click="selectedLearner = selectedLearner === l.id ? null : l.id"
            >
              <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap">
                <div class="av" :style="{ width:'38px',height:'38px',fontSize:'13px',background:l.color,color:'#fff',flexShrink:0 }">{{ l.init }}</div>
                <div style="flex:1;min-width:150px">
                  <div style="display:flex;align-items:center;gap:8px;margin-bottom:4px;flex-wrap:wrap">
                    <span style="font-weight:700;font-size:13px">{{ l.name }}</span>
                    <span style="font-size:11px;color:var(--tx2)">{{ l.role }}</span>
                    <span v-if="l.alert" class="pill pill-coral"><IconAlertTriangle :size="10" /> Alerte</span>
                  </div>
                  <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap">
                    <div style="display:flex;align-items:center;gap:6px;min-width:100px">
                      <div class="bar" style="width:80px;margin:0"><div class="bf" :style="{ width: l.prg + '%', background:'var(--blue)' }"></div></div>
                      <span style="font-size:11px;font-weight:700">{{ l.prg }}%</span>
                    </div>
                    <span class="pill" :class="engPill(l.eng)">{{ l.eng }}</span>
                    <span style="font-size:11px;color:var(--tx3)">{{ l.last }}</span>
                  </div>
                </div>
                <div style="display:flex;gap:6px;flex-shrink:0">
                  <span style="font-family:var(--fh);font-size:15px;font-weight:800" :style="{ color: sc(l.quiz) }">{{ l.quiz }}%</span>
                  <button class="btn btn-xs" @click.stop="toast('Feedback personnalisé envoyé à ' + l.name + ' !')">Feedback</button>
                  <button class="btn btn-xs" @click.stop="activeMsgThread = l.id; nav('messages')" title="Envoyer message"><IconMail :size="12" /></button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- ══════════ MESSAGES ══════════ -->
      <template v-else-if="section === 'messages'">
        <div class="si msg-layout">
          <div class="msg-threads">
            <div class="msg-threads-header">
              <div style="font-size:13px;font-weight:700">Messagerie</div>
              <button class="btn btn-xs btn-primary" @click="toast('Nouveau message')"><IconPencil :size="12" /></button>
            </div>
            <div class="msg-threads-list">
              <template v-for="(thread, id) in MESSAGES" :key="id">
                <div
                  class="msg-thread-item"
                  :style="{ background: activeMsgThread === id ? 'var(--blue-lt)' : 'transparent' }"
                  @click="activeMsgThread = id"
                >
                  <div class="av" :style="{ width:'36px',height:'36px',fontSize:'12px',background:thread.color,color:'#fff',flexShrink:0 }">{{ thread.init }}</div>
                  <div style="flex:1;min-width:0">
                    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:2px">
                      <span :style="{ fontSize:'12px', fontWeight: (id === 'sl' || id === 'lm') ? '700' : '500' }">{{ thread.name.split(' ')[0] }}</span>
                      <span v-if="id === 'sl' || id === 'lm'" class="unread-dot"></span>
                    </div>
                    <div class="msg-thread-preview">{{ thread.thread[thread.thread.length - 1].text.slice(0, 42) }}…</div>
                  </div>
                </div>
              </template>
              <div style="padding:12px 14px;border-bottom:1px solid var(--bd)">
                <div style="font-size:11px;font-weight:700;color:var(--tx2);text-transform:uppercase;letter-spacing:.8px;margin-bottom:8px">Envoyer à tous</div>
                <button class="btn btn-sm" style="width:100%;justify-content:center" @click="async () => { const res = await store.broadcastMessage(auth.profile.id, null, msgInput || 'Message du formateur'); toast(res.error ? 'Erreur' : 'Message envoyé aux 47 apprenants !') }"><IconUsers :size="14" /> Tous les apprenants</button>
              </div>
            </div>
          </div>

          <div class="msg-panel">
            <div class="msg-panel-header">
              <div class="av" :style="{ width:'36px',height:'36px',fontSize:'12px',background:MESSAGES[activeMsgThread].color,color:'#fff' }">{{ MESSAGES[activeMsgThread].init }}</div>
              <div style="flex:1">
                <div style="font-size:13px;font-weight:700">{{ MESSAGES[activeMsgThread].name }}</div>
                <div style="font-size:11px;color:var(--tx2)">{{ MESSAGES[activeMsgThread].role }} · {{ LEARNERS.find(l => l.id === activeMsgThread)?.last || '—' }}</div>
              </div>
              <button class="btn btn-xs" @click="selectedLearner = activeMsgThread; nav('learners')"><IconUser :size="12" /> Profil</button>
            </div>

            <div class="msg-bubbles">
              <div
                v-for="(msg, i) in MESSAGES[activeMsgThread].thread"
                :key="i"
                class="msg-row"
                :style="{ flexDirection: msg.from === 'me' ? 'row-reverse' : 'row' }"
              >
                <div v-if="msg.from === 'them'" class="av msg-av-them" :style="{ background: MESSAGES[activeMsgThread].color }">
                  {{ MESSAGES[activeMsgThread].init }}
                </div>
                <div>
                  <div class="msg-bubble" :class="msg.from">{{ msg.text }}</div>
                  <div class="msg-time" :style="{ textAlign: msg.from === 'me' ? 'right' : 'left' }">{{ msg.time }}</div>
                </div>
              </div>
            </div>

            <div class="msg-quick-bar">
              <button
                v-for="qm in QUICK_MSGS"
                :key="qm.label"
                class="btn btn-xs pill-gray"
                style="white-space:nowrap;flex-shrink:0"
                @click="async () => { const res = await store.sendMessage(auth.profile.id, null, qm.text); toast(res.error ? 'Erreur' : 'Message envoyé : ' + qm.label) }"
              >
                {{ qm.label }}
              </button>
            </div>

            <div class="msg-compose">
              <textarea
                v-model="chatInput"
                class="ta msg-textarea"
                placeholder="Votre message..."
                @keydown.enter.prevent="sendMessage"
              ></textarea>
              <div style="display:flex;flex-direction:column;gap:6px">
                <button class="btn btn-xs" @click="toast('Pièce jointe ajoutée !')"><IconPaperclip :size="12" /></button>
                <button class="btn btn-primary btn-xs" @click="sendMessage"><IconSend :size="12" /></button>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- ══════════ RESULTS ══════════ -->
      <template v-else-if="section === 'results'">
        <div class="si">
          <div style="font-family:var(--fh);font-size:18px;font-weight:800;margin-bottom:18px">Résultats des évaluations</div>

          <div class="grid-4 mb-20">
            <div class="kpi">
              <div class="kpi-lbl" style="color:var(--am)">Taux de réussite</div>
              <div class="kpi-val" style="color:var(--am)">68%</div>
              <div class="kpi-delta dn"><IconTrendingDown :size="11" /> vs seuil 75%</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl" style="color:var(--blue)">Apprenants évalués</div>
              <div class="kpi-val" style="color:var(--blue)">47</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> Ce trimestre</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl" style="color:var(--em)">Durée moy. quiz</div>
              <div class="kpi-val" style="color:var(--em)">14 min</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> Objectif : 20 min</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl" style="color:var(--pu)">Tentatives moy.</div>
              <div class="kpi-val" style="color:var(--pu)">1.4</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> Par apprenant</div>
            </div>
          </div>

          <div class="grid-main mb-20">
            <div class="card">
              <div class="ct"><IconChartBar :size="13" style="color:var(--blue)" /> Taux de réussite par question — Management Agile</div>
              <div v-for="q in perQ" :key="q.q" style="margin-bottom:14px">
                <div style="display:flex;align-items:center;gap:8px;margin-bottom:5px;flex-wrap:wrap">
                  <span style="font-size:12px;font-weight:500;flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ q.q }}</span>
                  <span
                    class="pill"
                    :style="{ background: QT_BG[q.type], color: QT_COLORS[q.type], border: '1px solid ' + QT_COLORS[q.type] + '33', fontSize:'9px', flexShrink:0 }"
                  >
                    {{ QT_LABELS[q.type] }}
                  </span>
                  <span :style="{ fontFamily:'var(--fh)', fontSize:'14px', fontWeight:800, color:sc(q.pct), minWidth:'38px', textAlign:'right' }">{{ q.pct }}%</span>
                </div>
                <div class="bar bar-lg">
                  <div class="bf" :style="{ width: q.pct + '%', background: q.pct >= 75 ? 'var(--em)' : q.pct >= 50 ? 'var(--am)' : 'var(--co)' }"></div>
                </div>
                <div style="display:flex;gap:12px;margin-top:4px;font-size:10px;color:var(--tx3)">
                  <span style="color:var(--em)">✓ {{ q.good }} corrects</span>
                  <span style="color:var(--co)">✗ {{ q.bad }} incorrects</span>
                  <span v-if="q.pct < 50" style="color:var(--co);font-weight:600">⚠ Contenu à retravailler</span>
                </div>
              </div>
            </div>

            <div style="display:flex;flex-direction:column;gap:14px">
              <div class="card">
                <div class="ct"><IconUsers :size="13" style="color:var(--blue)" /> Résultats par apprenant</div>
                <div v-for="l in LEARNERS" :key="l.id" style="display:flex;align-items:center;gap:10px;padding:9px 0;border-bottom:1px solid var(--bd)">
                  <div class="av" :style="{ width:'28px',height:'28px',fontSize:'10px',background:l.color,color:'#fff',flexShrink:0 }">{{ l.init }}</div>
                  <div style="flex:1;min-width:0">
                    <div style="font-size:12px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ l.name.split(' ')[0] }}</div>
                    <div style="display:flex;align-items:center;gap:6px;margin-top:3px">
                      <div class="bar" style="flex:1;margin:0"><div class="bf" :style="{ width: l.quiz + '%', background: sc(l.quiz) }"></div></div>
                      <span style="font-size:11px;font-weight:700;min-width:30px" :style="{ color: sc(l.quiz) }">{{ l.quiz }}%</span>
                    </div>
                  </div>
                  <span class="pill" :class="l.quiz >= 75 ? 'pill-green' : 'pill-coral'" style="flex-shrink:0">{{ l.quiz >= 75 ? 'Réussi' : 'Insuffisant' }}</span>
                </div>
              </div>

              <div class="card">
                <div class="ct"><IconDownload :size="13" style="color:var(--em)" /> Exports</div>
                <button class="btn btn-ghost-alt btn-sm" style="width:100%;justify-content:flex-start;margin-bottom:6px" @click="toast('Rapport détaillé PDF...')">
                  <IconFileDescription :size="14" style="color:var(--blue)" /> Rapport détaillé PDF
                </button>
                <button class="btn btn-ghost-alt btn-sm" style="width:100%;justify-content:flex-start;margin-bottom:6px" @click="toast('Export CSV résultats...')">
                  <IconTableExport :size="14" style="color:var(--blue)" /> Export CSV résultats
                </button>
                <button class="btn btn-ghost-alt btn-sm" style="width:100%;justify-content:flex-start;margin-bottom:6px" @click="toast('Envoyer aux apprenants...')">
                  <IconMailForward :size="14" style="color:var(--blue)" /> Envoyer aux apprenants
                </button>
                <button class="btn btn-ghost-alt btn-sm" style="width:100%;justify-content:flex-start" @click="toast('Feedbacks automatiques...')">
                  <IconMessage :size="14" style="color:var(--blue)" /> Feedbacks automatiques
                </button>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- ══════════ REPORTING ══════════ -->
      <template v-else-if="section === 'reporting'">
        <div class="si">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;flex-wrap:wrap;gap:10px">
            <div style="font-family:var(--fh);font-size:18px;font-weight:800">Reporting Formateur</div>
            <div style="display:flex;gap:8px">
              <select class="sel" style="width:auto">
                <option>Ce trimestre</option>
                <option>Ce mois</option>
                <option>Cette année</option>
              </select>
              <button class="btn btn-primary btn-sm" @click="toast('Rapport PDF généré !')"><IconDownload :size="14" /> Exporter</button>
            </div>
          </div>

          <div class="grid-4 mb-20">
            <div class="kpi">
              <div class="kpi-lbl"><IconUsers :size="13" style="color:var(--blue)" /> Apprenants</div>
              <div class="kpi-val" style="color:var(--blue)">47</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> ↑ 5</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl"><IconChartPie :size="13" style="color:var(--em)" /> Complétion moy.</div>
              <div class="kpi-val" style="color:var(--em)">84%</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> ↑ 6%</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl"><IconStar :size="13" style="color:var(--am)" /> Satisfaction</div>
              <div class="kpi-val" style="color:var(--am)">4.5/5</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> ↑ 0.2</div>
            </div>
            <div class="kpi">
              <div class="kpi-lbl"><IconCertificate :size="13" style="color:var(--pu)" /> Certifications</div>
              <div class="kpi-val" style="color:var(--pu)">18</div>
              <div class="kpi-delta up"><IconTrendingUp :size="11" /> délivrées</div>
            </div>
          </div>

          <div class="grid-2 mb-20">
            <div class="card">
              <div class="ct"><IconChartBar :size="13" style="color:var(--blue)" /> Progression mensuelle</div>
              <div class="bar-chart">
                <div
                  v-for="b in monthlyBars"
                  :key="b.m"
                  class="bar-col"
                  :style="{ background: b.cur ? 'var(--blue)' : 'var(--blue)55', height: b.v + 'px' }"
                  :title="b.v + '%'"
                >
                  <div class="bar-col-val">{{ b.v }}%</div>
                </div>
              </div>
              <div class="bar-labels">
                <div v-for="b in monthlyBars" :key="b.m" class="bar-label-item">{{ b.m }}</div>
              </div>
            </div>

            <div class="card">
              <div class="ct"><IconTrophy :size="13" style="color:var(--am)" /> Top formations par complétion</div>
              <div v-for="f in topFormations" :key="f.name" style="display:flex;align-items:center;gap:10px;margin-bottom:10px">
                <span style="font-size:12px;font-weight:500;flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ f.name }}</span>
                <div class="bar" style="width:80px;margin:0"><div class="bf" :style="{ width: f.pct + '%', background: f.color }"></div></div>
                <span style="font-size:11px;font-weight:700;min-width:30px;text-align:right" :style="{ color: f.color }">{{ f.pct }}%</span>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="ct"><IconDownload :size="13" style="color:var(--em)" /> Générer des rapports</div>
            <div style="display:flex;gap:8px;flex-wrap:wrap">
              <button class="btn btn-sm" @click="toast('Rapport mensuel complet PDF...')"><IconFileDescription :size="14" style="color:var(--blue)" /> Rapport mensuel complet PDF</button>
              <button class="btn btn-sm" @click="toast('Export apprenants CSV...')"><IconTableExport :size="14" style="color:var(--blue)" /> Export apprenants CSV</button>
              <button class="btn btn-sm" @click="toast('Email récap. RH...')"><IconMail :size="14" style="color:var(--blue)" /> Email récap. RH</button>
              <button class="btn btn-sm" @click="toast('Synthèse COMEX...')"><IconPresentation :size="14" style="color:var(--blue)" /> Synthèse COMEX</button>
              <button class="btn btn-sm" @click="toast('Rapport automatique...')"><IconCalendar :size="14" style="color:var(--blue)" /> Rapport automatique</button>
            </div>
</div>
</div>
  </template>
  </div>
  </template>
  </div>
</template>

<style scoped>
.formateur-layout {
  display: flex;
  gap: 20px;
}

.formateur-main {
  flex: 1;
  min-width: 0;
}

.sidebar-profile {
  padding: 16px;
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  margin-bottom: 16px;
  box-shadow: var(--shadow-sm);
}

.sidebar-profile-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.sidebar-av {
  flex-shrink: 0;
}

.sidebar-name {
  font-size: 13px;
  font-weight: 700;
}

.sidebar-role {
  font-size: 11px;
  color: var(--tx2);
}

.sidebar-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 6px;
}

.sidebar-stat {
  text-align: center;
  padding: 8px;
  background: var(--surf2);
  border-radius: var(--rs);
  border: 1px solid var(--bd);
}

.sidebar-stat-val {
  font-family: var(--fh);
  font-size: 16px;
  font-weight: 800;
}

.sidebar-stat-lbl {
  font-size: 10px;
  color: var(--tx2);
}

.sess-week-row {
  display: flex;
  gap: 12px;
  padding: 10px 12px;
  border-radius: var(--rs);
  background: var(--surf2);
  margin-bottom: 8px;
  border-left: 3px solid;
  cursor: pointer;
  transition: all 0.18s;
  align-items: center;
}

.sess-week-row:hover {
  box-shadow: var(--shadow-sm);
}

.sess-week-row:last-of-type {
  margin-bottom: 0;
}

.sess-week-date {
  min-width: 52px;
  font-size: 11px;
  font-weight: 700;
  padding-top: 2px;
}

.sess-week-title {
  font-size: 13px;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.sess-week-sub {
  font-size: 11px;
  color: var(--tx2);
}

.alert-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  border-radius: var(--rs);
  background: var(--co-lt);
  border: 1px solid #FFB3C0;
  margin-bottom: 8px;
}

.alert-row:last-child {
  margin-bottom: 0;
}

.sess-day-badge {
  min-width: 52px;
  text-align: center;
  padding: 8px 4px;
  border-radius: var(--rs);
  border: 1px solid;
  flex-shrink: 0;
}

.sess-day-num {
  font-family: var(--fh);
  font-size: 20px;
  font-weight: 800;
}

.tool-icon-wrap {
  width: 46px;
  height: 46px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  border: 1px solid;
}

.learner-metric {
  padding: 12px;
  background: var(--surf2);
  border-radius: var(--rs);
  border: 1px solid var(--bd);
  text-align: center;
}

.learner-metric-val {
  font-family: var(--fh);
  font-size: 16px;
  font-weight: 800;
}

.learner-metric-lbl {
  font-size: 10px;
  color: var(--tx2);
  margin-top: 2px;
}

.learner-note {
  padding: 12px 14px;
  background: var(--surf2);
  border-radius: var(--rs);
  border-left: 3px solid;
}

.learner-list-card {
  cursor: pointer;
  transition: all 0.2s;
}

.msg-layout {
  height: calc(100vh - 120px);
  display: flex;
  gap: 16px;
}

.msg-threads {
  width: 280px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 0;
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}

.msg-threads-header {
  padding: 14px 16px;
  border-bottom: 1px solid var(--bd);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.msg-threads-list {
  overflow-y: auto;
  flex: 1;
}

.msg-thread-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 12px 14px;
  cursor: pointer;
  border-bottom: 1px solid var(--bd);
  transition: background 0.15s;
}

.msg-thread-preview {
  font-size: 11px;
  color: var(--tx2);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.unread-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--blue);
  flex-shrink: 0;
}

.msg-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}

.msg-panel-header {
  padding: 14px 18px;
  border-bottom: 1px solid var(--bd);
  display: flex;
  align-items: center;
  gap: 12px;
}

.msg-bubbles {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.msg-row {
  display: flex;
  align-items: flex-end;
  gap: 8px;
}

.msg-av-them {
  width: 28px;
  height: 28px;
  font-size: 10px;
  color: #fff;
  margin-bottom: 2px;
  flex-shrink: 0;
}

.msg-time {
  font-size: 10px;
  color: var(--tx3);
  margin-top: 4px;
}

.msg-quick-bar {
  padding: 8px 14px;
  border-top: 1px solid var(--bd);
  display: flex;
  gap: 6px;
  overflow-x: auto;
}

.msg-compose {
  padding: 12px 16px;
  border-top: 1px solid var(--bd);
  display: flex;
  gap: 10px;
  align-items: flex-end;
}

.msg-textarea {
  flex: 1;
  min-height: 44px;
  max-height: 120px;
  resize: none;
}

.bar-chart {
  display: flex;
  align-items: flex-end;
  gap: 6px;
  height: 100px;
  margin-bottom: 8px;
}

.bar-col {
  flex: 1;
  border-radius: 6px 6px 0 0;
  position: relative;
  cursor: pointer;
  transition: opacity 0.18s;
}

.bar-col:hover {
  opacity: 0.8;
}

.bar-col-val {
  position: absolute;
  bottom: calc(100% + 4px);
  left: 50%;
  transform: translateX(-50%);
  font-size: 10px;
  font-weight: 700;
  color: var(--tx2);
}

.bar-labels {
  display: flex;
  gap: 6px;
  font-size: 10px;
  color: var(--tx2);
}

.bar-label-item {
  flex: 1;
  text-align: center;
}

@media (max-width: 900px) {
  .msg-layout {
    flex-direction: column;
    height: auto;
  }
  .msg-threads {
    width: 100%;
    max-height: 200px;
  }
}
@keyframes spin { from { transform: rotate(0deg) } to { transform: rotate(360deg) } }
</style>
