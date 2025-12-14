const std = @import("std");

const RollExtractor = struct {
    count: usize = 0,

    top: []const u8 = &[_]u8{},
    mid: []const u8 = &[_]u8{},
    bot: []const u8 = &[_]u8{},

    bot_count: usize = 0,
    extract_buf: [1024]u8 = undefined,

    pub fn addRow(self: *RollExtractor, row: []const u8) []const u8 {
        self.top = self.mid;
        self.mid = self.bot;
        self.bot = row;

        self.count -= self.bot_count;
        self.bot_count = 0;

        var idx: usize = 0;
        const row_len: usize = @max(self.mid.len, self.bot.len);
        while (idx < row_len) : (idx += 1) {
            var start: usize = idx;
            var end: usize = idx + 2;

            if (idx > 0) start -= 1;
            if (idx == row_len - 1) end -= 1;

            if (idx < self.mid.len) {
                self.extract_buf[idx] = self.mid[idx];
            }

            if (self.mid.len > 0 and self.mid[idx] == '@') {
                var mid_adjacent: usize = 0;

                if (self.top.len > 0) {
                    mid_adjacent += std.mem.count(u8, self.top[start..end], "@");
                }
                if (self.bot.len > 0) {
                    mid_adjacent += std.mem.count(u8, self.bot[start..end], "@");
                }
                mid_adjacent += std.mem.count(u8, self.mid[start..end], "@") - 1;

                if (mid_adjacent < 4) {
                    self.extract_buf[idx] = 'x';
                    self.count += 1;
                }
            }

            if (self.bot.len > 0 and self.bot[idx] == '@') {
                var bot_adjacent: usize = 0;

                if (self.mid.len > 0) {
                    bot_adjacent += std.mem.count(u8, self.mid[start..end], "@");
                }
                bot_adjacent += std.mem.count(u8, self.bot[start..end], "@") - 1;

                if (bot_adjacent < 4) {
                    self.bot_count += 1;
                }
            }
        }
        self.count += self.bot_count;
        return self.extract_buf[0..self.mid.len];
    }
};

pub fn solve(input: []const u8) !void {
    var extractor = RollExtractor{};
    var iter = std.mem.tokenizeScalar(u8, input, '\n');

    while (iter.next()) |row| {
        _ = extractor.addRow(row);
    }

    std.debug.print("Total rolls: {}\n", .{extractor.count});
}
