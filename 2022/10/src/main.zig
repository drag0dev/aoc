const std = @import("std");
const GPA = std.heap.GeneralPurposeAllocator;

fn parseNum(input: []u8) i64 {
    var res: i64 = 0;
    var inputMod: []u8 = input;
    if (input[0] == '-') {
        inputMod = input[1..];
    }
    for (inputMod) |char|{
        res *= 10;
        res += char-48;
    }

    if (input[0] == '-') return res*-1;
    return res;
}

const Action = struct {
    cyclesLeft: u64,
    value: i64
};

// FIXME: last 20pixel not rendered correctly but still able to read letters
pub fn main() !void {
    var gpa = GPA(.{}){};
    const allocator = gpa.allocator();
    defer if (gpa.deinit()) std.debug.print("leaking", .{});

    const file = try std.fs.cwd().openFile("input", std.fs.File.OpenFlags{});
    defer file.close();

    const buff: []u8 = try allocator.alloc(u8, 1024);
    defer allocator.free(buff);

    var partOne: i64 = 0;
    var crt: [240]u8 = undefined;
    var X: i64 = 1;
    var num: i64 = undefined;
    var tick: u64 = 1;
    var index: u64 = 0;
    var currentAction = Action{.cyclesLeft = 0, .value = 0};
    var line: []u8 = undefined;
    var temp: ?[]u8 = undefined;

    var bufferedReader = std.io.bufferedReader(file.reader());
    var inStream = bufferedReader.reader();

    while (true) {
        if (currentAction.cyclesLeft == 0) {
            // get a new action
            temp = try inStream.readUntilDelimiterOrEof(buff, '\n');
            if (temp == null) break;
            line = temp.?;

            // parse aciton
            if (line[0] == 'a') { // addx
                num = parseNum(line[5..]);
                currentAction.cyclesLeft = 2;
                currentAction.value = num;
            }else { // noop
                currentAction.cyclesLeft = 1;
                currentAction.value = 0;
            }
        }

        crt[tick-1] = '.';
        if (index <= X+1 and index >= X-1) crt[tick-1] = '0';
        index += 1;
        if (index == 40) index = 0;

        currentAction.cyclesLeft -= 1;
        if (tick < 220 and currentAction.cyclesLeft == 0) {
            X += currentAction.value;
        }

        tick += 1;
        if (tick == 20) {partOne += 20*X;}
        else if (tick == 60) {partOne += 60*X;}
        else if (tick == 100) {partOne += 100*X;}
        else if (tick == 140) {partOne += 140*X;}
        else if (tick == 180) {partOne += 180*X;}
        else if (tick == 220) {partOne += 220*X;}
    }

    std.debug.print("Part one: {}\n", .{partOne});
    std.debug.print("Part two:\n", .{});
    std.debug.print("{s}\n", .{crt[0..40]});
    std.debug.print("{s}\n", .{crt[40..80]});
    std.debug.print("{s}\n", .{crt[80..120]});
    std.debug.print("{s}\n", .{crt[120..160]});
    std.debug.print("{s}\n", .{crt[160..200]});
    std.debug.print("{s}\n", .{crt[200..240]});
}
