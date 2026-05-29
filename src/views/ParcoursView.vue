<script setup>
import { inject, ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import {
  IconFlame, IconCompass, IconBulb, IconTool, IconRosette,
  IconPlayerPlay, IconList, IconRefresh, IconClock, IconUsers,
  IconCalendar, IconMap2, IconCheck, IconBriefcase, IconDeviceLaptop,
  IconHeadphones, IconPencil, IconLayoutList, IconClipboardList,
  IconStar, IconMessage, IconLock, IconLockOpen, IconCertificate,
  IconFolder, IconFileText, IconLink, IconPresentation, IconDownload,
  IconSend, IconArrowLeft, IconArrowRight, IconHelp, IconAlertCircle,
  IconLoader2, IconAlertTriangle
} from '@tabler/icons-vue'

const auth = useAuthStore()
const store = useDataStore()
const router = useRouter()
const toast = inject('toast')

const pageLoading = ref(false)
const pageError = ref(null)
const activePhase = ref(2)
const view = ref('cours')
const completedActs = ref(new Set(['e1-a1','e1-a2','e1-a3','e2-a1','e2-a2','e2-a3','e2-a4']))
const starRating = ref(0)
const ratingHover = ref(0)
const comment = ref('')

const STATIC_PHASES = [
  {
    id: 'e1', label: 'Engager', short: 'E1',
    icon: IconFlame, color: '#00D4A1', colorVar: 'var(--em)',
    tagline: "Créer la motivation d'apprendre",
    duration: '45 min',
    objective: "Identifier ses pratiques de management actuelles et déceler ses zones d'inconfort.",
    desc: "Une mise en situation immersive pour activer vos représentations initiales. Aucune connaissance préalable requise — venez comme vous êtes.",
    activities: [
      { id: 'e1-a1', type: 'situation', icon: IconUsers, title: 'Mise en situation — Chef de projet sous pression', desc: 'Scénario immersif : votre équipe ne livre pas, le client appelle. Comment réagissez-vous ?', duration: '20 min', required: true },
      { id: 'e1-a2', type: 'video', icon: IconPlayerPlay, title: "Vidéo — Pourquoi l'Agilité transforme le management ?", desc: 'Témoignages de managers ayant adopté les méthodes agiles. Format court, impactant.', duration: '12 min', required: true },
      { id: 'e1-a3', type: 'quiz', icon: IconHelp, title: 'Auto-diagnostic — Quel manager êtes-vous aujourd\'hui ?', desc: 'Questionnaire de positionnement initial (8 questions). Résultat personnel confidentiel.', duration: '10 min', required: false },
    ],
    resources: [
      { icon: IconFileText, label: 'Guide apprenant — Introduction au module', type: 'PDF', size: '1.2 Mo' },
      { icon: IconLink, label: 'Manifeste Agile — Version française', type: 'Lien', size: '' },
    ],
    validation: { type: 'Auto-évaluation', threshold: null, mandatory: false },
  },
  {
    id: 'e2', label: 'Explorer', short: 'E2',
    icon: IconCompass, color: '#1E6FFF', colorVar: 'var(--blue)',
    tagline: "Apprendre par l'expérimentation",
    duration: '1h 30',
    objective: 'Découvrir les principes Scrum et Kanban à travers des situations réelles d\'entreprise.',
    desc: "Exploration libre des concepts clés via des cas concrets. Vous apprenez en faisant, sans crainte de vous tromper — c'est le principe même de l'agilité.",
    activities: [
      { id: 'e2-a1', type: 'cas', icon: IconBriefcase, title: "Cas pratique — 3 projets : lequel a réussi grâce à l'Agilité ?", desc: 'Analyse de cas réels issus de la tech, du retail et des RH. Discussion guidée.', duration: '30 min', required: true },
      { id: 'e2-a2', type: 'elearning', icon: IconDeviceLaptop, title: 'Découverte interactive — Le tableau Kanban en action', desc: "Simulation d'un Kanban board à compléter en autonomie, avec feedback instantané.", duration: '25 min', required: true },
      { id: 'e2-a3', type: 'podcast', icon: IconHeadphones, title: "Podcast — Retour d'expérience DRH sur l'Agilité RH", desc: 'Interview exclusive d\'une DRH ayant mené la transformation agile de 400 personnes.', duration: '20 min', required: false },
      { id: 'e2-a4', type: 'exercice', icon: IconPencil, title: 'Exercice — Cartographier votre flux de travail actuel', desc: 'Représentez vos tâches actuelles sur un Kanban simplifié. Première prise de recul.', duration: '15 min', required: false },
    ],
    resources: [
      { icon: IconFileText, label: 'Guide Kanban illustré', type: 'PDF', size: '2.1 Mo' },
      { icon: IconFileText, label: "3 cas d'étude annotés", type: 'PDF', size: '1.8 Mo' },
    ],
    validation: { type: 'Synthèse des cas', threshold: null, mandatory: true },
  },
  {
    id: 'e3', label: 'Expliquer', short: 'E3',
    icon: IconBulb, color: '#7B6FEE', colorVar: 'var(--pu)',
    tagline: 'Structurer et conceptualiser',
    duration: '2h 00',
    objective: 'Maîtriser les frameworks Scrum, Kanban et SAFe dans leur dimension managériale.',
    desc: "Le formateur apporte le cadre théorique pour formaliser ce que vous avez découvert. Les concepts s'ancrent maintenant sur du vécu.",
    activities: [
      { id: 'e3-a1', type: 'module', icon: IconLayoutList, title: 'Module — Les 4 valeurs et 12 principes du Manifeste Agile', desc: 'Contenu structuré en 6 séquences avec schémas, exemples et points clés mémorisables.', duration: '45 min', required: true },
      { id: 'e3-a2', type: 'video', icon: IconPlayerPlay, title: 'Vidéo — Scrum en 15 min : rôles, cérémonies, artefacts', desc: 'Animation pédagogique claire et mémorisable. Le meilleur résumé Scrum du marché.', duration: '15 min', required: true },
      { id: 'e3-a3', type: 'module', icon: IconLayoutList, title: "Module — Le rôle du manager dans une équipe auto-organisée", desc: 'Comment passer du contrôle à la facilitation. Outils pratiques pour lâcher prise.', duration: '40 min', required: true },
      { id: 'e3-a4', type: 'exercice', icon: IconPencil, title: 'Exercice — Remplir un backlog de sprint simulé', desc: 'Exercice guidé avec feedback automatique. Comprendre la priorisation par la valeur.', duration: '20 min', required: false },
    ],
    resources: [
      { icon: IconFileText, label: 'Fiche mémo — Scrum Master vs Product Owner', type: 'PDF', size: '0.8 Mo' },
      { icon: IconPresentation, label: 'Slides du module complet', type: 'PPTX', size: '12 Mo' },
      { icon: IconFileText, label: 'Glossaire Agile illustré', type: 'PDF', size: '1.4 Mo' },
    ],
    validation: { type: 'Quiz de compréhension', threshold: 70, mandatory: true },
  },
  {
    id: 'e4', label: 'Élaborer', short: 'E4',
    icon: IconTool, color: '#FF9B21', colorVar: 'var(--am)',
    tagline: 'Transférer vers sa pratique',
    duration: '2h 30',
    objective: "Concevoir et présenter un plan de transformation Agile pour votre propre équipe.",
    desc: "Vous réinvestissez vos apprentissages dans votre contexte professionnel réel. C'est ici que la formation produit de la valeur concrète.",
    activities: [
      { id: 'e4-a1', type: 'projet', icon: IconClipboardList, title: "Projet — Plan de transformation Agile de votre équipe", desc: "Livrable individuel : diagnostic + plan d'action en 1 page. Critères fournis.", duration: '60 min', required: true },
      { id: 'e4-a2', type: 'simulation', icon: IconUsers, title: "Simulation — Animer une rétro d'équipe difficile", desc: 'Jeu de rôle avec personnages résistants. Pratiquer la facilitation sous pression.', duration: '45 min', required: true },
      { id: 'e4-a3', type: 'exercice', icon: IconPencil, title: 'Atelier — Prioriser un backlog conflictuel', desc: 'Exercice de prise de décision sous contraintes business et humaines.', duration: '25 min', required: false },
    ],
    resources: [
      { icon: IconFileText, label: 'Template — Plan de transformation Agile', type: 'DOCX', size: '0.6 Mo' },
      { icon: IconFileText, label: "Grille d'auto-évaluation du livrable", type: 'PDF', size: '0.4 Mo' },
    ],
    validation: { type: 'Livrable évalué formateur', threshold: null, mandatory: true },
  },
  {
    id: 'e5', label: 'Évaluer', short: 'E5',
    icon: IconRosette, color: '#FF4D6A', colorVar: 'var(--co)',
    tagline: 'Valider et certifier',
    duration: '1h 15',
    objective: "Démontrer la maîtrise des compétences agiles et obtenir la validation de la formation.",
    desc: 'Évaluation formelle des acquis, feedback personnalisé du formateur et délivrance de la certification.',
    activities: [
      { id: 'e5-a1', type: 'quiz', icon: IconHelp, title: 'Quiz final — 20 questions — Management Agile', desc: 'Couverture complète des 4 phases. Seuil de réussite : 75 %. 2 tentatives autorisées.', duration: '25 min', required: true },
      { id: 'e5-a2', type: 'simulation', icon: IconUsers, title: 'Cas de synthèse — Piloter une équipe en crise de sprint', desc: 'Évaluation en conditions réelles. Grille partagée avant la session.', duration: '30 min', required: true },
      { id: 'e5-a3', type: 'eval', icon: IconStar, title: "Évaluation de la formation par l'apprenant", desc: 'Satisfaction, utilité perçue, recommandation — 5 min. Anonyme et confidentiel.', duration: '5 min', required: false },
      { id: 'e5-a4', type: 'feedback', icon: IconMessage, title: 'Retour personnalisé formateur sur le livrable E4', desc: 'Commentaires individuels écrits + recommandations pour la suite du parcours.', duration: '15 min', required: false },
    ],
    resources: [
      { icon: IconCertificate, label: 'Attestation de formation (après validation)', type: 'PDF', size: '—' },
      { icon: IconFileText, label: 'Rapport de compétences acquises', type: 'PDF', size: '—' },
    ],
    validation: { type: 'Certification SkillPath', threshold: 75, mandatory: true },
  },
]

const PHASE_ICONS = [IconFlame, IconCompass, IconBulb, IconTool, IconRosette]
const PHASE_COLORS = ['#00D4A1', '#1E6FFF', '#7B6FEE', '#FF9B21', '#FF4D6A']
const PHASE_COLORVARS = ['var(--em)', 'var(--blue)', 'var(--pu)', 'var(--am)', 'var(--co)']
const PHASE_LABELS = ['Engager', 'Explorer', 'Expliquer', 'Élaborer', 'Évaluer']
const PHASE_SHORTS = ['E1', 'E2', 'E3', 'E4', 'E5']
const ACT_ICON_MAP = { situation: IconUsers, video: IconPlayerPlay, quiz: IconHelp, cas: IconBriefcase, elearning: IconDeviceLaptop, podcast: IconHeadphones, exercice: IconPencil, module: IconLayoutList, projet: IconClipboardList, simulation: IconUsers, eval: IconStar, feedback: IconMessage }

const PHASES = computed(() => {
  if (store.pathPhases.length) {
    return store.pathPhases.map((p, i) => ({
      id: p.id,
      label: p.label || PHASE_LABELS[i] || '',
      short: PHASE_SHORTS[i] || `E${i + 1}`,
      icon: PHASE_ICONS[i] || IconFlame,
      color: p.color || PHASE_COLORS[i] || '#1E6FFF',
      colorVar: PHASE_COLORVARS[i] || 'var(--blue)',
      tagline: p.tagline || '',
      duration: p.duration || '',
      objective: p.objective || '',
      desc: p.desc || '',
      activities: (p.path_activities || []).map(a => ({
        id: a.id,
        type: a.type || 'module',
        icon: ACT_ICON_MAP[a.type] || IconLayoutList,
        title: a.title || '',
        desc: a.desc || '',
        duration: a.duration || '',
        required: a.required ?? false,
      })),
      resources: p.resources || [],
      validation: p.validation || {},
    }))
  }
  return STATIC_PHASES
})

const ACT_TYPES = {
  situation: { label: 'Mise en situation', bg: '#F5F5F0', tc: '#444440', bc: '#CCCCC0', icon: IconUsers },
  video: { label: 'Vidéo', bg: '#FFF0F2', tc: '#7A0020', bc: '#FFB3C0', icon: IconPlayerPlay },
  quiz: { label: 'Quiz', bg: '#FFF3FB', tc: '#6B0050', bc: '#F5B3E8', icon: IconHelp },
  cas: { label: 'Cas pratique', bg: '#FFF4E0', tc: '#6B3B00', bc: '#FFD280', icon: IconBriefcase },
  elearning: { label: 'E-learning', bg: '#F0EFFE', tc: '#3C3480', bc: '#C8C4F5', icon: IconDeviceLaptop },
  podcast: { label: 'Podcast', bg: '#FFF4E0', tc: '#6B3B00', bc: '#FFD280', icon: IconHeadphones },
  exercice: { label: 'Exercice', bg: '#E0F9F3', tc: '#005A42', bc: '#A8EDD8', icon: IconPencil },
  module: { label: 'Module', bg: '#EEF4FF', tc: '#1A4AAA', bc: '#C5D9FF', icon: IconLayoutList },
  projet: { label: 'Projet', bg: '#EEF4FF', tc: '#1A4AAA', bc: '#C5D9FF', icon: IconClipboardList },
  simulation: { label: 'Simulation', bg: '#F5F5F0', tc: '#444440', bc: '#CCCCC0', icon: IconUsers },
  eval: { label: 'Évaluation', bg: '#E0F9F3', tc: '#005A42', bc: '#A8EDD8', icon: IconStar },
  feedback: { label: 'Feedback', bg: '#F0EFFE', tc: '#3C3480', bc: '#C8C4F5', icon: IconMessage },
}

const RING_R = 34
const RING_C = 2 * Math.PI * RING_R

function phaseProgress(idx) {
  const ph = PHASES[idx]
  const done = ph.activities.filter(a => completedActs.value.has(a.id)).length
  return Math.round((done / ph.activities.length) * 100)
}

function isPhaseUnlocked(idx) {
  if (idx === 0) return true
  const prev = PHASES[idx - 1]
  return prev.activities.filter(a => a.required).every(a => completedActs.value.has(a.id))
}

const overallProgress = computed(() => {
  const total = PHASES.reduce((s, p) => s + p.activities.length, 0)
  return Math.round((completedActs.value.size / total) * 100)
})

const currentPhase = computed(() => PHASES[activePhase.value])
const currentPhasePct = computed(() => phaseProgress(activePhase.value))
const totalActs = computed(() => PHASES.reduce((s, p) => s + p.activities.length, 0))

const ratingLabel = computed(() => {
  if (starRating.value === 0) return 'Cliquez pour noter'
  const labels = ['', 'Insuffisant', 'Passable', 'Bien', 'Très bien', 'Excellent']
  return labels[starRating.value] + ' (' + starRating.value + '/5)'
})

function toggleActivity(actId) {
  if (completedActs.value.has(actId)) completedActs.value.delete(actId)
  else {
    completedActs.value.add(actId)
    if (auth.profile?.id) store.markActivityComplete(auth.profile.id, actId)
    toast('Activité validée ✓')
  }
}

function goToPhase(idx) {
  if (!isPhaseUnlocked(idx)) {
    toast("Terminez d'abord les activités obligatoires de la phase précédente", 'err'); return
  }
  activePhase.value = idx
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function isNextActivity(act, idx) {
  if (completedActs.value.has(act.id)) return false
  return currentPhase.value.activities.slice(0, idx).every(a => completedActs.value.has(a.id))
}

function submitRating() {
  if (starRating.value === 0) { toast('Cliquez sur une étoile pour noter', 'err'); return }
  toast('Évaluation envoyée — merci pour votre retour !')
  starRating.value = 0
  ratingHover.value = 0
  comment.value = ''
}

function synopsisClick(idx) {
  if (!isPhaseUnlocked(idx)) {
    toast('Phase verrouillée — terminez les activités obligatoires précédentes', 'err'); return
  }
  goToPhase(idx)
  view.value = 'cours'
}

onMounted(async () => {
  pageLoading.value = true
  pageError.value = null
  try {
    if (!auth.profile?.id) return
    const uid = auth.profile.id
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
    <div v-if="pageLoading" style="display:flex;flex-direction:column;align-items:center;justify-content:center;padding:80px 20px;gap:14px">
      <IconLoader2 :size="36" style="color:var(--blue);animation:spin 1s linear infinite" />
      <div style="font-size:14px;color:var(--tx2)">Chargement…</div>
    </div>
    <div v-else-if="pageError" style="display:flex;flex-direction:column;align-items:center;justify-content:center;padding:80px 20px;gap:14px">
      <IconAlertTriangle :size="36" style="color:var(--co)" />
      <div style="font-size:14px;color:var(--co)">{{ pageError }}</div>
    </div>
    <div v-if="!pageLoading && !pageError">
<div class="card fade-in top-bar">
      <div class="top-bar-inner">
        <div class="top-bar-icon" :style="{ background: currentPhase.color + '18', borderColor: currentPhase.color + '44' }">
          <IconRefresh :size="24" :style="{ color: currentPhase.color }" />
        </div>
        <div class="top-bar-info">
          <div class="top-bar-title">Management Agile — SCRUM</div>
          <div class="top-bar-pills">
            <span class="pill level-int">Intermédiaire</span>
            <span class="pill pill-gray"><IconClock :size="10" /> 8h au total</span>
            <span class="pill pill-gray"><IconUsers :size="10" /> Marc Dupont · Formateur</span>
            <span class="pill pill-gray"><IconCalendar :size="10" /> Session 19–26 mai 2025</span>
          </div>
        </div>
        <div class="top-bar-right">
          <div class="ring-wrap">
            <svg width="80" height="80" viewBox="0 0 80 80">
              <circle cx="40" cy="40" :r="RING_R" fill="none" stroke="var(--surf2)" stroke-width="7" />
              <circle cx="40" cy="40" :r="RING_R" fill="none" stroke="var(--blue)" stroke-width="7"
                :stroke-dasharray="RING_C"
                :stroke-dashoffset="RING_C * (1 - overallProgress / 100)"
                stroke-linecap="round" class="ring-progress" />
            </svg>
            <div class="ring-label">
              <div class="ring-pct">{{ overallProgress }}%</div>
              <div class="ring-sub">global</div>
            </div>
          </div>
          <div class="view-toggles">
            <button :class="['btn btn-sm', view === 'cours' ? 'btn-primary' : '']" @click="view = 'cours'">
              <IconPlayerPlay :size="11" /> Parcours
            </button>
            <button :class="['btn btn-sm', view === 'synopsis' ? 'btn-primary' : '']" @click="view = 'synopsis'">
              <IconList :size="11" /> Synopsis
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ═══ SYNOPSIS VIEW ═══ -->
    <template v-if="view === 'synopsis'">
      <div class="fade-in">
        <div class="grid-4 synopsis-stats">
          <div v-for="stat in [
            { label: 'Phases', value: '5', icon: IconMap2, color: 'var(--blue)' },
            { label: 'Activités', value: totalActs, icon: IconList, color: 'var(--pu)' },
            { label: 'Complétées', value: completedActs.size + '/' + totalActs, icon: IconCheck, color: 'var(--em)' },
            { label: 'Durée totale', value: '8h', icon: IconClock, color: 'var(--am)' },
          ]" :key="stat.label" class="card" style="text-align:center">
            <div class="stat-icon" :style="{ background: stat.color + '18' }">
              <component :is="stat.icon" :size="20" :style="{ color: stat.color }" />
            </div>
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>

        <div v-for="(ph, i) in PHASES" :key="ph.id"
          class="card synopsis-phase-card"
          :class="{ current: i === activePhase, locked: !isPhaseUnlocked(i) }"
          :style="{ borderLeftColor: ph.color }"
          @click="synopsisClick(i)"
        >
          <div class="synopsis-inner">
            <div class="synopsis-phase-icon" :style="{ background: ph.color + '18', borderColor: ph.color + '44' }">
              <component :is="ph.icon" :size="22" :style="{ color: ph.color }" />
            </div>
            <div class="synopsis-phase-body">
              <div class="synopsis-phase-header">
                <span class="synopsis-phase-title">{{ ph.short }} — {{ ph.label }}</span>
                <span v-if="i === activePhase" class="pill" :style="{ background: ph.color, color: '#fff', fontSize: '9px' }">En cours</span>
                <span v-if="phaseProgress(i) === 100" class="pill pill-green">✓ Terminée</span>
                <span v-if="!isPhaseUnlocked(i)" class="pill pill-gray"><IconLock :size="10" /> Verrouillée</span>
                <span class="pill pill-gray"><IconClock :size="10" /> {{ ph.duration }}</span>
              </div>
              <div class="synopsis-tagline">"{{ ph.tagline }}"</div>
              <div class="synopsis-objective">{{ ph.objective }}</div>
              <div class="synopsis-act-pills">
                <span v-for="a in ph.activities" :key="a.id"
                  class="act-pill"
                  :style="{
                    borderColor: completedActs.has(a.id) ? 'var(--em)' : ACT_TYPES[a.type]?.bc,
                    background: completedActs.has(a.id) ? 'var(--em-lt)' : ACT_TYPES[a.type]?.bg,
                    color: completedActs.has(a.id) ? '#005A42' : ACT_TYPES[a.type]?.tc
                  }">
                  <component :is="completedActs.has(a.id) ? IconCheck : (ACT_TYPES[a.type]?.icon || IconLayoutList)" :size="10" />
                  {{ a.duration }}
                </span>
              </div>
              <div class="synopsis-progress-row">
                <div class="bar" style="flex:1">
                  <div class="bf" :style="{ width: phaseProgress(i) + '%', background: ph.color }"></div>
                </div>
                <span class="synopsis-pct" :style="{ color: ph.color }">{{ phaseProgress(i) }}%</span>
                <span class="synopsis-count">{{ ph.activities.filter(a => completedActs.has(a.id)).length }}/{{ ph.activities.length }}</span>
              </div>
            </div>
            <div class="synopsis-phase-side">
              <span class="validation-pill" :style="{
                background: ph.validation.mandatory ? 'var(--co-lt)' : 'var(--surf2)',
                borderColor: ph.validation.mandatory ? '#FFB3C0' : 'var(--bd)'
              }">
                {{ ph.validation.type }}{{ ph.validation.threshold ? ' (' + ph.validation.threshold + '%)' : '' }}
              </span>
              <button v-if="isPhaseUnlocked(i)" class="btn btn-sm" :style="{ borderColor: ph.color, color: ph.color }"
                @click.stop="goToPhase(i); view = 'cours'">
                Ouvrir →
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>

    <!-- ═══ COURS VIEW ═══ -->
    <div v-else>
      <div class="phase-stepper fade-in">
        <template v-for="(ph, i) in PHASES" :key="ph.id">
          <div v-if="i > 0" class="connector" :class="{ done: phaseProgress(i - 1) === 100 }"></div>
          <div class="phase-step" :class="{
            active: i === activePhase,
            done: phaseProgress(i) === 100 && i !== activePhase,
            locked: !isPhaseUnlocked(i) && i !== activePhase && phaseProgress(i) !== 100
          }" :style="{ '--phase-col': ph.color }" @click="goToPhase(i)">
            <div class="phase-step-icon" :style="{
              background: i === activePhase ? 'rgba(255,255,255,.2)' : phaseProgress(i) === 100 ? ph.color : ph.color + '18'
            }">
              <component :is="phaseProgress(i) === 100 ? IconCheck : ph.icon" :size="20"
                :style="{ color: i === activePhase ? '#fff' : phaseProgress(i) === 100 ? '#fff' : ph.color }" />
            </div>
            <div class="phase-step-label" :style="{ color: i === activePhase ? '#fff' : phaseProgress(i) === 100 ? '#005A42' : 'var(--tx2)' }">
              {{ ph.short }} · {{ ph.label }}
            </div>
            <div class="phase-step-sub" :style="{ color: i === activePhase ? 'rgba(255,255,255,.75)' : phaseProgress(i) === 100 ? '#00A87880' : 'var(--tx3)' }">
              <template v-if="phaseProgress(i) === 100">✓ Terminée</template>
              <template v-else-if="!isPhaseUnlocked(i)">🔒 Verrouillée</template>
              <template v-else-if="i === activePhase">● En cours</template>
              <template v-else>{{ ph.duration }}</template>
            </div>
            <div class="phase-step-pct" :style="{ color: i === activePhase ? '#fff' : phaseProgress(i) === 100 ? 'var(--em)' : 'var(--tx2)' }">
              {{ phaseProgress(i) }}%
            </div>
          </div>
        </template>
      </div>

      <div class="grid-main fade-in">
        <!-- LEFT: Phase content -->
        <div class="left-col">
          <div class="card phase-header-card" :style="{ borderLeftColor: currentPhase.color }">
            <div class="phase-header-top">
              <div class="phase-header-icon" :style="{ background: currentPhase.color + '18', borderColor: currentPhase.color + '44' }">
                <component :is="currentPhase.icon" :size="26" :style="{ color: currentPhase.color }" />
              </div>
              <div class="phase-header-body">
                <div class="phase-header-title-row">
                  <span class="phase-header-title">{{ currentPhase.short }} — {{ currentPhase.label }}</span>
                  <span class="pill" :style="{ background: currentPhase.color, color: '#fff' }">{{ currentPhase.duration }}</span>
                </div>
                <div class="phase-header-tagline">"{{ currentPhase.tagline }}"</div>
                <div class="phase-header-desc">{{ currentPhase.desc }}</div>
              </div>
            </div>
            <div class="phase-objective" :style="{ background: currentPhase.color + '0F', borderColor: currentPhase.color + '22' }">
              <div class="phase-objective-label" :style="{ color: currentPhase.color }">Objectif de la phase</div>
              <div>{{ currentPhase.objective }}</div>
            </div>
            <div class="phase-progress-row">
              <div class="bar bar-lg" style="flex:1">
                <div class="bf" :style="{ width: currentPhasePct + '%', background: currentPhase.color }"></div>
              </div>
              <span class="phase-pct" :style="{ color: currentPhase.color }">{{ currentPhasePct }}%</span>
              <span class="phase-count">{{ currentPhase.activities.filter(a => completedActs.has(a.id)).length }}/{{ currentPhase.activities.length }} activités</span>
            </div>
          </div>

          <div class="card">
            <div class="card-title">
              <component :is="IconList" :size="14" :style="{ color: currentPhase.color }" />
              Activités de la phase
            </div>
            <div v-for="(act, idx) in currentPhase.activities" :key="act.id"
              class="act-row" :class="{
                done: completedActs.has(act.id),
                'active-act': isNextActivity(act, idx)
              }" @click="toggleActivity(act.id)">
              <div class="act-check" :class="{ done: completedActs.has(act.id) }"
                :style="{ borderColor: completedActs.has(act.id) ? 'var(--em)' : isNextActivity(act, idx) ? currentPhase.color : 'var(--bd)' }"
                @click.stop="toggleActivity(act.id)">
                <IconCheck v-if="completedActs.has(act.id)" :size="12" color="#fff" />
                <span v-else-if="isNextActivity(act, idx)" class="pulsing-dot" :style="{ background: currentPhase.color }"></span>
              </div>
              <div class="act-icon" :style="{ background: ACT_TYPES[act.type]?.bg, borderColor: ACT_TYPES[act.type]?.bc }">
                <component :is="ACT_TYPES[act.type]?.icon || IconLayoutList" :size="16" :style="{ color: ACT_TYPES[act.type]?.tc }" />
              </div>
              <div class="act-body">
                <div class="act-title-row">
                  <span class="act-title">{{ act.title }}</span>
                  <span v-if="act.required" class="required-badge">Obligatoire</span>
                </div>
                <div class="act-desc">{{ act.desc }}</div>
              </div>
              <div class="act-meta">
                <span class="act-type-badge" :style="{
                  background: ACT_TYPES[act.type]?.bg,
                  color: ACT_TYPES[act.type]?.tc,
                  borderColor: ACT_TYPES[act.type]?.bc
                }">{{ ACT_TYPES[act.type]?.label }}</span>
                <span class="act-duration"><IconClock :size="10" /> {{ act.duration }}</span>
                <button v-if="!completedActs.has(act.id)" class="btn btn-xs btn-primary"
                  :style="{ background: isNextActivity(act, idx) ? currentPhase.color : 'var(--blue)', borderColor: isNextActivity(act, idx) ? currentPhase.color : 'var(--blue)' }"
                  @click.stop="toggleActivity(act.id)">
                  {{ isNextActivity(act, idx) ? '▶ Démarrer' : 'Valider' }}
                </button>
                <span v-else class="pill pill-green" style="font-size:9px">✓ Fait</span>
              </div>
            </div>
          </div>

          <div class="phase-nav">
            <button class="btn btn-sm" :disabled="activePhase === 0" @click="goToPhase(activePhase - 1)">
              <IconArrowLeft :size="14" /> Phase précédente
            </button>
            <div class="phase-nav-center">
              Phase {{ activePhase + 1 }} / {{ PHASES.length }}<br>
              <span :style="{ color: PHASES[activePhase].color, fontWeight: 600 }">{{ PHASES[activePhase].label }}</span>
            </div>
            <button v-if="activePhase < PHASES.length - 1" class="btn btn-sm btn-primary" @click="goToPhase(activePhase + 1)">
              Phase suivante <IconArrowRight :size="14" />
            </button>
            <button v-else class="btn btn-sm btn-primary" @click="async () => { const formationId = store.formations[0]?.id; if (formationId) { const res = await store.requestCertification(auth.profile.id, formationId); if (res.error) toast('Erreur : ' + res.error.message, 'err'); else toast('Félicitations ! Formation terminée — certification en cours...') } else { toast('Félicitations ! Formation terminée — certification en cours...') } }">
              <IconRosette :size="14" /> Terminer & Certifier
            </button>
          </div>
        </div>

        <!-- RIGHT: Sidebar -->
        <div class="right-col">
          <div class="card" :style="{ borderColor: currentPhase.validation.mandatory ? currentPhase.color + '44' : 'var(--bd)' }">
            <div class="card-title">
              <IconCertificate :size="14" :style="{ color: currentPhase.color }" />
              Validation de la phase
            </div>
            <div class="validation-row">
              <div class="validation-icon" :style="{ background: currentPhase.color + '18', borderColor: currentPhase.color + '44' }">
                <component :is="currentPhase.validation.mandatory ? IconLock : IconLockOpen" :size="16" :style="{ color: currentPhase.color }" />
              </div>
              <div>
                <div class="validation-type">{{ currentPhase.validation.type }}</div>
                <div v-if="currentPhase.validation.threshold" class="validation-threshold">
                  Seuil de réussite : <strong :style="{ color: currentPhase.color }">{{ currentPhase.validation.threshold }}%</strong>
                </div>
                <span :class="['pill', currentPhase.validation.mandatory ? 'pill-coral' : 'pill-green']" style="margin-top:6px">
                  {{ currentPhase.validation.mandatory ? '⚠ Obligatoire pour progresser' : 'Facultative' }}
                </span>
              </div>
            </div>
            <button v-if="currentPhase.validation.threshold" class="btn btn-primary btn-sm" style="width:100%;justify-content:center"
              @click="router.push('/quiz')">
              <IconHelp :size="14" /> Passer le quiz de validation
            </button>
            <button v-else-if="currentPhasePct === 100" class="btn btn-success btn-sm" style="width:100%;justify-content:center"
              @click="toast('Phase validée ✓')">>
              <IconCheck :size="14" /> Phase complète — Valider
            </button>
            <div v-else class="validation-hint">Complétez toutes les activités de la phase pour valider.</div>
          </div>

          <div class="card">
            <div class="card-title">
              <IconFolder :size="14" style="color:var(--am)" />
              Ressources de la phase
            </div>
            <div v-for="(r, ri) in currentPhase.resources" :key="ri" class="res-item" @click="toast('Téléchargement : ' + r.label)">
              <div class="res-icon-wrap">
                <component :is="r.icon" :size="16" style="color:var(--blue)" />
              </div>
              <div class="res-body">
                <div class="res-label">{{ r.label }}</div>
                <div class="res-meta">{{ r.type }}{{ r.size ? ' · ' + r.size : '' }}</div>
              </div>
              <IconDownload :size="14" style="color:var(--tx3)" />
            </div>
            <button class="btn btn-sm" style="width:100%;justify-content:center;margin-top:10px"
              @click="toast('Tous les supports partagés par le formateur !')">
              <IconSend :size="14" /> Demander au formateur
            </button>
          </div>

          <div class="card">
            <div class="card-title">
              <IconMap2 :size="14" style="color:var(--blue)" />
              Vue d'ensemble du parcours
            </div>
            <div v-for="(ph, i) in PHASES" :key="ph.id" class="overview-row"
              :class="{ clickable: isPhaseUnlocked(i) }"
              @click="isPhaseUnlocked(i) && goToPhase(i)">
              <div class="overview-icon" :style="{ background: phaseProgress(i) === 100 ? ph.color : ph.color + '18' }">
                <component :is="phaseProgress(i) === 100 ? IconCheck : ph.icon" :size="13"
                  :style="{ color: phaseProgress(i) === 100 ? '#fff' : ph.color }" />
              </div>
              <div class="overview-body">
                <div class="overview-label" :style="{ fontWeight: i === activePhase ? '700' : '400', color: i === activePhase ? ph.color : 'var(--tx)' }">
                  {{ ph.short }} · {{ ph.label }}
                  <span v-if="i === activePhase" class="pulsing-dot" :style="{ background: ph.color, marginLeft: '5px' }"></span>
                </div>
                <div class="bar bar-sm" style="margin-top:4px">
                  <div class="bf" :style="{ width: phaseProgress(i) + '%', background: ph.color }"></div>
                </div>
              </div>
              <span class="overview-pct" :style="{ color: ph.color }">{{ phaseProgress(i) }}%</span>
              <IconLock v-if="!isPhaseUnlocked(i)" :size="12" style="color:var(--tx3)" />
            </div>
          </div>

          <div class="card">
            <div class="card-title">
              <IconStar :size="14" style="color:var(--am)" />
              Évaluer cette phase
            </div>
            <div class="rating-hint">Votre avis aide le formateur à améliorer le contenu.</div>
            <div class="stars" @mouseleave="ratingHover = 0">
              <span v-for="n in 5" :key="n" class="star" :class="{ lit: n <= Math.max(starRating, ratingHover) }"
                @mouseover="ratingHover = n" @click="starRating = n; ratingHover = 0">★</span>
            </div>
            <div class="rating-label">{{ ratingLabel }}</div>
            <textarea v-model="comment" class="comment-field" placeholder="Votre commentaire (optionnel)..."></textarea>
            <button class="btn btn-primary btn-sm" style="margin-top:10px" @click="submitRating">
              <IconSend :size="14" /> Envoyer
            </button>
</div>
</div>
</div>
</div>
</div>
</div>
</template>

<style scoped>
.page {
  max-width: 1200px;
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
.fade-in {
  animation: fadeUp 0.3s ease forwards;
}
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
.pulsing-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: block;
  animation: pulse 2s infinite;
}

/* TOP BAR */
.top-bar { margin-bottom: 20px; padding: 16px 22px; }
.top-bar-inner { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
.top-bar-icon {
  width: 48px; height: 48px; border-radius: 13px;
  border: 1px solid; display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.top-bar-info { flex: 1; min-width: 0; }
.top-bar-title { font-family: var(--fh); font-size: 17px; font-weight: 800; margin-bottom: 4px; }
.top-bar-pills { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
.top-bar-right { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
.view-toggles { display: flex; flex-direction: column; gap: 6px; }

/* PILLS */
.pill {
  display: inline-flex; align-items: center; gap: 3px;
  font-size: 10px; font-weight: 700; padding: 3px 9px; border-radius: 20px;
}
.pill-green { background: var(--em-lt); color: #005A42; border: 1px solid #A8EDD8; }
.pill-amber { background: var(--am-lt); color: #6B3B00; border: 1px solid #FFD280; }
.pill-blue { background: var(--blue-lt); color: #1A4AAA; border: 1px solid var(--blue-md); }
.pill-coral { background: var(--co-lt); color: #7A0020; border: 1px solid #FFB3C0; }
.pill-purple { background: var(--pu-lt); color: #3C3480; border: 1px solid #C8C4F5; }
.pill-gray { background: var(--surf2); color: var(--tx2); border: 1px solid var(--bd); }
.level-int { background: var(--am-lt); color: #6B3B00; border: 1px solid #FFD280; }

/* PROGRESS RING */
.ring-wrap { position: relative; width: 80px; height: 80px; flex-shrink: 0; }
.ring-wrap svg { transform: rotate(-90deg); }
.ring-progress { transition: stroke-dashoffset 0.6s ease; }
.ring-label {
  position: absolute; inset: 0; display: flex; flex-direction: column;
  align-items: center; justify-content: center; font-family: var(--fh);
}
.ring-pct { font-size: 16px; font-weight: 800; color: var(--blue); }
.ring-sub { font-size: 8px; color: var(--tx2); }

/* BUTTONS */
.btn {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 8px 16px; border-radius: var(--rs);
  border: 1px solid var(--bd); background: var(--surf); color: var(--tx);
  font-size: 13px; font-weight: 600; font-family: var(--fb);
  cursor: pointer; transition: all 0.18s; white-space: nowrap;
}
.btn:hover { border-color: var(--blue); color: var(--blue); }
.btn-primary { background: var(--blue); color: #fff; border-color: var(--blue); box-shadow: var(--shadow-blue); }
.btn-primary:hover { background: #1658D8; border-color: #1658D8; color: #fff; }
.btn-success { background: var(--em-lt); color: #005A42; border-color: #A8EDD8; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
.btn-xs { padding: 3px 9px; font-size: 11px; }
.btn:disabled { opacity: 0.4; cursor: not-allowed; }

/* BARS */
.bar { height: 6px; background: var(--surf2); border-radius: 4px; overflow: hidden; }
.bar-sm { height: 4px; }
.bar-lg { height: 8px; }
.bf { height: 100%; border-radius: 4px; transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1); }

/* GRIDS */
.grid-4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.grid-main { display: grid; grid-template-columns: minmax(0, 1.6fr) minmax(0, 1fr); gap: 18px; }

/* SYNOPSIS */
.synopsis-stats { margin-bottom: 20px; }
.stat-icon {
  width: 40px; height: 40px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center; margin: 0 auto 8px;
}
.stat-value { font-family: var(--fh); font-size: 22px; font-weight: 800; }
.stat-label { font-size: 11px; color: var(--tx2); margin-top: 2px; }
.synopsis-phase-card {
  margin-bottom: 12px;
  border-left: 4px solid;
  border-radius: 0 var(--r) var(--r) 0;
  cursor: pointer;
  transition: all 0.2s;
}
.synopsis-phase-card.locked { opacity: 0.55; cursor: not-allowed; }
.synopsis-phase-card.current { box-shadow: 0 0 0 2px; }
.synopsis-inner { display: flex; align-items: flex-start; gap: 14px; }
.synopsis-phase-icon {
  width: 44px; height: 44px; border-radius: 12px;
  border: 1px solid; display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.synopsis-phase-body { flex: 1; min-width: 0; }
.synopsis-phase-header { display: flex; align-items: center; gap: 8px; margin-bottom: 4px; flex-wrap: wrap; }
.synopsis-phase-title { font-family: var(--fh); font-size: 15px; font-weight: 700; }
.synopsis-tagline { font-size: 12px; font-style: italic; color: var(--tx2); margin-bottom: 8px; }
.synopsis-objective { font-size: 12px; color: var(--tx2); margin-bottom: 10px; }
.synopsis-act-pills { display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 10px; }
.act-pill {
  display: inline-flex; align-items: center; gap: 4px;
  padding: 3px 8px; border-radius: 10px; border: 1px solid;
  font-size: 10px; font-weight: 600;
}
.synopsis-progress-row { display: flex; align-items: center; gap: 10px; }
.synopsis-pct { font-size: 12px; font-weight: 700; min-width: 32px; }
.synopsis-count { font-size: 11px; color: var(--tx2); }
.synopsis-phase-side { display: flex; flex-direction: column; align-items: flex-end; gap: 8px; flex-shrink: 0; }
.validation-pill {
  font-size: 11px; color: var(--tx2); padding: 3px 9px;
  border-radius: 10px; border: 1px solid;
}

/* PHASE STEPPER */
.phase-stepper {
  display: flex; align-items: flex-start; gap: 0; margin-bottom: 24px;
  background: var(--surf); border: 1px solid var(--bd);
  border-radius: var(--rl); padding: 6px; box-shadow: var(--shadow-sm);
}
.phase-step {
  flex: 1; display: flex; flex-direction: column; align-items: center;
  padding: 14px 8px; border-radius: 12px; cursor: pointer;
  transition: all 0.2s; position: relative; text-align: center;
}
.phase-step:hover:not(.active) { background: var(--surf2); }
.phase-step.active { background: var(--phase-col); color: #fff; }
.phase-step.done { background: var(--em-lt); }
.phase-step.locked { opacity: 0.45; cursor: not-allowed; }
.phase-step-icon {
  width: 40px; height: 40px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  margin: 0 auto 8px; transition: all 0.2s;
}
.phase-step.active .phase-step-icon { background: rgba(255, 255, 255, 0.2); }
.phase-step.done .phase-step-icon { background: var(--em); color: #fff; }
.phase-step-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
.phase-step-sub { font-size: 10px; margin-top: 2px; opacity: 0.75; }
.phase-step-pct { font-family: var(--fh); font-size: 13px; font-weight: 800; margin-top: 4px; }
.connector { width: 24px; height: 2px; background: var(--bd); flex-shrink: 0; margin-top: 28px; transition: background 0.3s; }
.connector.done { background: var(--em); }

/* LEFT COL */
.left-col { display: flex; flex-direction: column; gap: 16px; }
.phase-header-card { border-left: 4px solid; border-radius: 0 var(--r) var(--r) 0; }
.phase-header-top { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 14px; }
.phase-header-icon {
  width: 52px; height: 52px; border-radius: 14px;
  border: 1px solid; display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.phase-header-body { flex: 1; }
.phase-header-title-row { display: flex; align-items: center; gap: 8px; margin-bottom: 5px; flex-wrap: wrap; }
.phase-header-title { font-family: var(--fh); font-size: 18px; font-weight: 800; }
.phase-header-tagline { font-size: 13px; font-style: italic; color: var(--tx2); margin-bottom: 6px; }
.phase-header-desc { font-size: 13px; color: var(--tx); line-height: 1.65; }
.phase-objective {
  padding: 10px 14px; border-radius: var(--rs); border: 1px solid;
  margin-bottom: 14px;
}
.phase-objective-label {
  font-size: 11px; font-weight: 700; margin-bottom: 3px;
  text-transform: uppercase; letter-spacing: 0.8px;
}
.phase-progress-row { display: flex; align-items: center; gap: 10px; }
.phase-pct { font-size: 13px; font-weight: 700; min-width: 40px; }
.phase-count { font-size: 12px; color: var(--tx2); }

/* ACTIVITY ROW */
.act-row {
  display: flex; align-items: center; gap: 12px;
  padding: 12px 14px; border-radius: var(--rs);
  border: 1px solid var(--bd); background: var(--surf);
  margin-bottom: 8px; transition: all 0.2s; cursor: pointer;
}
.act-row:hover { border-color: var(--bd2); box-shadow: var(--shadow-sm); }
.act-row.done { border-color: var(--em); background: var(--em-lt); }
.act-row.active-act { border-color: var(--blue); background: var(--blue-lt); }
.act-row:last-child { margin-bottom: 0; }
.act-check {
  width: 22px; height: 22px; border-radius: 50%;
  border: 2px solid var(--bd); display: flex; align-items: center;
  justify-content: center; flex-shrink: 0; transition: all 0.2s; cursor: pointer;
}
.act-check.done { background: var(--em); border-color: var(--em); }
.act-icon {
  width: 34px; height: 34px; border-radius: 9px;
  border: 1px solid; display: flex; align-items: center;
  justify-content: center; flex-shrink: 0;
}
.act-body { flex: 1; min-width: 0; }
.act-title-row { display: flex; align-items: center; gap: 6px; margin-bottom: 4px; flex-wrap: wrap; }
.act-title { font-size: 13px; font-weight: 600; }
.required-badge {
  font-size: 9px; font-weight: 700; padding: 2px 6px; border-radius: 10px;
  background: var(--co-lt); color: var(--co); border: 1px solid #FFB3C0;
}
.act-desc { font-size: 12px; color: var(--tx2); }
.act-meta { display: flex; flex-direction: column; align-items: flex-end; gap: 5px; flex-shrink: 0; }
.act-type-badge {
  font-size: 9px; font-weight: 700; padding: 2px 7px;
  border-radius: 10px; white-space: nowrap; border: 1px solid;
}
.act-duration { font-size: 11px; color: var(--tx2); display: inline-flex; align-items: center; gap: 2px; }

/* PHASE NAV */
.phase-nav { display: flex; justify-content: space-between; align-items: center; gap: 12px; }
.phase-nav-center { font-size: 12px; color: var(--tx2); text-align: center; }

/* RIGHT COL */
.right-col { display: flex; flex-direction: column; gap: 16px; }
.validation-row { display: flex; gap: 10px; align-items: flex-start; margin-bottom: 12px; }
.validation-icon {
  width: 36px; height: 36px; border-radius: 10px;
  border: 1px solid; display: flex; align-items: center;
  justify-content: center; flex-shrink: 0;
}
.validation-type { font-size: 13px; font-weight: 600; margin-bottom: 3px; }
.validation-threshold { font-size: 12px; color: var(--tx2); }
.validation-hint { font-size: 12px; color: var(--tx2); }

/* RESOURCE ITEM */
.res-item {
  display: flex; align-items: center; gap: 10px;
  padding: 10px 12px; border-radius: var(--rs);
  border: 1px solid var(--bd); background: var(--surf);
  margin-bottom: 8px; cursor: pointer; transition: all 0.18s;
}
.res-item:hover { border-color: var(--blue); box-shadow: var(--shadow-sm); }
.res-item:last-of-type { margin-bottom: 0; }
.res-icon-wrap {
  width: 32px; height: 32px; border-radius: 8px;
  background: var(--surf2); display: flex; align-items: center;
  justify-content: center; flex-shrink: 0;
}
.res-body { flex: 1; min-width: 0; }
.res-label { font-size: 12px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.res-meta { font-size: 10px; color: var(--tx2); }

/* OVERVIEW */
.overview-row { display: flex; align-items: center; gap: 10px; padding: 8px 0; border-bottom: 1px solid var(--bd); }
.overview-row:last-child { border-bottom: none; }
.overview-row.clickable { cursor: pointer; }
.overview-icon {
  width: 28px; height: 28px; border-radius: 8px;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.overview-body { flex: 1; min-width: 0; }
.overview-label { font-size: 12px; }
.overview-pct { font-size: 11px; font-weight: 700; min-width: 28px; text-align: right; }

/* RATING */
.rating-hint { font-size: 13px; color: var(--tx2); margin-bottom: 12px; }
.stars { display: flex; gap: 4px; cursor: pointer; }
.star { font-size: 22px; color: var(--bd2); transition: color 0.15s; cursor: pointer; }
.star.lit { color: var(--am); }
.rating-label { font-size: 11px; color: var(--tx2); margin-top: 6px; margin-bottom: 10px; }
.comment-field {
  width: 100%; padding: 10px 12px; border: 1px solid var(--bd);
  border-radius: var(--rs); background: var(--surf2); color: var(--tx);
  font-size: 13px; font-family: var(--fb); resize: none; height: 68px;
  transition: border 0.2s; box-sizing: border-box;
}
.comment-field:focus { border-color: var(--blue); outline: none; }
.comment-field::placeholder { color: var(--tx3); }

/* RESPONSIVE */
@media (max-width: 1050px) {
  .grid-main { grid-template-columns: 1fr; }
}
@media (max-width: 760px) {
  .phase-stepper { flex-wrap: wrap; gap: 8px; }
  .connector { display: none; }
  .page { padding: 16px; }
  .grid-4 { grid-template-columns: 1fr 1fr; }
}
@keyframes spin { from { transform: rotate(0deg) } to { transform: rotate(360deg) } }
</style>
