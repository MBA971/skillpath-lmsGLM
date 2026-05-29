<script setup>
import { ref, computed, inject, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useDataStore } from '../stores/data'
import {
  IconSearch,
  IconBooks,
  IconMessageCircle,
  IconCode,
  IconBriefcase,
  IconTag,
  IconClock,
  IconUsers,
  IconBookmark,
  IconShare,
  IconPlayerPlay,
  IconCheck,
  IconX,
  IconSparkles,
  IconHeart,
  IconMicrophone,
  IconExchange,
  IconBrain,
  IconTable,
  IconLock,
  IconDatabase,
  IconChartBar,
  IconTransfer,
  IconRefresh,
  IconClipboardList,
  IconCoin,
  IconBulb,
  IconUserPlus,
  IconSpeakerphone,
  IconLoader2,
  IconAlertTriangle
} from '@tabler/icons-vue'

const auth = useAuthStore()
const store = useDataStore()
const toast = inject('toast')

const ICON_MAP = {
  'ti-users': IconUsers,
  'ti-message': IconMessageCircle,
  'ti-heart': IconHeart,
  'ti-microphone': IconMicrophone,
  'ti-handshake': IconExchange,
  'ti-brain': IconBrain,
  'ti-code': IconCode,
  'ti-table': IconTable,
  'ti-lock': IconLock,
  'ti-database': IconDatabase,
  'ti-chart-bar': IconChartBar,
  'ti-arrows-transfer': IconTransfer,
  'ti-refresh': IconRefresh,
  'ti-clipboard-list': IconClipboardList,
  'ti-coin': IconCoin,
  'ti-bulb': IconBulb,
  'ti-user-plus': IconUserPlus,
  'ti-speakerphone': IconSpeakerphone,
}

function getIcon(ico) {
  return ICON_MAP[ico] || IconBooks
}

const CAT_ICON_MAP = {
  books: IconBooks,
  'message-circle': IconMessageCircle,
  code: IconCode,
  briefcase: IconBriefcase,
}

function getCatIcon(icon) {
  return CAT_ICON_MAP[icon] || IconBooks
}

const LVL_LBL = { deb: 'Débutant', int: 'Intermédiaire', avd: 'Avancé', exp: 'Expert' }
const LVL_CLS = { deb: 'level-deb', int: 'level-int', avd: 'level-avd', exp: 'level-exp' }

const STATIC_COURSES = [
  { id: 'c01', cat: 'Soft Skills', title: 'Leadership & Influence', lvl: 'exp', col: '#7B6FEE', ico: 'ti-users', dur: '12h', sc: 4.8, ins: 187, prg: 0, mod: ['Vidéo', 'Simulation', 'Quiz'], tag: 'new', desc: "Développez votre style de leadership situationnel et adaptez votre posture au niveau de maturité de chaque collaborateur. Études de cas issus d'organisations réelles.", comps: ['Leadership', 'Communication', 'Management'] },
  { id: 'c02', cat: 'Soft Skills', title: 'Communication Non Violente', lvl: 'int', col: '#FF9B21', ico: 'ti-message', dur: '6h', sc: 4.6, ins: 143, prg: 23, mod: ['Vidéo', 'Jeu de rôle', 'Podcast'], tag: '', desc: "Appliquer les 4 composantes CNV en contexte professionnel : observation, sentiment, besoin, demande. Pratique intensive avec mises en situation.", comps: ['Communication', 'Soft Skills'] },
  { id: 'c03', cat: 'Soft Skills', title: 'Gestion du stress & résilience', lvl: 'deb', col: '#7B6FEE', ico: 'ti-heart', dur: '4h', sc: 4.4, ins: 98, prg: 0, mod: ['Vidéo', 'Podcast', 'E-learning'], tag: '', desc: "Identifier vos sources de stress, développer votre résilience et pratiquer des techniques de régulation émotionnelle adaptées au contexte professionnel.", comps: ['Soft Skills', 'Bien-être'] },
  { id: 'c04', cat: 'Soft Skills', title: 'Prise de parole en public', lvl: 'int', col: '#FF4D6A', ico: 'ti-microphone', dur: '8h', sc: 4.7, ins: 112, prg: 0, mod: ['Présentiel', 'Simulation', 'Vidéo'], tag: 'popular', desc: "Structurer un discours, captiver son auditoire, gérer le trac. Entraînement avec feedback vidéo et coaching individuel.", comps: ['Communication', 'Leadership'] },
  { id: 'c05', cat: 'Soft Skills', title: 'Négociation commerciale', lvl: 'avd', col: '#FF9B21', ico: 'ti-handshake', dur: '10h', sc: 4.9, ins: 55, prg: 0, mod: ['Simulation', 'Jeu de rôle', 'Vidéo'], tag: '', desc: "Méthode Harvard, BATNA, gestion des objections et closing. Formation intense en jeu de rôle avec acteurs professionnels.", comps: ['Négociation', 'Communication'] },
  { id: 'c06', cat: 'Soft Skills', title: 'Intelligence émotionnelle', lvl: 'int', col: '#00D4A1', ico: 'ti-brain', dur: '5h', sc: 4.5, ins: 76, prg: 0, mod: ['E-learning', 'Quiz', 'Podcast'], tag: '', desc: "Comprendre et réguler ses émotions, développer l'empathie, améliorer ses relations professionnelles grâce au modèle de Goleman.", comps: ['Soft Skills', 'Management'] },
  { id: 'c07', cat: 'Technical Skills', title: 'Python Data Science', lvl: 'avd', col: '#1E6FFF', ico: 'ti-code', dur: '20h', sc: 4.9, ins: 98, prg: 0, mod: ['TP', 'Vidéo', 'Exercices'], tag: 'new', desc: "Maîtriser pandas, numpy, matplotlib et scikit-learn sur des données réelles. Projet fil rouge avec un dataset RH d'entreprise.", comps: ['Data & Analyse', 'Outils Digitaux'] },
  { id: 'c08', cat: 'Technical Skills', title: 'Excel Avancé — Tableaux de bord', lvl: 'deb', col: '#00D4A1', ico: 'ti-table', dur: '5h', sc: 4.5, ins: 312, prg: 100, mod: ['E-learning', 'Exercices', 'Quiz'], tag: '', desc: "Tableaux croisés dynamiques, Power Query, formules avancées et construction de dashboards professionnels avec mises en forme conditionnelles.", comps: ['Outils Digitaux', 'Data & Analyse'] },
  { id: 'c09', cat: 'Technical Skills', title: 'Cybersécurité fondamentaux', lvl: 'deb', col: '#FF4D6A', ico: 'ti-lock', dur: '6h', sc: 4.3, ins: 85, prg: 0, mod: ['Vidéo', 'Quiz', 'Simulation'], tag: '', desc: "Bonnes pratiques de sécurité informatique en entreprise : phishing, mots de passe, RGPD, gestion des accès et gestion des incidents.", comps: ['Cybersécurité', 'Technical Skills'] },
  { id: 'c10', cat: 'Technical Skills', title: 'SQL & Bases de données', lvl: 'int', col: '#1E6FFF', ico: 'ti-database', dur: '12h', sc: 4.6, ins: 72, prg: 0, mod: ['TP', 'Vidéo', 'Exercices guidés'], tag: '', desc: "Requêtes SELECT, jointures, agrégations, sous-requêtes et optimisation. Comprendre les SGBD relationnels en contexte métier avec PostgreSQL.", comps: ['Data & Analyse', 'Technical Skills'] },
  { id: 'c11', cat: 'Technical Skills', title: 'Power BI — Visualisation data', lvl: 'int', col: '#7B6FEE', ico: 'ti-chart-bar', dur: '8h', sc: 4.7, ins: 64, prg: 0, mod: ['E-learning', 'TP', 'Quiz'], tag: 'popular', desc: "Connecter des sources de données, modéliser avec DAX et publier des rapports interactifs. Cas d'usage RH, finance et commercial.", comps: ['Data & Analyse', 'Outils Digitaux'] },
  { id: 'c12', cat: 'Technical Skills', title: 'No-code — Automatiser avec Zapier', lvl: 'deb', col: '#FF9B21', ico: 'ti-arrows-transfer', dur: '4h', sc: 4.4, ins: 48, prg: 0, mod: ['Vidéo', 'TP', 'E-learning'], tag: 'new', desc: "Créer des automatisations sans code entre vos outils SaaS : Slack, Google Sheets, Notion, HubSpot. Gain de temps immédiat.", comps: ['Outils Digitaux', 'Productivité'] },
  { id: 'c13', cat: 'Functional Skills', title: 'Management Agile — SCRUM', lvl: 'int', col: '#00D4A1', ico: 'ti-refresh', dur: '8h', sc: 4.8, ins: 234, prg: 67, mod: ['Présentiel', 'E-learning', 'Quiz'], tag: 'popular', desc: "Acquérir les fondamentaux Scrum et Kanban. Comprendre le rôle du manager dans une équipe auto-organisée et animer son premier sprint.", comps: ['Agilité', 'Management', 'Leadership'] },
  { id: 'c14', cat: 'Functional Skills', title: 'Gestion de projet — PMP Ready', lvl: 'int', col: '#FF4D6A', ico: 'ti-clipboard-list', dur: '15h', sc: 4.6, ins: 120, prg: 0, mod: ['Présentiel', 'E-learning', 'Quiz'], tag: '', desc: "Cadrage, planification WBS, gestion des risques, maîtrise des délais et coûts, clôture de projet. Méthodologies classiques et hybrides.", comps: ['Management', 'Functional Skills'] },
  { id: 'c15', cat: 'Functional Skills', title: 'Finance pour non-financiers', lvl: 'avd', col: '#FF9B21', ico: 'ti-coin', dur: '12h', sc: 4.6, ins: 76, prg: 0, mod: ['Vidéo', 'Cas pratiques', 'Quiz'], tag: '', desc: "Comprendre le bilan, le compte de résultat et le cash-flow. Piloter un budget, analyser la rentabilité et parler finance avec la direction.", comps: ['Finance', 'Functional Skills'] },
  { id: 'c16', cat: 'Functional Skills', title: 'Design Thinking & Innovation', lvl: 'int', col: '#7B6FEE', ico: 'ti-bulb', dur: '8h', sc: 4.7, ins: 64, prg: 0, mod: ['Atelier', 'Vidéo', 'Exercice'], tag: '', desc: "Appliquer la démarche en 5 étapes : empathie, définition, idéation, prototypage, test. Animez vos propres ateliers d'innovation.", comps: ['Innovation', 'Functional Skills'] },
  { id: 'c17', cat: 'Functional Skills', title: 'Recrutement & marque employeur', lvl: 'int', col: '#FF4D6A', ico: 'ti-user-plus', dur: '6h', sc: 4.5, ins: 88, prg: 0, mod: ['Vidéo', 'Simulation', 'Quiz'], tag: '', desc: "Structurer un processus de recrutement inclusif, rédiger des offres attractives et conduire des entretiens comportementaux (STAR, STAR-L).", comps: ['RH', 'Functional Skills'] },
  { id: 'c18', cat: 'Functional Skills', title: 'Marketing Digital & SEO', lvl: 'avd', col: '#1E6FFF', ico: 'ti-speakerphone', dur: '18h', sc: 4.7, ins: 62, prg: 0, mod: ['E-learning', 'TP', 'Cas pratique'], tag: 'new', desc: "Stratégie de contenu, SEO on/off-page, Google Ads, analytics et marketing automation. Projet fil rouge avec un vrai site à optimiser.", comps: ['Marketing', 'Outils Digitaux'] },
]

const COURSES = computed(() => store.courses.length ? store.courses : STATIC_COURSES)

const CATS = [
  { id: 'all', label: 'Tout le catalogue', icon: 'books', col: '#1E6FFF' },
  { id: 'Soft Skills', label: 'Soft Skills', icon: 'message-circle', col: '#7B6FEE' },
  { id: 'Technical Skills', label: 'Technical', icon: 'code', col: '#1E6FFF' },
  { id: 'Functional Skills', label: 'Functional', icon: 'briefcase', col: '#00D4A1' },
]

const CAT_META = {
  'Soft Skills': { icon: 'message-circle', col: '#7B6FEE' },
  'Technical Skills': { icon: 'code', col: '#1E6FFF' },
  'Functional Skills': { icon: 'briefcase', col: '#00D4A1' },
}

const CAT_PILL_CLS = {
  'Soft Skills': 'pill-purple',
  'Technical Skills': 'pill-blue',
  'Functional Skills': 'pill-green',
}

const activeCat = ref('all')
const searchQuery = ref('')
const filterLevel = ref('')
const filterModality = ref('')
const filterSort = ref('popular')
const showModal = ref(false)
const selectedCourse = ref(null)
const pageLoading = ref(false)
const pageError = ref(null)

const filtered = computed(() => {
  let result = COURSES.filter(c => {
    if (activeCat.value !== 'all' && c.cat !== activeCat.value) return false
    if (filterLevel.value && c.lvl !== filterLevel.value) return false
    if (filterModality.value) {
      const modMap = { elearning: 'E-learning', presentiel: 'Présentiel', video: 'Vidéo', podcast: 'Podcast' }
      const target = modMap[filterModality.value]
      if (target && !c.mod.includes(target)) return false
    }
    if (searchQuery.value && !c.title.toLowerCase().includes(searchQuery.value.toLowerCase()) && !c.cat.toLowerCase().includes(searchQuery.value.toLowerCase()) && !c.comps.join(' ').toLowerCase().includes(searchQuery.value.toLowerCase())) return false
    return true
  })
  if (filterSort.value === 'rating') result = [...result].sort((a, b) => b.sc - a.sc)
  if (filterSort.value === 'popular') result = [...result].sort((a, b) => b.ins - a.ins)
  if (filterSort.value === 'short') result = [...result].sort((a, b) => parseInt(a.dur) - parseInt(b.dur))
  return result
})

const displayCategories = computed(() => {
  if (activeCat.value === 'all') return ['Soft Skills', 'Technical Skills', 'Functional Skills']
  return [activeCat.value]
})

function catCount(catId) {
  if (catId === 'all') return COURSES.length
  return COURSES.filter(c => c.cat === catId).length
}

function sectionItems(cat) {
  return filtered.value.filter(c => c.cat === cat)
}

function btnLabel(c) {
  if (c.prg === 100) return 'Revoir'
  if (c.prg > 0) return 'Reprendre'
  return 'Commencer'
}

function openCourseModal(c) {
  selectedCourse.value = c
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  selectedCourse.value = null
}

function resetFilters() {
  searchQuery.value = ''
  filterLevel.value = ''
  filterModality.value = ''
  activeCat.value = 'all'
}

function startCourse(c) {
  const label = c.prg > 0 && c.prg < 100 ? 'Reprise' : 'Démarrage'
  toast.success(`${label} : ${c.title}`)
  if (auth.profile?.id && c.id) {
    store.createEnrollment({ user_id: auth.profile.id, course_id: c.id, progress: c.prg || 0 })
  }
  closeModal()
}

onMounted(async () => {
  pageLoading.value = true
  pageError.value = null
  try {
    if (auth.profile?.id) await store.fetchCourses()
  } catch (e) {
    pageError.value = e.message
  } finally {
    pageLoading.value = false
  }
})
</script>

<template>
  <div class="page">
    <div v-if="pageLoading" class="loading-card fade-in">
      <IconLoader2 :size="32" class="spin" />
      <div style="margin-top: 12px; font-size: 14px; color: var(--tx2)">Chargement du catalogue...</div>
    </div>
    <div v-else-if="pageError" class="error-card fade-in">
      <IconAlertTriangle :size="32" color="var(--co)" />
      <div style="margin-top: 12px; font-family: var(--fh); font-size: 16px; font-weight: 700">Erreur de chargement</div>
      <div style="font-size: 13px; color: var(--tx2); margin-top: 4px">{{ pageError }}</div>
      <button class="btn btn-primary btn-sm" style="margin-top: 14px" @click="() => { pageError = null; onMounted() }">Réessayer</button>
    </div>
    <template v-else>
    <div class="hero fade-in" style="margin-bottom: 22px">
      <div class="hero-left">
        <div class="hero-tag">Catalogue de formations</div>
        <div class="hero-title">Développez vos compétences</div>
        <div class="hero-sub">Parcourez nos formations sur-étagère en 3 domaines, 4 niveaux et 7 modalités pédagogiques.</div>
      </div>
      <div class="hero-stats">
        <div class="hstat">
          <div class="hstat-val">124</div>
          <div class="hstat-lbl">Formations</div>
        </div>
        <div class="hstat">
          <div class="hstat-val">18</div>
          <div class="hstat-lbl">Certifications</div>
        </div>
        <div class="hstat">
          <div class="hstat-val">4.6</div>
          <div class="hstat-lbl">Note moy.</div>
        </div>
      </div>
    </div>

    <div class="filter-bar fade-in">
      <div class="search-wrap">
        <IconSearch :size="14" color="var(--tx3)" />
        <input v-model="searchQuery" type="text" placeholder="Rechercher une formation, un thème, une compétence..." />
      </div>
      <select v-model="filterLevel" class="sel">
        <option value="">Tous niveaux</option>
        <option value="deb">Débutant</option>
        <option value="int">Intermédiaire</option>
        <option value="avd">Avancé</option>
        <option value="exp">Expert</option>
      </select>
      <select v-model="filterModality" class="sel">
        <option value="">Toutes modalités</option>
        <option value="elearning">E-learning</option>
        <option value="presentiel">Présentiel</option>
        <option value="video">Vidéo</option>
        <option value="podcast">Podcast</option>
      </select>
      <select v-model="filterSort" class="sel">
        <option value="popular">Tri : Popularité</option>
        <option value="rating">Tri : Meilleures notes</option>
        <option value="new">Tri : Nouveautés</option>
        <option value="short">Tri : + Court d'abord</option>
      </select>
      <div class="filter-count">
        <IconBooks :size="14" />
        <strong>{{ filtered.length }}</strong> formations
      </div>
    </div>

    <div class="cat-tabs">
      <div
        v-for="cat in CATS"
        :key="cat.id"
        class="cat-tab"
        :class="{ on: activeCat === cat.id }"
        :style="activeCat === cat.id ? { background: cat.col, borderColor: cat.col } : {}"
        @click="activeCat = cat.id"
      >
        <component :is="getCatIcon(cat.icon)" :size="15" :color="activeCat === cat.id ? '#fff' : 'inherit'" />
        {{ cat.label }}
        <span class="ct-count">{{ catCount(cat.id) }}</span>
      </div>
    </div>

    <div v-if="!filtered.length" class="empty fade-in">
      <IconSearch :size="42" style="opacity: 0.3" />
      <div style="font-family: var(--fh); font-size: 16px; font-weight: 700">Aucune formation trouvée</div>
      <div style="font-size: 13px">Essayez de modifier vos filtres</div>
      <button class="btn btn-sm" @click="resetFilters">Réinitialiser les filtres</button>
    </div>

    <template v-else>
      <div v-for="cat in displayCategories" :key="cat" style="margin-bottom: 30px">
        <div v-if="sectionItems(cat).length" class="sec-hdr">
          <div class="sec-title">
            <div
              :style="{
                width: '32px',
                height: '32px',
                borderRadius: '8px',
                background: CAT_META[cat].col + '18',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }"
            >
              <component :is="getCatIcon(CAT_META[cat].icon)" :size="17" :color="CAT_META[cat].col" />
            </div>
            {{ cat }}
            <span style="font-size: 12px; font-weight: 400; color: var(--tx2)">
              {{ sectionItems(cat).length }} formation{{ sectionItems(cat).length > 1 ? 's' : '' }}
            </span>
          </div>
        </div>
        <div v-if="sectionItems(cat).length" class="grid-3 stagger">
          <div v-for="c in sectionItems(cat)" :key="c.id" class="ccard" @click="openCourseModal(c)">
            <div class="cthumb" :style="{ background: c.col + '18' }">
              <component :is="getIcon(c.ico)" :size="38" :color="c.col" />
              <span class="pill" :class="LVL_CLS[c.lvl]" style="position: absolute; top: 10px; right: 10px">
                {{ LVL_LBL[c.lvl] }}
              </span>
              <div v-if="c.tag === 'new'" class="c-badge" style="background: var(--blue); color: #fff">&#10022; Nouveau</div>
              <div v-else-if="c.tag === 'popular'" class="c-badge" style="background: var(--am); color: #fff">&#128293; Populaire</div>
              <div v-if="c.prg === 100" class="c-badge" style="background: var(--em); color: #fff; left: 10px; top: auto; bottom: 10px">&#10003; Terminé</div>
            </div>
            <div class="cbody">
              <div class="c-cat">
                <IconTag :size="10" />
                {{ c.cat }}
              </div>
              <div class="c-title">{{ c.title }}</div>
              <div class="c-mod">{{ c.mod.join(' · ') }}</div>
              <div v-if="c.prg > 0 && c.prg < 100" class="c-prg">
                <div class="bar">
                  <div class="bf" :style="{ width: c.prg + '%', background: c.col }"></div>
                </div>
                <div style="font-size: 10px; color: var(--tx2); margin-top: 3px">{{ c.prg }}% complété</div>
              </div>
              <div class="c-meta">
                <span><IconClock :size="11" /> {{ c.dur }}</span>
                <span style="color: var(--am)">&#9733; {{ c.sc }}</span>
                <span><IconUsers :size="11" /> {{ c.ins }}</span>
              </div>
              <button
                class="btn btn-primary btn-sm"
                style="width: 100%; justify-content: center"
                @click.stop="startCourse(c)"
              >
                <IconPlayerPlay :size="12" />
                {{ btnLabel(c) }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>

    <div v-if="showModal && selectedCourse" class="modal-overlay open" @click.self="closeModal">
      <div class="modal">
        <div class="modal-thumb" :style="{ background: selectedCourse.col + '18' }">
          <component :is="getIcon(selectedCourse.ico)" :size="54" :color="selectedCourse.col" />
          <button class="modal-close" @click="closeModal">
            <IconX :size="16" color="#fff" />
          </button>
        </div>
        <div class="modal-body">
          <div style="margin-bottom: 6px">
            <div style="font-family: var(--fh); font-size: 20px; font-weight: 800; margin-bottom: 8px">
              {{ selectedCourse.title }}
            </div>
            <div style="display: flex; gap: 8px; flex-wrap: wrap; align-items: center; margin-bottom: 14px">
              <span class="pill" :class="LVL_CLS[selectedCourse.lvl]">{{ LVL_LBL[selectedCourse.lvl] }}</span>
              <span class="pill pill-gray"><IconClock :size="10" /> {{ selectedCourse.dur }}</span>
              <span class="pill pill-gray" style="color: var(--am)">&#9733; {{ selectedCourse.sc }}</span>
              <span class="pill pill-gray"><IconUsers :size="10" /> {{ selectedCourse.ins }} inscrits</span>
              <span class="pill" :class="CAT_PILL_CLS[selectedCourse.cat]">{{ selectedCourse.cat }}</span>
            </div>
          </div>

          <div style="font-size: 13px; color: var(--tx2); line-height: 1.7; margin-bottom: 18px">
            {{ selectedCourse.desc }}
          </div>

          <div v-if="selectedCourse.prg > 0 && selectedCourse.prg < 100" style="margin-bottom: 16px">
            <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 5px">
              <span style="color: var(--tx2)">Votre progression</span>
              <span style="font-weight: 700" :style="{ color: selectedCourse.col }">{{ selectedCourse.prg }}%</span>
            </div>
            <div class="bar" style="height: 8px">
              <div class="bf" :style="{ width: selectedCourse.prg + '%', background: selectedCourse.col }"></div>
            </div>
          </div>

          <div style="margin-bottom: 16px">
            <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; color: var(--tx2); margin-bottom: 8px">
              Modalités pédagogiques
            </div>
            <div style="display: flex; gap: 6px; flex-wrap: wrap">
              <span v-for="m in selectedCourse.mod" :key="m" class="pill pill-gray">
                <IconCheck :size="10" color="var(--em)" />
                {{ m }}
              </span>
            </div>
          </div>

          <div style="margin-bottom: 22px">
            <div style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; color: var(--tx2); margin-bottom: 8px">
              Compétences développées
            </div>
            <div style="display: flex; gap: 6px; flex-wrap: wrap">
              <span v-for="comp in selectedCourse.comps" :key="comp" class="pill pill-blue">{{ comp }}</span>
            </div>
          </div>

          <div style="display: flex; gap: 10px; flex-wrap: wrap">
            <button class="btn btn-primary" @click="startCourse(selectedCourse)">
              <IconPlayerPlay :size="16" />
              {{ selectedCourse.prg === 100 ? 'Revoir la formation' : selectedCourse.prg > 0 ? 'Reprendre' : 'Commencer la formation' }}
            </button>
<button class="btn btn-sm" style="background: transparent" @click="async () => { await store.createEnrollment({ user_id: auth.profile.id, course_id: selectedCourse.id, status: 'bookmarked' }); toast('Formation ajoutée à ma liste !') }">
      <IconBookmark :size="14" />
      Sauvegarder
    </button>
    <button class="btn btn-sm" style="background: transparent" @click="async () => { await store.sendMessage(auth.profile.id, null, { type: 'course_share', course_id: selectedCourse.id }); toast('Formation partagée !') }">
      <IconShare :size="14" />
              Partager
            </button>
          </div>
        </div>
      </div>
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
  margin-bottom: 26px;
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
  right: -50px;
  top: -50px;
  width: 240px;
  height: 240px;
  border-radius: 50%;
  background: var(--blue);
  opacity: 0.07;
}
.hero::after {
  content: '';
  position: absolute;
  left: 40%;
  bottom: -80px;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background: var(--em);
  opacity: 0.05;
}
.hero-left {
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
  line-height: 1.6;
}
.hero-stats {
  display: flex;
  gap: 24px;
  position: relative;
  z-index: 1;
  flex-shrink: 0;
}
.hstat {
  text-align: center;
  padding: 14px 18px;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.hstat-val {
  font-family: var(--fh);
  font-size: 22px;
  font-weight: 800;
  color: #fff;
}
.hstat-lbl {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.4);
  margin-top: 2px;
  text-transform: uppercase;
  letter-spacing: 0.8px;
}

.filter-bar {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  padding: 16px 20px;
  margin-bottom: 22px;
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
  box-shadow: var(--shadow-sm);
}
.search-wrap {
  display: flex;
  align-items: center;
  gap: 8px;
  background: var(--surf2);
  border: 1px solid var(--bd);
  border-radius: 22px;
  padding: 8px 14px;
  flex: 1;
  min-width: 180px;
  transition: border 0.2s;
}
.search-wrap:focus-within {
  border-color: var(--blue);
}
.search-wrap input {
  background: none;
  border: none;
  outline: none;
  color: var(--tx);
  font-size: 13px;
  font-family: var(--fb);
  width: 100%;
}
.search-wrap input::placeholder {
  color: var(--tx3);
}
.sel {
  padding: 8px 12px;
  border: 1px solid var(--bd);
  border-radius: var(--rs);
  background: var(--surf2);
  color: var(--tx);
  font-size: 13px;
  font-family: var(--fb);
  cursor: pointer;
  transition: border 0.2s;
}
.sel:focus {
  outline: none;
  border-color: var(--blue);
}
.filter-count {
  margin-left: auto;
  font-size: 13px;
  color: var(--tx2);
  white-space: nowrap;
  display: flex;
  align-items: center;
  gap: 6px;
}

.cat-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}
.cat-tab {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 9px 16px;
  border-radius: 10px;
  border: 1px solid var(--bd);
  background: var(--surf);
  font-size: 13px;
  font-weight: 600;
  font-family: var(--fb);
  cursor: pointer;
  transition: all 0.18s;
  color: var(--tx2);
}
.cat-tab:hover {
  border-color: var(--bd2);
  color: var(--tx);
}
.cat-tab.on {
  color: #fff;
  border-color: transparent;
}
.ct-count {
  font-size: 10px;
  font-weight: 700;
  padding: 1px 6px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.25);
}
.cat-tab:not(.on) .ct-count {
  background: var(--surf2);
  color: var(--tx2);
}

.sec-hdr {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}
.sec-title {
  font-family: var(--fh);
  font-size: 15px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 10px;
}

.grid-3 {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.ccard {
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  overflow: hidden;
  cursor: pointer;
  transition: all 0.22s;
  box-shadow: var(--shadow-sm);
  display: flex;
  flex-direction: column;
}
.ccard:hover {
  border-color: var(--blue);
  transform: translateY(-3px);
  box-shadow: var(--shadow-md);
}
.cthumb {
  height: 114px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  flex-shrink: 0;
}
.c-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  font-size: 9px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 10px;
}
.cbody {
  padding: 14px 16px;
  flex: 1;
  display: flex;
  flex-direction: column;
}
.c-cat {
  font-size: 10px;
  color: var(--tx2);
  margin-bottom: 4px;
  display: flex;
  align-items: center;
  gap: 4px;
}
.c-title {
  font-size: 13px;
  font-weight: 700;
  margin-bottom: 6px;
  line-height: 1.35;
  flex: 1;
}
.c-mod {
  font-size: 11px;
  color: var(--tx2);
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.c-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  font-size: 11px;
  color: var(--tx2);
}
.c-meta span {
  display: inline-flex;
  align-items: center;
  gap: 3px;
}
.c-prg {
  margin-bottom: 6px;
}

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
  color: #1a4aaa;
  border: 1px solid var(--blue-md);
}
.pill-green {
  background: var(--em-lt);
  color: #005a42;
  border: 1px solid #a8edd8;
}
.pill-amber {
  background: var(--am-lt);
  color: #6b3b00;
  border: 1px solid #ffd280;
}
.pill-coral {
  background: var(--co-lt);
  color: #7a0020;
  border: 1px solid #ffb3c0;
}
.pill-purple {
  background: var(--pu-lt);
  color: #3c3480;
  border: 1px solid #c8c4f5;
}
.pill-gray {
  background: var(--surf2);
  color: var(--tx2);
  border: 1px solid var(--bd);
}
.level-deb {
  background: var(--em-lt);
  color: #005a42;
  border: 1px solid #a8edd8;
}
.level-int {
  background: var(--am-lt);
  color: #6b3b00;
  border: 1px solid #ffd280;
}
.level-avd {
  background: var(--pu-lt);
  color: #3c3480;
  border: 1px solid #c8c4f5;
}
.level-exp {
  background: var(--co-lt);
  color: #7a0020;
  border: 1px solid #ffb3c0;
}

.bar {
  height: 5px;
  background: var(--surf2);
  border-radius: 4px;
  overflow: hidden;
}
.bf {
  height: 100%;
  border-radius: 4px;
  transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
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
  background: #1658d8;
  border-color: #1658d8;
  color: #fff;
}
.btn-sm {
  padding: 5px 12px;
  font-size: 12px;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.55);
  z-index: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}
.modal {
  background: var(--surf);
  border-radius: var(--rl);
  padding: 0;
  max-width: 620px;
  width: 100%;
  max-height: 88vh;
  overflow-y: auto;
  box-shadow: 0 24px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid var(--bd);
}
.modal-thumb {
  height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--rl) var(--rl) 0 0;
  position: relative;
  flex-shrink: 0;
}
.modal-body {
  padding: 24px 28px 28px;
}
.modal-close {
  position: absolute;
  top: 14px;
  right: 14px;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.15);
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.18s;
}
.modal-close:hover {
  background: rgba(255, 255, 255, 0.25);
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 20px;
  gap: 12px;
  color: var(--tx2);
  text-align: center;
}

.loading-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 64px 20px;
  background: var(--surf);
  border: 1px solid var(--bd);
  border-radius: var(--r);
  text-align: center;
}

.error-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 20px;
  background: var(--surf);
  border: 2px solid var(--co);
  border-radius: var(--r);
  text-align: center;
}

.spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes fadeUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.fade-in {
  animation: fadeUp 0.3s ease forwards;
}
.stagger > * {
  opacity: 0;
  animation: fadeUp 0.3s ease forwards;
}
.stagger > *:nth-child(1) { animation-delay: 0.04s; }
.stagger > *:nth-child(2) { animation-delay: 0.08s; }
.stagger > *:nth-child(3) { animation-delay: 0.12s; }
.stagger > *:nth-child(4) { animation-delay: 0.16s; }
.stagger > *:nth-child(5) { animation-delay: 0.20s; }
.stagger > *:nth-child(6) { animation-delay: 0.24s; }
.stagger > *:nth-child(7) { animation-delay: 0.28s; }
.stagger > *:nth-child(8) { animation-delay: 0.32s; }
.stagger > *:nth-child(9) { animation-delay: 0.36s; }

@media (max-width: 1100px) {
  .grid-3 {
    grid-template-columns: 1fr 1fr;
  }
}
@media (max-width: 760px) {
  .grid-3 {
    grid-template-columns: 1fr;
  }
  .hero {
    flex-direction: column;
  }
  .hero-stats {
    flex-direction: row;
    width: 100%;
  }
  .filter-bar {
    flex-direction: column;
  }
  .page {
    padding: 16px;
  }
}
</style>
