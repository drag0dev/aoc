const std = @import("std");
const GPA = std.heap.GeneralPurposeAllocator;
const ARENA = std.heap.ArenaAllocator;

pub fn main() !void {
    var gpa = GPA(.{}){};
    const allocator = gpa.allocator();
    defer {
        var leaked = gpa.deinit();
        if (leaked) std.debug.print("leaking", .{});
    }

    var arena = ARENA.init(std.heap.page_allocator);
    var arenaAllocator = arena.allocator();
    defer arena.deinit();

    const file = try std.fs.cwd().openFile("input", std.fs.File.OpenFlags{});
    defer file.close();

    var buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(buffer);

    var lines = std.ArrayList([]u8).init(allocator);
    defer lines.deinit();

    var bufferedReader = std.io.bufferedReader(file.reader());
    var inStream = bufferedReader.reader();

    var i: u64 = 0;
    while (try inStream.readUntilDelimiterOrEof(buffer, '\n')) |line| {
        var temp = try arenaAllocator.alloc(u8, line.len);
        i = 0;
        while (i < line.len) { // convert char to num
            line[i] -= 48;
            i += 1;
        }
        std.mem.copy(u8, temp, line[0..line.len]);
        try lines.append(temp);
    }

    // default value number of outer trees
    var partOne: u64 = 2*lines.items[0].len + 2*(lines.items.len-2);
    var partTwo: u64 = 0;
    var partTwoTemp: u64 = undefined;
    var counter: u64 = undefined;

    i = 1;
    var j: u64 = undefined;
    var index: u64 = undefined;
    var height: u64 = undefined;
    var visible: bool = undefined;
    var visibleTemp: bool = undefined;
    const lineLength: usize = lines.items[0].len;

    // part one
    while (i < lines.items.len-1) {
        index = 1;
        while (index < lineLength-1){ // for each tree in a line
            height = lines.items[i][index];
            visibleTemp = false;
            partTwoTemp = 1;

            // check left
            j = index-1;
            visible = true;
            counter = 0;
            while (true){
                counter += 1;
                if (lines.items[i][j] >= height) {
                    visible = false;
                    break;
                }
                if (j == 0) break;
                j -= 1;
            }
            if (visible) {
                visibleTemp = true;
            }
            partTwoTemp *= counter;

            // check right
            j = index+1;
            visible = true;
            counter = 0;
            while (j < lineLength){
                counter += 1;
                if (lines.items[i][j] >= height) {
                    visible = false;
                    break;
                }
                j += 1;
            }
            if (!visibleTemp and visible) {
                visibleTemp = true;
            }
            partTwoTemp *= counter;

            // check up
            visible = true;
            j = i-1;
            counter = 0;
            while (true){
                counter += 1;
                if (lines.items[j][index] >= height) {
                    visible = false;
                    break;
                }
                if (j == 0) break;
                j -= 1;
            }
            if (!visibleTemp and visible) {
                visibleTemp = true;
            }
            partTwoTemp *= counter;

            // check down
            visible = true;
            j = i+1;
            counter = 0;
            while (j < lines.items.len){
                counter += 1;
                if (lines.items[j][index] >= height) {
                    visible = false;
                    break;
                }
                j += 1;
            }
            if (!visibleTemp and visible) {
                visibleTemp = true;
            }
            partTwoTemp *= counter;

            if (visibleTemp) partOne += 1;
            if (partTwoTemp > partTwo) partTwo = partTwoTemp;
            index += 1;
        }
        i += 1;
    }

    std.debug.print("Part one: {}\n", .{partOne});
    std.debug.print("Part two: {}\n", .{partTwo});
}
