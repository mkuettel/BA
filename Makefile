FILE_NAME=BA-Bericht
PRESENTATION_FILE_NAME=Presentation
MEETING_NOTES=Meetings/24-02-2021.pdf Meetings/26-02-2021.pdf Meetings/03-03-2021.pdf Meetings/03-03-2021-1400.pdf Meetings/05-03-2021.pdf Meetings/10-03-2021.pdf Meetings/12-03-2021.pdf Meetings/19-03-2021.pdf Meetings/24-03-2021.pdf Meetings/31-03-2021.pdf Meetings/14-04-2021.pdf Meetings/21-04-2021.pdf
PDFLATEXOPTS := -shell-escape -interaction=nonstopmode

ifdef draft
	PDFLATEXOPTSDRAFT=-draftmode $(PDFLATEXOPTS)
else
	PDFLATEXOPTSDRAFT=$(PDFLATEXOPTS)
endif


all: $(wildcard *.tex) Referenzen.bib $(MEETING_NOTES) include/journal-total-hours.csv uml.out
	pdflatex ${PDFLATEXOPTSDRAFT} ${FILE_NAME}.tex
	biber *.bcf
	makeglossaries ${FILE_NAME}
	pdflatex ${PDFLATEXOPTSDRAFT} ${FILE_NAME}.tex
	pdflatex ${PDFLATEXOPTS} ${FILE_NAME}.tex

pres: ${PRESENTATION_FILE_NAME}.tex Referenzen.bib
	pdflatex ${PDFLATEXOPTSDRAFT} ${PRESENTATION_FILE_NAME}.tex
	biber *.bcf
	pdflatex ${PDFLATEXOPTSDRAFT} ${PRESENTATION_FILE_NAME}.tex
	pdflatex ${PDFLATEXOPTS} ${PRESENTATION_FILE_NAME}.tex

Meetings/%.pdf: Meetings/%.md
	pandoc --from markdown --to latex $< \
		--metadata-file=Meetings/pandoc-settings.yml \
	-o $@

include/journal-total-hours.csv: include/journal.csv
	bin/calc-journal-hours

uml.out: $(wildcard include/uml/*.txt)
	plantuml include/uml/*.txt
	touch uml.out

clean:
	rm -f *.aux *.glo *.idx *.log *.toc *.ist *.acn *.acr *.alg *.bbl *.blg *.dvi *.glg *.gls *.ilg *.ind *.loa *.lof *.lot *.lol *.maf *.mtc *.mtc1 *.out *.synctex.gz BA-Bericht.pdf build/* $(MEETING_NOTES) include/journal-total-hours.csv

open:
	evince ${FILE_NAME}.pdf &

watch:
	find . -iname '*.tex' -or -iname '*.csv' -or -iname '*.txt' -or -iname '*.md' -or -iname 'References.bib' | entr make -f Makefile

open-pres:
	open ${PRESENTATION_FILE_NAME}.pdf

watch-pres:
	find . -iname '*.tex' -or -iname '*.csv' -or -iname '*.txt' -or -iname '*.md' -or -iname 'References.bib' | entr make -f Makefile pres
