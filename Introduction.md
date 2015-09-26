Ocamljs is a system for compiling OCaml to Javascript. It includes a
Javascript back-end for the OCaml compiler, as well as several support
libraries, such as bindings to the browser DOM. It also works with
[orpc](http://code.google.com/p/orpc2) for RPC over HTTP to an OCaml
server, and [froc](http://code.google.com/p/froc) for functional
reactive programming.

Ocamljs is written by Jake Donham, with contributions from Mike Wells
and Haoyang Wang.

  * [how to install and use ocamljs](Installation.md)
  * [the Javascript back-end](Jscomp.md)
  * [interfacing with native code](Interfacing.md)
  * [findlib support](Findlib.md)

  * [Ocamljs](Ocamljs.md) ocamljs support library
  * [Stdlib](Stdlib.md) support for the OCaml standard library
  * [Javascript](Javascript.md) binding to built-in Javascript libraries
  * [Dom](Dom.md) binding to browser DOM
  * [Mozilla](Mozilla.md) binding to Mozilla API
  * [Lwt\_js](Lwt_js.md) library for cooperative threading
  * [Jslib](Jslib.md) library for working with Javascript using Camlp4
  * [Gears](Gears.md) Google Gears binding

See the [Ocamldoc](http://ocamljs.googlecode.com/svn/doc/index.html)
and some [examples](http://ocamljs.googlecode.com/svn/examples/index.html).

### Contributing ###

If you find a bug, it would be very helpful to get a test case that
produces different behavior from regular OCaml (see `test/jscomp` for
examples). Other contributions are very welcome as well. See also the
[mailing list](http://groups.google.com/group/ocamljs-discuss).