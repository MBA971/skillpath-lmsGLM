-- ============================================================
-- SkillPath LMS — Complete Supabase Schema
-- ============================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- Helper: updated_at trigger
-- ============================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- Helper: handle_new_user trigger
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name, role, avatar_color)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'apprenant'),
    CONCAT('#', substr(md5(random()::text), 1, 6))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 1. profiles — extends auth.users
-- ============================================================
CREATE TABLE public.profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  role        TEXT NOT NULL CHECK (role IN ('apprenant', 'formateur', 'rh')),
  avatar_color TEXT DEFAULT CONCAT('#', substr(md5(random()::text), 1, 6)),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_read_own"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "profiles_update_own"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "profiles_formateur_read_learners"
  ON public.profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.enrollments e
      JOIN public.formations f ON f.id = e.formation_id
      JOIN public.sessions s ON s.formation_id = f.id
      WHERE s.facilitator_id = auth.uid()
        AND e.profile_id = profiles.id
    )
  );

CREATE POLICY "profiles_rh_read_all"
  ON public.profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh'
    )
  );

-- Trigger: auto-create profile on signup
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- 4. companies — client companies (before formations)
-- ============================================================
CREATE TABLE public.companies (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  sector      TEXT,
  employees   INT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "companies_read_all"
  ON public.companies FOR SELECT
  USING (true);

CREATE POLICY "companies_rh_all"
  ON public.companies FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh'
    )
  );

-- ============================================================
-- 2. courses — 18 courses in catalogue
-- ============================================================
CREATE TABLE public.courses (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  category      TEXT NOT NULL CHECK (category IN ('Management', 'Communication', 'Data & Analyse', 'Cybersécurité')),
  level         TEXT NOT NULL CHECK (level IN ('deb', 'int', 'avd', 'exp')),
  duration      TEXT NOT NULL,
  description   TEXT,
  icon_key      TEXT,
  rating        NUMERIC(3,2) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
  learners_count INT DEFAULT 0,
  is_new        BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "courses_read_all"
  ON public.courses FOR SELECT
  USING (true);

CREATE POLICY "courses_rh_all"
  ON public.courses FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh'
    )
  );

CREATE POLICY "courses_formateur_all"
  ON public.courses FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur'
    )
  );

-- ============================================================
-- 3. formations — 8 training programs
-- ============================================================
CREATE TABLE public.formations (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  company_id    UUID REFERENCES public.companies(id) ON DELETE SET NULL,
  status        TEXT NOT NULL CHECK (status IN ('active', 'completed', 'planned')),
  progress      INT DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  learners_count INT DEFAULT 0,
  start_date    DATE,
  end_date      DATE,
  budget        NUMERIC,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.formations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "formations_read_own_or_all"
  ON public.formations FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
    OR EXISTS (
      SELECT 1 FROM public.enrollments e
      WHERE e.formation_id = formations.id AND e.profile_id = auth.uid()
    )
  );

CREATE POLICY "formations_rh_all"
  ON public.formations FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "formations_formateur_all"
  ON public.formations FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 5. sessions — training sessions/events
-- ============================================================
CREATE TABLE public.sessions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  formation_id    UUID NOT NULL REFERENCES public.formations(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  date            DATE NOT NULL,
  start_time      TIME NOT NULL,
  end_time        TIME NOT NULL,
  location        TEXT,
  facilitator_id  UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  status          TEXT NOT NULL CHECK (status IN ('planned', 'confirmed', 'completed', 'cancelled')),
  max_participants INT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "sessions_read_formation_member"
  ON public.sessions FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
    OR EXISTS (
      SELECT 1 FROM public.enrollments e
      WHERE e.formation_id = sessions.formation_id AND e.profile_id = auth.uid()
    )
    OR sessions.facilitator_id = auth.uid()
  );

CREATE POLICY "sessions_rh_all"
  ON public.sessions FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "sessions_formateur_all"
  ON public.sessions FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 6. enrollments — links profiles to formations/courses
-- ============================================================
CREATE TABLE public.enrollments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id    UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  course_id     UUID REFERENCES public.courses(id) ON DELETE CASCADE,
  formation_id  UUID REFERENCES public.formations(id) ON DELETE CASCADE,
  status        TEXT NOT NULL CHECK (status IN ('enrolled', 'in_progress', 'completed', 'dropped')),
  progress      INT DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  enrolled_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at  TIMESTAMPTZ,
  UNIQUE (profile_id, course_id, formation_id)
);

ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "enrollments_read_own"
  ON public.enrollments FOR SELECT
  USING (
    profile_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
  );

CREATE POLICY "enrollments_insert_own"
  ON public.enrollments FOR INSERT
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "enrollments_update_own"
  ON public.enrollments FOR UPDATE
  USING (profile_id = auth.uid());

CREATE POLICY "enrollments_rh_all"
  ON public.enrollments FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "enrollments_formateur_all"
  ON public.enrollments FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 7. competencies — 10 competency domains
-- ============================================================
CREATE TABLE public.competencies (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        TEXT NOT NULL UNIQUE CHECK (slug IN ('lead','comm','data','agil','nego','cyber','innov','mgmt','digit','mktg')),
  name        TEXT NOT NULL,
  icon_key    TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.competencies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "competencies_read_all"
  ON public.competencies FOR SELECT
  USING (true);

CREATE POLICY "competencies_rh_all"
  ON public.competencies FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

-- ============================================================
-- 8. competency_scores — per-user per-competency scores
-- ============================================================
CREATE TABLE public.competency_scores (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id    UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  score         INT NOT NULL DEFAULT 0 CHECK (score >= 0 AND score <= 100),
  status        TEXT NOT NULL CHECK (status IN ('mastered', 'progress', 'weak', 'locked')),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (profile_id, competency_id)
);

ALTER TABLE public.competency_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "competency_scores_read_own"
  ON public.competency_scores FOR SELECT
  USING (
    profile_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
  );

CREATE POLICY "competency_scores_insert_own"
  ON public.competency_scores FOR INSERT
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "competency_scores_update_own"
  ON public.competency_scores FOR UPDATE
  USING (profile_id = auth.uid());

CREATE POLICY "competency_scores_rh_all"
  ON public.competency_scores FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

-- updated_at trigger
CREATE TRIGGER competency_scores_updated_at
  BEFORE UPDATE ON public.competency_scores
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 9. resources — 27 learning resources
-- ============================================================
CREATE TABLE public.resources (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  type          TEXT NOT NULL CHECK (type IN ('module', 'elearning', 'video', 'podcast', 'exercice', 'quiz', 'situation')),
  title         TEXT NOT NULL,
  level         TEXT NOT NULL CHECK (level IN ('deb', 'int', 'avd', 'exp')),
  duration      TEXT,
  rating        NUMERIC(3,2) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.resources ENABLE ROW LEVEL SECURITY;

CREATE POLICY "resources_read_all"
  ON public.resources FOR SELECT
  USING (true);

CREATE POLICY "resources_rh_all"
  ON public.resources FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "resources_formateur_all"
  ON public.resources FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 10. development_plan_resources — assigned resources in dev plan
-- ============================================================
CREATE TABLE public.development_plan_resources (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id    UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  resource_id   UUID NOT NULL REFERENCES public.resources(id) ON DELETE CASCADE,
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  assigned_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (profile_id, resource_id)
);

ALTER TABLE public.development_plan_resources ENABLE ROW LEVEL SECURITY;

CREATE POLICY "dev_plan_read_own"
  ON public.development_plan_resources FOR SELECT
  USING (
    profile_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
  );

CREATE POLICY "dev_plan_insert_own"
  ON public.development_plan_resources FOR INSERT
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "dev_plan_delete_own"
  ON public.development_plan_resources FOR DELETE
  USING (profile_id = auth.uid());

CREATE POLICY "dev_plan_rh_all"
  ON public.development_plan_resources FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "dev_plan_formateur_all"
  ON public.development_plan_resources FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 11. quizzes — 3 quizzes
-- ============================================================
CREATE TABLE public.quizzes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title           TEXT NOT NULL,
  formation_id    UUID REFERENCES public.formations(id) ON DELETE SET NULL,
  phase           TEXT,
  level           TEXT NOT NULL CHECK (level IN ('deb', 'int', 'avd')),
  threshold       INT NOT NULL DEFAULT 50,
  chrono          INT,
  attempts_allowed INT DEFAULT 1,
  tag             TEXT NOT NULL DEFAULT '' CHECK (tag IN ('obligatoire', 'new', '')),
  created_by      UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "quizzes_read_formation_member"
  ON public.quizzes FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
    OR EXISTS (
      SELECT 1 FROM public.enrollments e
      WHERE e.formation_id = quizzes.formation_id AND e.profile_id = auth.uid()
    )
    OR quizzes.created_by = auth.uid()
  );

CREATE POLICY "quizzes_rh_all"
  ON public.quizzes FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "quizzes_formateur_all"
  ON public.quizzes FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 12. quiz_questions — questions within quizzes
-- ============================================================
CREATE TABLE public.quiz_questions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id         UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  type            TEXT NOT NULL CHECK (type IN ('qcm', 'qcmm', 'vf', 'order', 'situation', 'open')),
  question_text   TEXT NOT NULL,
  options         JSONB,
  correct_answer  JSONB,
  points          INT NOT NULL DEFAULT 1,
  explanation     TEXT,
  sort_order      INT NOT NULL DEFAULT 0
);

ALTER TABLE public.quiz_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "quiz_questions_read_via_quiz"
  ON public.quiz_questions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.quizzes q
      WHERE q.id = quiz_questions.quiz_id
        AND (
          EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
          OR EXISTS (
            SELECT 1 FROM public.enrollments e
            WHERE e.formation_id = q.formation_id AND e.profile_id = auth.uid()
          )
          OR q.created_by = auth.uid()
        )
    )
  );

CREATE POLICY "quiz_questions_rh_all"
  ON public.quiz_questions FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "quiz_questions_formateur_all"
  ON public.quiz_questions FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 13. quiz_attempts — user attempts at quizzes
-- ============================================================
CREATE TABLE public.quiz_attempts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id    UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  quiz_id       UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  score         INT NOT NULL DEFAULT 0,
  total_points  INT NOT NULL DEFAULT 0,
  percentage    INT NOT NULL DEFAULT 0,
  passed        BOOLEAN NOT NULL DEFAULT false,
  time_spent    TEXT,
  answers       JSONB,
  attempted_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "quiz_attempts_read_own"
  ON public.quiz_attempts FOR SELECT
  USING (
    profile_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
  );

CREATE POLICY "quiz_attempts_insert_own"
  ON public.quiz_attempts FOR INSERT
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "quiz_attempts_rh_all"
  ON public.quiz_attempts FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "quiz_attempts_formateur_read"
  ON public.quiz_attempts FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 14. messages — messaging system
-- ============================================================
CREATE TABLE public.messages (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  recipient_id  UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  thread_id     UUID,
  subject       TEXT,
  body          TEXT NOT NULL,
  is_read       BOOLEAN NOT NULL DEFAULT false,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "messages_read_own"
  ON public.messages FOR SELECT
  USING (
    sender_id = auth.uid() OR recipient_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "messages_insert_own"
  ON public.messages FOR INSERT
  WITH CHECK (sender_id = auth.uid());

CREATE POLICY "messages_update_own"
  ON public.messages FOR UPDATE
  USING (recipient_id = auth.uid());

CREATE POLICY "messages_delete_own"
  ON public.messages FOR DELETE
  USING (sender_id = auth.uid() OR recipient_id = auth.uid());

-- ============================================================
-- 15. badges — gamification badges
-- ============================================================
CREATE TABLE public.badges (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id  UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  type        TEXT NOT NULL,
  label       TEXT NOT NULL,
  earned_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "badges_read_own"
  ON public.badges FOR SELECT
  USING (
    profile_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
  );

CREATE POLICY "badges_insert_rh"
  ON public.badges FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "badges_rh_all"
  ON public.badges FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

-- ============================================================
-- 16. path_phases — 5E pedagogical phases for a formation
-- ============================================================
CREATE TABLE public.path_phases (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  formation_id UUID NOT NULL REFERENCES public.formations(id) ON DELETE CASCADE,
  phase       TEXT NOT NULL CHECK (phase IN ('E1', 'E2', 'E3', 'E4', 'E5')),
  title       TEXT NOT NULL,
  description TEXT,
  sort_order  INT NOT NULL DEFAULT 0,
  is_locked   BOOLEAN NOT NULL DEFAULT true,
  UNIQUE (formation_id, phase)
);

ALTER TABLE public.path_phases ENABLE ROW LEVEL SECURITY;

CREATE POLICY "path_phases_read_formation_member"
  ON public.path_phases FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
    OR EXISTS (
      SELECT 1 FROM public.enrollments e
      WHERE e.formation_id = path_phases.formation_id AND e.profile_id = auth.uid()
    )
  );

CREATE POLICY "path_phases_rh_all"
  ON public.path_phases FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "path_phases_formateur_all"
  ON public.path_phases FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- 17. path_activities — activities within phases
-- ============================================================
CREATE TABLE public.path_activities (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phase_id      UUID NOT NULL REFERENCES public.path_phases(id) ON DELETE CASCADE,
  type          TEXT NOT NULL,
  title         TEXT NOT NULL,
  description   TEXT,
  is_completed  BOOLEAN NOT NULL DEFAULT false,
  sort_order    INT NOT NULL DEFAULT 0
);

ALTER TABLE public.path_activities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "path_activities_read_via_phase"
  ON public.path_activities FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.path_phases pp
      WHERE pp.id = path_activities.phase_id
        AND (
          EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role IN ('rh', 'formateur'))
          OR EXISTS (
            SELECT 1 FROM public.enrollments e
            WHERE e.formation_id = pp.formation_id AND e.profile_id = auth.uid()
          )
        )
    )
  );

CREATE POLICY "path_activities_rh_all"
  ON public.path_activities FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'rh')
  );

CREATE POLICY "path_activities_formateur_all"
  ON public.path_activities FOR ALL
  USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.role = 'formateur')
  );

-- ============================================================
-- Indexes for performance
-- ============================================================
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_courses_category ON public.courses(category);
CREATE INDEX idx_courses_level ON public.courses(level);
CREATE INDEX idx_formations_company_id ON public.formations(company_id);
CREATE INDEX idx_formations_status ON public.formations(status);
CREATE INDEX idx_sessions_formation_id ON public.sessions(formation_id);
CREATE INDEX idx_sessions_facilitator_id ON public.sessions(facilitator_id);
CREATE INDEX idx_sessions_date ON public.sessions(date);
CREATE INDEX idx_enrollments_profile_id ON public.enrollments(profile_id);
CREATE INDEX idx_enrollments_course_id ON public.enrollments(course_id);
CREATE INDEX idx_enrollments_formation_id ON public.enrollments(formation_id);
CREATE INDEX idx_enrollments_status ON public.enrollments(status);
CREATE INDEX idx_competency_scores_profile_id ON public.competency_scores(profile_id);
CREATE INDEX idx_competency_scores_competency_id ON public.competency_scores(competency_id);
CREATE INDEX idx_resources_competency_id ON public.resources(competency_id);
CREATE INDEX idx_resources_type ON public.resources(type);
CREATE INDEX idx_development_plan_profile_id ON public.development_plan_resources(profile_id);
CREATE INDEX idx_development_plan_resource_id ON public.development_plan_resources(resource_id);
CREATE INDEX idx_quiz_questions_quiz_id ON public.quiz_questions(quiz_id);
CREATE INDEX idx_quiz_attempts_profile_id ON public.quiz_attempts(profile_id);
CREATE INDEX idx_quiz_attempts_quiz_id ON public.quiz_attempts(quiz_id);
CREATE INDEX idx_messages_sender_id ON public.messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON public.messages(recipient_id);
CREATE INDEX idx_messages_thread_id ON public.messages(thread_id);
CREATE INDEX idx_messages_created_at ON public.messages(created_at);
CREATE INDEX idx_badges_profile_id ON public.badges(profile_id);
CREATE INDEX idx_path_phases_formation_id ON public.path_phases(formation_id);
CREATE INDEX idx_path_activities_phase_id ON public.path_activities(phase_id);
