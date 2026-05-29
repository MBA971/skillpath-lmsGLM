-- ============================================================
-- SkillPath LMS — Seed Data
-- Run AFTER schema.sql
-- All IDs are explicit deterministic UUIDs (no gen_random_uuid)
-- ============================================================

-- Disable RLS for seeding
SET session_replication_role = 'replica';

-- ============================================================
-- 1. COMPANIES
-- ============================================================
INSERT INTO public.companies (id, name, sector, employees) VALUES
  ('c1000000-0000-0000-0000-000000000001', 'Acme Corp',          'Services',     82),
  ('c1000000-0000-0000-0000-000000000002', 'TechStart SAS',      'Technologie',  45),
  ('c1000000-0000-0000-0000-000000000003', 'Global Finance',     'Finance',     120);

-- ============================================================
-- 2. PROFILES  (must exist in auth.users in production)
-- ============================================================
INSERT INTO public.profiles (id, name, role, avatar_color) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'Sophie Laurent',  'apprenant',  '#1E6FFF'),
  ('a0000000-0000-0000-0000-000000000002', 'Thomas Bernard',  'apprenant',  '#00D4A1'),
  ('a0000000-0000-0000-0000-000000000003', 'Emma Petit',      'apprenant',  '#FF4D6A'),
  ('a0000000-0000-0000-0000-000000000004', 'Lucas Moreau',    'apprenant',  '#FF9B21'),
  ('a0000000-0000-0000-0000-000000000005', 'Julie Durand',    'apprenant',  '#7B6FEE'),
  ('a0000000-0000-0000-0000-000000000006', 'Maxime Roy',      'apprenant',  '#D85A30'),
  ('a0000000-0000-0000-0000-000000000007', 'Marc Dupont',     'formateur',  '#00D4A1'),
  ('a0000000-0000-0000-0000-000000000008', 'Claire Martin',   'rh',         '#7B6FEE');

-- ============================================================
-- 3. COURSES  (18 courses from CatalogueView)
-- Category mapping: 'Soft Skills' -> 'Communication', 'Technical Skills' -> 'Data & Analyse', 'Functional Skills' -> 'Management'
-- Schema allows: 'Management','Communication','Data & Analyse','Cybersécurité'
-- We map Soft Skills->Communication, Technical Skills->Data & Analyse, Functional Skills->Management
-- ============================================================
INSERT INTO public.courses (id, title, category, level, duration, description, icon_key, rating, learners_count, is_new) VALUES
  ('c2000000-0000-0000-0000-000000000001', 'Leadership & Influence',           'Communication', 'exp', '12h', 'Développez votre style de leadership situationnel et adaptez votre posture au niveau de maturité de chaque collaborateur. Études de cas issus d''organisations réelles.', 'ti-users',           4.80, 187, true),
  ('c2000000-0000-0000-0000-000000000002', 'Communication Non Violente',       'Communication', 'int', '6h', 'Appliquer les 4 composantes CNV en contexte professionnel : observation, sentiment, besoin, demande. Pratique intensive avec mises en situation.', 'ti-message',         4.60, 143, false),
  ('c2000000-0000-0000-0000-000000000003', 'Gestion du stress & résilience',   'Communication', 'deb', '4h', 'Identifier vos sources de stress, développer votre résilience et pratiquer des techniques de régulation émotionnelle adaptées au contexte professionnel.', 'ti-heart',           4.40,  98, false),
  ('c2000000-0000-0000-0000-000000000004', 'Prise de parole en public',        'Communication', 'int', '8h', 'Structurer un discours, captiver son auditoire, gérer le trac. Entraînement avec feedback vidéo et coaching individuel.', 'ti-microphone',      4.70, 112, false),
  ('c2000000-0000-0000-0000-000000000005', 'Négociation commerciale',          'Communication', 'avd', '10h', 'Méthode Harvard, BATNA, gestion des objections et closing. Formation intense en jeu de rôle avec acteurs professionnels.', 'ti-handshake',       4.90,  55, false),
  ('c2000000-0000-0000-0000-000000000006', 'Intelligence émotionnelle',        'Communication', 'int', '5h', 'Comprendre et réguler ses émotions, développer l''empathie, améliorer ses relations professionnelles grâce au modèle de Goleman.', 'ti-brain',           4.50,  76, false),
  ('c2000000-0000-0000-0000-000000000007', 'Python Data Science',              'Data & Analyse','avd', '20h', 'Maîtriser pandas, numpy, matplotlib et scikit-learn sur des données réelles. Projet fil rouge avec un dataset RH d''entreprise.', 'ti-code',            4.90,  98, true),
  ('c2000000-0000-0000-0000-000000000008', 'Excel Avancé — Tableaux de bord',  'Data & Analyse','deb', '5h', 'Tableaux croisés dynamiques, Power Query, formules avancées et construction de dashboards professionnels avec mises en forme conditionnelles.', 'ti-table',           4.50, 312, false),
  ('c2000000-0000-0000-0000-000000000009', 'Cybersécurité fondamentaux',       'Cybersécurité', 'deb', '6h', 'Bonnes pratiques de sécurité informatique en entreprise : phishing, mots de passe, RGPD, gestion des accès et gestion des incidents.', 'ti-lock',            4.30,  85, false),
  ('c2000000-0000-0000-0000-000000000010', 'SQL & Bases de données',           'Data & Analyse','int', '12h', 'Requêtes SELECT, jointures, agrégations, sous-requêtes et optimisation. Comprendre les SGBD relationnels en contexte métier avec PostgreSQL.', 'ti-database',        4.60,  72, false),
  ('c2000000-0000-0000-0000-000000000011', 'Power BI — Visualisation data',    'Data & Analyse','int', '8h', 'Connecter des sources de données, modéliser avec DAX et publier des rapports interactifs. Cas d''usage RH, finance et commercial.', 'ti-chart-bar',       4.70,  64, false),
  ('c2000000-0000-0000-0000-000000000012', 'No-code — Automatiser avec Zapier','Data & Analyse','deb', '4h', 'Créer des automatisations sans code entre vos outils SaaS : Slack, Google Sheets, Notion, HubSpot. Gain de temps immédiat.', 'ti-arrows-transfer', 4.40,  48, true),
  ('c2000000-0000-0000-0000-000000000013', 'Management Agile — SCRUM',         'Management',    'int', '8h', 'Acquérir les fondamentaux Scrum et Kanban. Comprendre le rôle du manager dans une équipe auto-organisée et animer son premier sprint.', 'ti-refresh',         4.80, 234, false),
  ('c2000000-0000-0000-0000-000000000014', 'Gestion de projet — PMP Ready',    'Management',    'int', '15h', 'Cadrage, planification WBS, gestion des risques, maîtrise des délais et coûts, clôture de projet. Méthodologies classiques et hybrides.', 'ti-clipboard-list',  4.60, 120, false),
  ('c2000000-0000-0000-0000-000000000015', 'Finance pour non-financiers',      'Management',    'avd', '12h', 'Comprendre le bilan, le compte de résultat et le cash-flow. Piloter un budget, analyser la rentabilité et parler finance avec la direction.', 'ti-coin',            4.60,  76, false),
  ('c2000000-0000-0000-0000-000000000016', 'Design Thinking & Innovation',     'Management',    'int', '8h', 'Appliquer la démarche en 5 étapes : empathie, définition, idéation, prototypage, test. Animez vos propres ateliers d''innovation.', 'ti-bulb',            4.70,  64, false),
  ('c2000000-0000-0000-0000-000000000017', 'Recrutement & marque employeur',   'Management',    'int', '6h', 'Structurer un processus de recrutement inclusif, rédiger des offres attractives et conduire des entretiens comportementaux (STAR, STAR-L).', 'ti-user-plus',       4.50,  88, false),
  ('c2000000-0000-0000-0000-000000000018', 'Marketing Digital & SEO',          'Management',    'avd', '18h', 'Stratégie de contenu, SEO on/off-page, Google Ads, analytics et marketing automation. Projet fil rouge avec un vrai site à optimiser.', 'ti-speakerphone',    4.70,  62, true);

-- ============================================================
-- 4. FORMATIONS  (8 from ReportingView)
-- ============================================================
INSERT INTO public.formations (id, title, company_id, status, progress, learners_count, start_date, end_date, budget) VALUES
  ('f1000000-0000-0000-0000-000000000001', 'Management Agile',           'c1000000-0000-0000-0000-000000000001', 'active',    92, 234, '2025-01-15', '2025-07-15', 18720),
  ('f1000000-0000-0000-0000-000000000002', 'Leadership & Influence',    'c1000000-0000-0000-0000-000000000001', 'active',    88, 187, '2025-02-01', '2025-08-01', 28050),
  ('f1000000-0000-0000-0000-000000000003', 'Excel Avancé',              'c1000000-0000-0000-0000-000000000002', 'active',    81, 312, '2025-03-01', '2025-06-30',  9360),
  ('f1000000-0000-0000-0000-000000000004', 'Communication CNV',         'c1000000-0000-0000-0000-000000000001', 'active',    85, 143, '2025-02-15', '2025-08-15', 10725),
  ('f1000000-0000-0000-0000-000000000005', 'Python Data Science',       'c1000000-0000-0000-0000-000000000002', 'active',    76,  98, '2025-04-01', '2025-10-01', 23520),
  ('f1000000-0000-0000-0000-000000000006', 'Cybersécurité',             'c1000000-0000-0000-0000-000000000003', 'active',    73,  85, '2025-03-15', '2025-09-15',  8000),
  ('f1000000-0000-0000-0000-000000000007', 'Gestion de projet',         'c1000000-0000-0000-0000-000000000003', 'active',    69, 120, '2025-05-01', '2025-11-01', 14000),
  ('f1000000-0000-0000-0000-000000000008', 'Finance non-financiers',    'c1000000-0000-0000-0000-000000000003', 'completed', 82,  76, '2025-01-01', '2025-04-30', 12000);

-- ============================================================
-- 5. SESSIONS  (4 from FormateurView)
-- ============================================================
INSERT INTO public.sessions (id, formation_id, title, date, start_time, end_time, location, facilitator_id, status, max_participants) VALUES
  ('01000000-0000-0000-0000-000000000001', 'f1000000-0000-0000-0000-000000000002', 'Leadership & Influence', '2025-05-19', '09:00', '12:30', 'Paris 8e — Salle Voltaire',                'a0000000-0000-0000-0000-000000000007', 'confirmed', 12),
  ('01000000-0000-0000-0000-000000000002', 'f1000000-0000-0000-0000-000000000004', 'Communication CNV',     '2025-05-21', '14:00', '16:30', 'meet.skillpath.io/cnv-052025',             'a0000000-0000-0000-0000-000000000007', 'confirmed', 15),
  ('01000000-0000-0000-0000-000000000003', 'f1000000-0000-0000-0000-000000000001', 'Management Agile',      '2025-05-26', '09:00', '17:00', 'Lyon — Centre IDEC',                       'a0000000-0000-0000-0000-000000000007', 'planned',    8),
  ('01000000-0000-0000-0000-000000000004', 'f1000000-0000-0000-0000-000000000002', 'Leadership & Influence', '2025-06-03', '09:00', '12:30', 'Paris 8e — Salle Voltaire',                'a0000000-0000-0000-0000-000000000007', 'planned',   12);

-- ============================================================
-- 6. ENROLLMENTS  (linking profiles to formations)
-- ============================================================
INSERT INTO public.enrollments (id, profile_id, course_id, formation_id, status, progress) VALUES
  ('e1000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000001', 'f1000000-0000-0000-0000-000000000002', 'in_progress', 23),
  ('e1000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000008', 'f1000000-0000-0000-0000-000000000003', 'completed',  100),
  ('e1000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000013', 'f1000000-0000-0000-0000-000000000001', 'in_progress', 67),
  ('e1000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000002', 'c2000000-0000-0000-0000-000000000007', 'f1000000-0000-0000-0000-000000000005', 'in_progress', 45),
  ('e1000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000003', 'c2000000-0000-0000-0000-000000000013', 'f1000000-0000-0000-0000-000000000001', 'in_progress', 91),
  ('e1000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000004', 'c2000000-0000-0000-0000-000000000007', 'f1000000-0000-0000-0000-000000000005', 'in_progress', 23),
  ('e1000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000005', 'c2000000-0000-0000-0000-000000000013', 'f1000000-0000-0000-0000-000000000001', 'in_progress', 78),
  ('e1000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000006', 'c2000000-0000-0000-0000-000000000013', 'f1000000-0000-0000-0000-000000000001', 'in_progress', 34);

-- ============================================================
-- 7. COMPETENCIES  (10 from CartographieView)
-- Schema slug CHECK: 'lead','comm','data','agil','nego','cyber','innov','mgmt','digit','mktg'
-- ============================================================
INSERT INTO public.competencies (id, slug, name, icon_key) VALUES
  ('c03b0000-0000-0000-0000-000000000001', 'lead',  'Leadership',       'ti-users'),
  ('c03b0000-0000-0000-0000-000000000002', 'comm',  'Communication',    'ti-message'),
  ('c03b0000-0000-0000-0000-000000000003', 'data',  'Data & Analyse',   'ti-chart-bar'),
  ('c03b0000-0000-0000-0000-000000000004', 'agil',  'Agilité',          'ti-refresh'),
  ('c03b0000-0000-0000-0000-000000000005', 'nego',  'Négociation',      'ti-handshake'),
  ('c03b0000-0000-0000-0000-000000000006', 'cyber', 'Cybersécurité',    'ti-lock'),
  ('c03b0000-0000-0000-0000-000000000007', 'innov', 'Innovation',       'ti-bulb'),
  ('c03b0000-0000-0000-0000-000000000008', 'mgmt',  'Management',       'ti-sitemap'),
  ('c03b0000-0000-0000-0000-000000000009', 'digit', 'Outils Digitaux',  'ti-device-laptop'),
  ('c03b0000-0000-0000-0000-000000000010', 'mktg',  'Marketing',        'ti-speakerphone');

-- ============================================================
-- 8. COMPETENCY_SCORES  (from CartographieView TEAM_MEMBERS)
-- ============================================================
-- Sophie Laurent
INSERT INTO public.competency_scores (id, profile_id, competency_id, score, status) VALUES
  ('0c500000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000001', 87, 'mastered'),
  ('0c500000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000002', 72, 'progress'),
  ('0c500000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000003', 45, 'weak'),
  ('0c500000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000004', 91, 'mastered'),
  ('0c500000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000005', 33, 'weak'),
  ('0c500000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000006', 12, 'weak'),
  ('0c500000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000007', 68, 'progress'),
  ('0c500000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000008', 40, 'progress'),
  ('0c500000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000009', 78, 'mastered'),
  ('0c500000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000010',  0, 'locked');

-- Thomas Bernard
INSERT INTO public.competency_scores (id, profile_id, competency_id, score, status) VALUES
  ('0c500000-0000-0000-0000-000000000011', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000001', 52, 'progress'),
  ('0c500000-0000-0000-0000-000000000012', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000002', 61, 'progress'),
  ('0c500000-0000-0000-0000-000000000013', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000003', 88, 'mastered'),
  ('0c500000-0000-0000-0000-000000000014', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000004', 79, 'mastered'),
  ('0c500000-0000-0000-0000-000000000015', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000005', 25, 'weak'),
  ('0c500000-0000-0000-0000-000000000016', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000006', 70, 'progress'),
  ('0c500000-0000-0000-0000-000000000017', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000007', 55, 'progress'),
  ('0c500000-0000-0000-0000-000000000018', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000008', 30, 'weak'),
  ('0c500000-0000-0000-0000-000000000019', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000009', 85, 'mastered'),
  ('0c500000-0000-0000-0000-000000000020', 'a0000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000010',  0, 'locked');

-- Emma Petit
INSERT INTO public.competency_scores (id, profile_id, competency_id, score, status) VALUES
  ('0c500000-0000-0000-0000-000000000021', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000001', 75, 'mastered'),
  ('0c500000-0000-0000-0000-000000000022', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000002', 90, 'mastered'),
  ('0c500000-0000-0000-0000-000000000023', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000003', 62, 'progress'),
  ('0c500000-0000-0000-0000-000000000024', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000004', 95, 'mastered'),
  ('0c500000-0000-0000-0000-000000000025', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000005', 68, 'progress'),
  ('0c500000-0000-0000-0000-000000000026', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000006', 40, 'weak'),
  ('0c500000-0000-0000-0000-000000000027', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000007', 84, 'mastered'),
  ('0c500000-0000-0000-0000-000000000028', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000008', 58, 'progress'),
  ('0c500000-0000-0000-0000-000000000029', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000009', 72, 'progress'),
  ('0c500000-0000-0000-0000-000000000030', 'a0000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000010', 45, 'weak');

-- Lucas Moreau
INSERT INTO public.competency_scores (id, profile_id, competency_id, score, status) VALUES
  ('0c500000-0000-0000-0000-000000000031', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000001', 35, 'weak'),
  ('0c500000-0000-0000-0000-000000000032', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000002', 48, 'weak'),
  ('0c500000-0000-0000-0000-000000000033', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000003', 91, 'mastered'),
  ('0c500000-0000-0000-0000-000000000034', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000004', 55, 'progress'),
  ('0c500000-0000-0000-0000-000000000035', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000005', 42, 'weak'),
  ('0c500000-0000-0000-0000-000000000036', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000006', 58, 'progress'),
  ('0c500000-0000-0000-0000-000000000037', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000007', 30, 'weak'),
  ('0c500000-0000-0000-0000-000000000038', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000008', 22, 'weak'),
  ('0c500000-0000-0000-0000-000000000039', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000009', 80, 'mastered'),
  ('0c500000-0000-0000-0000-000000000040', 'a0000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000010', 20, 'weak');

-- Julie Durand
INSERT INTO public.competency_scores (id, profile_id, competency_id, score, status) VALUES
  ('0c500000-0000-0000-0000-000000000041', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000001', 60, 'progress'),
  ('0c500000-0000-0000-0000-000000000042', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000002', 85, 'mastered'),
  ('0c500000-0000-0000-0000-000000000043', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000003', 50, 'progress'),
  ('0c500000-0000-0000-0000-000000000044', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000004', 73, 'progress'),
  ('0c500000-0000-0000-0000-000000000045', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000005', 55, 'progress'),
  ('0c500000-0000-0000-0000-000000000046', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000006', 28, 'weak'),
  ('0c500000-0000-0000-0000-000000000047', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000007', 92, 'mastered'),
  ('0c500000-0000-0000-0000-000000000048', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000008', 44, 'weak'),
  ('0c500000-0000-0000-0000-000000000049', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000009', 68, 'progress'),
  ('0c500000-0000-0000-0000-000000000050', 'a0000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000010', 60, 'progress');

-- ============================================================
-- 9. RESOURCES  (27 from CartographieView)
-- ============================================================
INSERT INTO public.resources (id, competency_id, type, title, level, duration, rating) VALUES
  ('10000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000001', 'module',    'Leadership situationnel — Module complet',                           'avd', '4h',    4.80),
  ('10000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000001', 'video',     'Les 5 styles de leadership',                                         'int', '22min', 4.60),
  ('10000000-0000-0000-0000-000000000003', 'c03b0000-0000-0000-0000-000000000001', 'quiz',      'Quiz — Leadership niveau avancé',                                    'avd', '15min', 4.50),
  ('10000000-0000-0000-0000-000000000004', 'c03b0000-0000-0000-0000-000000000001', 'situation', 'Gérer un conflit d''équipe — Simulation',                             'avd', '45min', 4.90),
  ('10000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000002', 'elearning', 'Communication Non Violente — Parcours',                              'int', '3h',    4.70),
  ('10000000-0000-0000-0000-000000000006', 'c03b0000-0000-0000-0000-000000000002', 'podcast', 'Clés d''une communication efficace',                                  'deb', '35min', 4.40),
  ('10000000-0000-0000-0000-000000000007', 'c03b0000-0000-0000-0000-000000000002', 'exercice',  'Exercice — Reformulation active',                                    'int', '30min', 4.30),
  ('10000000-0000-0000-0000-000000000008', 'c03b0000-0000-0000-0000-000000000002', 'module',    'Storytelling professionnel',                                         'int', '2h',    4.50),
  ('10000000-0000-0000-0000-000000000009', 'c03b0000-0000-0000-0000-000000000003', 'module',    'Introduction à la Data Science',                                     'deb', '6h',    4.80),
  ('10000000-0000-0000-0000-000000000010', 'c03b0000-0000-0000-0000-000000000003', 'video',     'Excel — Tableaux croisés dynamiques',                                'int', '40min', 4.60),
  ('10000000-0000-0000-0000-000000000011', 'c03b0000-0000-0000-0000-000000000003', 'exercice',  'TP — Analyse de données réelles',                                    'int', '2h',    4.70),
  ('10000000-0000-0000-0000-000000000012', 'c03b0000-0000-0000-0000-000000000003', 'elearning', 'Power BI — Visualisation Data',                                      'int', '8h',    4.70),
  ('10000000-0000-0000-0000-000000000013', 'c03b0000-0000-0000-0000-000000000004', 'module',    'Fondamentaux SCRUM',                                                 'deb', '3h',    4.70),
  ('10000000-0000-0000-0000-000000000014', 'c03b0000-0000-0000-0000-000000000004', 'situation', 'Sprint planning — Simulation complète',                              'int', '1h',    4.80),
  ('10000000-0000-0000-0000-000000000015', 'c03b0000-0000-0000-0000-000000000004', 'quiz',      'Quiz — Agilité & méthodes',                                         'avd', '20min', 4.50),
  ('10000000-0000-0000-0000-000000000016', 'c03b0000-0000-0000-0000-000000000005', 'module',    'Techniques de négociation avancée',                                  'avd', '5h',    4.90),
  ('10000000-0000-0000-0000-000000000017', 'c03b0000-0000-0000-0000-000000000005', 'video',     'La négociation raisonnée — Harvard',                                 'int', '28min', 4.70),
  ('10000000-0000-0000-0000-000000000018', 'c03b0000-0000-0000-0000-000000000005', 'situation', 'Négocier un contrat — Jeu de rôle',                                  'avd', '1h',    4.80),
  ('10000000-0000-0000-0000-000000000019', 'c03b0000-0000-0000-0000-000000000006', 'module',    'Cybersécurité fondamentaux',                                         'deb', '4h',    4.60),
  ('10000000-0000-0000-0000-000000000020', 'c03b0000-0000-0000-0000-000000000006', 'quiz',      'Quiz — Bonnes pratiques sécurité',                                   'deb', '15min', 4.40),
  ('10000000-0000-0000-0000-000000000021', 'c03b0000-0000-0000-0000-000000000006', 'video',     'Phishing & ingénierie sociale',                                      'deb', '20min', 4.30),
  ('10000000-0000-0000-0000-000000000022', 'c03b0000-0000-0000-0000-000000000007', 'elearning', 'Design Thinking & Innovation',                                       'int', '4h',    4.80),
  ('10000000-0000-0000-0000-000000000023', 'c03b0000-0000-0000-0000-000000000007', 'exercice',  'Atelier — Brainstorming structuré',                                  'int', '1h',    4.60),
  ('10000000-0000-0000-0000-000000000024', 'c03b0000-0000-0000-0000-000000000008', 'module', 'Management d''équipe — Parcours complet',                             'avd', '8h',    4.90),
  ('10000000-0000-0000-0000-000000000025', 'c03b0000-0000-0000-0000-000000000008', 'podcast',   'Manager coach — Les fondamentaux',                                   'int', '42min', 4.50),
  ('10000000-0000-0000-0000-000000000026', 'c03b0000-0000-0000-0000-000000000009', 'elearning', 'Excel Avancé — Tableaux de bord',                                    'deb', '5h',    4.50),
  ('10000000-0000-0000-0000-000000000027', 'c03b0000-0000-0000-0000-000000000009', 'module',    'Automatiser avec Zapier — No-code',                                  'deb', '4h',    4.40);

-- ============================================================
-- 10. DEVELOPMENT_PLAN_RESOURCES  (from assignedResources in CartographieView)
-- ============================================================
INSERT INTO public.development_plan_resources (id, profile_id, resource_id, competency_id) VALUES
  ('dpr00000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'c03b0000-0000-0000-0000-000000000001'),
  ('dpr00000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000002', 'c03b0000-0000-0000-0000-000000000001'),
  ('dpr00000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000005', 'c03b0000-0000-0000-0000-000000000002'),
  ('dpr00000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000013', 'c03b0000-0000-0000-0000-000000000004'),
  ('dpr00000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000015', 'c03b0000-0000-0000-0000-000000000004'),
  ('dpr00000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000019', 'c03b0000-0000-0000-0000-000000000006');

-- ============================================================
-- 11. QUIZZES  (3 from QuizView)
-- ============================================================
INSERT INTO public.quizzes (id, title, formation_id, phase, level, threshold, chrono, attempts_allowed, tag, created_by) VALUES
  ('31000000-0000-0000-0000-000000000001', 'Management Agile — Évaluation finale',        'f1000000-0000-0000-0000-000000000001', 'E5', 'int', 75, 20, 2, 'obligatoire', 'a0000000-0000-0000-0000-000000000007'),
  ('31000000-0000-0000-0000-000000000002', 'Leadership situationnel — Quiz intermédiaire', 'f1000000-0000-0000-0000-000000000002', 'E3', 'avd', 70, 15, 3, '',             'a0000000-0000-0000-0000-000000000007'),
  ('31000000-0000-0000-0000-000000000003', 'Cybersécurité — Bonnes pratiques en entreprise','f1000000-0000-0000-0000-000000000006', 'E3', 'deb', 80, 10, 2, 'new',          'a0000000-0000-0000-0000-000000000007');

-- ============================================================
-- 12. QUIZ_QUESTIONS  (from QuizView)
-- ============================================================
-- Quiz 1: Management Agile (6 questions)
INSERT INTO public.quiz_questions (id, quiz_id, type, question_text, options, correct_answer, points, explanation, sort_order) VALUES
  ('33000000-0000-0000-0000-000000000001', '31000000-0000-0000-0000-000000000001', 'qcm', 'Dans Scrum, qui est responsable de maximiser la valeur du produit livré ?',
   '["Le Scrum Master","Le Product Owner","L''équipe de développement","Le Chef de projet"]', '1', 2, 'Le Product Owner est garant du Product Backlog et de la valeur livrée à chaque sprint. C''est lui qui priorise les items selon la valeur business.', 1),

  ('33000000-0000-0000-0000-000000000002', '31000000-0000-0000-0000-000000000001', 'qcmm', 'Quels sont les artefacts officiels définis par le Guide Scrum 2020 ?',
   '["Product Backlog","Sprint Backlog","Roadmap produit","Increment","Burndown chart"]', '[0,1,3]', 3, 'Scrum 2020 définit exactement 3 artefacts : Product Backlog, Sprint Backlog et Increment. La Roadmap et le Burndown chart ne font pas partie du framework.', 2),

  ('33000000-0000-0000-0000-000000000003', '31000000-0000-0000-0000-000000000001', 'vf', 'Le Daily Scrum doit obligatoirement durer 15 minutes exactement, quelle que soit la taille de l''équipe.',
   '["Vrai","Faux"]', '0', 1, 'Vrai — le Daily est time-boxé à 15 minutes maximum par la définition officielle Scrum, quel que soit l''effectif de l''équipe.', 3),

  ('33000000-0000-0000-0000-000000000004', '31000000-0000-0000-0000-000000000001', 'order', 'Remettez les étapes d''un sprint dans le bon ordre chronologique.',
   '["Sprint Retrospective","Sprint Planning","Development Work + Daily Scrums","Sprint Review"]', '[1,2,3,0]', 3, 'L''ordre correct est : Sprint Planning → Development Work + Daily Scrums → Sprint Review → Sprint Retrospective.', 4),

  ('33000000-0000-0000-0000-000000000005', '31000000-0000-0000-0000-000000000001', 'situation', 'En fin de sprint, votre équipe n''a pas pu terminer toutes les user stories planifiées. Quelle est la bonne réaction en tant que Product Owner ?',
   '["Prolonger le sprint de 2 jours pour tout finir","Annuler le sprint et recommencer la planification","Tenir la Sprint Review avec l''incrément réalisé, puis organiser la Rétrospective","Déplacer toutes les stories non finies dans le prochain sprint sans discussion"]', '2', 4, 'La Sprint Review porte sur l''incrément réel livré. La Rétrospective permettra à l''équipe d''analyser pourquoi les stories n''ont pas été terminées et d''améliorer le processus.', 5),

  ('33000000-0000-0000-0000-000000000006', '31000000-0000-0000-0000-000000000001', 'open', 'Décrivez en 5 à 10 lignes comment vous organiseriez la transition vers l''Agilité dans une équipe habituée au cycle en V.',
   '[]', 'null', 5, 'Critères évalués : sensibilisation au Manifeste Agile, choix d''un pilote, formation de l''équipe, accompagnement au changement, itérations progressives, métriques de succès.', 6);

-- Quiz 2: Leadership (4 questions)
INSERT INTO public.quiz_questions (id, quiz_id, type, question_text, options, correct_answer, points, explanation, sort_order) VALUES
  ('33000000-0000-0000-0000-000000000007', '31000000-0000-0000-0000-000000000002', 'qcm', 'Selon le modèle de Hersey & Blanchard, quel style convient à un collaborateur à la fois compétent et motivé ?',
   '["Directif","Persuasif","Participatif","Délégatif"]', '3', 2, 'Le style Délégatif (S4) est adapté aux collaborateurs à haute maturité (compétents ET motivés). Le manager délègue la décision tout en restant disponible.', 1),

  ('33000000-0000-0000-0000-000000000008', '31000000-0000-0000-0000-000000000002', 'vf', 'Le leadership transformationnel se concentre principalement sur les tâches à accomplir plutôt que sur l''inspiration des équipes.',
   '["Vrai","Faux"]', '1', 1, 'Faux. Le leadership transformationnel se concentre sur la vision, l''inspiration et le développement des personnes. Le leadership transactionnel est davantage axé sur les tâches.', 2),

  ('33000000-0000-0000-0000-000000000009', '31000000-0000-0000-0000-000000000002', 'qcmm', 'Quelles sont les caractéristiques d''un feedback constructif efficace ?',
   '["Spécifique et factuel","Centré sur la personne","Orienté comportement","Donné en public pour l''effet","Proposer des pistes d''amélioration"]', '[0,2,4]', 3, 'Un feedback efficace est : spécifique (basé sur des faits), centré sur le comportement (pas la personnalité) et constructif (propose des pistes d''amélioration). Il se donne en privé.', 3),

  ('33000000-0000-0000-0000-000000000010', '31000000-0000-0000-0000-000000000002', 'situation', 'Thomas, 3 ans d''ancienneté, vient vous voir démoralisé : son projet a été rejeté en CODIR. Il remet en question ses compétences. Quel est votre premier réflexe ?',
   '["Minimiser et passer à la suite","Analyser immédiatement les erreurs du projet","Écouter activement, reconnaître l''émotion, puis analyser ensemble","Lui rappeler qu''il a d''autres réussites"]', '2', 4, 'L''écoute active et la reconnaissance émotionnelle sont les premiers leviers. Analyser les erreurs avant d''accueillir l''émotion serait contre-productif et briserait la confiance.', 4);

-- Quiz 3: Cybersécurité (3 questions)
INSERT INTO public.quiz_questions (id, quiz_id, type, question_text, options, correct_answer, points, explanation, sort_order) VALUES
  ('33000000-0000-0000-0000-000000000011', '31000000-0000-0000-0000-000000000003', 'qcm', 'Qu''est-ce qu''une attaque de type phishing ?',
   '["Un logiciel espion installé sur votre PC","Un email frauduleux imitant un expéditeur de confiance pour voler vos identifiants","Une attaque sur les serveurs de l''entreprise","Un virus qui chiffre vos fichiers"]', '1', 2, 'Le phishing (hameçonnage) utilise des emails ou sites frauduleux imitant des entités de confiance pour dérober des identifiants ou informations sensibles.', 1),

  ('33000000-0000-0000-0000-000000000012', '31000000-0000-0000-0000-000000000003', 'vf', 'Utiliser le même mot de passe fort pour plusieurs services professionnels est acceptable si ce mot de passe est suffisamment complexe.',
   '["Vrai","Faux"]', '1', 1, 'Faux. Même fort, un mot de passe réutilisé crée un point de défaillance unique. Si un service est compromis, tous vos comptes le sont. Utilisez un gestionnaire de mots de passe.', 2),

  ('33000000-0000-0000-0000-000000000013', '31000000-0000-0000-0000-000000000003', 'qcmm', 'Quelles actions réduisent efficacement les risques de sécurité informatique au bureau ?',
   '["Verrouiller son PC en quittant son poste","Partager ses accès à un collègue de confiance","Utiliser un VPN sur les réseaux Wi-Fi publics","Cliquer rapidement sur les liens pour gagner du temps","Activer l''authentification à deux facteurs"]', '[0,2,4]', 3, 'Verrouiller son poste, utiliser un VPN et activer le 2FA sont des pratiques essentielles. Partager ses accès et cliquer sans vérifier sont des risques majeurs.', 3);

-- ============================================================
-- 13. QUIZ_ATTEMPTS  (4 from QuizView HISTORY)
-- ============================================================
INSERT INTO public.quiz_attempts (id, profile_id, quiz_id, score, total_points, percentage, passed, time_spent, attempted_at) VALUES
  ('3a000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', '31000000-0000-0000-0000-000000000001', 14, 18, 78, true,  '17 min', '2025-05-14T10:00:00Z'),
  ('3a000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', '31000000-0000-0000-0000-000000000002', 13, 10, 72, true,  '12 min', '2025-05-10T14:00:00Z'),
  ('3a000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', '31000000-0000-0000-0000-000000000003',  6,  6, 53, false, '9 min',  '2025-05-08T09:00:00Z'),
  ('3a000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', '31000000-0000-0000-0000-000000000002',  7, 10, 66, false, '14 min', '2025-05-05T11:00:00Z');

-- ============================================================
-- 14. MESSAGES  (from FormateurView MESSAGES)
-- ============================================================
-- Thread: Sophie Laurent
INSERT INTO public.messages (id, sender_id, recipient_id, thread_id, subject, body, is_read, created_at) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000007', 't0000000-0000-0000-0000-000000000001', 'Slides session Leadership', 'Bonjour Marc, est-ce que vous pourriez partager les slides de la session de lundi avant vendredi ?', true, '2025-05-19T13:24:00Z'),
  ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000001', 't0000000-0000-0000-0000-000000000001', 'Re: Slides session Leadership', 'Bien sûr Sophie ! Je vous envoie ça ce soir. Préparez aussi un cas réel de votre équipe pour l''exercice E4.', true, '2025-05-19T14:02:00Z'),
  ('b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000007', 't0000000-0000-0000-0000-000000000001', 'Re: Slides session Leadership', 'Parfait ! J''ai justement un projet de migration Agile en cours. Ce sera parfait comme étude de cas.', true, '2025-05-19T14:18:00Z');

-- Thread: Lucas Moreau
INSERT INTO public.messages (id, sender_id, recipient_id, thread_id, subject, body, is_read, created_at) VALUES
  ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000004', 't0000000-0000-0000-0000-000000000002', 'Prise de nouvelles', 'Bonjour Lucas, je voulais prendre de vos nouvelles. Vous êtes absent depuis 5 jours — tout va bien ?', false, '2025-05-15T09:00:00Z');

-- Thread: Emma Petit
INSERT INTO public.messages (id, sender_id, recipient_id, thread_id, subject, body, is_read, created_at) VALUES
  ('b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000007', 't0000000-0000-0000-0000-000000000003', 'Session de la semaine', 'Super session la semaine dernière ! J''ai pu appliquer le daily standup avec mon équipe dès le lendemain.', true, '2025-05-13T11:05:00Z'),
  ('b0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000003', 't0000000-0000-0000-0000-000000000003', 'Re: Session de la semaine', 'C''est exactement ce qu''on cherche — bravo Emma ! Votre livrable E4 était également excellent.', true, '2025-05-13T11:32:00Z');

-- ============================================================
-- 15. BADGES  (from DashboardView)
-- ============================================================
INSERT INTO public.badges (id, profile_id, type, label, earned_at) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'certification', 'Agiliste',            '2025-05-12T10:00:00Z'),
  ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'contribution',  'Innovateur',          '2025-05-10T14:00:00Z'),
  ('b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', 'streak',        'Top Learner',         '2025-05-12T08:00:00Z'),
  ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', 'streak',        '7j Streak',           '2025-05-14T08:00:00Z'),
  ('b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000001', 'completion',    'Data Lover',          '2025-05-08T16:00:00Z'),
  ('b0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000001', 'animation',     'Speaker',             '2025-05-06T17:00:00Z');

-- ============================================================
-- 16. PATH_PHASES  (5E from ParcoursView, for formation Management Agile)
-- ============================================================
INSERT INTO public.path_phases (id, formation_id, phase, title, description, sort_order, is_locked) VALUES
  ('pp000000-0000-0000-0000-000000000001', 'f1000000-0000-0000-0000-000000000001', 'E1', 'Engager', 'Créer la motivation d''apprendre. Identifier ses pratiques de management actuelles et déceler ses zones d''inconfort.', 1, false),
  ('pp000000-0000-0000-0000-000000000002', 'f1000000-0000-0000-0000-000000000001', 'E2', 'Explorer', 'Apprendre par l''expérimentation. Découvrir les principes Scrum et Kanban à travers des situations réelles d''entreprise.', 2, false),
  ('pp000000-0000-0000-0000-000000000003', 'f1000000-0000-0000-0000-000000000001', 'E3', 'Expliquer', 'Structurer et conceptualiser. Maîtriser les frameworks Scrum, Kanban et SAFe dans leur dimension managériale.', 3, false),
  ('pp000000-0000-0000-0000-000000000004', 'f1000000-0000-0000-0000-000000000001', 'E4', 'Élaborer', 'Transférer vers sa pratique. Concevoir et présenter un plan de transformation Agile pour votre propre équipe.', 4, true),
  ('pp000000-0000-0000-0000-000000000005', 'f1000000-0000-0000-0000-000000000001', 'E5', 'Évaluer', 'Valider et certifier. Démontrer la maîtrise des compétences agiles et obtenir la validation de la formation.', 5, true);

-- ============================================================
-- 17. PATH_ACTIVITIES  (from ParcoursView PHASES)
-- ============================================================
-- E1 activities
INSERT INTO public.path_activities (id, phase_id, type, title, description, is_completed, sort_order) VALUES
  ('pa000000-0000-0000-0000-000000000001', 'pp000000-0000-0000-0000-000000000001', 'situation', 'Mise en situation — Chef de projet sous pression',        'Scénario immersif : votre équipe ne livre pas, le client appelle. Comment réagissez-vous ?', true,  1),
  ('pa000000-0000-0000-0000-000000000002', 'pp000000-0000-0000-0000-000000000001', 'video', 'Vidéo — Pourquoi l''Agilité transforme le management ?', 'Témoignages de managers ayant adopté les méthodes agiles. Format court, impactant.', true,  2),
  ('pa000000-0000-0000-0000-000000000003', 'pp000000-0000-0000-0000-000000000001', 'quiz', 'Auto-diagnostic — Quel manager êtes-vous aujourd''hui ?', 'Questionnaire de positionnement initial (8 questions). Résultat personnel confidentiel.', true,  3);

-- E2 activities
INSERT INTO public.path_activities (id, phase_id, type, title, description, is_completed, sort_order) VALUES
  ('pa000000-0000-0000-0000-000000000004', 'pp000000-0000-0000-0000-000000000002', 'cas', 'Cas pratique — 3 projets : lequel a réussi grâce à l''Agilité ?', 'Analyse de cas réels issus de la tech, du retail et des RH. Discussion guidée.', true,  1),
  ('pa000000-0000-0000-0000-000000000005', 'pp000000-0000-0000-0000-000000000002', 'elearning', 'Découverte interactive — Le tableau Kanban en action', 'Simulation d''un Kanban board à compléter en autonomie, avec feedback instantané.', true,  2),
  ('pa000000-0000-0000-0000-000000000006', 'pp000000-0000-0000-0000-000000000002', 'podcast', 'Podcast — Retour d''expérience DRH sur l''Agilité RH', 'Interview exclusive d''une DRH ayant mené la transformation agile de 400 personnes.', true,  3),
  ('pa000000-0000-0000-0000-000000000007', 'pp000000-0000-0000-0000-000000000002', 'exercice',  'Exercice — Cartographier votre flux de travail actuel',            'Représentez vos tâches actuelles sur un Kanban simplifié. Première prise de recul.', true,  4);

-- E3 activities
INSERT INTO public.path_activities (id, phase_id, type, title, description, is_completed, sort_order) VALUES
  ('pa000000-0000-0000-0000-000000000008',  'pp000000-0000-0000-0000-000000000003', 'module',    'Module — Les 4 valeurs et 12 principes du Manifeste Agile',       'Contenu structuré en 6 séquences avec schémas, exemples et points clés mémorisables.', false, 1),
  ('pa000000-0000-0000-0000-000000000009',  'pp000000-0000-0000-0000-000000000003', 'video',     'Vidéo — Scrum en 15 min : rôles, cérémonies, artefacts',          'Animation pédagogique claire et mémorisable. Le meilleur résumé Scrum du marché.', false, 2),
  ('pa000000-0000-0000-0000-000000000010', 'pp000000-0000-0000-0000-000000000003', 'module', 'Module — Le rôle du manager dans une équipe auto-organisée',       'Comment passer du contrôle à la facilitation. Outils pratiques pour lâcher prise.', false, 3),
  ('pa000000-0000-0000-0000-000000000011', 'pp000000-0000-0000-0000-000000000003', 'exercice',  'Exercice — Remplir un backlog de sprint simulé',                   'Exercice guidé avec feedback automatique. Comprendre la priorisation par la valeur.', false, 4);

-- E4 activities
INSERT INTO public.path_activities (id, phase_id, type, title, description, is_completed, sort_order) VALUES
  ('pa000000-0000-0000-0000-000000000012', 'pp000000-0000-0000-0000-000000000004', 'projet', 'Projet — Plan de transformation Agile de votre équipe', 'Livrable individuel : diagnostic + plan d''action en 1 page. Critères fournis.', false, 1),
  ('pa000000-0000-0000-0000-000000000013', 'pp000000-0000-0000-0000-000000000004', 'simulation', 'Simulation — Animer une rétro d''équipe difficile',                'Jeu de rôle avec personnages résistants. Pratiquer la facilitation sous pression.', false, 2),
  ('pa000000-0000-0000-0000-000000000014', 'pp000000-0000-0000-0000-000000000004', 'exercice',  'Atelier — Prioriser un backlog conflictuel',                      'Exercice de prise de décision sous contraintes business et humaines.', false, 3);

-- E5 activities
INSERT INTO public.path_activities (id, phase_id, type, title, description, is_completed, sort_order) VALUES
  ('pa000000-0000-0000-0000-000000000015', 'pp000000-0000-0000-0000-000000000005', 'quiz',       'Quiz final — 20 questions — Management Agile',                    'Couverture complète des 4 phases. Seuil de réussite : 75 %. 2 tentatives autorisées.', false, 1),
  ('pa000000-0000-0000-0000-000000000016', 'pp000000-0000-0000-0000-000000000005', 'simulation', 'Cas de synthèse — Piloter une équipe en crise de sprint',         'Évaluation en conditions réelles. Grille partagée avant la session.', false, 2),
  ('pa000000-0000-0000-0000-000000000017', 'pp000000-0000-0000-0000-000000000005', 'eval', 'Évaluation de la formation par l''apprenant',                      'Satisfaction, utilité perçue, recommandation — 5 min. Anonyme et confidentiel.', false, 3),
  ('pa000000-0000-0000-0000-000000000018', 'pp000000-0000-0000-0000-000000000005', 'feedback',   'Retour personnalisé formateur sur le livrable E4',                'Commentaires individuels écrits + recommandations pour la suite du parcours.', false, 4);

-- Re-enable RLS
SET session_replication_role = 'origin';
