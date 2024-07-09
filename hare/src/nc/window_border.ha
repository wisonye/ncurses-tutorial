use fmt;
use io;
use types::c;

//
// `chtype` means a unsigned character, e.g.:
// 	'a'~'z', 'A'~ Z', '0'~'9'
// 	'*', '?', '>', '<', '=', etc.
//
// 	'0' means use the default charater to fill the border!!!
//
export @symbol ("wborder") fn wborder(
	win: nullable *WINDOW,
	left: chtype,
	right: chtype,
	top: chtype,
	bottom: chtype,
	top_left_corner: chtype,
	top_right_corner: chtype,
	bottom_left_corner: chtype,
	bottom_right_corner: chtype) int;

export fn box(
	win: nullable *WINDOW,
	left_right: chtype,
	top_bottom: chtype) int = {
	return wborder(
		win,
		top_bottom,
		top_bottom,
		left_right,
		left_right,
		0u, 0u, 0u, 0u);
};

export type BorderStyleRegular = void;
export type BorderStyleBold = void;
export type BorderStyleRounded = void;
export type BorderStyleDouble = void;
export type BorderStyleCustomAscii = BoxBorderChar;
export type BorderStyleCustomUtf8 = BoxBorderWideChar;
export type BoxBorderStyle = (
	BorderStyleRegular |
	BorderStyleBold |
	BorderStyleRounded |
	BorderStyleDouble |
	BorderStyleCustomAscii |
	BorderStyleCustomUtf8);

//
// ASCII range border char
//
export type BoxBorderChar = struct {
	top_left: u8,
	top: u8,
	top_right: u8,
	left: u8,
	right: u8,
	bottom_left: u8,
	bottom: u8,
	bottom_right: u8,
};

//
// UTF8 range border char
//
export type BoxBorderWideChar = struct {
	top_left: rune,
	top: rune,
	top_right: rune,
	left: rune,
	right: rune,
	bottom_left: rune,
	bottom: rune,
	bottom_right: rune,
};

// type BoxBorderAttr = struct {
// 	top: pen,
// 	bottom: pen,
// 	left: pen,
// 	right: pen,
// };

export type BoxBorderConfig = struct {
	style: BoxBorderStyle,
	// color: (void | BoxBorderPen),
};

const BoldBorderChar = BoxBorderWideChar {
	top_left = '┏',
	top = '━',
	top_right = '┓',
	left = '┃',
	right = '┃',
	bottom_left = '┗',
	bottom = '━',
	bottom_right = '┛',
};

const RoundedBorderChar = BoxBorderWideChar {
	top_left = '╭',
	top = '─',
	top_right = '╮',
	left = '│',
	right = '│',
	bottom_left = '╰',
	bottom = '─',
	bottom_right = '╯',
};

const DoubleBorderChar = BoxBorderWideChar {
	top_left = '╔',
	top = '═',
	top_right = '╗',
	left = '║',
	right = '║',
	bottom_left = '╚',
	bottom = '═',
	bottom_right = '╝',
};


//
// `wborder` function only accepts u8 ASCII char, so we must draw the wide char
// border ourselves.
//
fn draw_window_border_with_wide_char(win: const nullable *WINDOW, draw_char: BoxBorderWideChar) void = {
	const rect = get_window_rect(win);
	
	//
	// Top left
	//
	mvwprintw(win, 0, 0, c::nulstr("%lc\0"), draw_char.top_left);

	//
	// Top
	//
	let draw_len: size = (rect.width - 1): size;
	for( let index=1z; index < draw_len; index +=1) {
		wprintw(win, c::nulstr("%lc\0"), draw_char.top);
	};

	//
	// Top right
	//
	wprintw(win, c::nulstr("%lc\0"), draw_char.top_right);

	//
	// Left & right
	//
	let draw_count: size = (rect.height - 1): size;
	for( let index=1z; index < draw_count; index +=1) {
		mvwprintw(win, index: int, 0, c::nulstr("%lc\0"), draw_char.left);
		mvwprintw(win, index: int, rect.width-1, c::nulstr("%lc\0"), draw_char.right);
	};

	//
	// Bottom left
	//
	mvwprintw(win, rect.height - 1, 0, c::nulstr("%lc\0"), draw_char.bottom_left);

	//
	// bottom
	//
	draw_len = (rect.width - 1): size;
	for( let index=1z; index < draw_len; index +=1) {
		wprintw(win, c::nulstr("%lc\0"), draw_char.bottom);
	};

	//
	// Bottom right
	//
	wprintw(win, c::nulstr("%lc\0"), draw_char.bottom_right: chtype);
};

export fn draw_window_border(win: const nullable *WINDOW, config: const *BoxBorderConfig) void = {
	match (config.style) {
	case  BorderStyleRegular => {
		box(win, 0, 0);
	};
	case  BorderStyleBold => {
		draw_window_border_with_wide_char(win, BoldBorderChar);
	};
	case  BorderStyleRounded => {
		draw_window_border_with_wide_char(win, RoundedBorderChar);
	};
	case  BorderStyleDouble => {
		draw_window_border_with_wide_char(win, DoubleBorderChar);
	};
	case let draw_char:BorderStyleCustomAscii => {
		wborder(win,
			draw_char.left: chtype,
			draw_char.right: chtype,
			draw_char.top: chtype,
			draw_char.bottom: chtype,
			draw_char.top_left: chtype,
			draw_char.top_right: chtype,
			draw_char.bottom_left: chtype,
			draw_char.bottom_right: chtype);
	};
	case let draw_char:BorderStyleCustomUtf8 => {
		draw_window_border_with_wide_char(win, draw_char);
	};
	};

	wrefresh(win);
};

