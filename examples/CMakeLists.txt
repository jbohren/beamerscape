
cmake_minimum_required(VERSION 2.8.3)

# Include Kenneth Moreland's LaTeX CMake module
include(../cmake/UseLATEX.cmake)

# Include our Beamerscape CMake module
include(../cmake/UseBeamerscape.cmake)

# Add our example beamerscape overlay
add_beamerscape_overlay(figures/beamerscape_example.svg)

# Add our main presentation (make a PDF by default)
add_latex_document(test.tex
  DEPENDS ${BEAMERSCAPE_OVERLAY_TARGETS}
  DEFAULT_PDF)
