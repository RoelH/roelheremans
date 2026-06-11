# HANDOFF

Working state for the next agent session. (See `CLAUDE.md` for durable project facts.)

## Goal
Sharpen Roel's professional identity to **"Neurotech Artist and Keynote Speaker"** across the web, and improve the favicon.

## Done (shipped to master)
- Changed **"Neurotechnology Artist" → "Neurotech Artist"** in `app/helpers/application_helper.rb`: page `<title>`, meta description, and JSON-LD `PERSON_SCHEMA` (`jobTitle` + `hasOccupation`). Test updated. Committed + pushed (`Rename title to Neurotech Artist`).
- Left "neurotechnology" as a *topic* word on the speaking page (e.g. "AI & Neurotechnology…") — intentional, it's the field, not his title.

## Wikidata findings (item Q140002789)
Google's Knowledge Panel label ("Keynote-spreker") is driven mainly by Wikidata + web-wide corroboration, not the page `<title>`.
- **`occupation` (P106) cannot say "neurotech artist"** — it only accepts existing Wikidata items, and no such item exists. Creating one risks deletion as a coined term. Keep the existing art occupations (visual / installation / new media artist + keynote speaker).
- **Highest-impact edits (free text, no item needed):**
  - Edit the **description** "Belgian artist and keynote speaker" → "Belgian neurotech artist and keynote speaker".
  - Add **"neurotech artist"** as an **alias** (also known as).
- These are manual edits the user makes on wikidata.org (not in this repo).

## Still open
- **Favicon:** wants something cooler / more mysterious, possibly **animated**; current one looks too small. Live favicon is the Cloudinary PNG in `app/views/layouts/application.html.erb:14`; `public/favicon.ico` + apple-touch icons are 0-byte/empty. No concept chosen yet. (Note: browsers largely ignore animated favicons; animated SVG/APNG support is limited.)
- **Off-site consistency** (for Google to relabel him "neurotech artist"): LinkedIn headline, speaker bios, press/interview blurbs, YouTube descriptions should all say "neurotech artist". Optionally claim the Google Knowledge Panel.

## Repo housekeeping
- Untracked at root: `public/llms.txt`, `public/llms-full.txt`, and a modified `.DS_Store` — not part of the title work, left uncommitted.
