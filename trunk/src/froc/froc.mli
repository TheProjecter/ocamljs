type 'a result = Value of 'a | Fail of exn
type 'a event
type 'a behavior

val init : unit -> unit
val set_debug : (string -> unit) -> unit
val set_exn_handler : (exn -> unit) -> unit

val return : 'a -> 'a behavior
val fail : exn -> 'a behavior
val bind : 'a behavior -> ('a -> 'b behavior) -> 'b behavior
val (>>=) : 'a behavior -> ('a -> 'b behavior) -> 'b behavior
val bind_lift : 'a behavior -> ('a -> 'b) -> 'b behavior
val (>>) : 'a behavior -> ('a -> 'b) -> 'b behavior
val catch : (unit -> 'a behavior) -> (exn -> 'a behavior) -> 'a behavior
val try_bind : (unit -> 'a behavior) -> ('a -> 'b behavior) -> (exn -> 'b behavior) -> 'b behavior
val catch_lift : (unit -> 'a behavior) -> (exn -> 'a) -> 'a behavior
val try_bind_lift : (unit -> 'a behavior) -> ('a -> 'b) -> (exn -> 'b) -> 'b behavior

val read : 'a behavior -> 'a
val read_result : 'a behavior -> 'a result
val notify_b : 'a behavior -> ('a result -> unit) -> unit
val switch : 'a behavior behavior -> 'a behavior

val make : unit -> 'a event
val send : 'a event -> 'a -> unit
val send_exn : 'a event -> exn -> unit
val send_result : 'a event -> 'a result -> unit

val notify_e : 'a event -> ('a result -> unit) -> unit

val merge : 'a event list -> 'a event
val map : ('a -> 'b) -> 'a event -> 'b event
val filter : ('a -> bool) -> 'a event -> 'a event
val collect : ('b -> 'a -> 'b) -> 'b -> 'a event -> 'b event

val hold : 'a -> 'a event -> 'a behavior
val hold_result : 'a result -> 'a event -> 'a behavior
val changes : 'a behavior -> 'a event
val when_true : bool behavior -> unit event
val count : 'a event -> int behavior