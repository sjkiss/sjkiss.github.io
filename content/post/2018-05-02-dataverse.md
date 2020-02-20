+++
title = "Welcome To The Dataverse"
date = 2018-05-02T15:04:50-04:00
draft = false
# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = []
categories = []

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
# Use `caption` to display an image caption.
#   Markdown linking is allowed, e.g. `caption = "[Image credit](http://example.org)"`.
# Set `preview` to `false` to disable the thumbnail in listings.
[header]
image = ""
caption = ""
preview = true

+++

The dataverse is an initiative associated with Harvard University's [Institute for Quantitative Social Sciences](https://www.iq.harvard.edu/). It establishes a fairly user-friendly space for scholars to store data-sets, documentation and code.  

Going forward, it's going to be a bigger part of scholarship to make datasets and code publicly available to hold scholars to account for their claims. You may have heard, but science (or at least some disciplines in science (*cough* psychology *cough*) are in a fairly profound replication crisis. The dataverse is meant to address this by making it dead easy for scholars to upload their data and their code to a publicly-available, free and searchable database. Reflecting this increased importance, SSHRC is rolling out new (and presumably stricter) guidelines in the next  year or two about Research Data Management. 

<!-- In a conversation, a biologist, in theory, anybody should be able to download the data and the code, run it, and sbe able to get the plots and tables right there, exactly as they appear in the publication.   -->

In Ontario, Ontario universities have collaborated to establish their own network of dataverses [here](https://dataverse.scholarsportal.info/). And, yes, I've got my own working [dataverse](https://dataverse.scholarsportal.info/dataverse.xhtml?alias=sjkiss) where I'll be be uploading my datasets and code mostly associated with peer-reviewed articles, but sometimes dealing with fun stuff I'm working on. 

To that point, here's something fun, as part of some ongoing research into Canada's NDP, I had reason to try to figure out the evolution of the NDP's fundraising over its history. [Elections Canada](http://www.elections.ca/content.aspx?section=fin&&document=index&lang=e) has been doing some great work on making parties' financial returns available, but I was interested in stuff going back to the 1970s and 1980s, and that seems to be locked up. Jansen and Young (2009, 2011) have very good data on the NDP, but the numbers are not available digitally, at least such that I could find them. I also found a very good table in Archer (1990), but again, the raw numbers are nowhere to be found. 

This seems to me to be...wrong., in an age where the cost of memory and storage space is so low. 

So, I decided to do something about it.  

First, I used my home (home!) printer to scan one of Archer's tables that has the NDP's contributions, as reported to Elections Canada, by source from 1979 to 1986. From there, I got this ![pdf](/img/archer_table.pdf). Because I splurged on Adobe Acrobat Pro a few years ago, I was able to use its handy OCR tool to parase that into a spreadsheet.  With a few modifications, I was able to get a spreadsheet that looks like the one right [here](http://dx.doi.org/10.5683/SP/DPBTKP). 

And, I can also add in an R file right [here](doi:10.5683/SP/DPBTKP) that you can download to make a version of this plot that shows the breakdown of individual and union contributions to the federal party, compared to the revenue that provincial parties earned during the same time period. 

![NDP fundraising](/img/ndp_fundraising.jpeg)

# References
Archer, Keith. (1990). Political choices and electoral consequences: A study of organized Labour and the New Democratic Party. McGill-Queen’s Press-MQUP.
Jansen, Harold J., & Young, Lisa. (2009). Solidarity forever? The NDP, organized labour, and the changing face of party finance in Canada. Canadian Journal of Political Science/Revue Canadienne de Science Politique, 42(3), 657–678.

Jansen, Harold J., & Young, Lisa. (2011). Money, politics, and democracy: Canada’s party finance reforms. Vancouver: UBC Press.
