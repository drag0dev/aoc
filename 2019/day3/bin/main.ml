let read_lines filename =
    let channel = open_in filename in
    let try_read () =
        try Some (input_line channel)
        with End_of_file -> None in

    let rec read acc = match try_read() with
    | Some line -> read (line :: acc)
    | None ->
            close_in channel;
            acc in
    read [];;

let parse_move move =
    let direction = String.get move 0 in
    let num_str = String.sub move 1 ( String.length move - 1 ) in
    let num = int_of_string num_str in
    (direction, num);;

let rec map_moves_to_coords moves acc coords = match moves with
    | [] -> List.rev acc
    | move :: tail ->
            let (x, y) = coords in
            let (direction, change) = parse_move move in
            let end_point = match direction with
            | 'R' -> (x+change, y)
            | 'L' -> (x-change, y)
            | 'U' -> (x, y+change)
            | 'D' -> (x, y-change)
            | _ -> assert false in

            let part = (direction, coords, end_point) in

            let acc = part :: acc in

            map_moves_to_coords tail acc end_point;;

module PointSet = Set.Make(struct
  type t = int * int
  let compare (x1, y1) (x2, y2) =
    match compare x1 x2 with
    | 0 -> compare y1 y2
    | other -> other
end);;

let rec visit_points_between_start_and_end points current_cords end_coords x_change y_change =
    let (curr_x, curr_y) = current_cords in
    let (end_x, end_y) = end_coords in
    match curr_x = end_x && curr_y = end_y with
    | true -> points
    | false ->
            let points = (curr_x + x_change, curr_y + y_change) :: points in
            let current_cords = (curr_x+x_change, curr_y+y_change) in
            visit_points_between_start_and_end points current_cords end_coords x_change y_change;;

let rec visit_all_points moves points =
    match moves with
    | [] -> List.rev points
    | h :: t ->
            let (direction, start_coords, end_coords) = h in
            let points = match direction with
            | 'R' -> visit_points_between_start_and_end points start_coords end_coords 1 0
            | 'L' -> visit_points_between_start_and_end points start_coords end_coords (-1) 0
            | 'U' -> visit_points_between_start_and_end points start_coords end_coords 0 1
            | 'D' -> visit_points_between_start_and_end points start_coords end_coords 0 (-1)
            | _ -> assert false in
            visit_all_points t points

let part_one first_parts second_parts =
    let first_line_points = visit_all_points first_parts [] in
    let first_line_points = PointSet.of_list first_line_points in

    let second_line_points = visit_all_points second_parts [] in
    let second_line_points = PointSet.of_list second_line_points in

    let intersection_points = PointSet.inter first_line_points second_line_points in
    let intersection_points = PointSet.to_list intersection_points in

    let distance_from_start = List.map (fun (x, y) -> abs(x) + abs(y) ) intersection_points in
    let min_distance = List.fold_left (fun acc dist -> min acc dist) 999999999999999999 distance_from_start in
    Printf.printf "Part one: %d\n" min_distance;;

module CordToStepMap = Map.Make(struct
  type t = int * int
  let compare (x1, y1) (x2, y2) =
    match compare x1 x2 with
    | 0 -> compare y1 y2
    | c -> c
end);;

let part_two first_parts second_parts =
    let first_line_points = visit_all_points first_parts [] in
    let first_line_points_with_step = List.mapi (fun i (x, y) -> (x, y, i+1)) first_line_points in
    let first_line_cord_to_step_index = List.fold_left (
        fun acc (x, y, step) ->
            match CordToStepMap.find_opt (x, y) acc with
            | None -> CordToStepMap.add (x ,y) step acc
            | _ -> acc
        ) CordToStepMap.empty first_line_points_with_step in

    let second_line_points = visit_all_points second_parts [] in
    let second_line_points_with_step = List.mapi (fun i (x, y) -> (x, y, i+1)) second_line_points in
    let second_line_cord_to_step_index = List.fold_left (
        fun acc (x, y, step) ->
            match CordToStepMap.find_opt (x, y) acc with
            | None -> CordToStepMap.add (x ,y) step acc
            | _ -> acc
        ) CordToStepMap.empty second_line_points_with_step in

    let first_line_points = PointSet.of_list first_line_points in
    let second_line_points = PointSet.of_list second_line_points in
    let intersection_points = PointSet.inter first_line_points second_line_points in
    let intersection_points = PointSet.to_list intersection_points in
    let intersection_points_distance = List.map (fun point ->
        let one_steps = CordToStepMap.find point first_line_cord_to_step_index in
        let second_steps = CordToStepMap.find point second_line_cord_to_step_index in
        one_steps + second_steps
        ) intersection_points in

    let min_distance = List.fold_left (fun acc dist -> min acc dist) 999999999999999999 intersection_points_distance in
    Printf.printf "Part two: %d\n" min_distance;;




let lines = read_lines "input";;
let lines = List.rev lines;;

let (first, second) = match lines with
    | first :: second :: _ -> (first, second)
    | _ -> assert false;;

let first = String.split_on_char ',' first;;
let second = String.split_on_char ',' second;;

let first_parts = map_moves_to_coords first [] (0, 0);;
let second_parts = map_moves_to_coords second [] (0, 0);;
part_one first_parts second_parts;;
part_two first_parts second_parts;;
