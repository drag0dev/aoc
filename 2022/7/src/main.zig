const std = @import("std");
const GPA = std.heap.GeneralPurposeAllocator;
const ARENA = std.heap.ArenaAllocator;

fn parseSize(buff: []u8) u64{ var res: u64 = 0;
    var i: u64 = 0;
    while(buff[i] >= '0' and buff[i] <= '9'){
        res *= 10;
        res += buff[i] - 48;
        i += 1;
    }
    return res;
}

fn nameStartIndex(buff: []u8) u64{
    var startIndex: u64 = 0;
    for (buff) |char| {
        if (char == ' ') break;
        startIndex += 1;
    }
    return startIndex+1;
}

fn joinSlice(start: []u8, end: []u8, allocator: std.mem.Allocator) ![]u8{
    var res: []u8 = try allocator.alloc(u8, start.len + end.len);
    std.mem.copy(u8, res, start);
    std.mem.copy(u8, res[start.len..], end);
    return res;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", std.fs.File.OpenFlags{});
    defer file.close();

    var gpa = GPA(.{}){};
    const allocator = gpa.allocator();
    defer if (gpa.deinit()) std.debug.print("leaking", .{});

    var arena = ARENA.init(std.heap.page_allocator);
    const arenaAllocator = arena.allocator();
    defer arena.deinit();

    var lineBuf: []u8 = try arenaAllocator.alloc(u8, 1024);
    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();

    var partOne: u64 = 0;
    var partTwo: u64 = 0;
    var cwd: []u8 = undefined;
    var size: u64 = undefined;
    var currentSize: u64 = undefined;

    var sizeHM = std.StringArrayHashMap(u64).init(allocator);
    defer sizeHM.deinit();
    var path = std.ArrayList([]u8).init(allocator);
    defer path.deinit();

    _ = try inStream.readUntilDelimiterOrEof(lineBuf, '\n'); // take cd /
    cwd = try arenaAllocator.alloc(u8, 1);
    cwd[0] = '/';
    try sizeHM.put(cwd, 0);
    try path.append(cwd);

    while (try inStream.readUntilDelimiterOrEof(lineBuf, '\n')) |line| {
        if (line[0] == '$' and line[2] == 'c' and line[3] == 'd') { // cd
            if (line[5] == '.') { // cd ..
                _ = path.pop();
                cwd = path.items[path.items.len-1];
            }else{ // cd a dir
                cwd = try joinSlice(cwd, line[5..], arenaAllocator);
                try path.append(cwd);
                try sizeHM.put(cwd, 0);
            }
        }
        else if(line[0] >= '0' and line[0] <= '9'){ // size of file
            size = parseSize(line);
            for (path.items) |dir| try sizeHM.put(dir, sizeHM.get(dir).? + size); // add size to all parents
        }
    }

    partTwo = 1e14;
    var min: u64 = sizeHM.get("/").? - (70000000 - 30000000);
    for (sizeHM.keys()) |key| {
        currentSize = sizeHM.get(key).?;
        if (currentSize >= min and currentSize < partTwo) partTwo = currentSize;
        if (currentSize <= 100000) partOne += currentSize;
    }

    std.debug.print("Part one: {}\n", .{partOne});
    std.debug.print("Part two: {}\n", .{partTwo});
}
