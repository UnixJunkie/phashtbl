(* a hash table stored on disk (e.g. because it would not fit in RAM) *)

type filename = string

(* val find: t -> string -> 'b
   we have to marshal and unmarshal values *)
module StrKeyToGenVal : sig

  type t

  (* to create and populate a new DB *)
  val open_new: filename -> t

  (* to open an existing one *)
  val open_existing: filename -> t

  val close: t -> unit

  val mem: t -> string -> bool

  val add: t -> string -> 'b -> unit

  val replace: t -> string -> 'b -> unit

  val remove: t -> string -> unit

  val find: t -> string -> 'b

  val iter: (string -> 'b -> unit) -> t -> unit

  (* WARNING: only use on a small table *)
  val fold: (string -> 'b -> 'c -> 'c) -> t -> 'c -> 'c

end

module StrKeyToStrVal : sig

  type t

  (* to create and populate a new DB *)
  val open_new: filename -> t

  (* to open an existing one *)
  val open_existing: filename -> t

  val close: t -> unit

  val mem: t -> string -> bool

  val add: t -> string -> string -> unit

  val replace: t -> string -> string -> unit

  val remove: t -> string -> unit

  val find: t -> string -> string

  val iter: (string -> string -> unit) -> t -> unit

  (* WARNING: only use on a small table *)
  val fold: (string -> string -> 'c -> 'c) -> t -> 'c -> 'c

end

module GenKeyToGenVal : sig

  type t

  (* to create and populate a new DB *)
  val open_new: filename -> t

  (* to open an existing one *)
  val open_existing: filename -> t

  val close: t -> unit

  val mem: t -> 'a -> bool

  val add: t -> 'a -> 'b -> unit

  val replace: t -> 'a -> 'b -> unit

  val remove: t -> 'a -> unit

  val find: t -> 'a -> 'b

  val iter: ('a -> 'b -> unit) -> t -> unit

  (* WARNING: only use on a small table *)
  val fold: ('a -> 'b -> 'c -> 'c) -> t -> 'c -> 'c

end

module GenKeyToStrVal : sig

  type t

  (* to create and populate a new DB *)
  val open_new: filename -> t

  (* to open an existing one *)
  val open_existing: filename -> t

  val close: t -> unit

  val mem: t -> 'a -> bool

  val add: t -> 'a -> string -> unit

  val replace: t -> 'a -> string -> unit

  val remove: t -> 'a -> unit

  val find: t -> 'a -> string

  val iter: ('a -> string -> unit) -> t -> unit

  (* WARNING: only use on a small table *)
  val fold: ('a -> string -> 'c -> 'c) -> t -> 'c -> 'c

end
