const std = @import("std");
const GPA = std.heap.GeneralPurposeAllocator;
const ARENA = std.heap.ArenaAllocator;

const Monkey = struct {
    items: std.ArrayList(u128),
    operation: u8,
    operand: ?u8,
    divisableBy: u8,
    trueRes: u8,
    falseRes: u8,
};

fn parseNum(num: []u8) u8 {
    var res: u8 = 0;
    for (num) |char| {
        res *= 10;
        res += char - 48;
    }
    return res;
}

fn parseItems(items: []u8, list: *std.ArrayList(u128)) !void {
    var temp: u8 = 0;
    for (items) |char| {
        if (char == ' ') continue;
        if (char == ',') {
            try list.*.append(temp);
            temp = 0;
            continue;
        }
        temp *= 10;
        temp += char - 48;
    }
    try list.*.append(temp);
}

fn sortArr(arr: []u64) void {
    var temp: u64 = 0;
    var i: u64 = 0;
    var j: u64 = undefined;
    while (i < arr.len) {
        j = i;
        while (j < arr.len-1){
            if (arr[j] > arr[j+1]) {
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
    defer if(gpa.deinit()) std.debug.print("leaking", .{});

    var arena = ARENA.init(std.heap.page_allocator);
    var arenaAllocator = arena.allocator();
    defer arena.deinit();

    const file = try std.fs.cwd().openFile("input", std.fs.File.OpenFlags{});
    defer file.close();

    var bufferedReader = std.io.bufferedReader(file.reader());
    var inStream = bufferedReader.reader();
    var lineBuff: []u8 = try allocator.alloc(u8, 1024);
    defer allocator.free(lineBuff);

    var monkeys = std.ArrayList(*Monkey).init(allocator);
    defer monkeys.deinit();

    var tempMonkey: *Monkey = undefined;
    var numberOfMonkeys: u8 = 0;

    // parse monkeys
    while (try inStream.readUntilDelimiterOrEof(lineBuff, '\n')) |line| {
        if (line.len == 0) {
            try monkeys.append(tempMonkey);
            continue;
        }
        if (line[0] == 'M') { // "Monkey n"
            tempMonkey = try arenaAllocator.create(Monkey);
            tempMonkey.*.items = std.ArrayList(u128).init(arenaAllocator);
            numberOfMonkeys += 1;
        }
        else if(line[2] == 'S') { // "Starting items..."
            try parseItems(line[18..], &tempMonkey.*.items);
        }
        else if(line[2] == 'O') { // "Operation..."
            // [23] - operation
            tempMonkey.*.operation = line[23];
            if (line[25] == 'o') {tempMonkey.*.operand = null;} // if operand is old
            else tempMonkey.*.operand = parseNum(line[25..]); // if operand in number
        }
        else if(line[2] == 'T') { // "Test:..."
            tempMonkey.*.divisableBy = parseNum(line[21..]);
        }
        else if(line[7] == 't') { // "If true..."
            tempMonkey.*.trueRes = line[line.len-1]-48;
        }
        else if(line[7] == 'f') { // "If false..."
            tempMonkey.*.falseRes = line[line.len-1]-48;
        }
    }
    try monkeys.append(tempMonkey);

    var round: u64 = 0;
    var i: u64 = 0;
    var inspections: []u64 = try arenaAllocator.alloc(u64, numberOfMonkeys);
    var tempThing: u128 = undefined;
    var operand: u128 = undefined;
    std.mem.set(u64, inspections, 0);
    var modulo: u128 = 1;
    for (monkeys.items) |monkey| modulo = (modulo * monkey.divisableBy);

    while (round < 10000) {
        i = 0;
        while (i < numberOfMonkeys){
            tempMonkey = monkeys.items[i];
            for (tempMonkey.*.items.items) |thing| {
                if (tempMonkey.*.operand == null) {operand = thing;}
                else operand = tempMonkey.*.operand.?;

                if (tempMonkey.*.operation == '*') {tempThing = thing * operand;}
                else tempThing = thing + operand;
                //tempThing /= 3; // part one
                tempThing %= modulo;
                if (tempThing % tempMonkey.*.divisableBy == 0) {try monkeys.items[tempMonkey.*.trueRes].items.append(tempThing);}
                else try monkeys.items[tempMonkey.*.falseRes].items.append(tempThing);
                inspections[i] += 1;
            }
            tempMonkey.items.clearAndFree();
            i += 1;
        }
        round += 1;
    }

    sortArr(inspections);
    std.debug.print("res: {}\n", .{inspections[inspections.len-1] * inspections[inspections.len-2]});
}
