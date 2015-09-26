Because Javascript in a browser is not normally multi-threaded, it is
very convenient to use the monadic cooperative threads of
[Lwt](http://ocsigen.org/lwt). This library contains the core of `Lwt`
that can be compiled under ocamljs, along with a few functions in
`Lwt_dom` for timers etc. At present it is most useful with
[orpc](http://code.google.com/p/orpc2). See the
[Ocamldoc](http://ocamljs.googlecode.com/svn/doc/index.html).