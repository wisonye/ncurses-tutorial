use fmt;
use io;
use types::c;

//
// VT100 symbols are stored in extern `acs_map` array and can be accessed by
// index with an ASCII character.
//
// It defined in the `ncurses` source code
// ./ncurses/llib-lncursesw:chtype acs_map[128];
// ./ncurses/llib-ltinfo:chtype    acs_map[128];
//
export let @symbol("acs_map") acs_map: [128]chtype;

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
export type BorderStyleCustomAscii = WindowBorderChar;
export type BorderStyleCustomUtf8 = WindowBorderWideChar;
export type WindowBorderStyle = (
	BorderStyleRegular |
	BorderStyleBold |
	BorderStyleRounded |
	BorderStyleDouble |
	BorderStyleCustomAscii |
	BorderStyleCustomUtf8);

//
// ASCII range border char
//
export type WindowBorderChar = struct {
	top_left: chtype,
	top: chtype,
	top_right: chtype,
	left: chtype,
	right: chtype,
	bottom_left: chtype,
	bottom: chtype,
	bottom_right: chtype,
};

//
// UTF8 range border char
//
export type WindowBorderWideChar = struct {
	top_left: rune,
	top: rune,
	top_right: rune,
	left: rune,
	right: rune,
	bottom_left: rune,
	bottom: rune,
	bottom_right: rune,
};

export type WindowBorderColor = struct {
	top: VideoAttr,
	bottom: VideoAttr,
	left: VideoAttr,
	right: VideoAttr,
};

export type WindowBorderConfig = struct {
	style: WindowBorderStyle,
	color: (void | WindowBorderColor),
};

const BoldBorderChar = WindowBorderWideChar {
	top_left = '┏',
	top = '━',
	top_right = '┓',
	left = '┃',
	right = '┃',
	bottom_left = '┗',
	bottom = '━',
	bottom_right = '┛',
};

const RoundedBorderChar = WindowBorderWideChar {
	top_left = '╭',
	top = '─',
	top_right = '╮',
	left = '│',
	right = '│',
	bottom_left = '╰',
	bottom = '─',
	bottom_right = '╯',
};

const DoubleBorderChar = WindowBorderWideChar {
	top_left = '╔',
	top = '═',
	top_right = '╗',
	left = '║',
	right = '║',
	bottom_left = '╚',
	bottom = '═',
	bottom_right = '╝',
};

fn draw_window_border_with_char(
	win: const nullable *WINDOW,
	draw_char: WindowBorderChar,
	draw_color: (void | WindowBorderColor)) void = {
	match (draw_color) {
		case void => {
			wborder(win,
				draw_char.left,
				draw_char.right,
				draw_char.top,
				draw_char.bottom,
				draw_char.top_left,
				draw_char.top_right,
				draw_char.bottom_left,
				draw_char.bottom_right);
		};
		case let color: WindowBorderColor => {
			wborder(win,
				draw_char.left | color.left: chtype,
				draw_char.right | color.right: chtype,
				draw_char.top | color.top: chtype,
				draw_char.bottom | color.bottom: chtype,
				draw_char.top_left | color.top: chtype,
				draw_char.top_right | color.top: chtype,
				draw_char.bottom_left | color.bottom: chtype,
				draw_char.bottom_right | color.bottom: chtype);
		};
	};
};

fn draw_window_border_with_wide_char(
	win: const nullable *WINDOW,
	draw_char: WindowBorderWideChar,
	draw_color: (void | WindowBorderColor)) void = {
	const rect = get_window_rect(win);
	
	//
	// Top left
	//
	match (draw_color) {
		case void => mvwprintw(win, 0, 0, c::nulstr("%lc\0"), draw_char.top_left);
		case let color: WindowBorderColor => {
			wattr_on(win, color.top);
			mvwprintw(win, 0, 0, c::nulstr("%lc\0"), draw_char.top_left);
			wattr_off(win, color.top);
		};
	};

	//
	// Top
	//
	let draw_len: size = (rect.width - 1): size;
	for( let index=1z; index < draw_len; index +=1) {
		match (draw_color) {
			case void => wprintw(win, c::nulstr("%lc\0"), draw_char.top);
			case let color: WindowBorderColor => {
				wattr_on(win, color.top);
				wprintw(win, c::nulstr("%lc\0"), draw_char.top);
				wattr_off(win, color.top);
			};
		};
	};

	//
	// Top right
	//
	match (draw_color) {
		case void => wprintw(win, c::nulstr("%lc\0"), draw_char.top_right);
		case let color: WindowBorderColor => {
			wattr_on(win, color.top);
			wprintw(win, c::nulstr("%lc\0"), draw_char.top_right);
			wattr_off(win, color.top);
		};
	};


	//
	// Left & right
	//
	let draw_count: size = (rect.height - 1): size;
	for( let index=1z; index < draw_count; index +=1) {
		match (draw_color) {
			case void => {
				mvwprintw(win, index: int, 0, c::nulstr("%lc\0"), draw_char.left);
				mvwprintw(win, index: int, rect.width-1, c::nulstr("%lc\0"),
					draw_char.right);
			};
			case let color: WindowBorderColor => {
				wattr_on(win, color.left);
				mvwprintw(win, index: int, 0, c::nulstr("%lc\0"), draw_char.left);
				wattr_off(win, color.left);

				wattr_on(win, color.right);
				mvwprintw(win, index: int, rect.width-1, c::nulstr("%lc\0"),
					draw_char.right);
				wattr_off(win, color.right);
			};
		};
	};

	//
	// Bottom left
	//
	match (draw_color) {
		case void => mvwprintw(win, rect.height - 1, 0, c::nulstr("%lc\0"),
			draw_char.bottom_left);
		case let color: WindowBorderColor => {
			wattr_on(win, color.bottom);
			mvwprintw(win, rect.height - 1, 0, c::nulstr("%lc\0"),
				draw_char.bottom_left);
			wattr_off(win, color.bottom);
		};
	};

	//
	// bottom
	//
	draw_len = (rect.width - 1): size;
	for( let index=1z; index < draw_len; index +=1) {
		match (draw_color) {
			case void => wprintw(win, c::nulstr("%lc\0"), draw_char.bottom);
			case let color: WindowBorderColor => {
				wattr_on(win, color.bottom);
				wprintw(win, c::nulstr("%lc\0"), draw_char.bottom);
				wattr_off(win, color.bottom);
			};
		};
	};

	//
	// Bottom right
	//
	match (draw_color) {
		case void => wprintw(win, c::nulstr("%lc\0"), draw_char.bottom_right: chtype);
		case let color: WindowBorderColor => {
			wattr_on(win, color.bottom);
			wprintw(win, c::nulstr("%lc\0"), draw_char.bottom_right: chtype);
			wattr_off(win, color.bottom);
		};
	};
};

//
//
//
export fn draw_window_border(
	win: const nullable *WINDOW,
	config: const *WindowBorderConfig) void = {
	match (config.style) {
	case  BorderStyleRegular => {
		draw_window_border_with_char(win, WindowBorderChar {
			left = acs_map['x': chtype],
			right = acs_map['x': chtype],
			top = acs_map['q': chtype],
			bottom = acs_map['q': chtype],
			top_left = acs_map['l': chtype],
			top_right = acs_map['k': chtype],
			bottom_left = acs_map['m': chtype],
			bottom_right = acs_map['j': chtype],
		}, config.color);
	};
	case  BorderStyleBold => {
		draw_window_border_with_wide_char(win, BoldBorderChar, config.color);
	};
	case  BorderStyleRounded => {
		draw_window_border_with_wide_char(win, RoundedBorderChar, config.color);
	};
	case  BorderStyleDouble => {
		draw_window_border_with_wide_char(win, DoubleBorderChar, config.color);
	};
	case let draw_char:BorderStyleCustomAscii => {
		draw_window_border_with_char(win, draw_char, config.color);
	};
	case let draw_char:BorderStyleCustomUtf8 => {
		draw_window_border_with_wide_char(win, draw_char, config.color);
	};
	};

	wrefresh(win);
};
