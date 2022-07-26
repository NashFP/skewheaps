open Option;;
open List;;

module Int_skewheap =
    Skewheap.Make_skew_heap(struct
        type t = int
        let compare = Int.compare
    end)


let foo_heap = Int_skewheap.from_list [1;2;3;4;5;6;7;8;9;10]
let bar_heap = Int_skewheap.from_list [9;2;5;7;1;10;8;3;6;4]
