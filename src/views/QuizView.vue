<script setup>
import { inject, ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import {
  IconHelp,
  IconHistory,
  IconChartBar,
  IconPlus,
  IconSparkles,
  IconListCheck,
  IconCheckbox,
  IconCircleCheck,
  IconArrowsSort,
  IconUsers,
  IconWriting,
  IconCheck,
  IconX,
  IconClock,
  IconStar,
  IconRefresh,
  IconPlayerPlay,
  IconArrowLeft,
  IconArrowRight,
  IconArrowUp,
  IconArrowDown,
  IconInfoCircle,
  IconSettings,
  IconDeviceFloppy,
  IconSend,
  IconList,
  IconCertificate,
  IconRosette,
  IconLoader2,
  IconAlertTriangle
} from '@tabler/icons-vue'

const auth = useAuthStore()
const store = useDataStore()
const toast = inject('toast')

const pageLoading = ref(false)
const pageError = ref(null)
const screen = ref('list')
const activeTab = ref('quiz')
const quizId = ref(null)
const step = ref(0)
const answers = ref({})
const revealed = ref(false)
const orderArr = ref(null)

const STATIC_QUIZZES = [
  {
    id: 'q1',
    title: 'Management Agile — Évaluation finale',
    formation: 'Management Agile',
    phase: 'E5 — Évaluer',
    level: 'int',
    threshold: 75,
    chrono: 20,
    attempts: 2,
    tag: 'obligatoire',
    questions: [
      {
        type: 'qcm',
        pts: 2,
        q: "Dans Scrum, qui est responsable de maximiser la valeur du produit livré ?",
        opts: ['Le Scrum Master', 'Le Product Owner', "L'équipe de développement", 'Le Chef de projet'],
        correct: 1,
        expl: "Le Product Owner est garant du Product Backlog et de la valeur livrée à chaque sprint. C'est lui qui priorise les items selon la valeur business."
      },
      {
        type: 'qcmm',
        pts: 3,
        q: 'Quels sont les artefacts officiels définis par le Guide Scrum 2020 ?',
        opts: ['Product Backlog', 'Sprint Backlog', 'Roadmap produit', 'Increment', 'Burndown chart'],
        correct: [0, 1, 3],
        expl: "Scrum 2020 définit exactement 3 artefacts : Product Backlog, Sprint Backlog et Increment. La Roadmap et le Burndown chart ne font pas partie du framework."
      },
      {
        type: 'vf',
        pts: 1,
        q: "Le Daily Scrum doit obligatoirement durer 15 minutes exactement, quelle que soit la taille de l'équipe.",
        opts: ['Vrai', 'Faux'],
        correct: 0,
        expl: "Vrai — le Daily est time-boxé à 15 minutes maximum par la définition officielle Scrum, quel que soit l'effectif de l'équipe."
      },
      {
        type: 'order',
        pts: 3,
        q: "Remettez les étapes d'un sprint dans le bon ordre chronologique.",
        opts: ['Sprint Retrospective', 'Sprint Planning', 'Development Work + Daily Scrums', 'Sprint Review'],
        correct: [1, 2, 3, 0],
        expl: "L'ordre correct est : Sprint Planning → Development Work + Daily Scrums → Sprint Review → Sprint Retrospective."
      },
      {
        type: 'situation',
        pts: 4,
        q: "En fin de sprint, votre équipe n'a pas pu terminer toutes les user stories planifiées. Quelle est la bonne réaction en tant que Product Owner ?",
        opts: [
          'Prolonger le sprint de 2 jours pour tout finir',
          'Annuler le sprint et recommencer la planification',
          "Tenir la Sprint Review avec l'incrément réalisé, puis organiser la Rétrospective",
          'Déplacer toutes les stories non finies dans le prochain sprint sans discussion'
        ],
        correct: 2,
        expl: "La Sprint Review porte sur l'incrément réel livré. La Rétrospective permettra à l'équipe d'analyser pourquoi les stories n'ont pas été terminées et d'améliorer le processus."
      },
      {
        type: 'open',
        pts: 5,
        q: "Décrivez en 5 à 10 lignes comment vous organiseriez la transition vers l'Agilité dans une équipe habituée au cycle en V.",
        opts: [],
        correct: null,
        expl: "Critères évalués : sensibilisation au Manifeste Agile, choix d'un pilote, formation de l'équipe, accompagnement au changement, itérations progressives, métriques de succès."
      },
    ]
  },
  {
    id: 'q2',
    title: 'Leadership situationnel — Quiz intermédiaire',
    formation: 'Leadership & Influence',
    phase: 'E3 — Expliquer',
    level: 'avd',
    threshold: 70,
    chrono: 15,
    attempts: 3,
    tag: '',
    questions: [
      { type:'qcm', pts:2, q:"Selon le modèle de Hersey & Blanchard, quel style convient à un collaborateur à la fois compétent et motivé ?", opts:['Directif','Persuasif','Participatif','Délégatif'], correct:3, expl:"Le style Délégatif (S4) est adapté aux collaborateurs à haute maturité (compétents ET motivés). Le manager délègue la décision tout en restant disponible." },
      { type:'vf', pts:1, q:"Le leadership transformationnel se concentre principalement sur les tâches à accomplir plutôt que sur l'inspiration des équipes.", opts:['Vrai','Faux'], correct:1, expl:"Faux. Le leadership transformationnel se concentre sur la vision, l'inspiration et le développement des personnes. Le leadership transactionnel est davantage axé sur les tâches." },
      { type:'qcmm', pts:3, q:'Quelles sont les caractéristiques d\'un feedback constructif efficace ?', opts:['Spécifique et factuel','Centré sur la personne','Orienté comportement','Donné en public pour l\'effet','Proposer des pistes d\'amélioration'], correct:[0,2,4], expl:"Un feedback efficace est : spécifique (basé sur des faits), centré sur le comportement (pas la personnalité) et constructif (propose des pistes d'amélioration). Il se donne en privé." },
      { type:'situation', pts:4, q:"Thomas, 3 ans d'ancienneté, vient vous voir démoralisé : son projet a été rejeté en CODIR. Il remet en question ses compétences. Quel est votre premier réflexe ?", opts:['Minimiser et passer à la suite','Analyser immédiatement les erreurs du projet','Écouter activement, reconnaître l\'émotion, puis analyser ensemble','Lui rappeler qu\'il a d\'autres réussites'], correct:2, expl:"L'écoute active et la reconnaissance émotionnelle sont les premiers leviers. Analyser les erreurs avant d'accueillir l'émotion serait contre-productif et briserait la confiance." },
    ]
  },
  {
    id: 'q3',
    title: 'Cybersécurité — Bonnes pratiques en entreprise',
    formation: 'Cybersécurité',
    phase: 'E3 — Expliquer',
    level: 'deb',
    threshold: 80,
    chrono: 10,
    attempts: 2,
    tag: 'new',
    questions: [
      { type:'qcm', pts:2, q:"Qu'est-ce qu'une attaque de type phishing ?", opts:['Un logiciel espion installé sur votre PC','Un email frauduleux imitant un expéditeur de confiance pour voler vos identifiants','Une attaque sur les serveurs de l\'entreprise','Un virus qui chiffre vos fichiers'], correct:1, expl:"Le phishing (hameçonnage) utilise des emails ou sites frauduleux imitant des entités de confiance pour dérober des identifiants ou informations sensibles." },
      { type:'vf', pts:1, q:"Utiliser le même mot de passe fort pour plusieurs services professionnels est acceptable si ce mot de passe est suffisamment complexe.", opts:['Vrai','Faux'], correct:1, expl:"Faux. Même fort, un mot de passe réutilisé crée un point de défaillance unique. Si un service est compromis, tous vos comptes le sont. Utilisez un gestionnaire de mots de passe." },
      { type:'qcmm', pts:3, q:'Quelles actions réduisent efficacement les risques de sécurité informatique au bureau ?', opts:['Verrouiller son PC en quittant son poste','Partager ses accès à un collègue de confiance','Utiliser un VPN sur les réseaux Wi-Fi publics','Cliquer rapidement sur les liens pour gagner du temps','Activer l\'authentification à deux facteurs'], correct:[0,2,4], expl:"Verrouiller son poste, utiliser un VPN et activer le 2FA sont des pratiques essentielles. Partager ses accès et cliquer sans vérifier sont des risques majeurs." },
    ]
  },
]

const QUIZZES = computed(() => {
  if (store.quizzes.length) {
    return store.quizzes.map(q => ({
      ...q,
      questions: q.quiz_questions || q.questions || [],
    }))
  }
  return STATIC_QUIZZES
})

const Q_TYPES = {
  qcm: { label:'QCM', icon:IconListCheck, bg:'#EEF4FF', tc:'#1A4AAA', bc:'#C5D9FF' },
  qcmm: { label:'QCM Multiple', icon:IconCheckbox, bg:'#F0EFFE', tc:'#3C3480', bc:'#C8C4F5' },
  vf: { label:'Vrai / Faux', icon:IconCircleCheck, bg:'#E0F9F3', tc:'#005A42', bc:'#A8EDD8' },
  order: { label:'Mise en ordre', icon:IconArrowsSort, bg:'#FFF4E0', tc:'#6B3B00', bc:'#FFD280' },
  situation: { label:'Mise en situation', icon:IconUsers, bg:'#F5F5F0', tc:'#444440', bc:'#CCCCC0' },
  open: { label:'Question ouverte', icon:IconWriting, bg:'#FFF3FB', tc:'#6B0050', bc:'#F5B3E8' },
}

const Q_TYPE_DESCS = {
  qcm: 'Choix unique',
  qcmm: 'Plusieurs bonnes réponses',
  vf: 'Vrai ou Faux',
  order: 'Réordonner les étapes',
  situation: 'Scénario professionnel',
  open: 'Réponse libre',
}

const STATIC_HISTORY = [
  { quizId:'q1', date:'14 mai 2025', score:14, total:18, pct:78, passed:true, time:'17 min' },
  { quizId:'q2', date:'10 mai 2025', score:13, total:10, pct:72, passed:true, time:'12 min' },
  { quizId:'q3', date:'8 mai 2025', score:6, total:6, pct:53, passed:false, time:'9 min' },
  { quizId:'q2', date:'5 mai 2025', score:7, total:10, pct:66, passed:false, time:'14 min' },
]

const HISTORY = computed(() => {
  if (store.quizAttempts.length) {
    return store.quizAttempts.map(a => ({
      quizId: a.quiz_id,
      date: new Date(a.created_at).toLocaleDateString('fr-FR', { day: 'numeric', month: 'short', year: 'numeric' }),
      score: a.score || 0,
      total: a.total || 0,
      pct: a.pct || 0,
      passed: a.pct >= 75,
      time: a.time || '—',
    }))
  }
  return STATIC_HISTORY
})

const LVL_LBL = { deb:'Débutant', int:'Intermédiaire', avd:'Avancé' }
const LVL_CLS = { deb:'pill-green', int:'pill-amber', avd:'pill-purple' }

const CREATOR_TYPES = [
  { key:'qcm', label:'QCM', icon:IconListCheck, bg:'#EEF4FF', tc:'#1A4AAA', bc:'#C5D9FF', desc:'Choix unique parmi plusieurs réponses' },
  { key:'qcmm', label:'QCM Multiple', icon:IconCheckbox, bg:'#F0EFFE', tc:'#3C3480', bc:'#C8C4F5', desc:'Plusieurs bonnes réponses possibles' },
  { key:'vf', label:'Vrai / Faux', icon:IconCircleCheck, bg:'#E0F9F3', tc:'#005A42', bc:'#A8EDD8', desc:'Affirmation à valider ou réfuter' },
  { key:'order', label:'Mise en ordre', icon:IconArrowsSort, bg:'#FFF4E0', tc:'#6B3B00', bc:'#FFD280', desc:"Remettre des éléments dans l'ordre" },
  { key:'situation', label:'Mise en situation', icon:IconUsers, bg:'#F5F5F0', tc:'#444440', bc:'#CCCCC0', desc:'Scénario professionnel avec choix' },
  { key:'open', label:'Question ouverte', icon:IconWriting, bg:'#FFF3FB', tc:'#6B0050', bc:'#F5B3E8', desc:'Réponse libre évaluée par formateur' },
]

const ANALYTICS_DATA = [
  { label:'Quiz réussis', val:2, total:4, col:'var(--em)' },
  { label:'Taux de réussite moyen', val:67, total:100, col:'var(--blue)', unit:'%' },
  { label:'Questions correctes', val:74, total:100, col:'var(--am)', unit:'%' },
  { label:'Certifications obtenues', val:1, total:3, col:'var(--pu)' },
]

const PER_TYPE = [
  { type:'QCM', pct:85, tc:'#1A4AAA' },
  { type:'QCM Multiple', pct:68, tc:'#3C3480' },
  { type:'Vrai / Faux', pct:90, tc:'#005A42' },
  { type:'Mise en ordre', pct:55, tc:'#6B3B00' },
  { type:'Mise en situation', pct:72, tc:'#444440' },
  { type:'Question ouverte', pct:60, tc:'#6B0050' },
]

const TAG_STYLE = {
  obligatoire: { bg:'var(--co)', lbl:'Obligatoire' },
  new: { bg:'var(--blue)', lbl:'Nouveau' },
}

const currentQuiz = computed(() => QUIZZES.find(q => q.id === quizId.value))
const currentQuestion = computed(() => currentQuiz.value?.questions[step.value])
const currentQt = computed(() => Q_TYPES[currentQuestion.value?.type] || Q_TYPES.qcm)
const progressPct = computed(() => {
  if (!currentQuiz.value) return 0
  const total = currentQuiz.value.questions.length
  return Math.round(((step.value + (revealed.value ? 1 : 0)) / total) * 100)
})
const answeredCount = computed(() => Object.keys(answers.value).length)
const hasAnswer = computed(() => {
  const q = currentQuestion.value
  if (!q) return false
  const ans = answers.value[step.value]
  if (q.type === 'open') return typeof ans === 'string' && ans.trim().length > 0
  if (q.type === 'qcmm') return Array.isArray(ans) && ans.length > 0
  if (q.type === 'order') return true
  return ans !== undefined && ans !== null
})

const resultData = computed(() => {
  if (!currentQuiz.value) return { score:0, total:0, pct:0 }
  const quiz = currentQuiz.value
  let score = 0, total = 0
  quiz.questions.forEach((q, i) => {
    total += q.pts
    if (q.type === 'open') return
    const ans = answers.value[i]
    let ok = false
    if (q.type === 'qcmm') ok = Array.isArray(ans) && ans.length === q.correct.length && q.correct.every(c => ans.includes(c))
    else if (q.type === 'order') ok = Array.isArray(ans) && JSON.stringify(ans) === JSON.stringify(q.correct)
    else ok = ans === q.correct
    if (ok) score += q.pts
  })
  return { score, total, pct: total > 0 ? Math.round(score / total * 100) : 0 }
})

const resultPassed = computed(() => resultData.value.pct >= (currentQuiz.value?.threshold || 0))
const correctCount = computed(() => {
  if (!currentQuiz.value) return 0
  return currentQuiz.value.questions.filter((q, i) => isAnswerCorrect(q, answers.value[i]) === true).length
})

function scColor(v) { return v >= 75 ? 'var(--em)' : v >= 50 ? 'var(--am)' : 'var(--co)' }
function scColorHex(v) { return v >= 75 ? '#00D4A1' : v >= 50 ? '#FF9B21' : '#FF4D6A' }

function isAnswerCorrect(q, ans) {
  if (q.type === 'open') return null
  if (q.type === 'qcmm') return Array.isArray(ans) && ans.length === q.correct.length && q.correct.every(c => ans.includes(c))
  if (q.type === 'order') return Array.isArray(ans) && JSON.stringify(ans) === JSON.stringify(q.correct)
  return ans === q.correct
}

function startQuiz(id) {
  screen.value = 'quiz'
  quizId.value = id
  step.value = 0
  answers.value = {}
  revealed.value = false
  orderArr.value = null
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function goToList() {
  screen.value = 'list'
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function selectAns(oi) {
  answers.value[step.value] = oi
}

function toggleMulti(oi) {
  if (!Array.isArray(answers.value[step.value])) answers.value[step.value] = []
  const arr = answers.value[step.value]
  const idx = arr.indexOf(oi)
  if (idx === -1) arr.push(oi)
  else arr.splice(idx, 1)
}

function moveOrder(pos, dir) {
  const arr = [...(orderArr.value || [])]
  const npos = pos + dir
  if (npos < 0 || npos >= arr.length) return
  ;[arr[pos], arr[npos]] = [arr[npos], arr[pos]]
  orderArr.value = arr
  answers.value[step.value] = arr
}

function submitStep() {
  if (orderArr.value) answers.value[step.value] = [...orderArr.value]
  revealed.value = true
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function nextStep() {
  revealed.value = false
  orderArr.value = null
  step.value++
  if (step.value >= currentQuiz.value.questions.length) screen.value = 'results'
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function prevStep() {
  if (step.value > 0) {
    step.value--
    revealed.value = false
    orderArr.value = null
  }
}

function openCreator() {
  screen.value = 'creator'
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function scoreRingDash(pct, r) {
  const circ = 2 * Math.PI * r
  return { circ, offset: circ * (1 - pct / 100) }
}

function optClassForState(oi, q, ans) {
  if (!revealed.value) {
    if (q.type === 'qcmm') {
      return Array.isArray(ans) && ans.includes(oi) ? 'selected' : ''
    }
    return ans === oi ? 'selected' : ''
  }
  const isRight = q.type === 'qcmm' ? q.correct.includes(oi) : q.correct === oi
  if (q.type === 'qcmm') {
    const sel = Array.isArray(ans) && ans.includes(oi)
    if (isRight) return 'correct-hl'
    if (sel) return 'wrong'
    return ''
  }
  if (isRight) return 'correct-hl'
  if (ans === oi) return 'wrong'
  return ''
}

function circleContent(oi, q, ans) {
  if (!revealed.value) {
    if (q.type === 'qcmm') return ''
    return ans === oi ? '●' : (oi + 1)
  }
  const isRight = q.type === 'qcmm' ? q.correct.includes(oi) : q.correct === oi
  const sel = q.type === 'qcmm' ? (Array.isArray(ans) && ans.includes(oi)) : ans === oi
  if (isRight) return '✓'
  if (sel && !isRight) return '✗'
  return q.type === 'qcmm' ? '' : (oi + 1)
}

function quitQuiz() {
  if (confirm('Quitter le quiz ?')) goToList()
}

function showExpl(i) {
  const q = currentQuiz.value.questions[i]
  toast(q.expl.slice(0, 80) + (q.expl.length > 80 ? '…' : ''))
}

function initOrderArr() {
  if (currentQuestion.value?.type === 'order' && !orderArr.value) {
    orderArr.value = currentQuestion.value.opts.map((_, i) => i)
  }
}

const openText = computed({
  get() { return typeof answers.value[step.value] === 'string' ? answers.value[step.value] : '' },
  set(v) { answers.value[step.value] = v }
})

onMounted(async () => {
  pageLoading.value = true
  pageError.value = null
  try {
    if (!auth.profile?.id) return
    await Promise.all([
      store.fetchQuizzes(),
      store.fetchQuizAttempts(auth.profile.id),
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
<!-- ════════════════ LIST SCREEN ════════════════ -->
    <div v-if="screen === 'list'" class="fade-in">
      <div class="hero">
        <div class="hero-left">
          <div class="hero-tag">Évaluations & Quiz</div>
          <div class="hero-title">Validez vos acquis et progressez</div>
          <div class="hero-sub">6 types de questions · Scoring automatique · Certification à la clé</div>
        </div>
        <div class="hero-stats">
          <div v-for="s in ([
            { v:'3', l:'Quiz disponibles' },
            { v:'2', l:'Réussis' },
            { v:'78%', l:'Meilleur score' },
          ])" :key="s.l" class="hstat">
            <div class="hstat-val">{{ s.v }}</div>
            <div class="hstat-lbl">{{ s.l }}</div>
          </div>
        </div>
      </div>

      <div class="tabs-row">
        <button class="tab-btn" :class="{ active: activeTab === 'quiz' }" @click="activeTab = 'quiz'">
          <IconHelp :size="14" /> Mes quiz ({{ QUIZZES.length }})
        </button>
        <button class="tab-btn" :class="{ active: activeTab === 'history' }" @click="activeTab = 'history'">
          <IconHistory :size="14" /> Historique ({{ HISTORY.length }})
        </button>
        <button class="tab-btn" :class="{ active: activeTab === 'analytics' }" @click="activeTab = 'analytics'">
          <IconChartBar :size="14" /> Analytics
        </button>
      </div>

      <!-- TAB: Quiz -->
      <template v-if="activeTab === 'quiz'">
        <div style="display:flex;justify-content:flex-end;margin-bottom:14px">
          <button class="btn btn-sm btn-primary" @click="openCreator">
            <IconPlus :size="14" /> Créer un quiz
          </button>
        </div>

        <div class="card" style="margin-bottom:20px">
          <div class="card-title"><IconSparkles :size="14" style="color:var(--blue)" />6 types de questions disponibles</div>
          <div class="grid-3" style="gap:10px">
            <div v-for="(qt, qkey) in Q_TYPES" :key="qkey" style="display:flex;align-items:center;gap:10px;padding:12px;border-radius:var(--rs);border:1px solid v-bind(qt.bc);background:v-bind(qt.bg)">
              <div style="width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0" :style="{ background: qt.tc + '18' }">
                <component :is="qt.icon" :size="16" :style="{ color: qt.tc }" />
              </div>
              <div>
                <div style="font-size:12px;font-weight:700" :style="{ color: qt.tc }">{{ qt.label }}</div>
                <div style="font-size:10px;color:var(--tx2)">{{ Q_TYPE_DESCS[qkey] }}</div>
              </div>
            </div>
          </div>
        </div>

        <div style="display:flex;flex-direction:column;gap:14px">
          <div v-for="quiz in QUIZZES" :key="quiz.id" class="quiz-card" @click="startQuiz(quiz.id)">
            <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px;flex-wrap:wrap;margin-bottom:14px">
              <div style="flex:1;min-width:0">
                <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:6px">
                  <div style="font-family:var(--fh);font-size:16px;font-weight:700">{{ quiz.title }}</div>
                  <span v-if="TAG_STYLE[quiz.tag]" style="font-size:9px;font-weight:700;padding:2px 8px;border-radius:10px;color:#fff" :style="{ background: TAG_STYLE[quiz.tag].bg }">{{ TAG_STYLE[quiz.tag].lbl }}</span>
                  <span v-if="HISTORY.find(h => h.quizId === quiz.id && h.passed)" class="pill pill-green">
                    <IconCheck :size="10" />Réussi
                  </span>
                </div>
                <div style="display:flex;gap:8px;flex-wrap:wrap;align-items:center">
                  <span class="pill" :class="LVL_CLS[quiz.level]">{{ LVL_LBL[quiz.level] }}</span>
                  <span class="pill pill-gray"><IconHelp :size="10" />{{ quiz.questions.length }} questions</span>
                  <span class="pill pill-gray"><IconStar :size="10" />{{ quiz.questions.reduce((s,q) => s+q.pts, 0) }} pts</span>
                  <span class="pill pill-gray"><IconClock :size="10" />{{ quiz.chrono }} min</span>
                  <span class="pill pill-gray">Seuil : {{ quiz.threshold }}%</span>
                  <span class="pill pill-gray"><IconRefresh :size="10" />{{ quiz.attempts }} tentatives</span>
                </div>
              </div>
      <template v-if="HISTORY.find(h => h.quizId === quiz.id)">
        <div v-for="h in [HISTORY.find(h2 => h2.quizId === quiz.id)]" :key="'ring-'+quiz.id" style="position:relative;width:64px;height:64px;flex-shrink:0">
                  <svg width="64" height="64" viewBox="0 0 64 64" style="transform:rotate(-90deg)">
                    <circle cx="32" cy="32" r="26" fill="none" stroke="var(--surf2)" stroke-width="6" />
                    <circle cx="32" cy="32" r="26" fill="none" :stroke="scColorHex(h.pct)" stroke-width="6" :stroke-dasharray="2*Math.PI*26" :stroke-dashoffset="2*Math.PI*26*(1-h.pct/100)" stroke-linecap="round" />
                  </svg>
                  <div style="position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;font-family:var(--fh)">
                    <div style="font-size:13px;font-weight:800" :style="{ color: scColor(h.pct) }">{{ h.pct }}%</div>
 </div>
</div>
</template>
<template v-else><div style="width:64px;height:64px;border-radius:50%;background:var(--surf2);border:2px dashed var(--bd);display:flex;align-items:center;justify-content:center;flex-shrink:0;color:var(--tx3);font-size:11px;text-align:center;line-height:1.3">Non<br>fait</div></template>
</div>
            <div style="display:flex;gap:6px;flex-wrap:wrap;margin-bottom:14px">
              <span v-for="t in [...new Set(quiz.questions.map(q=>q.type))]" :key="t" class="type-badge" :style="{ background: Q_TYPES[t].bg, color: Q_TYPES[t].tc, border: '1px solid ' + Q_TYPES[t].bc }">
                <component :is="Q_TYPES[t].icon" :size="10" /> {{ Q_TYPES[t].label }}
              </span>
            </div>
            <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px">
              <div style="font-size:12px;color:var(--tx2)">
                <IconPlayerPlay :size="12" style="color:var(--blue)" />
                {{ quiz.formation }} · {{ quiz.phase }}
              </div>
              <button class="btn btn-primary btn-sm" @click.stop="startQuiz(quiz.id)">
                <IconPlayerPlay :size="14" />
                {{ HISTORY.find(h => h.quizId === quiz.id) ? 'Repasser le quiz' : 'Démarrer le quiz' }}
              </button>
            </div>
          </div>
        </div>
      </template>

      <!-- TAB: History -->
      <template v-if="activeTab === 'history'">
        <div style="display:flex;flex-direction:column;gap:10px">
          <div v-for="(h, i) in HISTORY" :key="i" class="hist-row" @click="toast('Détail de la tentative du ' + h.date)">
            <div style="width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;flex-shrink:0" :style="{ background: h.passed ? 'var(--em-lt)' : 'var(--co-lt)', border: '1px solid ' + (h.passed ? '#A8EDD8' : '#FFB3C0') }">
              <IconRosette v-if="h.passed" :size="20" style="color:var(--em)" />
              <IconRefresh v-else :size="20" style="color:var(--co)" />
            </div>
            <div style="flex:1;min-width:0">
              <div style="font-size:13px;font-weight:600;margin-bottom:3px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ QUIZZES.find(q => q.id === h.quizId)?.title || 'Quiz' }}</div>
              <div style="font-size:11px;color:var(--tx2)">{{ h.date }} · {{ h.time }} · {{ h.score }}/{{ h.total }} pts</div>
            </div>
            <div style="text-align:right;flex-shrink:0">
              <div style="font-family:var(--fh);font-size:18px;font-weight:800" :style="{ color: scColor(h.pct) }">{{ h.pct }}%</div>
              <span class="pill" :class="h.passed ? 'pill-green' : 'pill-coral'" style="font-size:9px">{{ h.passed ? 'Réussi' : 'Insuffisant' }}</span>
            </div>
          </div>
        </div>
      </template>

      <!-- TAB: Analytics -->
      <template v-if="activeTab === 'analytics'">
        <div class="grid-2" style="margin-bottom:18px">
          <div v-for="d in ANALYTICS_DATA" :key="d.label" class="card">
            <div style="font-size:12px;color:var(--tx2);margin-bottom:6px">{{ d.label }}</div>
            <div style="font-family:var(--fh);font-size:26px;font-weight:800;margin-bottom:8px" :style="{ color: d.col }">
              {{ d.val }}{{ d.unit || '' }}
              <span style="font-size:14px;color:var(--tx3);font-weight:400">/ {{ d.total }}{{ d.unit || '' }}</span>
            </div>
            <div class="bar"><div class="bf" :style="{ width: Math.round(d.val/d.total*100) + '%', background: d.col }"></div></div>
          </div>
        </div>
        <div class="card">
          <div class="card-title"><IconChartBar :size="14" style="color:var(--blue)" />Taux de réussite par type de question</div>
          <div v-for="t in PER_TYPE" :key="t.type" style="display:flex;align-items:center;gap:12px;margin-bottom:12px">
            <div style="width:110px;font-size:12px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;flex-shrink:0">{{ t.type }}</div>
            <div class="bar" style="flex:1"><div class="bf" :style="{ width: t.pct + '%', background: t.tc }"></div></div>
            <div style="font-size:12px;font-weight:700;min-width:36px;text-align:right" :style="{ color: t.tc }">{{ t.pct }}%</div>
          </div>
        </div>
      </template>
    </div>

    <!-- ════════════════ QUIZ SCREEN ════════════════ -->
    <div v-else-if="screen === 'quiz' && currentQuiz && currentQuestion" class="fade-in" style="max-width:780px;margin:0 auto" :key="step">
      {{ void initOrderArr() }}
      <div class="card" style="margin-bottom:16px">
        <div style="display:flex;align-items:center;justify-content:space-between;gap:12px;margin-bottom:10px;flex-wrap:wrap">
          <div>
            <div style="font-size:13px;font-weight:600;margin-bottom:4px">{{ currentQuiz.title }}</div>
            <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
              <span class="pill" :class="LVL_CLS[currentQuiz.level]">{{ LVL_LBL[currentQuiz.level] }}</span>
              <span class="pill pill-gray"><IconClock :size="10" />{{ currentQuiz.chrono }} min</span>
              <span class="type-badge" :style="{ background: currentQt.bg, color: currentQt.tc, border: '1px solid ' + currentQt.bc }">
                <component :is="currentQt.icon" :size="10" /> {{ currentQt.label }}
              </span>
              <span class="pill pill-gray">Seuil : {{ currentQuiz.threshold }}%</span>
            </div>
          </div>
          <div style="text-align:right">
            <div style="font-family:var(--fh);font-size:20px;font-weight:800">Q{{ step + 1 }}<span style="font-size:13px;color:var(--tx2);font-weight:400"> / {{ currentQuiz.questions.length }}</span></div>
            <div style="font-size:11px;color:var(--tx2)">{{ currentQuestion.pts }} point{{ currentQuestion.pts > 1 ? 's' : '' }}</div>
          </div>
        </div>
        <div class="quiz-progress">
          <div class="quiz-progress-fill" :style="{ width: progressPct + '%' }"></div>
        </div>
        <div style="font-size:11px;color:var(--tx2);margin-top:4px">{{ answeredCount }} / {{ currentQuiz.questions.length }} répondues</div>
      </div>

      <div class="card slide-in" style="margin-bottom:16px">
        <div style="font-size:15px;font-weight:600;line-height:1.6;margin-bottom:20px;padding-bottom:14px;border-bottom:1px solid var(--bd)">{{ currentQuestion.q }}</div>

        <!-- QCM / Situation -->
        <template v-if="currentQuestion.type === 'qcm' || currentQuestion.type === 'situation'">
          <div
            v-for="(opt, oi) in currentQuestion.opts" :key="oi"
            class="q-opt"
            :class="[optClassForState(oi, currentQuestion, answers[step]), { disabled: revealed }]"
            @click="!revealed && selectAns(oi)"
          >
            <div class="q-circle">{{ circleContent(oi, currentQuestion, answers[step]) }}</div>
            <span style="flex:1">{{ opt }}</span>
            <IconCheck v-if="revealed && (currentQuestion.type === 'qcmm' ? currentQuestion.correct.includes(oi) : currentQuestion.correct === oi)" :size="14" style="color:var(--em)" />
          </div>
        </template>

        <!-- Vrai / Faux -->
        <template v-else-if="currentQuestion.type === 'vf'">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
            <div
              v-for="(opt, oi) in currentQuestion.opts" :key="oi"
              class="q-opt"
              :class="[optClassForState(oi, currentQuestion, answers[step]), { disabled: revealed }]"
              style="justify-content:center;flex-direction:column;padding:20px;text-align:center;gap:8px"
              @click="!revealed && selectAns(oi)"
            >
              <IconCheck v-if="oi === 0" :size="28" />
              <IconX v-else :size="28" />
              <span style="font-size:14px;font-weight:700">{{ opt }}</span>
            </div>
          </div>
        </template>

        <!-- QCM Multiple -->
        <template v-else-if="currentQuestion.type === 'qcmm'">
          <div style="font-size:12px;color:var(--tx2);background:var(--surf2);padding:8px 12px;border-radius:var(--rs);margin-bottom:12px;display:flex;align-items:center;gap:6px">
            <IconInfoCircle :size="14" style="color:var(--blue)" />Plusieurs bonnes réponses — cochez toutes celles qui s'appliquent
          </div>
          <div
            v-for="(opt, oi) in currentQuestion.opts" :key="oi"
            class="q-opt"
            :class="[optClassForState(oi, currentQuestion, answers[step]), { disabled: revealed }]"
            @click="!revealed && toggleMulti(oi)"
          >
            <div class="q-checkbox">
              <IconCheck v-if="Array.isArray(answers[step]) && answers[step].includes(oi)" :size="11" color="#fff" />
            </div>
            <span style="flex:1">{{ opt }}</span>
            <IconCheck v-if="revealed && currentQuestion.correct.includes(oi)" :size="14" style="color:var(--em)" />
          </div>
        </template>

        <!-- Order -->
        <template v-else-if="currentQuestion.type === 'order'">
          <div style="font-size:12px;color:var(--tx2);background:var(--surf2);padding:8px 12px;border-radius:var(--rs);margin-bottom:12px;display:flex;align-items:center;gap:6px">
            <IconArrowsSort :size="14" style="color:var(--am)" />Utilisez les boutons ↑ ↓ pour remettre dans le bon ordre
          </div>
          <div
            v-for="(origIdx, pos) in (orderArr || [])" :key="pos"
            style="display:flex;align-items:center;gap:10px;padding:12px 14px;border-radius:var(--rs);margin-bottom:8px;transition:all .18s"
            :style="{
              border: '1.5px solid ' + (revealed ? ((answers[step]||orderArr)[pos] === currentQuestion.correct[pos] ? 'var(--em)' : 'var(--co)') : 'var(--bd)'),
              background: revealed ? ((answers[step]||orderArr)[pos] === currentQuestion.correct[pos] ? 'var(--em-lt)' : 'var(--co-lt)') : 'var(--surf)'
            }"
          >
            <span style="font-family:var(--fh);font-size:13px;font-weight:800;color:var(--tx2);min-width:24px">{{ pos + 1 }}.</span>
            <span style="flex:1;font-size:13px">{{ currentQuestion.opts[origIdx] }}</span>
            <template v-if="!revealed">
              <div style="display:flex;gap:4px">
                <button class="btn btn-xs" :disabled="pos === 0" :style="{ opacity: pos === 0 ? 0.3 : 1 }" @click="moveOrder(pos, -1)"><IconArrowUp :size="11" /></button>
                <button class="btn btn-xs" :disabled="pos === (orderArr || []).length - 1" :style="{ opacity: pos === (orderArr || []).length - 1 ? 0.3 : 1 }" @click="moveOrder(pos, 1)"><IconArrowDown :size="11" /></button>
              </div>
            </template>
            <template v-else>
              <IconCheck v-if="(answers[step]||orderArr)[pos] === currentQuestion.correct[pos]" :size="14" style="color:var(--em)" />
              <IconX v-else :size="14" style="color:var(--co)" />
            </template>
          </div>
        </template>

        <!-- Open -->
        <template v-else-if="currentQuestion.type === 'open'">
          <div style="font-size:12px;color:var(--tx2);background:var(--surf2);padding:8px 12px;border-radius:var(--rs);margin-bottom:12px;display:flex;align-items:center;gap:6px">
            <IconWriting :size="14" style="color:var(--pu)" />Réponse libre — évaluée par le formateur après la session
          </div>
          <textarea class="ta" style="height:110px" placeholder="Rédigez votre réponse ici..." v-model="openText"></textarea>
        </template>

        <!-- Explanation -->
        <div v-if="revealed" style="margin-top:16px;padding:14px 16px;border-radius:var(--rs)" :style="{
          background: currentQuestion.type === 'open' ? 'var(--surf2)' : isAnswerCorrect(currentQuestion, answers[step]) === true ? 'var(--em-lt)' : 'var(--co-lt)',
          border: '1px solid ' + (currentQuestion.type === 'open' ? 'var(--bd)' : isAnswerCorrect(currentQuestion, answers[step]) === true ? '#A8EDD8' : '#FFB3C0')
        }">
          <div style="display:flex;align-items:center;gap:8px;margin-bottom:6px">
            <template v-if="currentQuestion.type === 'open'">
              <IconClock :size="16" style="color:var(--blue)" />
              <span style="font-size:13px;font-weight:700;color:var(--blue)">Réponse enregistrée — évaluation formateur en attente</span>
            </template>
            <template v-else-if="isAnswerCorrect(currentQuestion, answers[step]) === true">
              <IconCheck :size="16" style="color:var(--em)" />
              <span style="font-size:13px;font-weight:700;color:var(--em)">Bonne réponse !</span>
            </template>
            <template v-else>
              <IconX :size="16" style="color:var(--co)" />
              <span style="font-size:13px;font-weight:700;color:var(--co)">Mauvaise réponse</span>
            </template>
            <span v-if="currentQuestion.type !== 'open'" class="pill" style="margin-left:auto" :style="{ background: isAnswerCorrect(currentQuestion, answers[step]) ? 'var(--em)' : 'var(--co)', color: '#fff' }">{{ isAnswerCorrect(currentQuestion, answers[step]) ? '+' + currentQuestion.pts + ' pts' : '0 pt' }}</span>
          </div>
          <div style="font-size:13px;color:var(--tx2);line-height:1.65">{{ currentQuestion.expl }}</div>
        </div>
      </div>

      <!-- Navigation -->
      <div style="display:flex;justify-content:space-between;align-items:center;gap:12px">
        <button class="btn btn-sm" :disabled="step === 0" @click="prevStep">
          <IconArrowLeft :size="14" /> Précédente
        </button>
        <button class="btn btn-sm btn-ghost-alt" @click="quitQuiz">
          <IconX :size="14" /> Quitter
        </button>
        <template v-if="!revealed">
          <button class="btn btn-primary btn-sm" :disabled="!hasAnswer" @click="submitStep">
            Valider <IconCheck :size="14" />
          </button>
        </template>
        <template v-else>
          <button class="btn btn-primary btn-sm" @click="nextStep">
            <template v-if="step < currentQuiz.questions.length - 1">Suivante <IconArrowRight :size="14" /></template>
            <template v-else>Voir les résultats <IconArrowRight :size="14" /></template>
          </button>
        </template>
      </div>
    </div>

    <!-- ════════════════ RESULTS SCREEN ════════════════ -->
    <div v-else-if="screen === 'results' && currentQuiz" class="fade-in" style="max-width:760px;margin:0 auto">
      <div class="card" style="text-align:center;padding:36px 28px;margin-bottom:18px" :style="{ border: '1px solid ' + (resultPassed ? 'var(--em)' : 'var(--co)') }">
        <div style="position:relative;width:130px;height:130px;margin:0 auto 20px">
          <svg width="130" height="130" viewBox="0 0 130 130" style="transform:rotate(-90deg)">
            <circle cx="65" cy="65" r="52" fill="none" stroke="var(--surf2)" stroke-width="10" />
            <circle cx="65" cy="65" r="52" fill="none" :stroke="scColorHex(resultData.pct)" stroke-width="10" :stroke-dasharray="scoreRingDash(resultData.pct, 52).circ" :stroke-dashoffset="scoreRingDash(resultData.pct, 52).offset" stroke-linecap="round" style="transition:stroke-dashoffset .8s ease" />
          </svg>
          <div style="position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;font-family:var(--fh)">
            <div style="font-size:26px;font-weight:800" :style="{ color: scColor(resultData.pct) }">{{ resultData.pct }}%</div>
            <div style="font-size:11px;color:var(--tx2)">{{ resultData.score }}/{{ resultData.total }} pts</div>
          </div>
        </div>
        <div style="font-family:var(--fh);font-size:22px;font-weight:800;margin-bottom:6px" :style="{ color: resultPassed ? 'var(--em)' : 'var(--co)' }">
          {{ resultPassed ? '🎉 Quiz réussi !' : '😕 Score insuffisant' }}
        </div>
        <div style="font-size:13px;color:var(--tx2);margin-bottom:20px">
          <template v-if="resultPassed">Félicitations ! Vous avez dépassé le seuil de {{ currentQuiz.threshold }}%. Compétences validées.</template>
          <template v-else>Le seuil requis est de {{ currentQuiz.threshold }}%. Révisez les points faibles et repassez le quiz.</template>
        </div>

        <div style="display:flex;gap:10px;justify-content:center;flex-wrap:wrap;margin-bottom:22px">
          <div v-for="stat in ([
            { l:'Score', v: resultData.pct + '%', c: scColor(resultData.pct) },
            { l:'Points', v: resultData.score + ' / ' + resultData.total, c:'var(--blue)' },
            { l:'Correct', v: correctCount + ' / ' + currentQuiz.questions.length, c:'var(--em)' },
            { l:'Seuil', v: currentQuiz.threshold + '%', c:'var(--am)' },
          ])" :key="stat.l" style="padding:12px 18px;background:var(--surf2);border-radius:12px;border:1px solid var(--bd);min-width:90px">
            <div style="font-family:var(--fh);font-size:17px;font-weight:800" :style="{ color: stat.c }">{{ stat.v }}</div>
            <div style="font-size:10px;color:var(--tx2);margin-top:2px">{{ stat.l }}</div>
          </div>
        </div>

        <div style="display:flex;gap:10px;justify-content:center;flex-wrap:wrap">
          <button v-if="!resultPassed" class="btn btn-primary" @click="startQuiz(currentQuiz.id)"><IconRefresh :size="14" /> Repasser le quiz</button>
          <button v-if="resultPassed" class="btn btn-success" @click="async () => { const formationId = store.formations[0]?.id; if (formationId) { const res = await store.requestCertification(auth.profile.id, formationId); if (res.error) toast('Erreur : ' + res.error.message, 'err'); else toast('Certification générée et ajoutée à votre profil !') } else { toast('Certification générée et ajoutée à votre profil !') } }"><IconCertificate :size="14" /> Obtenir ma certification</button>
          <button class="btn" @click="goToList"><IconList :size="14" /> Mes quiz</button>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><IconList :size="14" style="color:var(--blue)" />Détail par question</div>
        <div
          v-for="(q, i) in currentQuiz.questions" :key="i"
          style="display:flex;align-items:center;gap:12px;padding:11px 12px;border-radius:var(--rs);margin-bottom:6px"
          :style="{
            background: isAnswerCorrect(q, answers[i]) === true ? 'var(--em-lt)' : isAnswerCorrect(q, answers[i]) === false ? 'var(--co-lt)' : 'var(--surf2)',
            border: '1px solid ' + (isAnswerCorrect(q, answers[i]) === true ? '#A8EDD8' : isAnswerCorrect(q, answers[i]) === false ? '#FFB3C0' : 'var(--bd)')
          }"
        >
          <div style="width:26px;height:26px;border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0"
            :style="{
              background: isAnswerCorrect(q, answers[i]) === true ? 'var(--em)' : isAnswerCorrect(q, answers[i]) === false ? 'var(--co)' : 'var(--surf2)',
              border: '1.5px solid ' + (isAnswerCorrect(q, answers[i]) === true ? 'var(--em)' : isAnswerCorrect(q, answers[i]) === false ? 'var(--co)' : 'var(--bd)')
            }"
          >
            <IconCheck v-if="isAnswerCorrect(q, answers[i]) === true" :size="12" color="#fff" />
            <IconX v-else-if="isAnswerCorrect(q, answers[i]) === false" :size="12" color="#fff" />
            <IconClock v-else :size="12" style="color:var(--tx2)" />
          </div>
          <span style="font-size:11px;font-weight:700;color:var(--tx2);min-width:18px">Q{{ i + 1 }}</span>
          <span class="type-badge" :style="{ background: Q_TYPES[q.type].bg, color: Q_TYPES[q.type].tc, border: '1px solid ' + Q_TYPES[q.type].bc, fontSize: '9px', flexShrink: 0 }">{{ Q_TYPES[q.type].label }}</span>
          <span style="flex:1;font-size:12px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ q.q }}</span>
          <span style="font-size:12px;font-weight:800;flex-shrink:0" :style="{ color: isAnswerCorrect(q, answers[i]) === true ? 'var(--em)' : isAnswerCorrect(q, answers[i]) === false ? 'var(--co)' : 'var(--blue)' }">{{ isAnswerCorrect(q, answers[i]) === true ? q.pts : isAnswerCorrect(q, answers[i]) === false ? 0 : '?' }}/{{ q.pts }}</span>
          <button class="btn btn-xs btn-ghost-alt" style="flex-shrink:0" @click="showExpl(i)"><IconInfoCircle :size="12" /></button>
        </div>
      </div>
    </div>

    <!-- ════════════════ CREATOR SCREEN ════════════════ -->
    <div v-else-if="screen === 'creator'" class="fade-in" style="max-width:860px;margin:0 auto">
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:20px;flex-wrap:wrap;gap:10px">
        <div>
          <div style="font-family:var(--fh);font-size:20px;font-weight:800;margin-bottom:4px">Créer un nouveau quiz</div>
          <div style="font-size:13px;color:var(--tx2)">Configurez votre quiz, ajoutez vos questions et associez-le à une formation</div>
        </div>
        <button class="btn btn-sm" @click="goToList"><IconArrowLeft :size="14" /> Retour</button>
      </div>

      <div class="card" style="margin-bottom:16px">
        <div class="card-title"><IconSettings :size="14" style="color:var(--blue)" />Configuration générale</div>
        <div class="grid-2" style="gap:12px;margin-bottom:12px">
          <div>
            <label class="label">Titre du quiz *</label>
            <input type="text" class="inp" placeholder="Ex : Management Agile — Évaluation finale" />
          </div>
          <div>
            <label class="label">Formation associée</label>
            <select class="sel">
              <option>Management Agile</option>
              <option>Leadership & Influence</option>
              <option>Communication CNV</option>
              <option>Cybersécurité</option>
            </select>
          </div>
          <div>
            <label class="label">Phase pédagogique</label>
            <select class="sel">
              <option>E1 — Engager</option>
              <option>E2 — Explorer</option>
              <option>E3 — Expliquer</option>
              <option selected>E5 — Évaluer</option>
            </select>
          </div>
          <div>
            <label class="label">Niveau</label>
            <select class="sel">
              <option>Débutant</option>
              <option selected>Intermédiaire</option>
              <option>Avancé</option>
              <option>Expert</option>
            </select>
          </div>
          <div>
            <label class="label">Durée (minutes)</label>
            <input type="number" class="inp" value="20" min="5" max="120" />
          </div>
          <div>
            <label class="label">Seuil de réussite (%)</label>
            <input type="number" class="inp" value="75" min="50" max="100" />
          </div>
          <div>
            <label class="label">Tentatives autorisées</label>
            <select class="sel">
              <option>1</option>
              <option selected>2</option>
              <option>3</option>
              <option>Illimitées</option>
            </select>
          </div>
          <div>
            <label class="label">Options</label>
            <div style="display:flex;flex-direction:column;gap:6px;padding-top:4px">
              <label v-for="opt in ([
                { l:'Mélanger les questions', c:true },
                { l:'Mélanger les réponses', c:false },
                { l:'Afficher les corrections', c:true },
              ])" :key="opt.l" style="display:flex;align-items:center;gap:8px;cursor:pointer;font-size:13px">
              <input type="checkbox" :checked="opt.c" style="accent-color:var(--blue)" />{{ opt.l }}
            </label>
            </div>
          </div>
        </div>
      </div>

      <div class="card" style="margin-bottom:16px">
        <div class="card-title"><IconPlus :size="14" style="color:var(--blue)" />Ajouter une question</div>
        <div class="grid-3" style="gap:10px;margin-bottom:16px">
          <div
            v-for="ct in CREATOR_TYPES" :key="ct.key"
            class="creator-type"
            :style="{ borderColor: ct.bc, background: ct.bg }"
            @click="async () => { const res = await store.createQuizQuestion({ quiz_id: quizId.value, type: ct.label }); toast(res.error ? 'Erreur : ' + res.error.message : 'Question ' + ct.label + ' ajoutée au quiz !') }"
          >
            <div style="width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;margin:0 auto 8px" :style="{ background: ct.tc + '18' }">
              <component :is="ct.icon" :size="18" :style="{ color: ct.tc }" />
            </div>
            <div style="font-size:12px;font-weight:700;margin-bottom:3px" :style="{ color: ct.tc }">{{ ct.label }}</div>
            <div style="font-size:10px;color:var(--tx2)">{{ ct.desc }}</div>
          </div>
        </div>

        <div style="padding:16px;border-radius:var(--rs);border:1.5px dashed var(--bd);background:var(--surf2)">
          <div style="font-size:11px;font-weight:700;color:var(--tx2);text-transform:uppercase;letter-spacing:.8px;margin-bottom:12px">Question 1 — QCM</div>
          <div style="margin-bottom:10px">
            <label class="label">Intitulé de la question *</label>
            <textarea class="ta" style="height:64px" placeholder="Rédigez votre question ici..."></textarea>
          </div>
          <div class="grid-2" style="gap:8px;margin-bottom:10px">
            <div v-for="(ph, i) in ['Réponse A','Réponse B','Réponse C','Réponse D']" :key="i" style="display:flex;align-items:center;gap:6px">
              <input type="radio" name="correct" style="accent-color:var(--blue)" />
              <input type="text" class="inp" style="flex:1" :placeholder="ph" />
            </div>
          </div>
          <div class="grid-2" style="gap:8px">
            <div>
              <label class="label">Points</label>
              <input type="number" class="inp" value="2" min="1" max="10" />
            </div>
            <div>
              <label class="label">Explication (correction)</label>
              <input type="text" class="inp" placeholder="Expliquez la bonne réponse..." />
            </div>
          </div>
        </div>
      </div>

      <div style="display:flex;gap:10px;justify-content:flex-end;flex-wrap:wrap">
        <button class="btn btn-sm" @click="goToList()">Annuler</button>
<button class="btn btn-sm" @click="async () => { const res = await store.createQuiz({ status: 'draft', created_by: auth.profile.id }); toast(res.error ? 'Erreur : ' + res.error.message : 'Brouillon sauvegardé !') }"><IconDeviceFloppy :size="14" /> Sauvegarder brouillon</button>
    <button class="btn btn-primary btn-sm" @click="async () => { const res = await store.createQuiz({ status: 'published', created_by: auth.profile.id }); toast(res.error ? 'Erreur : ' + res.error.message : 'Quiz publié et disponible pour les apprenants !') }"><IconSend :size="14" /> Publier le quiz</button>
</div>
</div>
</template>
</div>
</template>

<style scoped>
.page { max-width: 1320px; margin: 0 auto; padding: 28px 28px 48px; }
.card { background: var(--surf); border: 1px solid var(--bd); border-radius: var(--r); padding: 18px 20px; box-shadow: var(--shadow-sm); }
.card-title { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .9px; color: var(--tx2); margin-bottom: 14px; display: flex; align-items: center; gap: 6px; }

.hero { background: var(--navy); border-radius: var(--rl); padding: 26px 32px; margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; gap: 20px; position: relative; overflow: hidden; border: 1px solid rgba(255,255,255,.06); }
.hero::before { content:''; position:absolute; right:-40px; top:-40px; width:220px; height:220px; border-radius:50%; background:var(--blue); opacity:.07; }
.hero-left { position:relative; z-index:1; flex:1; }
.hero-tag { font-size:11px; font-weight:700; letter-spacing:1.8px; text-transform:uppercase; color:var(--em); margin-bottom:8px; }
.hero-title { font-family:var(--fh); font-size:22px; font-weight:800; color:#fff; letter-spacing:-.4px; margin-bottom:6px; }
.hero-sub { font-size:13px; color:rgba(255,255,255,.5); }
.hero-stats { display:flex; gap:20px; position:relative; z-index:1; flex-shrink:0; }
.hstat { text-align:center; padding:14px 16px; background:rgba(255,255,255,.06); border-radius:12px; border:1px solid rgba(255,255,255,.08); }
.hstat-val { font-family:var(--fh); font-size:20px; font-weight:800; color:#fff; }
.hstat-lbl { font-size:10px; color:rgba(255,255,255,.4); margin-top:2px; text-transform:uppercase; letter-spacing:.8px; }

.tabs-row { display:flex; gap:4px; margin-bottom:18px; border-bottom:1px solid var(--bd); padding-bottom:0; }
.tab-btn { padding:8px 16px; border:none; background:transparent; font-size:13px; font-weight:600; color:var(--tx2); cursor:pointer; border-bottom:2px solid transparent; margin-bottom:-1px; display:flex; align-items:center; gap:6px; font-family:var(--fb); transition:all .18s; }
.tab-btn.active { color:var(--blue); border-bottom-color:var(--blue); }
.tab-btn:hover:not(.active) { color:var(--tx); }

.quiz-card { background:var(--surf); border:1px solid var(--bd); border-radius:var(--r); padding:20px; cursor:pointer; transition:all .22s; box-shadow:var(--shadow-sm); }
.quiz-card:hover { border-color:var(--blue); transform:translateY(-2px); box-shadow:var(--shadow-md); }

.type-badge { display:inline-flex; align-items:center; gap:4px; font-size:10px; font-weight:700; padding:3px 8px; border-radius:20px; border-width:1px; border-style:solid; }

.hist-row { display:flex; align-items:center; gap:14px; padding:14px 16px; background:var(--surf); border:1px solid var(--bd); border-radius:var(--rs); cursor:pointer; transition:all .18s; }
.hist-row:hover { border-color:var(--blue); background:var(--blue-lt); }

.grid-2 { display:grid; grid-template-columns:repeat(2,1fr); gap:16px; }
.grid-3 { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; }

.quiz-progress { height:6px; background:var(--surf2); border-radius:4px; overflow:hidden; }
.quiz-progress-fill { height:100%; background:var(--blue); border-radius:4px; transition:width .4s ease; }

.q-opt { display:flex; align-items:center; gap:12px; padding:14px 16px; border:1.5px solid var(--bd); border-radius:var(--rs); margin-bottom:10px; cursor:pointer; transition:all .18s; background:var(--surf); }
.q-opt:hover:not(.disabled) { border-color:var(--blue); background:var(--blue-lt); }
.q-opt.selected { border-color:var(--blue); background:var(--blue-lt); }
.q-opt.correct-hl { border-color:var(--em); background:var(--em-lt); }
.q-opt.wrong { border-color:var(--co); background:var(--co-lt); }
.q-opt.disabled { cursor:default; opacity:.85; }

.q-circle { width:28px; height:28px; border-radius:50%; border:2px solid var(--bd); display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:700; flex-shrink:0; transition:all .18s; }
.q-opt.selected .q-circle { border-color:var(--blue); background:var(--blue); color:#fff; }
.q-opt.correct-hl .q-circle { border-color:var(--em); background:var(--em); color:#fff; }
.q-opt.wrong .q-circle { border-color:var(--co); background:var(--co); color:#fff; }

.q-checkbox { width:22px; height:22px; border-radius:6px; border:2px solid var(--bd); display:flex; align-items:center; justify-content:center; flex-shrink:0; transition:all .18s; }
.q-opt.selected .q-checkbox { border-color:var(--blue); background:var(--blue); }

.ta { width:100%; padding:12px 14px; border:1px solid var(--bd); border-radius:var(--rs); background:var(--surf); color:var(--tx); font-size:13px; font-family:var(--fb); resize:vertical; }
.ta:focus { outline:none; border-color:var(--blue); }

.creator-type { padding:18px 14px; border-radius:var(--rs); border:1.5px solid var(--bd); text-align:center; cursor:pointer; transition:all .18s; }
.creator-type:hover { transform:translateY(-2px); box-shadow:var(--shadow-md); }

.label { display:block; font-size:11px; font-weight:700; color:var(--tx2); margin-bottom:4px; text-transform:uppercase; letter-spacing:.5px; }
.inp { width:100%; padding:8px 12px; border:1px solid var(--bd); border-radius:var(--rs); background:var(--surf); color:var(--tx); font-size:13px; font-family:var(--fb); }
.inp:focus { outline:none; border-color:var(--blue); }
.sel { width:100%; padding:8px 12px; border:1px solid var(--bd); border-radius:var(--rs); background:var(--surf); color:var(--tx); font-size:13px; font-family:var(--fb); }
.sel:focus { outline:none; border-color:var(--blue); }

.pill { display:inline-flex; align-items:center; gap:3px; font-size:10px; font-weight:700; padding:3px 9px; border-radius:20px; }
.pill-green { background:var(--em-lt); color:#005A42; border:1px solid #A8EDD8; }
.pill-amber { background:var(--am-lt); color:#6B3B00; border:1px solid #FFD280; }
.pill-coral { background:var(--co-lt); color:#7A0020; border:1px solid #FFB3C0; }
.pill-purple { background:var(--pu-lt); color:#3C3480; border:1px solid #C8C4F5; }
.pill-gray { background:var(--surf2); color:var(--tx2); border:1px solid var(--bd); }

.btn { display:inline-flex; align-items:center; gap:6px; padding:8px 16px; border-radius:var(--rs); border:1px solid var(--bd); background:var(--surf); color:var(--tx); font-size:13px; font-weight:600; font-family:var(--fb); cursor:pointer; transition:all .18s; white-space:nowrap; }
.btn:hover { border-color:var(--blue); color:var(--blue); }
.btn-primary { background:var(--blue); color:#fff; border-color:var(--blue); box-shadow:var(--shadow-blue); }
.btn-primary:hover { background:#1658D8; border-color:#1658D8; color:#fff; }
.btn-success { background:var(--em-lt); color:#005A42; border-color:#A8EDD8; }
.btn-success:hover { background:#C0EFE4; }
.btn-sm { padding:5px 12px; font-size:12px; }
.btn-xs { padding:3px 9px; font-size:11px; }
.btn-ghost-alt { background:transparent; border-color:transparent; color:var(--tx2); }
.btn-ghost-alt:hover { background:var(--surf2); color:var(--tx); }

.bar { height:6px; background:var(--surf2); border-radius:4px; overflow:hidden; }
.bf { height:100%; border-radius:4px; transition:width .6s cubic-bezier(.4,0,.2,1); }

.fade-in { animation: fadeIn .35s ease; }
.slide-in { animation: slideIn .3s ease; }
@keyframes fadeIn { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }
@keyframes slideIn { from { opacity:0; transform:translateX(12px); } to { opacity:1; transform:translateX(0); } }

@media (max-width:900px) {
  .hero { flex-direction:column; align-items:flex-start; }
  .hero-stats { flex-wrap:wrap; }
  .grid-2 { grid-template-columns:1fr; }
  .grid-3 { grid-template-columns:1fr 1fr; }
}
@media (max-width:600px) {
  .page { padding:16px; }
  .grid-3 { grid-template-columns:1fr; }
}
@keyframes spin { from { transform: rotate(0deg) } to { transform: rotate(360deg) } }
</style>
