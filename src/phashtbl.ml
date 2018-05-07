(* a hash table stored on disk because it would not fit in RAM *)

type filename = string

let string_of_key (k: 'a): string =
  Marshal.(to_string k [No_sharing])

let string_of_value (v: 'b): string =
  Marshal.(to_string v [No_sharing])

let key_of_string (k_str: string): 'a =
  Marshal.from_string k_str 0

let value_of_string (v_str: string): 'b =
  Marshal.from_string v_str 0

(* FBR: why don't I expose Dbm.remove ?! *)
(* FBR: factorize out open_new, open_existing and close? *)
(* FBR: create .mli file and hide types from there *)

(* val find: t -> string -> 'b
   we have to marshal and unmarshal values *)
module StrKeyToGenVal = struct

  type t = Dbm.t

  (* to create and populate a new DB *)
  let open_new (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr; Dbm_create] 0o600)

  (* to open an existing one *)
  let open_existing (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr] 0o600)

  let close (db: t): unit =
    Dbm.close db

  let mem (db: t) (k: string): bool =
    try let _ = Dbm.find db k in true
    with Not_found -> false

  let add (db: t) (k: string) (v: 'b): unit =
    Dbm.add db k (string_of_value v)

  let replace (db: t) (k: string) (v: 'b): unit =
    Dbm.replace db k (string_of_value v)

  let find (db: t) (k: string): 'b =
    value_of_string (Dbm.find db k)

  let iter (f: string -> 'b -> unit) (db: t): unit =
    Dbm.iter (fun k v_str ->
        f k (value_of_string v_str)
      ) db

  (* WARNING: only use on a small table *)
  let fold (f: string -> 'b -> 'c -> 'c) (db: t) (init: 'c): 'c =
    let acc = ref init in
    iter (fun k v ->
        acc := f k v !acc
      ) db;
    !acc

end

(* val find: t -> string -> string
   this is what dbm provides; not any marshal/unmarshal needed *)
module StrKeyToStrVal = struct

  type t = Dbm.t

  let open_new (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr; Dbm_create] 0o600)

  let open_existing (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr] 0o600)

  let close (db: t): unit =
    Dbm.close db

  let mem (db: t) (k: string) =
    try let _ = Dbm.find db k in true
    with Not_found -> false

  let add (db: t) (k: string) (v: string): unit =
    Dbm.add db k v

  let replace (db: t) (k: string) (v: string): unit =
    Dbm.replace db k v

  let find (db: t) (k: string): string =
    Dbm.find db k

  let iter (f: string -> string -> unit) (db: t): unit =
    Dbm.iter (fun k v ->
        f k v
      ) db

  let fold (f: string -> string -> 'c -> 'c) (db: t) (init: 'c): 'c =
    let acc = ref init in
    iter (fun k v ->
        acc := f k v !acc
      ) db;
    !acc

end

(* val find: t -> 'a -> 'b
   we have to marshal/unmarshal keys and values *)
module GenKeyToGenVal = struct

  type t = Dbm.t

  let open_new (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr; Dbm_create] 0o600)

  let open_existing (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr] 0o600)

  let close (db: t): unit =
    Dbm.close db

  let mem (db: t) (k: 'a): bool =
    try let _ = Dbm.find db (string_of_key k) in true
    with Not_found -> false

  let add (db: t) (k: 'a) (v: 'b): unit =
    Dbm.add db (string_of_key k) (string_of_value v)

  let replace (db: t) (k: 'a) (v: 'b): unit =
    Dbm.replace db (string_of_key k) (string_of_value v)

  let find (db: t) (k: 'a): 'b =
    Dbm.find db (string_of_key k)

  let iter (f: 'a -> 'b -> unit) (db: t): unit =
    Dbm.iter (fun k_str v_str ->
        f (key_of_string k_str) (value_of_string v_str)
      ) db

  let fold (f: 'a -> 'b -> 'b -> 'b) (db: t) (init: 'b): 'b =
    let acc = ref init in
    iter (fun k_str v_str ->
        acc := f (key_of_string k_str) (value_of_string v_str) !acc
      ) db;
    !acc

end

module GenKeyToStrVal = struct

  type t = Dbm.t

  let open_new (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr; Dbm_create] 0o600)

  let open_existing (fn: filename): t =
    Dbm.(opendbm fn [Dbm_rdwr] 0o600)

  let close (db: t): unit =
    Dbm.close db

  let mem (db: t) (k: 'a): bool =
    try let _ = Dbm.find db (string_of_key k) in true
    with Not_found -> false

  let add (db: t) (k: 'a) (v: string): unit =
    Dbm.add db (string_of_key k) v

  let replace (db: t) (k: 'a) (v: string): unit =
    Dbm.replace db (string_of_key k) v

  let find (db: t) (k: 'a): string =
    Dbm.find db (string_of_key k)

  let iter (f: 'a -> string -> unit) (db: t): unit =
    Dbm.iter (fun k_str v ->
        f (key_of_string k_str) v
      ) db

  let fold (f: 'a -> string -> 'c -> 'c) (db: t) (init: 'c): 'c =
    let acc = ref init in
    iter (fun k_str v ->
        acc := f (key_of_string k_str) v !acc
      ) db;
    !acc

end
