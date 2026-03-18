# Vibe Task — Setup Guide

A clean, minimal task manager organized by people and projects.
Web app + iPhone home screen app, synced via the cloud.

---

## What You Need

Three free accounts:
- **GitHub** (github.com) — stores your code
- **Supabase** (supabase.com) — your database
- **Vercel** (vercel.com) — hosts the website

---

## Step 1: Supabase Setup

### Create a project
1. Go to **supabase.com** → sign in with GitHub
2. Click **New Project**
3. Name: `vibetask`
4. Set a database password (save it somewhere safe)
5. Region: **East US**
6. Click **Create new project** (takes ~2 minutes)

### Create the database tables
1. Go to **SQL Editor** in the left sidebar
2. Click **New Query**
3. Open `supabase-schema.sql` from this project, copy everything, paste it in
4. Click **Run**
5. You should see "Success. No rows returned"

### Create the attachments bucket
1. Go to **Storage** in the left sidebar
2. Click **New bucket**
3. Name: `attachments`
4. Toggle **Private** on
5. Click **Create bucket**

### Turn off email confirmation
1. Go to **Authentication** → **Providers** → **Email**
2. Toggle OFF **Confirm email**
3. Click **Save**

### Copy your API keys
1. Go to **Settings** (gear icon) → **API**
2. Keep this page open — you need:
   - **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - **anon public** key (long string starting with `eyJ...`)

---

## Step 2: GitHub Setup

1. Go to **github.com** → click **+** → **New repository**
2. Name: `vibetask`
3. Leave all checkboxes unchecked
4. Click **Create repository**
5. Click **uploading an existing file**
6. Drag ALL contents of the `vibetask` folder into the upload area

**Important:** The files must be at the root level of the repo. When you look at your repo, you should see `package.json`, `index.html`, etc. at the top level — not inside a subfolder.

**Note about hidden files:** The `.gitignore` file may not be visible in your file browser. I've included a copy named `gitignore.txt` — upload that too. If you can see and upload `.gitignore` directly, you don't need the `.txt` version.

---

## Step 3: Deploy on Vercel

1. Go to **vercel.com/new**
2. Find and **Import** your `vibetask` repository
3. Framework should auto-detect as **Vite**
4. Click **Environment Variables** and add:

   | Name | Value |
   |------|-------|
   | `VITE_SUPABASE_URL` | `https://your-project-id.supabase.co` |
   | `VITE_SUPABASE_ANON_KEY` | `eyJ...your-long-key` |

5. Click **Deploy**
6. Wait ~60 seconds

---

## Step 4: First Login

1. Visit your Vercel URL (e.g., `vibetask-abc123.vercel.app`)
2. Click **Sign up**, enter email and password
3. You're in — start adding people, projects, and tasks

---

## Step 5: Add to iPhone

1. Open your Vercel URL in **Safari** on your iPhone
2. Sign in
3. Tap the **Share** button (square with arrow)
4. Tap **Add to Home Screen**
5. Tap **Add**

You now have a Vibe Task icon on your home screen that opens full-screen.

---

## How It Works

**Sidebar** — lists people and projects alphabetically
- Tap a **name** → opens task list
- Tap the **note icon** (📄/📝) → opens notes for that person/project
- Long-press (mobile) or right-click (desktop) → archive
- Archived items can be restored from the ↩ link at bottom

**Tasks**
- Checkbox to complete (completed tasks drop to collapsible section)
- Click task text to edit inline
- ＋/▸ button expands details: notes, due date, activation date, attachments
- Due dates turn red when within 3 days
- Activation dates hide tasks until that date arrives
- Drag to reorder (desktop) or use ↑↓ buttons (mobile)
- Completing a task auto-deletes its attachments

---

## Troubleshooting

**Blank screen or API errors** → Double-check environment variables in Vercel (no extra spaces)

**Can't sign up** → Make sure email confirmation is turned off in Supabase (Step 1)

**Files in a subfolder on GitHub** → `package.json` must be at the repo root, not inside `vibetask/vibetask/`

**Storage errors for attachments** → Make sure you created the `attachments` bucket in Supabase Storage AND ran the full SQL schema

---

## Project Structure

```
vibetask/
├── index.html
├── package.json
├── vite.config.js
├── supabase-schema.sql
├── .gitignore
├── gitignore.txt          ← visible copy of .gitignore
├── public/
│   ├── manifest.json
│   ├── icon-192.png
│   └── icon-512.png
└── src/
    ├── main.jsx
    ├── App.jsx
    ├── Auth.jsx
    ├── TaskFlow.jsx
    └── supabaseClient.js
```
