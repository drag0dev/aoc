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

let rec build_row x y acc serial_number =
    match x > 300 with
    | true -> List.rev acc
    | false ->
            let rack_id = x + 10 in
            let power_level = rack_id * y in
            let power_level = power_level + serial_number in
            let power_level = power_level * rack_id in
            let power_level = (power_level / 100) mod 10 in
            let power_level = power_level - 5 in
            let acc = power_level :: acc in
            build_row (x + 1) y acc serial_number;;

let rec build_grid y acc serial_number =
    match y > 300 with
    | true -> List.rev acc
    | false ->
            let row = build_row 1 y [] serial_number in
            let acc = row :: acc in
            build_grid (y+1) acc serial_number;;

let rec kernel_sum x y sums acc n =
    let (x, y) = match x > (300-n) with
    | true -> (1, y+1)
    | false -> (x, y) in

    match y > (300-n) with
    | true -> acc
    | false ->
        let new_sum = sums.(y-1).(x-1) in

        let (max_sum, _, _) = acc in
        let acc = match new_sum > max_sum with
        | false -> acc
        | true -> (new_sum, x, y) in

        kernel_sum (x + 1) y sums acc n;;

let update_sum_at sums grid n x y =
    let rec get_col_sum grid x y y_end acc =
        match y > y_end with
        | true -> acc
        | false ->
                let acc = acc + grid.(y - 1).(x - 1) in
                get_col_sum grid x (y+1) y_end acc in

    let rec get_row_sum grid x y x_end acc =
        match x > x_end with
        | true -> acc
        | false ->
                let acc = acc + grid.(y - 1).(x - 1) in
                get_row_sum grid (x+1) y x_end acc in

    let col_sum = get_col_sum grid (x+n-1) y (y+n-1) 0 in
    let row_sum = get_row_sum grid x (y+n-1) (x+n-2) 0 in

    let current = sums.(y - 1).(x - 1) in
    current + col_sum + row_sum;;

let rec update_sums sums grid n x y =
    let (x, y) = match x > (300-n+1) with
    | true -> (1, y+1)
    | false -> (x, y) in

    match y > (300-n+1) with
    | true -> sums
    | false ->
            let new_sum = update_sum_at sums grid n x y in
            sums.(y - 1).(x - 1) <- new_sum;
            update_sums sums grid n (x+1) y;;

let rec try_kernels sums grid n acc =
    match n > 300 with
    | true -> acc
    | false ->
            let (new_sum, new_x, new_y) = kernel_sum 1 1 sums (-99999999999999999, 0, 0) n in
            let (max_sum, _, _, _) = acc in
            let acc = match new_sum > max_sum with
            | false -> acc
            | true -> (new_sum, new_x, new_y, n) in
            let sums = update_sums sums grid (n+1) 1 1 in
            try_kernels sums grid (n+1) acc;;

let part_one grid =
    let sums = Array.map Array.copy grid in
    let sums = update_sums sums grid 2 1 1 in
    let sums = update_sums sums grid 3 1 1 in
    let (sum, x, y) = kernel_sum 1 1 sums (-9999999999999, 0, 0) 3 in
    Printf.printf "Part one: %d - %d,%d\n" sum x y;;

let part_two grid =
    let sums = Array.map Array.copy grid in
    let (max_sum, x, y, n) = try_kernels sums grid 1 (-999999999999999, 0, 0, 0) in
    Printf.printf "Part two: %d - %d,%d,%d\n" max_sum x y n;;

let line = match read_lines "input" with
    | line :: [] -> line
    | _ -> assert false;;
let serial_number = int_of_string line;;
let grid = build_grid 1 [] serial_number;;
let grid = List.map (fun line -> Array.of_list line) grid;;
let grid = Array.of_list grid;;
part_one grid;;
part_two grid;;
