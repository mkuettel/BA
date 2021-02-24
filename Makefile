all: $(wildcard *.tex) Referenzen.bib
	pdflatex BA-Bericht.tex
	#bibtex BA-Bericht
	pdflatex BA-Bericht.tex
	pdflatex BA-Bericht.tex

clean:
	rm -f *.aux *.glo *.idx *.log *.toc *.ist *.acn *.acr *.alg *.bbl *.blg *.dvi *.glg *.gls *.ilg *.ind *.loa *.lof *.lot *.lol *.maf *.mtc *.mtc1 *.out *.synctex.gz BA-Bericht.pdf build/*

open:
	evince BA-Bericht.pdf &

watch:
	stdbuf -o0 inotifywait -mrcq . | stdbuf -i0 -o0 -e0 egrep 'MODIFY|CREATE|MOVE|DELETE' | stdbuf -i0 -o0 -e0 grep -vE '.*\.(log|out|pdf|~|.sw?)' | while read line; do make -f Makefile; done

