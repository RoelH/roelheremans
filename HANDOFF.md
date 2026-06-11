# HANDOFF

Working state for the next agent session. (See `CLAUDE.md` for durable project facts.)

## Recent goal
Sharpen Roel's identity to **"Neurotech Artist and Keynote Speaker"** and give the site a real favicon. Both are **done and shipped to `master`** (which auto-deploys to Scalingo).

## Done
- **Title / SEO** — changed "Neurotechnology Artist" → **"Neurotech Artist"** in `app/helpers/application_helper.rb`: page `<title>`, meta description, and JSON-LD `PERSON_SCHEMA` (`jobTitle` + `hasOccupation`). Test updated (`test/controllers/profil_controller_test.rb`). "Neurotechnology" intentionally kept as a *topic* word on the speaking page.
- **Favicon** — replaced the single Cloudinary PNG with a self-hosted **"Inner wave"** set in `public/`:
  - `favicon.svg` — bold, theme-adaptive (ring + EEG wave flip black/white; four colored marks fixed).
  - `favicon.ico` (16/32/48), `favicon-16/32.png` — tab/legacy fallbacks.
  - `apple-touch-icon.png` (+ `-precomposed`, 180, hairline on white) — iOS home screen.
  - `favicon-192/512.png` + `site.webmanifest` — PWA.
  - `<head>` links updated in `app/views/layouts/application.html.erb`.
- **Docs** — `CLAUDE.md` favicon + deploy notes corrected (deploy is **Scalingo**, not Fly.io; `fly.toml` is a leftover — ignore it).

## Open / next (manual, off-repo)
- **Wikidata Q140002789** (the real Google Knowledge-Panel lever): edit the description "Belgian artist and keynote speaker" → **"Belgian neurotech artist and keynote speaker"**, and add **"neurotech artist"** as an alias. `occupation` (P106) can't say "neurotech artist" — no such Wikidata item; leave the existing art occupations.
- **Off-site consistency** for the title to stick in Google: LinkedIn headline, speaker bios, press/interview blurbs, YouTube descriptions → "neurotech artist".
- **Favicon caching** — after a deploy, browsers may keep the old tab icon for a while; hard-refresh or visit `/favicon.svg` to force it.

## Notes
- **Deploy:** Scalingo, automatic on push to `master`. No manual deploy command; don't run `fly deploy`.
- **Favicon meaning:** the four colored marks = a small group of witnesses around a measured inner image (the IIC); bold weight for tabs, hairline weight for the large apple-touch icon.
- **Untracked, pre-existing, not part of this work:** `.DS_Store`, `public/llms.txt`, `public/llms-full.txt` — left uncommitted.
