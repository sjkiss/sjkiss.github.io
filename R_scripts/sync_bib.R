# sync_bib.R  —  Quarto pre-render step.
# The single source of truth for publications is the Better BibTeX auto-export
# of the Zotero "kiss_articles" and "kiss_reports" collections, stored in the
# CV folder. Copy them into the site before every render so the whole website
# builds from those files. Edit publications in Zotero; the auto-export
# refreshes the CV .bib files; `quarto render` picks them up here.

for (name in c("kiss_articles.bib", "kiss_reports.bib")) {
  src <- file.path("../CV/Bib_files", name)   # canonical CV file (sibling of Website/)
  dst <- file.path("publications", name)      # site copy the pages read

  if (file.exists(src)) {
    ok <- file.copy(src, dst, overwrite = TRUE)
    if (ok) message("sync_bib: copied ", src, " -> ", dst)
    else    warning("sync_bib: copy failed; using existing ", dst)
  } else {
    warning("sync_bib: source not found at '", src,
            "' — building from the existing ", dst)
  }
}
