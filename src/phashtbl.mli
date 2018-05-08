(** {2 Persistent hash tables stored on disk using dbm under the carpet.} *)

type filename = string

(** {4 Polymorphic keys and values.} *)

module GenKeyToGenVal : sig

  type ('a, 'b) t

  (** [open_new filename] creates a new persistent hashtbl. *)
  val open_new: filename -> ('a, 'b) t

  (** [open_existing filename] opens an existing persistent hashtbl
      for reading and writing. *)
  val open_existing: filename -> ('a, 'b) t

  (** [close pht] closes the previously opened [pht]. *)
  val close: ('a, 'b) t -> unit

  (** [mem pht key] checks if [key] is bound in [pht]. *)
  val mem: ('a, 'b) t -> 'a -> bool

  (** [add pht key value] binds [key] to [value] in [pht]. *)
  val add: ('a, 'b) t -> 'a -> 'b -> unit

  (** [replace pht key value] TODO: check Dbm's doc *)
  val replace: ('a, 'b) t -> 'a -> 'b -> unit

  (** [remove pht key] removes [key] and its bound value from [pht]. *)
  val remove: ('a, 'b) t -> 'a -> unit

  (** [find pht key] finds the value bound to [key] in [pht].
      TODO: check Dbm's doc. *)
  val find: ('a, 'b) t -> 'a -> 'b

  (** [iter f pht] calls [f key value] on each [key]-[value] binding from [pht]. *)
  val iter: ('a -> 'b -> unit) -> ('a, 'b) t -> unit

  (** [fold f pht init] folds [f] over [pht]
      with [init] as the initial accumulator. *)
  val fold: ('a -> 'b -> 'c -> 'c) -> ('a, 'b) t -> 'c -> 'c

end

(** {4 String keys and polymorphic values.} *)

module StrKeyToGenVal : sig

  type 'b t

  val open_new: filename -> 'b t

  val open_existing: filename -> 'b t

  val close: 'b t -> unit

  val mem: 'b t -> string -> bool

  val add: 'b t -> string -> 'b -> unit

  val replace: 'b t -> string -> 'b -> unit

  val remove: 'b t -> string -> unit

  val find: 'b t -> string -> 'b

  val iter: (string -> 'b -> unit) -> 'b t -> unit

  val fold: (string -> 'b -> 'c -> 'c) -> 'b t -> 'c -> 'c

end

(** {4 Polymorphic keys and string values.} *)

module GenKeyToStrVal : sig

  type 'a t

  val open_new: filename -> 'a t

  val open_existing: filename -> 'a t

  val close: 'a t -> unit

  val mem: 'a t -> 'a -> bool

  val add: 'a t -> 'a -> string -> unit

  val replace: 'a t -> 'a -> string -> unit

  val remove: 'a t -> 'a -> unit

  val find: 'a t -> 'a -> string

  val iter: ('a -> string -> unit) -> 'a t -> unit

  val fold: ('a -> string -> 'c -> 'c) -> 'a t -> 'c -> 'c

end

(** {4 String keys and values.} *)

module StrKeyToStrVal : sig

  type t

  val open_new: filename -> t

  val open_existing: filename -> t

  val close: t -> unit

  val mem: t -> string -> bool

  val add: t -> string -> string -> unit

  val replace: t -> string -> string -> unit

  val remove: t -> string -> unit

  val find: t -> string -> string

  val iter: (string -> string -> unit) -> t -> unit

  val fold: (string -> string -> 'c -> 'c) -> t -> 'c -> 'c

end
