# project_listings.R
# Helper for project pages: render publication cards filtered by a project's
# category tag(s). Publications live in a single .bib file and carry topical
# tags in their `annotation` field, so we match the project's Quarto
# `categories:` against those annotation terms.
#
# Usage inside a project's index.qmd:
#   source(here_project("R_scripts/project_listings.R"))
#   render_project_pubs(c("Social Democracy", "Public Opinion"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(RefManageR)
  library(htmltools)
})

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a

# ---- locate the project root (folder containing _quarto.yml) --------------
find_project_root <- function(start = getwd()) {
  dir <- normalizePath(start, mustWork = FALSE)
  repeat {
    if (file.exists(file.path(dir, "_quarto.yml"))) return(dir)
    parent <- dirname(dir)
    if (identical(parent, dir)) stop("Could not locate _quarto.yml (project root).")
    dir <- parent
  }
}
here_project <- function(...) file.path(find_project_root(), ...)

# ---- category -> annotation-term mapping ----------------------------------
# Project categories don't always appear verbatim in the bib `annotation`
# field. Map each category to the annotation term(s) that identify it.
# A category with no publications maps to character(0).
category_term_map <- list(
  "Risk"                    = c("risk perception", "risk"),
  "Public Opinion"          = c("public opinion"),
  "Political communication" = c("political communication"),
  "Social Democracy"        = c("social democracy"),
  "R"                       = character(0),
  "Open science"            = character(0),
  "reproducibility"         = character(0)
)

category_terms <- function(categories) {
  terms <- unlist(lapply(categories, function(cat) {
    mapped <- category_term_map[[cat]]
    if (is.null(mapped)) tolower(cat) else c(tolower(cat), tolower(mapped))
  }))
  unique(terms[nzchar(terms)])
}

# ---- bib formatting helpers (mirrors publications.qmd) --------------------
strip_braces <- function(x) {
  if (is.null(x) || length(x) == 0) return(NA_character_)
  gsub("[{}]", "", as.character(x), perl = TRUE)
}

fmt_authors_card <- function(entry) {
  au <- entry$author
  if (is.null(au) || length(au) == 0) return(NA_character_)
  fmt_one <- function(a) {
    given  <- paste(a$given  %||% "", collapse = " ")
    family <- paste(a$family %||% "", collapse = " ")
    trimws(paste(given, family))
  }
  pieces <- vapply(au, fmt_one, character(1))
  pieces <- pieces[nzchar(pieces)]
  if (!length(pieces)) return(NA_character_)
  if (length(pieces) == 1) return(pieces)
  paste(paste(pieces[-length(pieces)], collapse = ", "), "&", pieces[length(pieces)])
}

get_abstract <- function(entry) {
  abs <- entry$abstract %||% entry$annotation %||% NA_character_
  if (isTRUE(is.na(abs)) || !nzchar(abs)) NA_character_ else abs
}

get_bibtex <- function(entry) {
  out <- tryCatch({
    e <- entry
    e$note <- NULL; e$Note <- NULL
    txt <- paste0(utils::toBibtex(e), collapse = "\n")
    txt <- sub(",\\s*\\n?\\s*\\}$", "\n}", txt, perl = TRUE)
    gsub("\n{3,}", "\n\n", txt)
  }, error = function(err) NA_character_)
  if (is.na(out) || !nzchar(out)) NA_character_ else out
}

normalize_link <- function(x) {
  y <- trimws(as.character(x))
  y[is.na(y) | y == "" | tolower(y) == "na"] <- NA_character_
  ok <- !is.na(y)
  doi_pref <- ok & grepl("^doi:\\s*", y, ignore.case = TRUE)
  y[doi_pref] <- sub("^doi:\\s*", "", y[doi_pref], ignore.case = TRUE)
  bare_doi <- ok & grepl("^10\\.", y)
  y[bare_doi] <- paste0("https://doi.org/", y[bare_doi])
  domain_like  <- ok & grepl("^(www\\.|[A-Za-z0-9.-]+\\.[A-Za-z]{2,})(/|$)", y)
  no_scheme    <- ok & !grepl("^https?://", y, ignore.case = TRUE)
  needs_scheme <- domain_like & no_scheme
  y[needs_scheme] <- paste0("https://", y[needs_scheme])
  y
}

# ---- read + tidy the bib --------------------------------------------------
build_rows <- function(bib_path = here_project("publications/kiss_articles.bib")) {
  bib  <- ReadBib(bib_path, check = FALSE)
  keys <- names(bib)
  tibble(key = keys, entry = lapply(keys, function(k) bib[k])) |>
    mutate(
      annotation   = map_chr(entry, ~ .x$annotation %||% ""),
      title        = map_chr(entry, ~ strip_braces(.x$title %||% "")),
      authors_card = map_chr(entry, fmt_authors_card),
      year         = map_chr(entry, ~ {
        y <- .x$year %||% .x$date %||% ""
        if (is.list(y)) y$year %||% "" else as.character(y)
      }),
      venue    = map_chr(entry, ~ strip_braces(.x$journal %||% .x$booktitle %||% .x$publisher %||% "")),
      abstract = map_chr(entry, get_abstract),
      bibtex   = map_chr(entry, get_bibtex),
      doi      = map_chr(entry, ~ .x$doi %||% NA_character_),
      url_fallback  = map_chr(entry, ~ .x$url %||% NA_character_),
      preprint_raw  = map_chr(entry, ~ { v <- .x$preprint;  if (is.null(v) || length(v)==0) NA_character_ else as.character(v[[1]]) }),
      materials_raw = map_chr(entry, ~ { v <- .x$materials; if (is.null(v) || length(v)==0) NA_character_ else as.character(v[[1]]) })
    ) |>
    mutate(
      preprint_url  = normalize_link(preprint_raw),
      materials_url = normalize_link(materials_raw),
      doi_url = normalize_link(if_else(
        nzchar(doi %||% ""),
        str_glue("https://doi.org/{doi}"),
        if_else(nzchar(preprint_url %||% ""), preprint_url, url_fallback)
      )),
      year_num = suppressWarnings(as.integer(str_extract(year, "\\d{4}")))
    ) |>
    arrange(desc(year_num), title)
}

# ---- card builder (mirrors publications.qmd) ------------------------------
build_card <- function(key, entry, title, authors_card, year, venue,
                       abstract, bibtex,
                       preprint_url = NA_character_, materials_url = NA_character_,
                       doi_url = NA_character_, ...) {
  has_preprint_key  <- !is.null(entry$preprint)  && length(entry$preprint)  > 0
  has_materials_key <- !is.null(entry$materials) && length(entry$materials) > 0

  category_block <- NULL
  if (!is.null(entry$annotation) && nzchar(entry$annotation)) {
    category_list <- strsplit(entry$annotation, ",\\s*")[[1]]
    category_block <- tags$div(class = "pub-category",
      lapply(category_list, function(category) tags$span(class = "category", category)))
  }

  # Treat missing (NA) values as empty so the JS shows its "not available"
  # fallback instead of a literal "NA".
  na_to_empty <- function(x) if (is.null(x) || length(x) == 0 || is.na(x)) "" else x
  payloads <- tags$div(style = "display:none;",
    tags$div(class = "payload-abstract", na_to_empty(abstract)),
    tags$div(class = "payload-bibtex",  na_to_empty(bibtex)))

  ttl_node <- if (isTRUE(nzchar(doi_url %||% ""))) {
    tags$div(class = "pub-title", tags$a(title, href = doi_url, target = "_blank", rel = "noopener"))
  } else {
    tags$div(class = "pub-title", title)
  }

  meta <- tags$div(class = "pub-meta",
    if (nzchar(authors_card %||% "")) tagList(HTML(authors_card), tags$br()) else NULL,
    if (nzchar(venue %||% "")) tags$em(venue) else NULL)

  actions <- tags$div(class = "pub-actions",
    tags$a("Abstract", href = "#", `data-action` = "abstract", role = "button"),
    tags$a("Citation", href = "#", `data-action` = "citation", role = "button"),
    tags$a("BibTeX",   href = "#", `data-action` = "bib",      role = "button"),
    if (isTRUE(has_preprint_key))
      tags$a("Preprint", class = "external", href = (preprint_url %||% "#"), target = "_blank", rel = "noopener"),
    if (isTRUE(has_materials_key))
      tags$a("Materials", class = "external", href = (materials_url %||% "#"), target = "_blank", rel = "noopener"))

  toggle_panel <- tags$div(class = "toggle-area", `data-current` = "",
    tags$button(class = "copy-btn", "Copy"),
    tags$span(class = "copy-toast", "Copied!"),
    tags$div(class = "panel-label", "—"),
    tags$div(class = "content"))

  tags$div(class = "pub-card", `data-key` = key, `data-year` = year,
    ttl_node, meta, category_block, actions, toggle_panel, payloads)
}

# ---- public entry point ---------------------------------------------------
# Render the publication cards whose annotation matches any of `categories`.
# Returns a browsable htmltools tag list (empty message if no matches).
render_project_pubs <- function(categories,
                                bib_path = here_project("publications/kiss_articles.bib"),
                                heading = "Publications") {
  terms <- category_terms(categories)
  rows  <- build_rows(bib_path)

  if (length(terms)) {
    # Match on whole annotation TERMS (comma-separated), not substrings, so a
    # short tag like "R" never matches "risk"/"class" etc.
    row_terms <- lapply(strsplit(tolower(rows$annotation), ",\\s*"), trimws)
    keep <- vapply(row_terms, function(v) any(terms %in% v), logical(1))
    rows <- rows[keep, , drop = FALSE]
  } else {
    rows <- rows[0, , drop = FALSE]
  }

  # No matches: render nothing (no dangling heading).
  if (nrow(rows) == 0) return(browsable(tagList()))

  cards <- rows |>
    select(key, entry, title, authors_card, year, venue,
           abstract, bibtex, preprint_url, materials_url, doi_url) |>
    pmap(build_card)

  browsable(tagList(
    tags$h2(class = "project-listing-heading", heading),
    tags$div(class = "pub-list", cards)
  ))
}

# Render the `n` most recent publications as cards (e.g. for the home page).
# Sorts by full date where available, falling back to year.
render_recent_pubs <- function(n = 3,
                               bib_path = here_project("publications/kiss_articles.bib")) {
  rows <- build_rows(bib_path)
  if (nrow(rows) == 0) return(browsable(tagList()))

  # Prefer a full date (YYYY-MM-DD); fall back to Jan 1 of the year.
  sort_date <- suppressWarnings(as.Date(rows$year, format = "%Y-%m-%d"))
  sort_date <- as.Date(ifelse(
    is.na(sort_date) & !is.na(rows$year_num),
    as.Date(paste0(rows$year_num, "-01-01")),
    sort_date
  ), origin = "1970-01-01")

  rows <- rows[order(sort_date, decreasing = TRUE), , drop = FALSE]
  rows <- head(rows, n)

  cards <- rows |>
    select(key, entry, title, authors_card, year, venue,
           abstract, bibtex, preprint_url, materials_url, doi_url) |>
    pmap(build_card)

  browsable(tags$div(class = "pub-list", cards))
}
