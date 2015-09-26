### Installing ocamljs ###

  1. Prerequisites: OCaml 3.10.2 or 3.11.0, [Findlib](http://projects.camlcity.org/projects/findlib.html), [ulex](http://www.cduce.org/download.html#side)
  1. Unpack the OCaml distribution into SRCDIR.
  1. In the ocamljs directory, run ./configure -srcdir SRCDIR
  1. 'make' builds ocamljs and the associated libraries
  1. 'make install' installs ocamljs and the associated libraries
  1. 'make test' runs the test suite; you will need SpiderMonkey or other Javascript interpreter
  1. 'make examples' builds all the examples

### Using ocamljs ###

The command 'ocamljs' may be used just like ocamlc or ocamlopt. It
generates .cmjs/.cmjsa files instead of .cmo/.cma. A linked file (.js)
consists of Javascript source, which may be run through a standalone
Javascript interpreter, or embedded in a web page or Firefox
extension. See the examples for details.

See tools/myocambuild.ml for some useful ocamlbuild rules.

There is also [findlib support](Findlib.md).