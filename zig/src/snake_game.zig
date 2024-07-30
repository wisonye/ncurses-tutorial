const std = @import("std");
const nc = @import("nc.zig");
const time = std.time;

// const ENABLE_DEBUG_PRINT: bool = true;
const ENABLE_DEBUG_PRINT: bool = false;

const FOOD_CHAR: nc.chtype = '󱗾';
const SNAKE_HEAD_CHAR: nc.chtype = '';
const SNAKE_BODY_CHAR: nc.chtype = '';

const GAME_TITLE: []const u8 = "[ SNAKE GAME ]";
const GAME_KEYBINDINDS: []const u8 = "E/D/S/F: Direction, P: Pause/Resume, Q: Exit game";
const TOPBAR_HEIGHT: c_int = 5;
const BOARD_HEIGHT: u32 = 30;
const BOARD_WIDTH: u32 = @as(f32, @floatFromInt(BOARD_HEIGHT)) * 2.5;

//
//
//
const Game = struct {

    //
    // This is the actual game board
    //
    const Board = struct {
        left: c_int,
        top: c_int,
        width: c_int,
        height: c_int,
        win: ?*nc.WINDOW,
    };

    //
    // This is only used for drawing the outside the border of the game board,
    // so it won't be redrawn whenever the game board changes, it solves the
    // refreshing performance issue.
    //
    const BoardBoundary = struct {
        left: c_int,
        top: c_int,
        width: c_int,
        height: c_int,
        win: ?*nc.WINDOW,
    };

    const TopBar = struct {
        left: c_int,
        top: c_int,
        width: c_int,
        height: c_int,
        win: ?*nc.WINDOW,
    };

    //
    // Same design purpose with the `BoardBoundary`
    //
    const TopBarBoundary = struct {
        left: c_int,
        top: c_int,
        width: c_int,
        height: c_int,
        win: ?*nc.WINDOW,
    };

    const Self = @This();

    level: usize,
    score: usize,
    is_pause: bool,
    is_destroy: bool,
    snake: std.ArrayList(nc.CursorPosition),
    food: nc.CursorPosition,
    board: Board,
    board_boundary: BoardBoundary,
    topbar: TopBar,
    // topbar_boundary: TopBarBoundary,

    fn get_random_u32(max: ?u32) u32 {
        const seed: u64 = @intCast(time.microTimestamp());
        var prnd = std.rand.DefaultPrng.init(seed);
        var rand = prnd.random();
        const max_u8 = if (max) |value| value else std.math.maxInt(u32);
        return rand.uintAtMost(u32, max_u8);
    }

    fn init_game(allocator: std.mem.Allocator) !Self {
        // const board_left = ((screen_width/2) - (BOARD_WIDTH/2)): int;
        // const board_top = ((screen_height/2) - (BOARD_HEIGHT/2)): int;
        const topbar_left: c_int = 2;
        const topbar_top: c_int = 2;
        const board_boundary_left: c_int = topbar_left;
        const board_boundary_top: c_int = TOPBAR_HEIGHT + 2;
        const board_boundary = BoardBoundary{
            .left = board_boundary_left,
            .top = board_boundary_top,
            .width = @as(c_int, @intCast(BOARD_WIDTH)),
            .height = @as(c_int, @intCast(BOARD_HEIGHT)),
            .win = nc.newwin(
                @as(c_int, @intCast(BOARD_HEIGHT)),
                @as(c_int, @intCast(BOARD_WIDTH)),
                board_boundary_top,
                board_boundary_left,
            ),
        };

        //
        // Make the game board smaller by one unit than the `board_boundary`
        //
        const board = Board{
            .left = board_boundary_left + 1,
            .top = board_boundary_top + 1,
            .width = @as(c_int, @intCast(BOARD_WIDTH)) - 2,
            .height = @as(c_int, @intCast(BOARD_HEIGHT)) - 2,
            .win = nc.derwin(
                board_boundary.win,
                @as(c_int, @intCast(BOARD_HEIGHT)) - 2,
                @as(c_int, @intCast(BOARD_WIDTH)) - 2,
                board_boundary_top + 1,
                board_boundary_left + 1,
            ),
        };

        var self = Game{
            .level = 1,
            // .score = 9999,
            .score = 0,
            .is_pause = false,
            .is_destroy = false,
            .snake = try std.ArrayList(nc.CursorPosition).initCapacity(
                allocator,
                20,
            ),
            .food = nc.CursorPosition{
                .x = @as(c_int, @intCast(get_random_u32(BOARD_WIDTH - 1))),
                .y = @as(c_int, @intCast(get_random_u32(BOARD_HEIGHT - 1))),
            },
            .board_boundary = board_boundary,
            .board = board,
            .topbar = TopBar{
                .left = topbar_left,
                .top = topbar_top,
                .width = @as(c_int, @intCast(BOARD_WIDTH)),
                .height = TOPBAR_HEIGHT,
                .win = nc.newwin(
                    TOPBAR_HEIGHT,
                    @as(c_int, @intCast(BOARD_WIDTH)),
                    topbar_top,
                    topbar_left,
                ),
            },
        };

        _ = nc.wrefresh(nc.stdscr);

        //
        // Snake head
        //
        try self.snake.append(nc.CursorPosition{
            .x = @as(c_int, @intCast(get_random_u32(BOARD_WIDTH - 1))),
            .y = @as(c_int, @intCast(get_random_u32(BOARD_HEIGHT - 1))),
        });

        //
        // Fix position on edge case
        //
        if (self.food.x == 0) {
            self.food.x += 1;
        }
        if (self.food.y == 0) {
            self.food.y += 1;
        }
        if (self.snake.items[0].x == 0) {
            self.snake.items[0].x += 1;
        }
        if (self.snake.items[0].y == 0) {
            self.snake.items[0].y += 1;
        }

        return self;
    }

    fn deinit(self: *Self) void {
        if (!self.is_destroy) {
            self.snake.deinit();
            _ = nc.delwin(self.board.win);
            _ = nc.delwin(self.board_boundary.win);
            _ = nc.delwin(self.topbar.win);
            self.is_destroy = true;
        }
    }

    fn reset_game(self: *Game, allocator: std.mem.Allocator) void {
        self.level = 1;
        self.score = 0;
        self.is_pause = false;
        self.is_destroy = false;

        self.snake.deinit();
        self.snake = try std.ArrayList(nc.CursorPosition).initCapacity(
            allocator,
            20,
        );

        self.food = nc.CursorPosition{
            .x = get_random_u32(BOARD_WIDTH - 1),
            .y = get_random_u32(BOARD_HEIGHT - 1),
        };

        self.draw_board_boundary();
    }

    pub fn draw_board_boundary(self: *Game) void {
        _ = nc.box(self.board_boundary.win, 0, 0);
        _ = nc.wrefresh(self.board_boundary.win);
    }

    pub fn draw_topbar(self: *const Game) void {
        _ = nc.wclear(self.topbar.win);
        _ = nc.box(self.topbar.win, 0, 0);

        var row: c_int = 1;
        const start_col: c_int = 2;

        //
        // Level
        //
        _ = nc.mvwprintw(
            self.topbar.win,
            row,
            start_col,
            "Level: %d",
            self.level,
        );

        //
        // Game title
        //
        const center_title_left: c_int = @intFromFloat(@as(
            f32,
            @floatFromInt(self.topbar.width),
        ) / 2.0 -
            @as(f32, @floatFromInt(GAME_TITLE.len)) / 2.0);

        _ = nc.mvwprintw(
            self.topbar.win,
            row,
            center_title_left,
            @as([*]const u8, @ptrCast(GAME_TITLE)),
        );
        row += 2;

        //
        // Game keybindings
        //
        const center_keybingins_left: c_int = @intFromFloat(@as(
            f32,
            @floatFromInt(self.topbar.width),
        ) / 2 -
            @as(f32, @floatFromInt(GAME_KEYBINDINDS.len)) / 2.0);
        _ = nc.mvwprintw(
            self.topbar.win,
            row,
            center_keybingins_left,
            @as([*]const u8, @ptrCast(GAME_KEYBINDINDS)),
        );

        //
        // Score: fixe on the right
        //
        var score_buffer = [_]u8{0x00} ** 30;
        const score_msg = std.fmt.bufPrint(
            &score_buffer,
            "Score: {: >5}",
            .{self.score},
        ) catch "";

        _ = nc.mvwprintw(
            self.topbar.win,
            1,
            self.topbar.width - 13,
            "%s",
            @as([*]const u8, @ptrCast(score_msg)),
        );

        _ = nc.wnoutrefresh(self.topbar.win);
    }

    fn draw(self: *const Game) void {
        _ = nc.wclear(self.board.win);

        //
        // Top bar
        //
        draw_topbar(self);

        //
        // After multiple `wnoutrefresh(win)` on different named windows, call the
        // `doupdate()` to push the virtual screen changes to the physical
        // screen in one shot.
        //
        _ = nc.doupdate();
    }
};

//
//
//
pub fn main() !void {
    //
    // Enable UTF8 support
    //
    _ = nc.setlocale(nc.LC_ALL, "en_US.UTF-8");

    //
    // Init screen
    //
    _ = nc.initscr();
    defer _ = nc.endwin();

    //
    // Check and enable color support
    //
    if (!nc.has_colors() or !nc.can_change_color()) {
        std.debug.print(">>> Terminal doesn't support colors", .{});
        return;
    }
    _ = nc.start_color();

    //
    // Hide cursor
    //
    _ = nc.hide_cursor();

    //
    // Input options
    //
    _ = nc.cbreak();
    _ = nc.noecho();
    _ = nc.nonl();
    _ = nc.raw();

    //
    // Create board
    //
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) std.testing.expect(false) catch @panic("\nGPA detected a memory leak!!!\n");
    }
    // const term_size = nc.get_window_size(nc.stdscr);
    var game = try Game.init_game(allocator);
    defer game.deinit();

    game.draw_board_boundary();
    game.draw();

    _ = nc.wgetch(nc.stdscr);

    // //
    // // Game loop
    // //
    // let c = nc. wgetch(game.board.win);
    // for(true) {
    // 	switch (c) {
    // 		case 'Q' => break;
    // 		// Up
    // 		case nc. KEY_E => {
    // 			game.snake[0].y -= 1;
    // 		};
    // 		// Down
    // 		case nc. KEY_D => {
    // 			game.snake[0].y += 1;
    // 		};
    // 		// Left
    // 		case nc. KEY_S => {
    // 			game.snake[0].x -= 1;
    // 		};
    // 		// Right
    // 		case nc. KEY_F => {
    // 			game.snake[0].x += 1;
    // 		};
    // 		case => void;
    //
    // 	};
    // 	draw(&game);
    // 	c = nc. wgetch(game.board.win);
    // };

    return;
}
