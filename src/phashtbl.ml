(* a hash table stored on disk because it would not fit in RAM *)

(*
StrKeyToGenVal => find: t -> string -> 'b
StrKeyToStrVal => find: t -> string -> string
GenKeyToGenVal => find: t -> 'a -> 'b
GenKeyToStrVal => find: t -> 'a -> string
*)

type filename = string

(* to create and populate a new DB *)
let open_new (fn: filename): Dbm.t =
  Dbm.(opendbm fn [Dbm_rdwr; Dbm_create] 0o600)

(* to just open an existing one for reading *)
let open_existing (fn: filename): Dbm.t =
  Dbm.(opendbm fn [Dbm_rdonly] 0o600)

let close (db: Dbm.t): unit =
  Dbm.close db

let mem (db: Dbm.t) (k: string) =
  try let _ = Dbm.find db k in true
  with Not_found -> false

let add (db: Dbm.t) (k: string) (v: 'a): unit =
  let marshaled = Marshal.(to_string v [No_sharing]) in
  Dbm.add db k marshaled

let replace (db: Dbm.t) (k: string) (v: 'a): unit =
  let marshaled = Marshal.(to_string v [No_sharing]) in
  Dbm.replace db k marshaled

let find (db: Dbm.t) (k: string): 'a =
  let marshaled = Dbm.find db k in
  Marshal.from_string marshaled 0

let iter f (db: Dbm.t): unit =
  Dbm.iter (fun k v_str ->
      let v = Marshal.from_string v_str 0 in
      f k v
    ) db

(* WARNING: only use on a small table *)
let fold f (db: Dbm.t) init =
  let acc = ref init in
  iter (fun k v ->
      acc := f k v !acc
    ) db;
  !acc
