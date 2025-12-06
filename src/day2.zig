const std = @import("std");

fn validateId(input: []const u8) bool {
    if (input.len % 2 != 0) {
        return true;
    }
    const half_len = input.len / 2;
    const left = input[0..half_len];
    const right = input[half_len..];

    return !std.mem.eql(u8, left, right);
}

fn strip(s: []const u8) []const u8 {
    var start: usize = 0;
    var end: usize = s.len;

    while (start < end and std.ascii.isWhitespace(s[start])) {
        start += 1;
    }
    while (end > start and std.ascii.isWhitespace(s[end - 1])) {
        end -= 1;
    }
    return s[start..end];
}

pub fn solve(input: []const u8) !void {
    var iter = std.mem.tokenizeScalar(u8, input, ',');
    var counter: usize = 0;

    while (iter.next()) |id_range| {
        var split = std.mem.splitScalar(u8, id_range, '-');

        const start_id_str = split.next() orelse return error.InvalidInput;
        const end_id_str = split.next() orelse return error.InvalidInput;

        const start_id = try std.fmt.parseInt(usize, strip(start_id_str), 10);
        const end_id = try std.fmt.parseInt(usize, strip(end_id_str), 10);

        for (start_id..end_id) |id| {
            var buffer: [20]u8 = undefined;
            const id_str = try std.fmt.bufPrint(&buffer, "{}", .{id});

            if (validateId(id_str) == false) {
                counter += id;
            }
        }
    }
    std.debug.print("Sum of invalid IDs: {}\n", .{counter});
}
