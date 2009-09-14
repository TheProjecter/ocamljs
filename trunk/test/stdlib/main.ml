open OUnit

let tests = "Stdlib" >::: [
  Stdlib_array.tests;
  Stdlib_hashtbl.tests;
  Stdlib_pervasives.tests;
  Stdlib_printf.tests;
]

;;

OUnit.run_test_tt_main tests
