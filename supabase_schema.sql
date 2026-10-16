-- منصة زاد للدعم المدرسي
-- نفّذ هذا الملف في Supabase SQL Editor بعد مراجعة السياسات.
-- ملاحظة: الملفات الخاصة والدفعات تحتاج إعدادات آمنة إضافية قبل النشر.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role text not null default 'student' check (role in ('student','teacher','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null default '',
  grade_level text not null default '',
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.lessons (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  title text not null,
  summary text not null default '',
  content text not null default '',
  file_path text,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null default '',
  published_at timestamptz not null default now(),
  is_published boolean not null default false
);

create table if not exists public.enrollments (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  subject_id uuid not null references public.subjects(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','active','cancelled')),
  created_at timestamptz not null default now(),
  unique(student_id, subject_id)
);

alter table public.profiles enable row level security;
alter table public.subjects enable row level security;
alter table public.lessons enable row level security;
alter table public.announcements enable row level security;
alter table public.enrollments enable row level security;

-- المستخدم يرى ملفه فقط. لا تسمح للمستخدم بتغيير دوره بنفسه.
create policy "profile read own" on public.profiles
for select to authenticated using (id = auth.uid());

create policy "profile insert own" on public.profiles
for insert to authenticated with check (id = auth.uid() and role = 'student');

create policy "published subjects visible" on public.subjects
for select to anon, authenticated using (is_published = true);

create policy "published lessons visible" on public.lessons
for select to anon, authenticated using (is_published = true);

create policy "published announcements visible" on public.announcements
for select to anon, authenticated using (is_published = true);

create policy "students read own enrollments" on public.enrollments
for select to authenticated using (student_id = auth.uid());

create policy "students request enrollment" on public.enrollments
for insert to authenticated with check (student_id = auth.uid() and status = 'pending');

-- لا تُضف سياسات كتابة عامة. أضف صلاحيات الإدارة عبر آلية موثوقة
-- (مثل دالة تحقق آمنة من دور المستخدم) قبل تمكين لوحة الإدارة.
