use fmt;
use math::random;
use nc;
use time;
use types::c;

// def ENABLE_DEBUG_PRINT: bool = true;
def ENABLE_DEBUG_PRINT: bool = false;

def FOOD_CHAR: nc::chtype = '󱗾';
def SNAKE_HEAD_CHAR: nc::chtype = '';
def SNAKE_BODY_CHAR: nc::chtype = '';

def GAME_TITLE:str = "[ SNAKE GAME ]\0";
def GAME_KEYBINDINDS: str = "E/D/S/F: Direction, P: Pause/Resume, Q: Exit game\0";
def TOPBAR_HEIGHT: int = 5i;
def BOARD_HEIGHT: u32 = 30;
def BOARD_WIDTH: u32 = (BOARD_HEIGHT:f32 * 2.5): u32;

type Board = struct {
	left: int,
	top: int,
	width: int,
	height: int,
	win: nullable *nc::WINDOW,
};

type TopBar = struct {
	left: int,
	top: int,
	width: int,
	height: int,
	win: nullable *nc::WINDOW,
};

type Game = struct {
	level: size,
	score: size,
	is_pause: bool,
	is_destroy: bool,
	snake: []nc::CursorPosition,
	food: nc::CursorPosition,
	board: Board,
	topbar: TopBar,
};

fn get_random_size(max: u32) size = {
	const nano_second_as_seed = time::now(time::clock::MONOTONIC).nsec: u64;
	const rand = random::init(nano_second_as_seed);
	return random::u32n(&rand, max);
};

fn init_game(screen_width: u32, screen_height: u32) Game = {
	// const board_left = ((screen_width/2) - (BOARD_WIDTH/2)): int;
	// const board_top = ((screen_height/2) - (BOARD_HEIGHT/2)): int;
	const topbar_left = 2i, topbar_top = 2i;
	const board_left = topbar_left, board_top = TOPBAR_HEIGHT + 2i;
	let self = Game {
		level = 1z,
		// score = 999z,
		score = 0z,
		is_pause = false,
		is_destroy = false,
		snake = alloc([], 20),
		food = nc::CursorPosition {
			x = get_random_size(BOARD_WIDTH - 1): int,
			y = get_random_size(BOARD_HEIGHT - 1): int,
		},
		board = Board {
			left = board_left,
			top = board_top,
			width = BOARD_WIDTH:int ,
			height = BOARD_HEIGHT:int ,
			win = nc::newwin(
				BOARD_HEIGHT: int,
				BOARD_WIDTH: int,
				board_top,
				board_left),
		},
		topbar = TopBar {
			left = topbar_left,
			top = topbar_top,
			width = BOARD_WIDTH:int ,
			height = TOPBAR_HEIGHT,
			win = nc::newwin(
				TOPBAR_HEIGHT,
				BOARD_WIDTH: int,
				topbar_top,
				topbar_left),
		},
	};
	nc::wrefresh(nc::stdscr);

	//
	// Snake head
	//
	append(self.snake, nc::CursorPosition {
			x = get_random_size(BOARD_WIDTH - 1): int,
			y = get_random_size(BOARD_HEIGHT - 1): int,
	});

	//
	// Fix position on edge case
	//
	if (self.food.x == 0) { self.food.x += 1; };
	if (self.food.y == 0) { self.food.y += 1; };
	if (self.snake[0].x == 0) { self.snake[0].x += 1; };
	if (self.snake[0].y == 0) { self.snake[0].y += 1; };

	return self;
};

fn deinit_game(self: *Game) void = {
	if (!self.is_destroy) {
		free(self.snake);
		nc::delwin(self.board.win);
		nc::delwin(self.topbar.win);
	};
};

fn draw_topbar(self: *const Game) void = {
	nc::wclear(self.topbar.win);
	nc::box(self.topbar.win, 0, 0);

	let row = 1i;
	const start_col = 2;

	//
	// Level
	//
	nc::mvwprintw(self.topbar.win,
		row, start_col,
		c::nulstr("Level: %d\0"),
		self.level);

	//
	// Game title
	//
	const center_title_left: int = (self.topbar.width / 2) - (len(GAME_TITLE):int / 2i);
	nc::mvwprintw(self.topbar.win,
		row, center_title_left,
		c::nulstr(GAME_TITLE));
	row += 2;

	//
	// Game keybindings
	//
	const center_keybingins_left: int = (self.topbar.width / 2) - (len(GAME_KEYBINDINDS):int / 2i);
	nc::mvwprintw(self.topbar.win,
		row, center_keybingins_left,
		c::nulstr(GAME_KEYBINDINDS));

	//
	// Score: fixe on the right
	//
	let score_buffer: [30]u8 = [0x00...];
	const score_msg = fmt::bsprintf(
		&score_buffer,
		"Score: {}\0",
		self.score);

	nc::mvwprintw(self.topbar.win,
		1, self.topbar.width - 12,
		c::nulstr("%10s\0"),
		c::nulstr(score_msg));

	nc::wrefresh(self.topbar.win);
};

fn draw(self: *const Game) void = {
	nc::wclear(self.board.win);

	//
	// Boarder
	//
	nc::box(self.board.win, 0, 0);

	//
	// Top bar
	//
	draw_topbar(self);

	//
	// Debug print
	//
	if (ENABLE_DEBUG_PRINT) {
		let row = 1;
		const start_col = 1;
		nc::mvwprintw(
			nc::stdscr,
			row, start_col,
			c::nulstr(">>> board left: %d, top: %d, width: %d, height: %d\0"),
			self.board.left,
			self.board.top,
			self.board.width,
			self.board.height);
		row += 1;
		nc::mvwprintw(
			nc::stdscr,
			row, start_col,
			c::nulstr(">>> Food: (%d, %d)\n\0"),
			self.food.x,
			self.food.y);
		row += 1;
		nc::mvwprintw(
			nc::stdscr,
			row, start_col,
			c::nulstr(">>> Snake head: (%d, %d)\n\0"),
			self.snake[0].x,
			self.snake[0].y);

		nc::wrefresh(nc::stdscr);
	};
	
	//
	// Food
	//
	nc::mvwprintw(self.board.win,
		self.food.y,
		self.food.x,
		c::nulstr("%lc\0"),
		FOOD_CHAR);

	//
	// Snake
	//
	const snake_len = len(self.snake);
	for( let index=0z; index < snake_len; index +=1) {
		nc::mvwprintw(self.board.win,
			self.snake[index].y,
			self.snake[index].x,
			c::nulstr("%lc\0"),
			if (index == 0) SNAKE_HEAD_CHAR
			else SNAKE_BODY_CHAR);
	};

	nc::wrefresh(self.board.win);
};

//
//
//
fn update_cursor_position(
	win: nullable *const nc::WINDOW,
	row: int,
	col: int) void = {
	nc::mvwprintw(win, 1, 2, c::nulstr("Cursor pos: (%d, %d)\0"), col, row);
	nc::wrefresh(win);
};

//
//
//
export fn main() int = {
	//
	// Enable UTF8 support
	//
 	nc::setlocale(nc::LC_ALL, c::nulstr("\0"));

	//
	// Init screen
	//
	nc::initscr();
	defer nc::endwin();

	//
	// Check and enable color support
	//
	if (!nc::has_colors() || !nc::can_change_color()) {
		fmt::printfln(">>> Terminal doesn't support colors")!;
		return -1;
	};
	nc::start_color();

	//
	// Hide cursor
	//
	nc::hide_cursor();

	//
	// Input options
	//
	nc::cbreak();
	nc::noecho();
	nc::nonl();
	nc::raw();

	//
	// Create board
	//
	const term_size = nc::get_window_size(nc::stdscr);
	const game = init_game(term_size.width: u32, term_size.height: u32);
	defer deinit_game(&game);

	draw(&game);

	//
	// Game loop
	//
	let c = nc::wgetch(game.board.win);
	for(true) {
		switch (c) {
			case 'Q' => break;
			// Up
			case nc::KEY_E => {
				nc::mvwprintw(nc::stdscr,
					2, 2,
					c::nulstr("Direction: Up\0"));
			};
			// Down
			case nc::KEY_D => {
				nc::mvwprintw(nc::stdscr,
					2, 2,
					c::nulstr("Direction: Down\0"));
			};
			// Left
			case nc::KEY_S => {
				nc::mvwprintw(nc::stdscr,
					2, 2,
					c::nulstr("Direction: Left\0"));
			};
			// Right
			case nc::KEY_F => {
				nc::mvwprintw(nc::stdscr,
					2, 2,
					c::nulstr("Direction: Right\0"));
			};
			case => void;

		};
		draw(&game);
		c = nc::wgetch(game.board.win);
	};

	return 0;
};
