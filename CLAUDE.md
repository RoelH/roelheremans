# CLAUDE.md

Project guide for agents working in this repo.

## What this is
Roel Heremans' personal website (`roelheremans.com`). Ruby on Rails app.

- **Ruby** 3.3.0 · **Rails** ~> 7.1.3
- **Backend admin:** ActiveAdmin (+ Devise) — all content is edited here, not in code
- **Frontend:** importmap + Stimulus + Turbo; Sprockets assets; SCSS/CSS in `app/assets/stylesheets`
- **DB:** PostgreSQL (`pg`)
- **Images:** Cloudinary (delivered via `cloudinary_delivery_url` helper)
- **Other:** `friendly_id` (slugs), `kaminari` (pagination)
- **Deploy:** Scalingo — auto-deploys on push to `master` (the `fly.toml` in the repo is not the live host; ignore it)

## Run / dev
```bash
bin/setup            # install deps + prepare db
bin/rails server     # local server (Puma)
bin/rails console
```
Puma is started in production via `Procfile` (`web: bundle exec puma -C config/puma.rb`).

## Test
Minitest + Capybara/Selenium.
```bash
bin/rails test
```

## Deploy
**Scalingo**, auto-deployed on push to `master` (no manual deploy command). Procfile/Puma run the app; health check hits `/up` (`rails/health#show`). Note: a `fly.toml` exists in the repo but is not the live host — don't run `fly deploy`.

## Routes / pages (`config/routes.rb`)
- `root` → `works#index`
- `works` (index, show)
- `speaking`, `cv`, `about`, `contact`, `newsletter` → `profil` controller
- `innerportrait/:slug` (+ password check) → `inner_portraits`
- Prompt archive: `prompt`, `prompt/submit`, `prompt_database`, `prompt/beacon`
- `/up` health check
- ActiveAdmin routes + Devise for `admin_users`

## Models
`profil`, `work`, `inner_portrait`, `speaking`, `speaking_logo`, `video`, `photo`, `prompt_submission`, `cv_category`, `address`, `admin_user`.

## Key files for SEO / title / favicon
This is the current area of active interest.

- `app/helpers/application_helper.rb`
  - `DEFAULT_META_TITLE` — site `<title>` (currently "Roel Heremans | Neurotech Artist and Keynote Speaker")
  - `DEFAULT_META_DESCRIPTION` — meta description
  - `PERSON_SCHEMA` — JSON-LD `Person` (`jobTitle`/`hasOccupation` = "Neurotech Artist" + "Keynote Speaker"; `sameAs` → Wikidata). This is what Google reads for the Knowledge Panel.
  - Note: "neurotech" is the *job title*; "neurotechnology" still appears as a *topic* word on the speaking page (e.g. "AI & Neurotechnology…") — that's intentional, leave it.
  - `cloudinary_delivery_url` — inserts `f_auto,q_auto,w_,h_,c_` transforms into Cloudinary URLs
- `app/views/layouts/application.html.erb`
  - `<title>`, meta description, favicon `<link>`s (self-hosted set in `public/` — see Favicon below)
  - Wikidata `rel="me"` link (Q140002789)
  - JSON-LD injection via `person_schema_json`
- **Favicon** (self-hosted in `public/`, no longer Cloudinary):
  - `favicon.svg` is primary — **bold, theme-adaptive**: the ring + EEG wave flip black/white via `@media (prefers-color-scheme)`; the four colored marks (red top, green right, blue left, yellow bottom) stay fixed.
  - `favicon.ico` (16/32/48) + `favicon-16.png` / `favicon-32.png` are tab/legacy fallbacks; `apple-touch-icon.png` (+ `-precomposed`, 180×180, **hairline on white**) is the iOS home-screen icon; `favicon-192.png` / `favicon-512.png` + `site.webmanifest` cover PWA.
  - The "Inner wave" mark = four witnesses around a measured inner image (the IIC). Render wrappers/scripts lived in `tmp/favicon_build/` (not committed).

## Conventions
- Content (works, speaking, profil, etc.) is managed through ActiveAdmin (`app/admin/*`), not hardcoded.
- Serve images through `cloudinary_delivery_url` for automatic format/quality/resize.
- Commit only when asked; don't touch the `*.dump` / `*.pgsql` DB snapshots at repo root.
