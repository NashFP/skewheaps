open Option;;
open List;;

module type Comparable = sig
    type t
    val compare : t -> t -> int
end

module Make_skew_heap(Item : Comparable) = struct
  type skew_heap = Empty | SkewHeap of Item.t * skew_heap * skew_heap

  let rec skew_union h1 h2 =
    match h1, h2 with
    | SkewHeap (v1, l1, r1), SkewHeap (v2, l2, r2) ->
       if Item.compare v1 v2 <= 0 then
         SkewHeap (v1, (skew_union h2 r1), l1)
       else
         SkewHeap (v2, (skew_union h1 r2), l2)
    | Empty, h -> h
    | h, Empty -> h
  
  let skew_add h v =
    skew_union h (SkewHeap (v, Empty, Empty))
  
  let extract_min h =
    match h with
    | Empty -> None
    | SkewHeap (v, l, r) -> Some (v, skew_union l r)
  
  let to_list h =
      let rec to_list' h acc =
          match extract_min h with
          | None -> rev acc
          | Some (v,h2) -> to_list' h2 (v::acc)
      in
        to_list' h []
  
  let from_list l = fold_left skew_add Empty l
end
