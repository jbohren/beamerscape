Beamerscape
===========

About
-----
This script takes an Inkscape .svg as input, and generates pdf files corresponding to each of the layers and a LaTeX file that uses the LaTeX Beamer commands to incrementally overlay them. It will export the layers into a directory with the same basename as the .svg file. The layers will be exported in pdf format to preserve transparency.

_Released under a new BSD license._

Example
-------

See the built-in examples [here](https://github.com/jbohren/beamerscape/tree/master/examples). The `export_overlays` example uses/builds the following:
 - [Inkscape File With Layers & Manual Overlay Spec](http://beamerscape.googlecode.com/hg/figures/beamer_template__ov.svg)
 - [Generated LaTeX](http://code.google.com/p/beamerscape/source/browse/figures/beamer_template__ov/overlay.tex)
 - [PDF From pdflatex](http://beamerscape.googlecode.com/hg/test.pdf)


Changelist
----------
 * 0.5 - added optional output path argument & disabled --export-latex argument
 * 0.4 - added "--export-latex" argument to inkscape export command
 * 0.3 - swiched to use pgfimage instead of includegraphics
 * 0.2 - more control over display, more robust layer extraction
  * general code cleanup
  * added xml parsing to get layer names
  * added manual overlay specification
 * 0.1 - initial release 

Dependencies
------------
 - Required
  - inkscape >= 0.47
  - latex
  - latex beamer
  - perl
  - perl bindings to libxml2
 - Optional
  - CMake >= 2.8.3

### Installing Dependencies on Ubuntu Linux

    sudo apt-get install cmake inkscape latex-beamer perl libxml-libxml-perl

Usage
-----

### 1. Create the Overlay Source SVG

Create an inkscape svg with multiple layers. Each layer in the SVG will appear in sequence in the final beamer presentation. If you copy the [template svg](http://code.google.com/p/beamerscape/source/browse/figures/beamer_template__ov.svg) file, it will already have a convenient grid and the correct aspect ratio set up for standard beamer presentations (4:3). The layers will appear in _bottom-up_ order from how they're defined in the Inkscape file.

### 2. Generate the Overlays
Once you have added your drawings, call the `export_overlays` script with an optional output path:

    export_overlays path/to/overlay_source.svg [path/to/generated_overlays]
    
This will create files in `path/to/overlay_source/*.pdf` as well as `path/to/overlat_source/overlay.tex` unless you specify an destination path, in which case, the `overlay_source` directory will be created there.

### 4. Add the Overlays to a Beamer Presentation

The `overlays.tex` tex file can be used within a beamer presentation to create successive overlays. The tex output uses the `textpos` package, so in order for the generated file compile, you must have the following in your preamble:

    \usepackage[absolute,overlay]{textpos}
    \setlength{\TPHorizModule}{\paperwidth}
    \setlength{\TPVertModule}{\paperheight}
    \textblockorigin{0mm}{0mm}

Then add the following to your beamer tex file in the frame that you want the overlays to appear:

    \input{path/to/overlay_source/overlay.tex}

Note that the `\includegraphics` macros for each layer will appear in the "bottom-up" order that they appear in the inkscape file.

Advanced Usage
--------------

### Building with CMake

It's useful to use a build system if you're generating a large number of presentations (i.e. for a course or seminar). In this case, you can use CMake to build your Beamer presentations. See the CMakeLists.txt file found in the examples directory [here](https://github.com/jbohren/beamerscape/blob/master/examples/CMakeLists.txt) for ean example. Also, due to CMake's use of out-of-source builds, all of the build products (and by-products!) will be contained in your build directory, so they don't litter your LaTeX source dir. 

### Manipulating How Overlays Appear

You can tell `export_overlays` specifically which layers you want to appear when by putting the overlay specification into the layer name. If you want the default behavior, that causes the display to be identical to the inkscape file, you can leave names without any specification. In other words, the layers:
 * `LayerX`
 * `LayerB`
 * `LayerA`

Would appear in the order A,B,X. Note that the _names_ of the layers are not important except for the overlay specification. You could specify each frame manually like so:
 * `<3->LayerX`
 * `<2->LayerB`
 * `<1->LayerA`

You could specify this manually using `<+->` as well (this is the default behavior):
 * `<+->LayerX`
 * `<+->LayerB`
 * `<+->LayerA`

If, however, you only wanted `LayerA` to appear alone during the first overlay, and not afterwards, you can specify it like so:
 * `<+->LayerX`
 * `<+(1)->LayerB`
 * `<1>LayerA`

Or, alternatively:
 * `LayerX`
 * `<+(1)->LayerB`
 * `<1>LayerA`

See the [Beamer User Guide](http://mirrors.ibiblio.org/pub/mirrors/CTAN/macros/latex/contrib/beamer/doc/beameruserguide.pdf), _sec. 3.10_ and _sec. 9.6.4_ to learn more about overlay specification. Also note that Inkscape 0.47, 0.48.1 [do *not* save a file if all you have changed is a layer name](https://bugs.launchpad.net/inkscape/+bug/806302), so you will need to move something back-and-forth and re-save if you want changes in layer names to be written to disk.
