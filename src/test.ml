open Printf

module Ht = Phashtbl.GenKeyToGenVal

let main () =
  let no_prfx = "" in
  let no_sufx = "" in
  let tmp_fn = Filename.temp_file no_prfx no_sufx in
  let ht = Ht.open_new tmp_fn in
  assert(not (Ht.mem ht 1));
  printf "1 not in ht\n%!";
  Ht.add ht 1 2;
  assert(Ht.mem ht 1);
  printf "1 in ht\n%!";
  assert(Ht.find ht 1 = 2);
  Ht.iter (fun k v -> printf "%d -> %d\n%!" k v) ht;
  let acc = Ht.fold (fun k v acc -> (k, v) :: acc) ht [] in
  assert(acc = [(1,2)]);
  Ht.remove ht 1;
  assert(not (Ht.mem ht 1));
  printf "1 no more in ht\n%!";
  Ht.close ht;
  ()

let () = main ()
