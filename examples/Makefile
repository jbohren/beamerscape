
all: test.pdf

# Generate eps filenames
EPS_FIGS=$(shell find figures | grep '\.eps')
PDF_FIGS=$(addsuffix .pdf,$(basename $(EPS_FIGS)))

# Generate overlay filenames
OVERLAY_SRCS=$(shell ls figures/*__ov.svg)
OVERLAYS=$(basename $(OVERLAY_SRCS))

# EPS generation rule
figures/%.pdf : figures/%.eps
	ps2pdf -dEPSCrop $^ $@

# Overlay generation rule
figures/%__ov: figures/%__ov.svg
	export_overlays $^

# Proxy rule for all figures
figures: $(OVERLAYS)

test.pdf: test.tex figures $(OVERLAY_SRCS)
	pdflatex test.tex

