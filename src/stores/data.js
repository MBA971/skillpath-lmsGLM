import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '../lib/supabase'

export const useDataStore = defineStore('data', () => {
  const courses = ref([])
  const formations = ref([])
  const companies = ref([])
  const sessions = ref([])
  const enrollments = ref([])
  const competencies = ref([])
  const competencyScores = ref({})
  const resources = ref([])
  const developmentPlanResources = ref({})
  const quizzes = ref([])
  const quizQuestions = ref([])
  const quizAttempts = ref([])
  const messages = ref({})
  const badges = ref([])
  const pathPhases = ref([])
  const pathActivities = ref([])
  const loading = ref(false)
  const error = ref(null)

  const masteredCompetencies = computed(() =>
    competencies.value.filter(c => competencyScores.value[c.id]?.status === 'mastered')
  )
  const progressCompetencies = computed(() =>
    competencies.value.filter(c => competencyScores.value[c.id]?.status === 'progress')
  )
  const weakCompetencies = computed(() =>
    competencies.value.filter(c => competencyScores.value[c.id]?.status === 'weak')
  )

  async function fetchCourses(filters = {}) {
    loading.value = true
    error.value = null
    let query = supabase.from('courses').select('*')

    if (filters.cat) query = query.eq('cat', filters.cat)
    if (filters.lvl) query = query.eq('lvl', filters.lvl)
    if (filters.tag) query = query.eq('tag', filters.tag)

    const { data, error: err } = await query
    loading.value = false
    if (err) { error.value = err; return { data: null, error: err } }
    courses.value = data
    return { data, error: null }
  }

  async function fetchCourseById(id) {
    const { data, error: err } = await supabase.from('courses').select('*').eq('id', id).single()
    if (err) return { data: null, error: err }
    return { data, error: null }
  }

  async function createCourse(course) {
    const { data, error: err } = await supabase.from('courses').insert(course).select().single()
    if (err) return { data: null, error: err }
    courses.value.push(data)
    return { data, error: null }
  }

  async function updateCourse(id, updates) {
    const { data, error: err } = await supabase.from('courses').update(updates).eq('id', id).select().single()
    if (err) return { data: null, error: err }
    const idx = courses.value.findIndex(c => c.id === id)
    if (idx !== -1) courses.value[idx] = data
    return { data, error: null }
  }

  async function deleteCourse(id) {
    const { error: err } = await supabase.from('courses').delete().eq('id', id)
    if (err) return { error: err }
    courses.value = courses.value.filter(c => c.id !== id)
    return { error: null }
  }

  async function fetchFormations() {
    loading.value = true
    error.value = null
    const { data, error: err } = await supabase.from('formations').select('*')
    loading.value = false
    if (err) { error.value = err; return { data: null, error: err } }
    formations.value = data
    return { data, error: null }
  }

  async function createFormation(formation) {
    const { data, error: err } = await supabase.from('formations').insert(formation).select().single()
    if (err) return { data: null, error: err }
    formations.value.push(data)
    return { data, error: null }
  }

  async function updateFormation(id, updates) {
    const { data, error: err } = await supabase.from('formations').update(updates).eq('id', id).select().single()
    if (err) return { data: null, error: err }
    const idx = formations.value.findIndex(f => f.id === id)
    if (idx !== -1) formations.value[idx] = data
    return { data, error: null }
  }

  async function fetchCompanies() {
    loading.value = true
    const { data, error: err } = await supabase.from('companies').select('*')
    loading.value = false
    if (err) { error.value = err; return { data: null, error: err } }
    companies.value = data
    return { data, error: null }
  }

  async function fetchCompanyById(id) {
    const { data, error: err } = await supabase.from('companies').select('*').eq('id', id).single()
    if (err) return { data: null, error: err }
    return { data, error: null }
  }

  async function createCompany(company) {
    const { data, error: err } = await supabase.from('companies').insert(company).select().single()
    if (err) return { data: null, error: err }
    companies.value.push(data)
    return { data, error: null }
  }

  async function updateCompany(id, updates) {
    const { data, error: err } = await supabase.from('companies').update(updates).eq('id', id).select().single()
    if (err) return { data: null, error: err }
    const idx = companies.value.findIndex(c => c.id === id)
    if (idx !== -1) companies.value[idx] = data
    return { data, error: null }
  }

  async function fetchSessions(filters = {}) {
    loading.value = true
    let query = supabase.from('sessions').select('*')

    if (filters.status) query = query.eq('status', filters.status)
    if (filters.formateur_id) query = query.eq('formateur_id', filters.formateur_id)
    if (filters.from) query = query.gte('date', filters.from)
    if (filters.to) query = query.lte('date', filters.to)

    const { data, error: err } = await query.order('date', { ascending: true })
    loading.value = false
    if (err) { error.value = err; return { data: null, error: err } }
    sessions.value = data
    return { data, error: null }
  }

  async function createSession(session) {
    const { data, error: err } = await supabase.from('sessions').insert(session).select().single()
    if (err) return { data: null, error: err }
    sessions.value.push(data)
    return { data, error: null }
  }

  async function updateSession(id, updates) {
    const { data, error: err } = await supabase.from('sessions').update(updates).eq('id', id).select().single()
    if (err) return { data: null, error: err }
    const idx = sessions.value.findIndex(s => s.id === id)
    if (idx !== -1) sessions.value[idx] = data
    return { data, error: null }
  }

  async function deleteSession(id) {
    const { error: err } = await supabase.from('sessions').delete().eq('id', id)
    if (err) return { error: err }
    sessions.value = sessions.value.filter(s => s.id !== id)
    return { error: null }
  }

  async function fetchEnrollments(userId) {
    const { data, error: err } = await supabase.from('enrollments').select('*').eq('user_id', userId)
    if (err) return { data: null, error: err }
    enrollments.value = data
    return { data, error: null }
  }

  async function createEnrollment(enrollment) {
    const { data, error: err } = await supabase.from('enrollments').insert(enrollment).select().single()
    if (err) return { data: null, error: err }
    enrollments.value.push(data)
    return { data, error: null }
  }

  async function updateEnrollment(id, updates) {
    const { data, error: err } = await supabase.from('enrollments').update(updates).eq('id', id).select().single()
    if (err) return { data: null, error: err }
    const idx = enrollments.value.findIndex(e => e.id === id)
    if (idx !== -1) enrollments.value[idx] = data
    return { data, error: null }
  }

  async function fetchCompetencies() {
    const { data, error: err } = await supabase.from('competencies').select('*')
    if (err) return { data: null, error: err }
    competencies.value = data
    return { data, error: null }
  }

  async function fetchCompetencyScores(userId) {
    const { data, error: err } = await supabase.from('competency_scores').select('*').eq('user_id', userId)
    if (err) return { data: null, error: err }

    const map = {}
    for (const row of data) {
      const status = row.score >= 75 ? 'mastered' : row.score >= 50 ? 'progress' : row.score > 0 ? 'weak' : 'locked'
      map[row.competency_id] = { score: row.score, status }
    }
    competencyScores.value = map
    return { data, error: null }
  }

  async function upsertCompetencyScore(userId, competencyId, score) {
    const status = score >= 75 ? 'mastered' : score >= 50 ? 'progress' : score > 0 ? 'weak' : 'locked'
    const { data, error: err } = await supabase
      .from('competency_scores')
      .upsert({ user_id: userId, competency_id: competencyId, score }, { onConflict: 'user_id,competency_id' })
      .select()
      .single()

    if (err) return { data: null, error: err }
    competencyScores.value[competencyId] = { score, status }
    return { data, error: null }
  }

  async function fetchResources(filters = {}) {
    let query = supabase.from('resources').select('*')
    if (filters.comp) query = query.eq('comp', filters.comp)
    if (filters.type) query = query.eq('type', filters.type)
    if (filters.level) query = query.eq('level', filters.level)

    const { data, error: err } = await query
    if (err) return { data: null, error: err }
    resources.value = data
    return { data, error: null }
  }

  async function createResource(resource) {
    const { data, error: err } = await supabase.from('resources').insert(resource).select().single()
    if (err) return { data: null, error: err }
    resources.value.push(data)
    return { data, error: null }
  }

  async function fetchDevelopmentPlanResources(userId) {
    const { data, error: err } = await supabase.from('development_plan_resources').select('*').eq('user_id', userId)
    if (err) return { data: null, error: err }

    const map = {}
    for (const row of data) {
      if (!map[row.competency_id]) map[row.competency_id] = []
      map[row.competency_id].push(row.resource_id)
    }
    developmentPlanResources.value = map
    return { data, error: null }
  }

  async function assignResourceToPlan(userId, competencyId, resourceId) {
    const { data, error: err } = await supabase
      .from('development_plan_resources')
      .insert({ user_id: userId, competency_id: competencyId, resource_id: resourceId })
      .select()
      .single()

    if (err) return { data: null, error: err }
    if (!developmentPlanResources.value[competencyId]) developmentPlanResources.value[competencyId] = []
    developmentPlanResources.value[competencyId].push(resourceId)
    return { data, error: null }
  }

  async function removeResourceFromPlan(userId, competencyId, resourceId) {
    const { error: err } = await supabase
      .from('development_plan_resources')
      .delete()
      .eq('user_id', userId)
      .eq('competency_id', competencyId)
      .eq('resource_id', resourceId)

    if (err) return { error: err }
    if (developmentPlanResources.value[competencyId]) {
      developmentPlanResources.value[competencyId] = developmentPlanResources.value[competencyId].filter(r => r !== resourceId)
    }
    return { error: null }
  }

  async function fetchQuizzes(filters = {}) {
    let query = supabase.from('quizzes').select('*, quiz_questions(*)')
    if (filters.formation) query = query.eq('formation', filters.formation)
    if (filters.level) query = query.eq('level', filters.level)

    const { data, error: err } = await query
    if (err) return { data: null, error: err }
    quizzes.value = data
    return { data, error: null }
  }

  async function fetchQuizById(id) {
    const { data, error: err } = await supabase.from('quizzes').select('*, quiz_questions(*)').eq('id', id).single()
    if (err) return { data: null, error: err }
    return { data, error: null }
  }

  async function createQuiz(quiz) {
    const { data, error: err } = await supabase.from('quizzes').insert(quiz).select().single()
    if (err) return { data: null, error: err }
    quizzes.value.push(data)
    return { data, error: null }
  }

  async function updateQuiz(id, updates) {
    const { data, error: err } = await supabase.from('quizzes').update(updates).eq('id', id).select().single()
    if (err) return { data: null, error: err }
    const idx = quizzes.value.findIndex(q => q.id === id)
    if (idx !== -1) quizzes.value[idx] = data
    return { data, error: null }
  }

  async function deleteQuiz(id) {
    const { error: err } = await supabase.from('quizzes').delete().eq('id', id)
    if (err) return { error: err }
    quizzes.value = quizzes.value.filter(q => q.id !== id)
    return { error: null }
  }

  async function createQuizQuestion(question) {
    const { data, error: err } = await supabase.from('quiz_questions').insert(question).select().single()
    if (err) return { data: null, error: err }
    quizQuestions.value.push(data)
    return { data, error: null }
  }

  async function updateQuizQuestion(id, updates) {
    const { data, error: err } = await supabase.from('quiz_questions').update(updates).eq('id', id).select().single()
    if (err) return { data: null, error: err }
    const idx = quizQuestions.value.findIndex(q => q.id === id)
    if (idx !== -1) quizQuestions.value[idx] = data
    return { data, error: null }
  }

  async function deleteQuizQuestion(id) {
    const { error: err } = await supabase.from('quiz_questions').delete().eq('id', id)
    if (err) return { error: err }
    quizQuestions.value = quizQuestions.value.filter(q => q.id !== id)
    return { error: null }
  }

  function scoreQuiz(questions, answers) {
    let totalPts = 0
    let earnedPts = 0

    for (const q of questions) {
      totalPts += q.pts || 0
      const answer = answers[q.id]

      if (answer === undefined || answer === null) continue

      if (q.type === 'qcm' || q.type === 'vf' || q.type === 'situation') {
        if (answer === q.correct) earnedPts += q.pts
      } else if (q.type === 'qcmm') {
        const selected = Array.isArray(answer) ? answer.sort() : []
        const correct = Array.isArray(q.correct) ? q.correct.sort() : []
        if (JSON.stringify(selected) === JSON.stringify(correct)) earnedPts += q.pts
      } else if (q.type === 'order') {
        const selected = Array.isArray(answer) ? answer : []
        const correct = Array.isArray(q.correct) ? q.correct : []
        if (JSON.stringify(selected) === JSON.stringify(correct)) earnedPts += q.pts
      } else if (q.type === 'open') {
        earnedPts += 0
      }
    }

    const pct = totalPts > 0 ? Math.round((earnedPts / totalPts) * 100) : 0
    return { earnedPts, totalPts, pct }
  }

  async function submitQuizAttempt(attempt) {
    const { data, error: err } = await supabase.from('quiz_attempts').insert(attempt).select().single()
    if (err) return { data: null, error: err }
    quizAttempts.value.push(data)
    return { data, error: null }
  }

  async function fetchQuizAttempts(userId, quizId) {
    let query = supabase.from('quiz_attempts').select('*').eq('user_id', userId)
    if (quizId) query = query.eq('quiz_id', quizId)

    const { data, error: err } = await query.order('created_at', { ascending: false })
    if (err) return { data: null, error: err }
    quizAttempts.value = data
    return { data, error: null }
  }

  async function fetchMessages(userId) {
    const { data, error: err } = await supabase
      .from('messages')
      .select('*')
      .or(`sender_id.eq.${userId},receiver_id.eq.${userId}`)
      .order('created_at', { ascending: true })

    if (err) return { data: null, error: err }

    const map = {}
    for (const msg of data) {
      const threadKey = msg.sender_id === userId ? msg.receiver_id : msg.sender_id
      if (!map[threadKey]) map[threadKey] = []
      map[threadKey].push({
        from: msg.sender_id === userId ? 'me' : 'them',
        text: msg.content,
        time: new Date(msg.created_at).toLocaleString('fr-FR', { weekday: 'short', hour: '2-digit', minute: '2-digit' }),
      })
    }
    messages.value = map
    return { data, error: null }
  }

  async function sendMessage(senderId, receiverId, content) {
    const { data, error: err } = await supabase
      .from('messages')
      .insert({ sender_id: senderId, receiver_id: receiverId, content })
      .select()
      .single()

    if (err) return { data: null, error: err }

    const threadKey = receiverId
    if (!messages.value[threadKey]) messages.value[threadKey] = []
    messages.value[threadKey].push({
      from: 'me',
      text: content,
      time: "À l'instant",
    })
    return { data, error: null }
  }

  async function fetchBadges(userId) {
    const { data, error: err } = await supabase.from('badges').select('*').eq('user_id', userId)
    if (err) return { data: null, error: err }
    badges.value = data
    return { data, error: null }
  }

  async function awardBadge(userId, badge) {
    const { data, error: err } = await supabase.from('badges').insert({ user_id: userId, ...badge }).select().single()
    if (err) return { data: null, error: err }
    badges.value.push(data)
    return { data, error: null }
  }

  async function fetchPathPhases(formationId) {
    const { data, error: err } = await supabase
      .from('path_phases')
      .select('*, path_activities(*)')
      .eq('formation_id', formationId)
      .order('order_index', { ascending: true })

    if (err) return { data: null, error: err }
    pathPhases.value = data
    return { data, error: null }
  }

  async function fetchPathActivities(phaseId) {
    const { data, error: err } = await supabase
      .from('path_activities')
      .select('*')
      .eq('phase_id', phaseId)
      .order('order_index', { ascending: true })

    if (err) return { data: null, error: err }
    pathActivities.value = data
    return { data, error: null }
  }

  async function markActivityComplete(userId, activityId) {
    const { data, error: err } = await supabase
      .from('activity_completions')
      .upsert({ user_id: userId, activity_id: activityId, completed: true }, { onConflict: 'user_id,activity_id' })
      .select()
      .single()

    if (err) return { data: null, error: err }
    return { data, error: null }
  }

  async function fetchActivityCompletions(userId, formationId) {
    const { data, error: err } = await supabase
      .from('activity_completions')
      .select('activity_id')
      .eq('user_id', userId)

    if (err) return { data: null, error: err }
    return { data: new Set(data.map(d => d.activity_id)), error: null }
  }

  async function fetchGlobalReporting(filters = {}) {
    let query = supabase.from('reporting_global').select('*')
    if (filters.period) query = query.eq('period', filters.period)

    const { data, error: err } = await query
    if (err) return { data: null, error: err }
    return { data, error: null }
  }

  async function fetchCompanyReporting(companyId, filters = {}) {
    let query = supabase.from('reporting_company').select('*').eq('company_id', companyId)
    if (filters.period) query = query.eq('period', filters.period)

    const { data, error: err } = await query
    if (err) return { data: null, error: err }
    return { data, error: null }
  }

  async function fetchCompetencyEvolution(filters = {}) {
    let query = supabase.from('competency_evolution').select('*')
    if (filters.company_id) query = query.eq('company_id', filters.company_id)

    const { data, error: err } = await query
    if (err) return { data: null, error: err }
    return { data, error: null }
  }

async function fetchLearnersForFormateur(formateurId) {
  const { data, error: err } = await supabase
    .from('enrollments')
    .select('user_id, profiles(id, name, role), courses(title, cat)')
    .eq('formateur_id', formateurId)

  if (err) return { data: null, error: err }
  return { data, error: null }
}

async function requestCertification(userId, formationId) {
  const { data, error: err } = await supabase
    .from('certifications')
    .insert({ user_id: userId, formation_id: formationId, status: 'pending' })
    .select()
    .single()
  if (err) return { data: null, error: err }
  return { data, error: null }
}

async function shareDevelopmentPlan(userId, managerId, planData) {
  const { data, error: err } = await supabase
    .from('messages')
    .insert({
      sender_id: userId,
      receiver_id: managerId,
      subject: 'Plan de développement partagé',
      body: JSON.stringify(planData),
      type: 'plan_share',
    })
    .select()
    .single()
  if (err) return { data: null, error: err }
  return { data, error: null }
}

async function sendSessionNotifications(sessionId, type) {
  const { data, error: err } = await supabase
    .from('session_notifications')
    .insert({ session_id: sessionId, notification_type: type, sent_at: new Date().toISOString() })
    .select()
  if (err) return { data: null, error: err }
  return { data, error: null }
}

async function broadcastMessage(senderId, sessionId, content) {
  const { data: enrollments, error: e1 } = await supabase
    .from('enrollments')
    .select('user_id')
    .eq('session_id', sessionId)
  if (e1 || !enrollments?.length) return { data: null, error: e1 || { message: 'No enrollees' } }

  const msgs = enrollments.map(e => ({
    sender_id: senderId,
    receiver_id: e.user_id,
    body: content,
    type: 'broadcast',
  }))
  const { data, error: err } = await supabase.from('messages').insert(msgs).select()
  if (err) return { data: null, error: err }
  return { data, error: null }
}

async function fetchNotifications(userId) {
  const { data, error: err } = await supabase
    .from('notifications')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(20)
  if (err) return { data: null, error: err }
  return { data, error: null }
}

  async function bootstrapApp(userId) {
    loading.value = true
    error.value = null

    try {
      const [coursesRes, formationsRes, competenciesRes, scoresRes, badgesRes] = await Promise.all([
        fetchCourses(),
        fetchFormations(),
        fetchCompetencies(),
        fetchCompetencyScores(userId),
        fetchBadges(userId),
      ])

      if (coursesRes.error) throw coursesRes.error
      if (formationsRes.error) throw formationsRes.error
      if (competenciesRes.error) throw competenciesRes.error
      if (scoresRes.error) throw scoresRes.error
      if (badgesRes.error) throw badgesRes.error
    } catch (e) {
      error.value = e
      console.error('[DataStore] bootstrap error:', e.message)
    } finally {
      loading.value = false
    }
  }

  return {
    courses,
    formations,
    companies,
    sessions,
    enrollments,
    competencies,
    competencyScores,
    resources,
    developmentPlanResources,
    quizzes,
    quizQuestions,
    quizAttempts,
    messages,
    badges,
    pathPhases,
    pathActivities,
    loading,
    error,
    masteredCompetencies,
    progressCompetencies,
    weakCompetencies,
    fetchCourses,
    fetchCourseById,
    createCourse,
    updateCourse,
    deleteCourse,
    fetchFormations,
    createFormation,
    updateFormation,
    fetchCompanies,
    fetchCompanyById,
    createCompany,
    updateCompany,
    fetchSessions,
    createSession,
    updateSession,
    deleteSession,
    fetchEnrollments,
    createEnrollment,
    updateEnrollment,
    fetchCompetencies,
    fetchCompetencyScores,
    upsertCompetencyScore,
    fetchResources,
    createResource,
    fetchDevelopmentPlanResources,
    assignResourceToPlan,
    removeResourceFromPlan,
    fetchQuizzes,
    fetchQuizById,
    createQuiz,
    updateQuiz,
    deleteQuiz,
    createQuizQuestion,
    updateQuizQuestion,
    deleteQuizQuestion,
    scoreQuiz,
    submitQuizAttempt,
    fetchQuizAttempts,
    fetchMessages,
    sendMessage,
    fetchBadges,
    awardBadge,
    fetchPathPhases,
    fetchPathActivities,
    markActivityComplete,
    fetchActivityCompletions,
    fetchGlobalReporting,
    fetchCompanyReporting,
    fetchCompetencyEvolution,
fetchLearnersForFormateur,
  requestCertification,
  shareDevelopmentPlan,
  sendSessionNotifications,
  broadcastMessage,
  fetchNotifications,
  bootstrapApp,
  }
})
