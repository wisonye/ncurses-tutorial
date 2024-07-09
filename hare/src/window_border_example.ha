use fmt;
use nc;
use types::c;
use encoding::utf8;

export fn main() void = {
 	nc::setlocale(nc::LC_ALL, c::nulstr("\0"));

	nc::initscr();
	defer nc::endwin();

	const term_size = nc::get_window_size(nc::stdscr);
	nc::mvwprintw(nc::stdscr, 0, 1, c::nulstr("[ Window border example ]\0"));
	nc::mvwprintw(nc::stdscr, term_size.height - 2, 1, c::nulstr("Press any key to exit:)\0"));
	nc::wrefresh(nc::stdscr);

	const win_width = 40z, win_height = 3z, win_left = 2z;
	const y_padding = 1z;
	let win_top = 2z;

	const regular_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::BoxBorderConfig { style = nc::BorderStyleRegular });
	win_top += win_height + y_padding;
	defer nc::delwin(regular_border_window.win);

	const bold_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::BoxBorderConfig { style = nc::BorderStyleBold });
	win_top += win_height + y_padding;
	defer nc::delwin(bold_border_window.win);

	const rounded_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::BoxBorderConfig { style = nc::BorderStyleRounded });
	win_top += win_height + y_padding;
	defer nc::delwin(rounded_border_window.win);

	const double_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::BoxBorderConfig { style = nc::BorderStyleDouble });
	win_top += win_height + y_padding;
	defer nc::delwin(double_border_window.win);

	const custom_ascii_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::BoxBorderConfig { style = nc::BorderStyleCustomAscii {
			top_left = '*',
			top = '#',
			top_right = '>',
			left = '{',
			right = '}',
			bottom_left = '[',
			bottom = '%',
			bottom_right = ']',
		} });
	win_top += win_height + y_padding;
	defer nc::delwin(custom_ascii_border_window.win);

	const custom_utf8_border_window = create_border_window(
		win_left,
		win_top,
		win_width,
		win_height,
		nc::BoxBorderConfig { style = nc::BorderStyleCustomUtf8 {
			top_left = '',
			top = '',
			top_right = '󰈀',
			left = '',
			right = '',
			bottom_left = '',
			bottom = '󰽲',
			bottom_right = '󱗾',
		} });
	win_top += win_height + y_padding;
	defer nc::delwin(custom_utf8_border_window.win);

	nc::wgetch(nc::stdscr);
};

fn create_border_window(
	left: size,
	top: size,
	width: size,
	height: size,
	border_config: nc::BoxBorderConfig) nc::PopupWindow = {
	const popup = nc::create_popup_window(left, top, width, height, false);

	// Draw
	nc::draw_window_border(popup.win, &border_config);

	nc::mvwprintw(popup.win, 1, 2, c::nulstr("%s\0"), match (border_config.style) {
		case nc::BorderStyleRegular => yield c::nulstr("Regular border style\0");
		case nc::BorderStyleBold => yield c::nulstr("Bold border style\0");
		case nc::BorderStyleRounded => yield c::nulstr("Rounded border style\0");
		case nc::BorderStyleDouble => yield c::nulstr("Double border style\0");
		case nc::BorderStyleCustomAscii => yield c::nulstr("CustomAscii border style\0");
		case nc::BorderStyleCustomUtf8 => yield c::nulstr("CustomUtf8 border style\0");
	});
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
