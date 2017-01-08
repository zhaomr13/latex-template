# $Id: Makefile 81803 2015-10-01 09:53:38Z mzhao $
# ===============================================================================
# Purpose: simple Makefile to streamline processing latex document (just say "make" to execute)
# Author: Tomasz Skwarnicki
# Created on: 2010-09-24
# A few changes by Patrick Koppenburg on 2015-06-26
# ===============================================================================

# name of the main latex file (do not include .tex)
MAIN = main

# name of the target - change that to something descriptive, like paper-v0, Bs2PhiPhi-ANA-v1, etc...
TARGET = QFT

# name of command to perform Latex (either pdflatex or latex)
LATEX = xelatex
NOBIB = True

ifeq ($(LATEX),xelatex)
	FIGEXT = .pdf
	MAINEXT= .pdf
	BUILDCOMMAND=rm -f $(MAIN).aux && $(LATEX) $(MAIN) && $(LATEX) $(MAIN)
else
	FIGEXT = .eps
	MAINEXT= .pdf
	ifeq ($(NOBIB), True)
	BUILDCOMMAND=rm -f $(MAIN).aux && $(LATEX) $(MAIN) && $(LATEX) $(MAIN) && $(LATEX) $(MAIN) && dvips -z -o $(MAIN).ps $(MAIN) && ps2pdf $(MAIN).ps && rm -f head.tmp body.tmp
else
	BUILDCOMMAND=rm -f $(MAIN).aux && $(LATEX) $(MAIN) && bibtex $(MAIN) && $(LATEX) $(MAIN) && $(LATEX) $(MAIN) && dvips -z -o $(MAIN).ps $(MAIN) && ps2pdf $(MAIN).ps && rm -f head.tmp body.tmp
endif
endif

# list of all source files
TEXSOURCES = $(wildcard *.tex) $(wildcard *.bib)
FIGSOURCES = $(wildcard figs/*$(FIGEXT))
SOURCES    = $(TEXSOURCES) $(FIGSOURCES)

# define output (could be making .ps instead)
OUTPUT = $(TARGET)$(MAINEXT)

# cp temporary main.pdf to target.
$(OUTPUT): $(MAIN)$(MAINEXT)
	cp $(MAIN)$(MAINEXT) $(OUTPUT)

# prescription how to make output (your favorite commands to process latex)
# do latex twice to make sure that all cross-references are updated 
$(MAIN)$(MAINEXT): $(SOURCES) Makefile
	$(BUILDCOMMAND)

# just so we can say "make all" without knowing the output name
all: $(OUTPUT)

# remove temporary files (good idea to say "make clean" before putting things back into repository)
.PHONY : clean
clean:
	rm -f *~ *.aux *.log *.bbl *.blg *.dvi *.tmp *.out *.blg *.bbl $(OUTPUT) $(MAIN)$(MAINEXT) $(MAIN).ps

# remove output file
rmout: 
	rm $(OUTPUT) $(MAIN)$(MAINEXT)
