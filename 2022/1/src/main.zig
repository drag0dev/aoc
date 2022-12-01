const std = @import("std");
const GPA = std.heap.GeneralPurposeAllocator;

fn parse64(num: []u8) u64{
    var res: u64 = 0;
    var index: u8 = 0;
    while (index < num.len and num[index] < 58 and num[index] > 47) {
        res *= 10;
        res += num[index] - 48;
        index += 1;
    }
    return res;
}

fn sort(arr: []u64) void {
    var i: u64 = 0;
    var j: u64 = undefined;
    var temp: u64 = undefined;
    while (i < arr.len) {
        j = i;
        while (j < arr.len - 1) {
            if (arr[j] > arr[j+1]){
                temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
            j += 1;
        }
        i += 1;
    }
}

pub fn main() !void {
    var gpa = GPA(.{}){};
    const allocator = gpa.allocator();
    defer{
        const leaked = gpa.deinit();
        if (leaked) std.debug.print("leaking", .{});
    }

    var sums = std.ArrayList(u64).init(allocator);
    defer sums.deinit();

    const file = try std.fs.cwd().openFile("./input", std.fs.File.OpenFlags{});
    defer file.close();

    var temp_sum: u64 = 0;
    var number_of_elfs: u64 = 0;
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var new_buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&new_buf, '\n')) |line| {
        if (line.len == 0){
            try sums.append(temp_sum);
            number_of_elfs += 1;
            temp_sum = 0;
            continue;
        }

        var broj = parse64(line);
        temp_sum += broj;
    }
    // readUntilDelimiterOrEof breaks when it finds eof therefore loop fails to push last sum
    try sums.append(temp_sum);
    number_of_elfs += 1;

    var sums_arr = try allocator.alloc(u64, number_of_elfs);
    defer allocator.free(sums_arr);

    var index: u64  = 0;
    var value: u64 = undefined;
    while (index < number_of_elfs){
        value = sums.pop();
        sums_arr[index] = value;
        index += 1;
    }

    sort(sums_arr);

    std.debug.print("Part one: {}\n", .{sums_arr[number_of_elfs-1]});
    std.debug.print("Part two: {}\n", .{
        sums_arr[number_of_elfs-1] +
        sums_arr[number_of_elfs-2] +
        sums_arr[number_of_elfs-3]
    });
}
