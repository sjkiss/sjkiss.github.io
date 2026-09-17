# sync_bib.R  —  Quarto pre-render step.
# The single source of truth for publications is the Better BibTeX auto-export
# of the Zotero "kiss_articles" collection, stored in the CV folder. Copy it
# into the site before every render so the whole website builds from that one
# file. Edit publications in Zotero; the auto-export refreshes the CV .bib;
# `quarto render` picks it up here.

src <- "../CV/Bib_files/kiss_articles.bib"          # canonical CV file (sibling of Website/)
dst <- "publications/kiss_articles.bib"             # site copy the pages read

if (file.exists(src)) {
  ok <- file.copy(src, dst, overwrite = TRUE)
  if (ok) message("sync_bib: copied ", src, " -> ", dst)
  else    warning("sync_bib: copy failed; using existing ", dst)
} else {
  warning("sync_bib: source not found at '", src,
          "' — building from the existing ", dst)
}
