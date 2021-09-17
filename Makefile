
.PHONY: build clean pdf

LATEX= pdflatex
BIBTEX= bibtex
BASE= cos
TEXROOT= ${BASE}.tex
SUBDIR!= find -type d ! -path '.' ! -path './.git/*' -print0
TEXINCLUDE!= find -type f -name '*.tex' ! -path './${TEXROOT}' ! -path './.git/*' -print

build: ${BASE}.pdf

pdf:
	pdflatex ${TEXROOT}

cos.pdf: ${BASE}.aux
	pdflatex ${TEXROOT}

cos.aux: ${TEXROOT} ${TEXINCLUDE} references.bib
	pdflatex -draftmode ${TEXROOT}
	makeglossaries ${BASE}
	for dir in ${SUBDIR} ; do \
		ln -sf references.bib $$dir ; \
	done
	find -type f -name '*.aux' ! -path './.git/*' -execdir bibtex '{}' ';'
	pdflatex -draftmode ${TEXROOT}

clean:
	find -type f ! -path './.git/*' ! -name '*\.tex' \
		! -name '*\.bib' ! -name '*\.sh' ! -name '\.gitignore' \
		! -name Makefile -delete
