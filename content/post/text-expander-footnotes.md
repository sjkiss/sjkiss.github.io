---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Text Expander Footnotes"
subtitle: ""
summary: "I've discovered a neat way to use TextExpander to make authoring slides in Markdown go much more quickly."
authors: ["Simon J. Kiss"]
tags: ["Plain-text", "Open Science"]
categories: ["Data"]
date: 2020-09-14T09:35:04-04:00
lastmod: 2020-09-14T09:35:04-04:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

I've discovered a neat way to use  [TextExpander](https://textexpander.com/)  to make authoring slides in Markdown go much more quickly. I started using TextExpander for a lot of different reasons. I found myself typing the same introduction of myself over and over again, e.g., "My name is Simon Kiss and I'm a ....". And during grading season I found myself writing, "This is very strong but could use some improvements..." again and again. And asically I fell in love with TextExpander and I've been slowly building up different types of snippets. 

Parallel to this, I had started using [Markdown](https://daringfireball.net/projects/markdown/)  a lot more. This website is built with markdown and Hugo. Markdown is a plain-text markup language that can be incredibly easy to use and incredibly versatile. The same document can be converted into different file formats using [pandoc](https://pandoc.org/) (e.g. Word, PDF, slides). I really got into Markdown because there are ways you can integrate R, slides, and text into one document. So my vision was really to have a way to quickly write code and some thoughts into one document and post it to a website or convert it into slides for a presentation, all using the same basic platform.

I'm pretty much sold on the whole suite of software, but there are moments where I find it really frustrating, and here's one. I have been using [Deckset](https://www.deckset.com/) to convert my markdown files into presentations. The reason I ahve been doing this is using pandoc to convert a markdown document into slides can be tedious; Deckset just goes so quickly. But: there is a problem: Deckset does not use pandoc (which makes it go more quickly) but that means it does not process my bibtex citations using the pandoc-citeproc filter. For those who don't know, pandoc-citeproc is just a fabulous way of converting biblatex citations into properlly formatted citations and bilbiographies. 

So I had this problem that I would write slides and I would want to include a reference to some book or journal article for students. The answer was just to use markdown's built-in footnote system. Footnotes in markdown are dead easy. 

You just enter them in like this: 
```markdown
Here is an idea I would like to reference.[^1]

[^1]: Here is the footnote text
```

And then they look like this.

Here is an idea I would like to reference.[^1]

[^1]: Here is the footnote text

So that's pretty cool. And here's where TextExpander comes in. 

Typing this is pretty tedious. 
```markdown
[^1]

[^1]:
```


so, I just made a TextExpander snippet that looks like this: 

 ![footnote_snippet](https://github.com/sjkiss/Images/raw/master/footnote.png) 

The exact syntax is: 

```unix
[^%filltext:name=Footnote:width=1%]


[^%filltext:name=Footnote:width=1%]: %fillarea:name=area 1:width=20:height=5%
```

Now, whenever I want to add a footnote, I just type the shortcut (abbreviation) for a footnote and I get this:

![foonote_menu](https://github.com/sjkiss/Images/raw/master/footnote_menu.png) 

I just fill in the footnote number (in this case 3), and then I go over to Zotero and copy the full citation: 

![](https://github.com/sjkiss/Images/raw/master/agenda_setting_citation.png) 

And paste it into the text box. 

Which puts the following into my markdown document
```markdown
[^2]


[^2]: McCombs, M, and D Shaw. “The Agenda-Setting Function of Mass Media.” Public Opinion Quarterly 36, no. 2 (January 1, 1972): 176.
```

Which renders as this: [^2]


[^2]: McCombs, M, and D Shaw. “The Agenda-Setting Function of Mass Media.” Public Opinion Quarterly 36, no. 2 (January 1, 1972): 176.

et, voial. A quick, nicely formatted footnote reference that I can put into any markdown document I'm using to prepare slides which Deckset can process. And, even if I decide to use pandoc to turn the markdown documents into slides, it will process the document quickly and nicely as well. They won't be processed via pandoc-citeproc and it won't produce a bibliography, but good enough is good enough.

There is one important catch using the Markdown-Deckset combination as opposed to markdown-pandoc. With pandoc, you don't have to worry about the sequence about entering footnotes. So: entering the first footnote with: 

```markdown
 [^4]


[^4]: 
```
Will still render the footnote as ```1``` if it is the first footnote in the document. But Deckset can't do this. It translates the footnotes literally. This is a challenge, because often you might need to go back to the beginning and add a footnote reference in, meaning then that you have to change the actual numbers of all the footnotes that follow. This is frustrating and it would be nice for Deckset to figure out a way to change that.




