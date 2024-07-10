use fmt;
use nc;
use types::c;

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
	// nc::hide_cursor();

	//
	// Input options
	//
	nc::cbreak();
	nc::noecho();
	nc::nonl();
	nc::raw();

	//
	// Print tile and exit tips
	//
	let row = 0;
	const term_size = nc::get_window_size(nc::stdscr);
	nc::mvwprintw(nc::stdscr, term_size.height - 2, 1,
		c::nulstr("Press 'Q' to exit:)\0"));

	nc::mvwprintw(nc::stdscr, row, 0, c::nulstr("[ Popup menu example ]\0"));
	row += 2;
	nc::mvwprintw(nc::stdscr, row, 0,
		c::nulstr("Type something and then press enter to show dropdown menu.\0"));
	row += 1;
	nc::mvwprintw(nc::stdscr, row, 0,
		c::nulstr("Press <C-J> and <C-K> to navigate menu item.\0"));
	row += 2;

	//
	// Typing loop
	//
	nc::wmove(nc::stdscr, row, 0);
	let pos = nc::get_cursor_position(nc::stdscr);
	nc::mvwprintw(nc::stdscr, term_size.height - 4, 1,
		c::nulstr("Cursor pos: (%d, %d)\0"), pos.x, pos.y);
	nc::wmove(nc::stdscr, row, 0);
	nc::wrefresh(nc::stdscr);

	let c = nc::wgetch(nc::stdscr);
	let pos = nc::get_cursor_position(nc::stdscr);
	nc::mvwprintw(nc::stdscr, term_size.height - 4, 1,
		c::nulstr("Cursor pos: (%d, %d)\0"), pos.x, pos.y);
	nc::wrefresh(nc::stdscr);
	for(true) {
		switch (c) {
			case 'Q' => break;
			case nc::KEY_DEL => {
				pos = nc::get_cursor_position(nc::stdscr);
				if (pos.y != 0 && pos.x != 0) {
					nc::mvwdelch(nc::stdscr, pos.y, pos.x - 1);
				};
			};
			case nc::KEY_CTRL_C => nc::waddstr(nc::stdscr, c::nulstr("<C-C>\0"));
			case nc::KEY_CTRL_J => nc::waddstr(nc::stdscr, c::nulstr("<C-J>\0"));
			case nc::KEY_CTRL_K => nc::waddstr(nc::stdscr, c::nulstr("<C-K>\0"));
			case nc::KEY_CR => nc::waddch(nc::stdscr, '\n');
			// case => nc::wprintw(nc::stdscr, c::nulstr("%c (%d)\0"), c, c);
			case => nc::wprintw(nc::stdscr, c::nulstr("%s\0"), nc::keyname(c));
		};

		c = nc::wgetch(nc::stdscr);
		nc::mvwprintw(nc::stdscr, term_size.height - 4, 1,
			c::nulstr("Cursor pos: (%d, %d)\0"), pos.x, pos.y);
		nc::wrefresh(nc::stdscr);
	};


	return 0;
};
