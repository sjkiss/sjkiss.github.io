# How publications work on this site

Everything you see under **Publications**, the **Recent Publications** box on the
home page, and the publication lists on each **Project** page comes from **one
file**, exported automatically from Zotero. This note explains the whole chain
so future-you (or anyone) can maintain it.

---

## The one-file rule

```
Zotero "kiss_articles" collection
        │  (Better BibTeX auto-export, on every change)
        ▼
CV/Bib_files/kiss_articles.bib      ← the single source of truth
        │  (copied in automatically at build time)
        ▼
Website/publications/kiss_articles.bib
        │  (read by the site's R code)
        ▼
Publications page · Home "Recent" · Project pages
```

You never edit the `.bib` files by hand. **You edit publications in Zotero**, and
the rest follows.

---

## To add or change a publication

1. In Zotero, add/edit the item in the **`kiss_articles`** collection.
2. Better BibTeX auto-exports it to `CV/Bib_files/kiss_articles.bib` (this happens
   on its own whenever the collection changes).
3. Rebuild the site (see [Rebuilding](#rebuilding-and-publishing)).

That's it. A publication appears on the site simply because it's **in the
`kiss_articles` collection**. There's no separate "show on website" flag.

> ⚠️ **One setting to leave alone.** The `kiss_articles.bib` auto-export in Zotero
> (Settings → Better BibTeX → Automatic export) must have **"Export all child
> collections" UNCHECKED**. If it gets checked, the whole `Full_Professor_articles`
> dossier — including cited references that aren't your papers — gets pulled in,
> and dozens of extra entries appear on the site.

---

## Tags: how a paper gets its topic chips and lands on a project page

The little grey chips under each publication (e.g. *Risk*, *Public Opinion*) and
the decision about **which project page a paper appears on** both come from
**Zotero Tags**.

- Add tags in Zotero's normal **Tags** pane. They export to the bib `keywords`
  field, and the site treats them as **subject tags**.
- **Administrative tags are hidden.** Anything in this list is treated as
  bookkeeping and never shown or matched:
  `mine, notmine, inprint, forthcoming, journalarticle, peerreviewed, notpeer,
  invited, sshrc, lispop, nosource`.
- Everything **else** is a subject tag.

### Matching a paper to a project

Each project page looks for papers whose subject tag matches the project. Case,
hyphens, and spaces don't matter — the Zotero tag `public-opinion` matches the
**Public Opinion** project and displays as "Public Opinion".

| Project page            | Zotero tag to use        |
|-------------------------|--------------------------|
| Risk                    | `risk`                   |
| Public Opinion          | `public-opinion`         |
| Social Democracy        | `social-democracy`       |
| Political communication | `political-communication`|
| R                       | `r`                      |
| Open Science            | `open-science`           |

So: **tag a paper `risk` in Zotero → it shows on the Risk project page with a
"Risk" chip.** (A few older synonyms like `risk perception` still match Risk too;
see `category_term_map` in the code if you want to adjust these.)

The `mine` tag is **no longer needed** — the `kiss_articles` collection already
contains only your papers.

---

## Blog posts on project pages

Each project page also lists related **blog posts**. A post joins a project when
its front-matter `categories:` includes that project's category. For example, in
a post's `index.qmd`:

```yaml
categories:
  - Social Democracy
```

---

## Rebuilding and publishing

From the `Website/` folder:

```bash
quarto render
git add -A
git commit -m "Update publications"
git push
```

- `quarto render` runs the pre-render step, copies the latest CV `.bib` in, and
  builds everything into `docs/`.
- Pushing to GitHub updates the live site (GitHub Pages serves the `docs/`
  folder). Give it a minute, then hard-refresh (`Cmd+Shift+R`).

---

## The moving parts (for reference)

| File | What it does |
|------|--------------|
| `CV/Bib_files/kiss_articles.bib` | **Source of truth.** Zotero auto-export of the `kiss_articles` collection. |
| `_quarto.yml` | Registers the pre-render step under `project: pre-render:`. |
| `R_scripts/sync_bib.R` | Pre-render step: copies the CV `.bib` into `publications/`. |
| `publications/kiss_articles.bib` | The site's working copy (overwritten on every build). |
| `R_scripts/project_listings.R` | Shared code: reads the bib, builds publication cards, derives subject tags, matches papers to projects, renders the home "Recent" list. |
| `publications.qmd` | The Publications page (its own card layout + category filter). |
| `index.qmd` | Home page, incl. the "Recent Publications" block. |
| `projects/*/index.qmd` | Each project page (related posts + matching publications). |
| `styles.css` | Card styling; hides the auto-generated bibliography used for citations. |
| `assets/pub-cards.js` | The Abstract / Citation / BibTeX toggle buttons on cards. |

### A note on citations
The **Citation** button on each card shows a formatted reference. That comes from
a hidden bibliography Quarto generates via `bibliography:` + `nocite: '@*'` in the
page front-matter (kept in the page but hidden with CSS). If citations ever go
blank, check those two front-matter lines are still present.
