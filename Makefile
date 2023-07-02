## Own website built using distill 
## effects/paper

current: target
-include target.mk

######################################################################

Sources += $(wildcard *.R *.md *.Rnw *.rmd *.Rmd *.bib *.css)
Sources += docs/cv/*
Sources += docs/images/*

######################################################################

## Create empty page template -- only fresh page
create_empty_page:
	echo "library(distill); create_website(dir=\"__site\", title=\"Steve Bicko Cygu\", gh_pages = FALSE)" | R --slave
	cp __site/_site.yml __site/index.Rmd .
	rm -rf __site

create_postcard:
	echo "library(distill); create_article(file=\"postcard\", template=\"jolla\", package=\"postcards\")" | R --slave

## Create html files from Rmd/rmd files
%.html.newpages: %.Rmd
	echo "library(rmarkdown); render_site(\"$*.Rmd\")" | R --slave
	$(MAKE) docs
	cp -a site_libs docs
	rm -rf site_libs
	cp $*.html docs
	cp _site.yml docs
	git add -f docs/$*.html docs/_site.yml docs/site_libs
	touch Makefile

######################################################################

index.html.newpages: index.Rmd
software.html.newpages: software.Rmd

all:
	$(MAKE) index.html.newpages
	$(MAKE) software.html.newpages

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

-include makestuff/chains.mk
-include makestuff/texi.mk
-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
