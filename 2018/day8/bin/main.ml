let read_lines filename =
    let channel = open_in filename in

    let try_read () =
        try Some (input_line channel)
        with End_of_file -> None in

    let rec loop acc = match try_read () with
    | Some line -> loop (line :: acc)
    | None ->
            close_in channel;
            acc in
    loop [];;

let rec parse_input nums acc =
    match nums with
    | [] -> List.rev acc
    | h :: t ->
            let num = int_of_string h in
            let acc = num :: acc in
            parse_input t acc;;

type 'a tree = | Node of int list * 'a tree list;;
let create_node metas children = Node(metas, children);;

let rec list_take l n acc =
    match n with
    | 0 -> (l, List.rev acc)
    | _ ->
            match l with
            | [] -> assert false
            | top :: t ->
                let acc = top :: acc in
                list_take t (n - 1) acc;;

let rec get_children nums children no_child =
    match no_child with
    | 0 ->
            let children = List.rev children in
            (nums, children)
    | _ ->
            match nums with
            | [] -> assert false
            | no_child_inner :: no_metadata :: t ->

                let (t, children_inner) = match no_child_inner with
                | 0 -> (t, [])
                | _ -> get_children t [] no_child_inner in

                let (t, meta) = list_take t no_metadata [] in
                let node = create_node meta children_inner in
                let children = node :: children in
                get_children t children (no_child - 1)
            | _ -> assert false;;

let turn_into_tree nums =
    match nums with
    | no_child :: no_metadata :: t ->
            let (t, children) = get_children t [] no_child in
            let (_, meta) = list_take t no_metadata [] in
            create_node meta children
    | _ -> assert false;;

let rec sum_metadata tree =
    match tree with
    | Node(metas, children) ->
            let meta_sum = List.fold_left (fun acc meta -> acc + meta) 0 metas in
            let children_sum = List.fold_left (fun acc child -> acc + (sum_metadata child)) 0 children in
            meta_sum + children_sum;;

let rec sum_based_on_children indices children_sums sum =
    match indices with
    | [] -> sum
    | idx :: t ->
            let sum = match List.nth_opt children_sums (idx - 1) with
            | None -> sum
            | Some child_sum -> sum + child_sum in
            sum_based_on_children t children_sums sum;;

let rec do_sum_tree tree =
    match tree with
    | Node(metas, children) ->
        match List.length children with
        | 0 ->
                List.fold_left (fun acc meta -> acc + meta) 0 metas
        | _ ->
            let inner_children_sums = List.map (fun child -> do_sum_tree child) children in
            sum_based_on_children metas inner_children_sums 0;;

let part_one nums =
    let tree = turn_into_tree nums in
    let total_meta = sum_metadata tree in
    Printf.printf "Part one: %d\n" total_meta;;

let part_two nums =
    let tree = turn_into_tree nums in
    let total_sum = do_sum_tree tree in
    Printf.printf "Part two: %d\n" total_sum;;

let lines = match read_lines "input" with
    | line :: [] -> line
    | _ -> assert false;;
let nums = parse_input ( String.split_on_char ' ' lines ) [];;
part_one nums;;
part_two nums;;
