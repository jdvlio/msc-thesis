LATEX= pdflatex
BIBTEX= bibtex
BASE= cos
TEXROOT= ${BASE}.tex
SUBDIR!= find . -type d ! -path '.' ! -path './.git/*' -print
TEXINCLUDE!= find . -type f -name '*.tex' ! -path './${TEXROOT}' ! -path './.git/*' -print

build: ${BASE}.pdf

pdf:
	pdflatex ${TEXROOT}

cos.pdf: ${BASE}.aux
	pdflatex ${TEXROOT}

cos.aux: ${TEXROOT} ${TEXINCLUDE} references.bib
	pdflatex -draftmode ${TEXROOT}
	makeglossaries ${BASE}
	for dir in ${SUBDIR} ; do \
		cp -f references.bib $$dir ; \
	done
	bibtex ${BASE} || /usr/bin/true
	find . -type f -name '*.aux' ! -path './${BASE}.aux' ! -path './.git/*' -execdir bibtex '{}' ';'
	pdflatex -draftmode ${TEXROOT}

clean:
	find . -type f ! -path './.git/*' ! -name '*\.tex' \
		! -path './*\.bib' ! -name '*\.sh' ! -name '\.gitignore' \
		! -name LICENSE \
		! -name Makefile -delete
	find . -regex '.*/\.auctex-auto(/.*)?' -delete

fmt:
	find . -type f -name '*.tex' ! -path './${TEXROOT}' ! -path './.git/*' \
		-exec latexindent -w '{}' ';'

.PHONY: build clean fmt pdf
