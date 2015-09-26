### How ocamljs compiles OCaml ###

Ocamljs uses the ocamlc front-end up to the point where it
generates 'lambda' code--an untyped representation that looks a lot
like Lisp. (You can see the lambda representation of OCaml code with
the -dlambda option to ocamlc or ocamljs.)

The translation is very direct: OCaml functions turn into
Javascript functions, OCaml exception handling to Javascript exception
handling, etc. Javascript distinguishes between expressions and
statements, while OCaml has only expressions, so there are two
compilations for most OCaml constructs, depending on which context the
construct appears in.

One difference between OCaml and Javascript is that functions in
OCaml may be applied to a different number of arguments than they are
defined to take. So OCaml function application is not compiled to
Javascript function application, but rather to a call to an apply
method which checks the number of arguments and either returns a
closure (for under-application) or tail calls the result of the
application with the extra arguments (for over-application). See
Xavier Leroy's talk
[From Krivine's machine to the Caml implementations](http://pauillac.inria.fr/~xleroy/talks/zam-kazam05.pdf).

This apply method is also where tail-recursion is implemented,
using trampolines. See `src/stdlib/support.js` for details.

Much of standard OCaml is implemented by a library of C primitives;
Javascript implementations of these (insofar as they have been
implemented) are in `src/ocamljs/primitives.js`. Some OCaml
primitives are implemented directly by the code generator; see
`comp_ccall` in `src/jscomp/jsgen.ml`.

### How ocamljs represents OCaml values in Javascript ###

OCaml ints, nativeints, int32s, floats, and characters are
represented by Javascript numbers. There is no support for int64s.

OCaml booleans are represented by either Javascript numbers or
booleans. OCaml lambda expressions don't distinguish between ints and
bools (it would be nice if they kept types around), but the Javascript
boolean operations return booleans. It would be inconvenient to
convert back and forth and/or reconstruct the types in order to
eliminate the conversions. 0 and 1 are acceptable in place of false
and true as operands to Javascript operators, but be careful of this
when interfacing to other code, which may distinguish between them
(see [Ocamljs](Ocamljs.md) and [Interfacing](Interfacing.md) for ways to get an actual Javascript
boolean).

OCaml heap blocks (used in OCaml to represent records, variants,
polymorphic variants, exceptions, and arrays) are represented by
Javascript arrays. Blocks may have a tag (used to distinguish branches
of variants), which is represented as an extra slot on the array
object. See `src/stdlib/support.js` for functions on blocks.

OCaml strings are mutable, but Javascript strings are immutable, so a
direct representation is not possible. Ocamljs represents mutable
strings as arrays of numbers (since it represents characters as
numbers). However, this representation seems expensive, and most of
the time you don't want to mutate your strings anyway, so OCaml
strings may also be represented by immutable Javascript strings. If
you write a literal string in OCaml, you get a literal string in
Javascript, but if you create a string with `String.create` (that is,
with the `caml_create_string` primitive) you get an array representing
a mutable string. You can read the elements of either string as usual,
but writing to an immutable string fails (at present with an
inscrutable error). `Pervasives.(^)` calls the Javascript `+`, and
`Buffer.contents` yields an immutable string.