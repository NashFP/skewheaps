open Option;;
open List;;

type thing = Thing of string * int

let compare_things t1 t2 =
    match t1,t2 with
    | Thing (_,v1), Thing (_,v2) -> Int.compare v1 v2

module Thing_skewheap_smallest =
    Skewheap.Make_skew_heap(struct
        type t = thing
        let compare = compare_things
    end)

module Thing_skewheap_biggest =
    Skewheap.Make_skew_heap(struct
        type t = thing
        let compare v1 v2 = compare_things v2 v1
    end)

let stooge_heap_smallest = Thing_skewheap_smallest.from_list [
    Thing ("Curly",30); Thing ("Moe",100); Thing ("Joe",5);
    Thing ("Curly Joe",15); Thing ("Shemp",50); Thing ("Larry",85)]

let stooge_heap_biggest = Thing_skewheap_biggest.from_list [
    Thing ("Curly",30); Thing ("Moe",100); Thing ("Joe",5);
    Thing ("Curly Joe",15); Thing ("Shemp",50); Thing ("Larry",85)]
