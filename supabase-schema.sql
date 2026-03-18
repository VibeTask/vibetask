-- ============================================
-- Vibe Task — Complete Database Schema
-- Paste this entire file into Supabase SQL Editor
-- (Dashboard > SQL Editor > New Query > Paste > Run)
-- ============================================

-- Groups table (people and projects)
create table groups (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  name text not null,
  notes text default '',
  archived boolean default false,
  created_at timestamptz default now()
);

-- Tasks table
create table tasks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  group_id uuid references groups on delete cascade not null,
  title text not null,
  notes text default '',
  done boolean default false,
  activate_date date,
  due_date date,
  position float default 0,
  created_at timestamptz default now()
);

-- Attachments table
create table attachments (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  task_id uuid references tasks on delete cascade not null,
  file_name text not null,
  file_path text not null,
  file_size bigint default 0,
  created_at timestamptz default now()
);

-- Row Level Security
alter table groups enable row level security;
alter table tasks enable row level security;
alter table attachments enable row level security;

create policy "Users manage own groups" on groups
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users manage own tasks" on tasks
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users manage own attachments" on attachments
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Indexes
create index idx_groups_user on groups (user_id);
create index idx_tasks_group on tasks (group_id);
create index idx_tasks_user on tasks (user_id);
create index idx_attachments_task on attachments (task_id);

-- Storage policies for attachments bucket
create policy "Users upload own files" on storage.objects
  for insert with check (
    bucket_id = 'attachments' and
    (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users read own files" on storage.objects
  for select using (
    bucket_id = 'attachments' and
    (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users delete own files" on storage.objects
  for delete using (
    bucket_id = 'attachments' and
    (storage.foldername(name))[1] = auth.uid()::text
  );
