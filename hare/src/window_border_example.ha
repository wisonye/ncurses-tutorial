use fmt;
use nc;
use types::c;
use encoding::utf8;

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
	// Print tile and exit tips
	//
	const term_size = nc::get_window_size(nc::stdscr);
	nc::mvwprintw(nc::stdscr, 0, 1, c::nulstr("[ Window border example ]\0"));
	nc::mvwprintw(nc::stdscr, term_size.height - 2, 1, c::nulstr("Press any key to exit:)\0"));
	nc::wrefresh(nc::stdscr);

	const win_width = 40z, win_height = 3z, win_left = 2z;
	const y_padding = 1z;
	let win_top = 2z;

	//
	// Draw a few border windows
	//
	const regular_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::WindowBorderConfig { style = nc::BorderStyleRegular, color = void });
	win_top += win_height + y_padding;
	defer nc::delwin(regular_border_window.win);

	const bold_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::WindowBorderConfig { style = nc::BorderStyleBold, color = void });
	win_top += win_height + y_padding;
	defer nc::delwin(bold_border_window.win);

	const rounded_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::WindowBorderConfig { style = nc::BorderStyleRounded, color = void });
	win_top += win_height + y_padding;
	defer nc::delwin(rounded_border_window.win);

	const double_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::WindowBorderConfig { style = nc::BorderStyleDouble, color = void });
	win_top += win_height + y_padding;
	defer nc::delwin(double_border_window.win);

	const custom_ascii_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::WindowBorderConfig { style = nc::BorderStyleCustomAscii {
			top_left = '*',
			top = '#',
			top_right = '>',
			left = '{',
			right = '}',
			bottom_left = '[',
			bottom = '%',
			bottom_right = ']',
		}, color = void });
	win_top += win_height + y_padding;
	defer nc::delwin(custom_ascii_border_window.win);

	const ascii_top_border_color_pair = 1u16;
	const ascii_bottom_border_color_pair = 2u16;
	const ascii_left_border_color_pair = 3u16;
	const ascii_right_border_color_pair = 4u16;
	nc::init_pair(ascii_top_border_color_pair, nc::COLOR_RED, nc::COLOR_BLACK);
	nc::init_pair(ascii_bottom_border_color_pair, nc::COLOR_YELLOW, nc::COLOR_BLACK);
	nc::init_pair(ascii_left_border_color_pair, nc::COLOR_GREEN, nc::COLOR_BLACK);
	nc::init_pair(ascii_right_border_color_pair, nc::COLOR_MAGENTA, nc::COLOR_BLACK);
	const ascii_top_attr = nc::color_pair(ascii_top_border_color_pair);
	const ascii_bottom_attr = nc::color_pair(ascii_bottom_border_color_pair);
	const ascii_left_attr = nc::color_pair(ascii_left_border_color_pair);
	const ascii_right_attr = nc::color_pair(ascii_right_border_color_pair);
	const custom_ascii_color_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::WindowBorderConfig {
			style = nc::BorderStyleCustomAscii {
				top_left = '*',
				top = '#',
				top_right = '>',
				left = '{',
				right = '}',
				bottom_left = '[',
				bottom = '%',
				bottom_right = ']',
			}, color = nc::WindowBorderColor {
				top = ascii_top_attr,
				bottom = ascii_bottom_attr,
				left = ascii_left_attr,
				right = ascii_right_attr,
 			}
		});
	win_top += win_height + y_padding;
	defer nc::delwin(custom_ascii_color_border_window.win);

	const custom_utf8_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::WindowBorderConfig { style = nc::BorderStyleCustomUtf8 {
			top_left = '',
			top = '',
			top_right = '󰈀',
			left = '',
			right = '',
			bottom_left = '',
			bottom = '󰽲',
			bottom_right = '󱗾',
		}, color = void });
	win_top += win_height + y_padding;
	defer nc::delwin(custom_utf8_border_window.win);

	const rainbow_window = create_rainbow_window(
		win_left,
		win_top,
		win_width,
		win_height,
		);
	win_top += win_height + y_padding;
	defer nc::delwin(rainbow_window.win);

	nc::wgetch(nc::stdscr);
	return 0;
};

//
//
//
fn create_border_window(
	left: size,
	top: size,
	width: size,
	height: size,
	border_config: nc::WindowBorderConfig) nc::PopupWindow = {
	const popup = nc::create_popup_window(left, top, width, height, false);

	// Draw border
	nc::draw_window_border(popup.win, &border_config);

	// Print content
	// const font_attr = nc::A_ITALIC | nc::A_BOLD | nc::A_UNDERLINE | nc::A_STANDOUT;
	const font_attr = nc::A_ITALIC | nc::A_BOLD;
	nc::wattr_on(popup.win, font_attr);
	nc::mvwprintw(popup.win, 1, 2, c::nulstr("%s\0"), match (border_config.style) {
		case nc::BorderStyleRegular => yield c::nulstr("Regular border style\0");
		case nc::BorderStyleBold => yield c::nulstr("Bold border style\0");
		case nc::BorderStyleRounded => yield c::nulstr("Rounded border style\0");
		case nc::BorderStyleDouble => yield c::nulstr("Double border style\0");
		case nc::BorderStyleCustomAscii => yield c::nulstr("CustomAscii border style\0");
		case nc::BorderStyleCustomUtf8 => yield c::nulstr("CustomUtf8 border style\0");
	});
	nc::wattr_off(popup.win, font_attr);

	nc::wrefresh(popup.win);
	return popup;
};

//
//
//
fn create_rainbow_window(
	left: size,
	top: size,
	width: size,
	height: size) nc::PopupWindow = {
	const popup = nc::create_popup_window(left, top, width, height, false);

	const top_border_color_pair = 10u16;
	const bottom_border_color_pair = 11u16;
	const left_border_color_pair = 12u16;
	const right_border_color_pair = 13u16;
	nc::init_pair(top_border_color_pair, nc::COLOR_RED, nc::COLOR_BLACK);
	nc::init_pair(bottom_border_color_pair, nc::COLOR_YELLOW, nc::COLOR_BLACK);
	nc::init_pair(left_border_color_pair, nc::COLOR_GREEN, nc::COLOR_BLACK);
	nc::init_pair(right_border_color_pair, nc::COLOR_MAGENTA, nc::COLOR_BLACK);
	const top_attr = nc::color_pair(top_border_color_pair);
	const bottom_attr = nc::color_pair(bottom_border_color_pair);
	const left_attr = nc::color_pair(left_border_color_pair);
	const right_attr = nc::color_pair(right_border_color_pair);

	const rainbow_border_config = nc::WindowBorderConfig { style = nc::BorderStyleCustomUtf8 {
		top_left = '',
		top = '',
		top_right = '󰈀',
		left = '',
		right = '',
		bottom_left = '',
		bottom = '󰽲',
		bottom_right = '󱗾',
	} , color = nc::WindowBorderColor {
		top = top_attr,
		bottom = bottom_attr,
		left = left_attr,
		right = right_attr,
	}};

	// Draw border
	nc::draw_window_border(popup.win, &rainbow_border_config);

	// Print content
	// const font_attr = nc::A_ITALIC | nc::A_BOLD | nc::A_UNDERLINE | nc::A_STANDOUT;
	const font_attr = nc::A_ITALIC | nc::A_BOLD;
	nc::wattr_on(popup.win, font_attr | top_attr);
	nc::mvwprintw(popup.win, 1, 2, c::nulstr("Custom\0"));
	nc::wattr_off(popup.win, font_attr | top_attr);

	nc::wattr_on(popup.win, font_attr | bottom_attr);
	nc::wprintw(popup.win, c::nulstr(" rainbow\0"));
	nc::wattr_off(popup.win, font_attr | bottom_attr);

	nc::wattr_on(popup.win, font_attr | left_attr);
	nc::wprintw(popup.win, c::nulstr(" border\0"));
	nc::wattr_off(popup.win, font_attr | left_attr);

	nc::wattr_on(popup.win, font_attr | right_attr);
	nc::wprintw(popup.win, c::nulstr(":)\0"));
	nc::wattr_off(popup.win, font_attr | right_attr);

	nc::wrefresh(popup.win);
	return popup;
};


// export fn main() void = {
// 	// const draw_char = '╗';
// 	const draw_char = 192u8: rune;
// 	// const draw_char = '*';
// 	const slice = utf8::encoderune(draw_char);
// 	print_slice(slice);
// 	fmt::printfln(">>> draw_char: {}, size: {}", draw_char,utf8::runesz(draw_char))!;
// };
