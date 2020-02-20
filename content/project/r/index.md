+++
title = "R"
date = 2018-02-28T14:15:30-05:00
draft = false

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ['R']

# Project summary to display on homepage.
summary = "I am an avid user of the statistical software [R](https://cran.r-project.org/) for all my quantitative research projects."

# Optional image to display on homepage.
image_preview = "r_logo_high_res.png"

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false

# Does the project detail page use source code highlighting?
highlight = true

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
[header]
image = "r_logo_high_res.png"
caption = "Image credit: [Hadley Wickham and others at RStudio](https://www.r-project.org/logo/) "

+++
Although I am a qualitative researcher at heart, I'm also a keen user of the statistical software [R](https://cran.r-project.org/) for my quantitative research projects. To my mind, R offers a number of advantages. It is free, it produces beautiful and informative plots, it encourages analytical thinking and familiarization with statistical concepts. It is also becoming extremely popular and it has a vibrant community of software developers and users that can provide assistance and develop new tools to deal with tasks as they emerge.

I attended the [Oxford Spring School in Modern Regression](https://www.politics.ox.ac.uk/spring-school/oxford-spring-school-in-advanced-research-methods.html) in 2010 that was taught by [Dr. Robert Andersen](http://politicalscience.uwo.ca/people/faculty/full-time_faculty/robert_andersen.html) and [Dr. David Armstrong](http://politicalscience.uwo.ca/people/faculty/full-time_faculty/dave_armstrong.html). Since then, all of my R learning has been self-taught.  To date I have used R to conduct sentiment analysis, event history analysis, as well as standard OLS and logistic regression. I have taught three successive introductory courses in R at the [Laurier School In Research Methods](http://www.lsirm.ca).

One marginally useful innovation I have developed for R is a plugin to the [tm](https://cran.r-project.org/web/packages/tm/index.html) ("text mining") package that reads in files containing news articles from Canadian media outlets in the [Canadian Newsstream](http://www.proquest.com/products-services/canadian_newsstand.html) database.  It extracts all of the useful metadata contained in each article (e.g. author, title, date of publication and word length, as well as section and page number) and prepares the article text for computer assisted content analysis. I have intentions of preparing the package for submission to CRAN, but for the moment, you can get a working version from my [github](https://github.com/sjkiss/tm.newsstand).
