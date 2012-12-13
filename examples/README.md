Beamerscape Examples
====================

These examples show some of the basic usage of Beamerscape's `export_overlays`
script. These examples can either be built manually, or with the use of CMake. 

Manual Compilation
------------------

    ../bin/export_overlays figures/beamerscape_example.svg
    pdflatex test.tex

Compilation with CMake
----------------------
    
    mkdir build
    cd build
    cmake ..
    make
