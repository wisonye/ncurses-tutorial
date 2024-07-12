use fmt;
use math::random;
use nc;
use time;
use types::c;

def ENABLE_DEBUG_PRINT: bool = true;

def FOOD_CHAR: nc::chtype = '󱗾';
def SNAKE_HEAD_CHAR: nc::chtype = '';
def SNAKE_BODY_CHAR: nc::chtype = '';

def BOARD_HEIGHT: u32 = 20;
def BOARD_WIDTH: u32 = (BOARD_HEIGHT:f32 * 2.5): u32;

type Board = struct {
	left: int,
	top: int,
	width: int,
	height: int,
	win: nullable *nc::WINDOW,
};

type Game = struct {
    is_pause: bool,
    is_destroy: bool,
	snake: []nc::CursorPosition,
	food: nc::CursorPosition,
	score: size,
	board: Board,
};

fn get_random_size(max: u32) size = {
	const nano_second_as_seed = time::now(time::clock::MONOTONIC).nsec: u64;
	const rand = random::init(nano_second_as_seed);
	return random::u32n(&rand, max);
};

fn init_game(screen_width: u32, screen_height: u32) Game = {
	const board_left = ((screen_width/2) - (BOARD_WIDTH/2)): int;
	const board_top = ((screen_height/2) - (BOARD_HEIGHT/2)): int;
	let self = Game {
        is_pause = false,
        is_destroy = false,
		snake = alloc([], 20),
		food = nc::CursorPosition {
			x = get_random_size(BOARD_WIDTH - 1): int,
			y = get_random_size(BOARD_HEIGHT - 1): int,
		},
		score = 0z,
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
	};
	nc::wrefresh(nc::stdscr);

	append(self.snake, nc::CursorPosition {
			x = get_random_size(BOARD_WIDTH - 1): int,
			y = get_random_size(BOARD_HEIGHT - 1): int,
	});

	return self;
};

fn deinit_game(self: *Game) void = {
	if (!self.is_destroy) {
		free(self.snake);
		nc::delwin(self.board.win);
	};
};

fn draw(self: *const Game) void = {
	nc::wclear(self.board.win);

	nc::box(self.board.win, 0, 0);

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
		row += 2;
		nc::mvwprintw(
			nc::stdscr,
			row, start_col,
			c::nulstr(">>> Food: (%d, %d)\n\0"),
			self.food.x,
			self.food.y);

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
	// Typing loop
	//
	let c = nc::wgetch(game.board.win);

	return 0;
};
