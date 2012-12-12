BeamerScape
===========

About
-----
This script takes an Inkscape .svg as input, and generates pdf files corresponding to each of the layers and a LaTeX file that uses the LaTeX Beamer commands to incrementally overlay them. It will export the layers into a directory with the same basename as the .svg file. The layers will be exported in pdf format to preserve transparency. See [http://code.google.com/p/beamerscape/source/browse/ the source browser] for files.

_Released under a new BSD license._

Example
-------

[Inkscape File With Layers & Manual Overlay Spec](http://beamerscape.googlecode.com/hg/figures/beamer_template__ov.svg)

[Generated LaTeX](http://code.google.com/p/beamerscape/source/browse/figures/beamer_template__ov/overlay.tex)

[PDF From pdflatex](http://beamerscape.googlecode.com/hg/test.pdf)


Changelist
----------
 * 0.4 - added "--export-latex" argument to inkscape export command
 * 0.3 - swiched to use pgfimage instead of includegraphics
 * 0.2 - more control over display, more robust layer extraction
  * general code cleanup
  * added xml parsing to get layer names
  * added manual overlay specification
 * 0.1 - initial release 

Usage
-----

First create an inkscape svg with multiple layers. If you copy the [template svg](http://code.google.com/p/beamerscape/source/browse/figures/beamer_template__ov.svg) file, it will already have a convenient grid and the correct aspect ratio set up for standard beamer presentations (4:3). Once you have added your drawings, call (assuming `export_overlays` is in your path):

    export_overlays path/to/some_file.svg
    
This will create files in `path/to/some_file/*.pdf` as well as `path/to/some_file/overlay.tex` Note that it is possible to put this step as an implicit rule in a latex makefile for convenience.  See MakefileExample for an example to automate the generation of overlays.

This tex file can be used with beamer to create successive overlays. The tex output uses the `textpos` package, so in order for the generated file compile, you must have the following in your preamble:

    \usepackage[absolute,overlay]{textpos}
    \setlength{\TPHorizModule}{\paperwidth}
    \setlength{\TPVertModule}{\paperheight}
    \textblockorigin{0mm}{0mm}

Then add the following to your beamer tex file in the frame that you want the overlays to appear:

    \input{path/to/some_file/overlay.tex}

Note that the `\includegraphics` macros for each layer will appear in the "bottom-up" order that they appear in the inkscape file.

Advanced Usage
--------------

You can tell `export_overlays` specifically which layers you want to appear when by putting the overlay specification into the layer name. If you want the default behavior, that causes the display to be identical to the inkscape file, you can leave names without any specification. In other words, the layers:
 * "LayerX"
 * "LayerB"
 * "LayerA"

Would appear in the order A,B,X. Note that the _names_ of the layers are not important except for the overlay specification. You could specify each frame manually like so:
 * "LayerX`<3->`"
 * "LayerB`<2->`"
 * "LayerA`<1->`"

You could specify this manually using `<+->` as well (this is the default behavior):
 * "LayerX`<+->`"
 * "LayerB`<+->`"
 * "LayerA`<+->`"

If, however, you only wanted "LayerA" to appear alone during the first overlay, and not afterwards, you can specify it like so:
 * "LayerX`<+->`"
 * "LayerB`<+(1)->`"
 * "LayerA`<1>`"

Or, alternatively:
 * "LayerX"
 * "LayerB`<+(1)->`"
 * "LayerA`<1>`"

See the [Beamer User Guide](http://mirrors.ibiblio.org/pub/mirrors/CTAN/macros/latex/contrib/beamer/doc/beameruserguide.pdf), _sec. 3.10_ and _sec. 9.6.4_ to learn more about overlay specification. Also note that Inkscape 0.47, 0.48.1 [do *not* save a file if all you have changed is a layer name](https://bugs.launchpad.net/inkscape/+bug/806302), so you will need to move something back-and-forth and re-save if you want changes in layer names to be written to disk.
