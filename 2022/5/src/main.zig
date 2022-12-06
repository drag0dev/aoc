const std = @import("std");
const GPA = std.heap.GeneralPurposeAllocator;
const ArrayList = std.ArrayList;
const LEN = 9;

fn parseMovement(input: []u8, res: []u8) void {
    var index: u64 = 0;
    var temp: u8 = undefined;
    var i: u8 = 0;
    while (index < input.len) {
        if (input[index] >= '0' and input[index] <= '9') {
            temp = 0;
            while (index < input.len and input[index] >= '0' and input[index] <= '9'){
                temp *= 10;
                temp += input[index] - 48;
                index += 1;
            }
            res[i] = temp;
            i += 1;
        }
        if (i == 3) break;
        index += 1;
    }
}

fn printState(crates: *[LEN]ArrayList(u8)) void {
    std.debug.print("State: \n", .{});
    for (crates.*) |row| {
        for (row.items) |item| {
            std.debug.print("{c} ", .{item});
        }
        std.debug.print("\n", .{});
    }
}

pub fn main() !void {
    var gpa = GPA(.{}){};
    const allocator = gpa.allocator();
    defer{
        const leaked = gpa.deinit();
        if (leaked) std.debug.print("leaking", .{});
    }

    const file = try std.fs.cwd().openFile("./input", std.fs.File.OpenFlags{});
    defer file.close();

    var lineBuf: [1024]u8 = undefined;
    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();

    var crates: [LEN]ArrayList(u8) = undefined;

    var index: u64 = undefined;
    var i: u64 = 0;
    var emptySpace: u64 = 0;
    while (i < LEN) {
        var temp = ArrayList(u8).init(allocator);
        crates[i] = temp;
        i += 1;
    }
    i = 0;


    // read position of crates
    // modified input because its horribly formed
    while (try inStream.readUntilDelimiterOrEof(&lineBuf, '\n')) |line| {
        index = 0;
        emptySpace = 0;

        while (index < line.len){
            if (line[index] >= 'A' and line[index] <= 'Z') {
                try crates[i].append(line[index]);
            }
            index += 1;
        }

        i += 1;
        if ( i == LEN) break;
    }

    _ = try inStream.readUntilDelimiterOrEof(&lineBuf, '\n'); // skip empty line

    var input: [3]u8 = undefined;
    // 0 - how many
    // 1 - from
    // 2 - to

    var tempValues = ArrayList(u8).init(allocator);

    // read moves
    while (try inStream.readUntilDelimiterOrEof(&lineBuf, '\n')) |line| {
        parseMovement(line, &input);
        // convert to index
        input[1] -= 1;
        input[2] -= 1;

        // execute move part one
        // var value: ?u8 = 0;
        // while (input[0] > 0) {
        //     value = crates[input[1]].popOrNull();
        //     if (value != null) {
        //         try crates[input[2]].append(value.?);
        //     }
        //     input[0] -= 1;
        // }

        // execute move part two
        // take
        i = input[0];
        while (i > 0) {
            try tempValues.append(crates[input[1]].pop());
            i -= 1;
        }
        // put
        while (input[0] > 0) {
            try crates[input[2]].append(tempValues.pop());
            input[0] -= 1;
        }
    }

    printState(&crates);

    tempValues.deinit();
    // deinit all vecs
    for (crates) |row| {
        row.deinit();
    }
}
