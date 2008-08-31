(*
 * This file is part of ocamljs, OCaml to Javascript compiler
 * Copyright (C) 2007 Skydeck, Inc
 * Original file (driver/compile.ml in the Objective Caml source
 * distribution) is Copyright (C) INRIA.
 *
 * This program is free software released under the QPL.
 * See LICENSE for more details.
 *
 * The Software is provided AS IS with NO WARRANTY OF ANY KIND,
 * INCLUDING THE WARRANTY OF DESIGN, MERCHANTABILITY AND 
 * FITNESS FOR A PARTICULAR PURPOSE.
 *)

(* The batch compiler *)

open Misc
open Config
open Format
open Typedtree

(* Initialize the search path.
   The current directory is always searched first,
   then the directories specified with the -I option (in command-line order),
   then the standard library directory (unless the -nostdlib option is given).
 *)

let init_path () =
  let dirs =
    if !Clflags.use_threads then "+threads" :: !Clflags.include_dirs
    else if !Clflags.use_vmthreads then "+vmthreads" :: !Clflags.include_dirs
    else !Clflags.include_dirs in
  let exp_dirs =
    List.map (expand_directory Config.standard_library) dirs in
  load_path := "" :: List.rev_append exp_dirs (Clflags.std_include_dir ());
  Env.reset_cache ()

(* Return the initial environment in which compilation proceeds. *)

(* Note: do not do init_path() in initial_env, this breaks
   toplevel initialization (PR#1775) *)
let initial_env () =
  Ident.reinit();
  try
    if !Clflags.nopervasives
    then Env.initial
    else Env.open_pers_signature "Pervasives" Env.initial
  with Not_found ->
    fatal_error "cannot open pervasives.cmi"

(* Compile a .mli file *)

let interface ppf sourcefile outputprefix =
  init_path ();
  let modulename =
    String.capitalize(Filename.basename(chop_extension_if_any sourcefile)) in
  Env.set_unit_name modulename;
  let inputfile = Pparse.preprocess sourcefile in
  try
    let ast =
      Pparse.file ppf inputfile Parse.interface ast_intf_magic_number in
    if !Clflags.dump_parsetree then fprintf ppf "%a@." Printast.interface ast;
    let sg = Typemod.transl_signature (initial_env()) ast in
    if !Clflags.print_types then
      fprintf std_formatter "%a@." Printtyp.signature
                                   (Typemod.simplify_signature sg);
    Warnings.check_fatal ();
    if not !Clflags.print_types then
      Env.save_signature sg modulename (outputprefix ^ ".cmi");
    Pparse.remove_preprocessed inputfile
  with e ->
    Pparse.remove_preprocessed_if_ast inputfile;
    raise e

(* Compile a .ml file *)

let print_if ppf flag printer arg =
  if !flag then fprintf ppf "%a@." printer arg;
  arg

let (++) x f = f x

let implementation ppf sourcefile outputprefix =
  init_path ();
  let modulename =
    String.capitalize(Filename.basename(chop_extension_if_any sourcefile)) in
  Env.set_unit_name modulename;
  let inputfile = Pparse.preprocess sourcefile in
  let env = initial_env() in
  if !Clflags.print_types then begin
    try ignore(
      Pparse.file ppf inputfile Parse.implementation ast_impl_magic_number
      ++ print_if ppf Clflags.dump_parsetree Printast.implementation
      ++ Typemod.type_implementation sourcefile outputprefix modulename env)
    with x ->
      Pparse.remove_preprocessed_if_ast inputfile;
      raise x
  end else begin    
    let objfile = outputprefix ^ ".cmjs" in
    let oc = open_out_bin objfile in
    try
      Pparse.file ppf inputfile Parse.implementation ast_impl_magic_number
      ++ print_if ppf Clflags.dump_parsetree Printast.implementation
      ++ Unused_var.warn ppf
      ++ Typemod.type_implementation sourcefile outputprefix modulename env
      ++ Translmod.transl_implementation modulename
      ++ print_if ppf Clflags.dump_rawlambda Printlambda.lambda
      ++ Simplif.simplify_lambda
      ++ print_if ppf Clflags.dump_lambda Printlambda.lambda
      ++ Jsgen.compile_implementation modulename
      ++ print_if ppf Clflags.dump_instr (fun ppf (js, _) -> Jslib_pp.stmt ppf js)
      ++ Emitjs.to_file oc modulename;
      Warnings.check_fatal ();
      Pparse.remove_preprocessed inputfile;
      close_out oc;
    with x ->
      close_out oc;
      remove_file objfile;
      Pparse.remove_preprocessed_if_ast inputfile;
      raise x
  end
