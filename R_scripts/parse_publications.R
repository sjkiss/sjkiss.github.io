# Running the function for publications
source("R_scripts/bibtex_2academic.R")
articles <- c("publications/articles/kiss_my_articles.bib")
reports<-c("publications/reports/kiss_reports.bib")
out_fold   <- "publications"
#Create articles
bibtex_2academic(bibfile  = articles,
                 outfold   = file.path(out_fold, "articles"),
                 abstract  = T,
                 overwrite = T)

#Create reports
bibtex_2academic(bibfile  =reports,
                 outfold   = file.path(out_fold, "reports"),
                 abstract  = T,
                 overwrite = T)
