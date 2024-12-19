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

module ObjSet = Set.Make(String);;
module Graph = Map.Make(String);;

let rec build_graph orbits graph objs =
    match orbits with
    | [] -> (graph, objs)
    | first :: t ->
            let (obj, orbits_around) = first in
            let objs = ObjSet.add obj objs in
            let graph = match Graph.find_opt obj graph with
                | None -> Graph.add obj [orbits_around] graph
                | Some other_objects -> Graph.add obj ( orbits_around :: other_objects ) graph in
            build_graph t graph objs;;

let list_add_with_check l el =
    match List.find_opt (fun e -> e = el ) l with
    | None -> el :: l
    | Some _ -> l;;

let rec build_bi_directional_graph orbits graph objs =
    match orbits with
    | [] -> (graph, objs)
    | first :: t ->
            let (obj, orbits_around) = first in
            let objs = ObjSet.add obj objs in
            let graph = match Graph.find_opt obj graph with
                | None -> Graph.add obj [orbits_around] graph
                | Some other_objects -> Graph.add obj ( list_add_with_check other_objects orbits_around ) graph in

            let graph = match Graph.find_opt orbits_around graph with
                | None -> Graph.add orbits_around [obj] graph
                | Some other_objects -> Graph.add orbits_around ( list_add_with_check other_objects obj ) graph in

            build_bi_directional_graph t graph objs;;


let rec count_orbits graph obj count =
    match Graph.find_opt obj graph with
    | None -> 0
    | Some orbits_around ->
        match List.length orbits_around with
        | 0 -> count
        | direct_count ->
            let indirect_counts = List.fold_left (fun acc indirect_obj -> acc + (count_orbits graph indirect_obj 0)) 0 orbits_around in
            indirect_counts + direct_count;;

let rec add_to_q objs q visited step =
    match objs with
    | [] -> (q, visited)
    | obj :: t ->
            match ObjSet.find_opt obj visited with
            | None ->
                    let visited = ObjSet.add obj visited in
                    Queue.add (obj, (step+1)) q;
                    add_to_q t q visited step
            | Some _ ->
                    add_to_q t q visited step;;

let rec process_q graph q visited n min_steps =
    match n with
    | 0 -> (q, visited, min_steps)
    | _ ->
            let top = Queue.pop q in
            let (obj, steps) = top in
            match obj = "SAN" with
            | true -> (q, visited, (steps - 2))
            | false ->
                    let objects_around = Graph.find obj graph in
                    let (q, visited) = add_to_q objects_around q visited steps in
                    process_q graph q visited ( n - 1 ) min_steps;;


let rec bfs graph q visited =
    let len = Queue.length q in
    match len with
    | 0 -> assert false
    | n ->
            let (q, visited, min_steps) = process_q graph q visited n 999999999999999 in
            match min_steps with
            | 999999999999999 -> bfs graph q visited
            | min_steps -> min_steps


let part_one orbits =
    let (graph, objs) = build_graph orbits Graph.empty ObjSet.empty in
    let objs = ObjSet.to_list objs in
    let count = List.fold_left (fun acc obj -> acc + (count_orbits graph obj 0)) 0 objs in
    Printf.printf "Part one: %d\n" count;;

let part_two orbits =
    let (graph, _) = build_bi_directional_graph orbits Graph.empty ObjSet.empty in
    let q = Queue.create () in
    let () = Queue.add ("YOU", 0) q in
    let visited = ObjSet.empty in
    let visited = ObjSet.add "YOU" visited in
    let min_steps = bfs graph q visited in
    Printf.printf "Part two: %d\n" min_steps;;

let lines = read_lines "input";;
let orbits = List.map (fun orbit ->
        match String.split_on_char ')' orbit with
            | obj :: orbit_around :: _ -> (obj, orbit_around)
            | _ -> assert false
    ) lines;;
part_one orbits;;
part_two orbits;;
