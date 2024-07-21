use fmt;
use nc;
use types::c;

def ENABLE_KEY_DEBUG_MODE: bool = true;
// def ENABLE_KEY_DEBUG_MODE: bool = false;

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
    if (!nc.has_colors() or !nc.can_change_color()) {
        print(">>> Terminal doesn't support colors", .{});
        return;
    }
    _ = nc.start_color();

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
	// Create typing window and print something
	//
	const term_size = nc::get_window_size(nc::stdscr);
	const typing_window_height = term_size.height - 3;
	const typing_window = nc::newwin(
		typing_window_height,
		term_size.width,
		0, 0);
	defer nc::delwin(typing_window);
	nc::wrefresh(nc::stdscr);

	nc::box(typing_window, 0, 0);

	const start_col = 2;
	let row = 0;

	nc::mvwprintw(typing_window, row, start_col,
		if (ENABLE_KEY_DEBUG_MODE) c::nulstr("[ Editor typing example - Key debug mode: enabled ]\0")
		else c::nulstr("[ Editor typing example ]\0"));
		
	row += 2;
	nc::mvwprintw(typing_window, row, start_col,
		c::nulstr("Try typing right now, press 'Q' to exit:)\0"));
	row += 2;
	nc::wmove(typing_window, row, start_col);
	nc::wrefresh(typing_window);

	//
	// Create status window and print typing window cursor position
	//
	const status_window_height = 3;
	const status_window = nc::newwin(
		status_window_height,
		term_size.width,
		typing_window_height,
		0);
	defer nc::delwin(status_window);

	nc::wrefresh(nc::stdscr);

	nc::box(status_window, 0, 0);

	let pos = nc::get_cursor_position(typing_window);
	update_cursor_position(status_window, pos.y, pos.x);

	//
	// Typing loop
	//
	let c = nc::wgetch(typing_window);
	for(true) {
		//
		// Print key debug info to status window (fixed on bottom right area)
		//
		if (ENABLE_KEY_DEBUG_MODE) {
			let debug_buffer: [30]u8 = [0x00...];
			const debug_msg = fmt::bsprintf(
				&debug_buffer,
				"Key: 0x{:X.2} ({}) - {}\0",
				c,
				c,
				c::tostr_unsafe(nc::keyname(c)));

			nc::mvwprintw(status_window,
				1, term_size.width - 30,
				c::nulstr("%20s\0"),
				c::nulstr(debug_msg));
			nc::wrefresh(status_window);
		};

		switch (c) {
			case 'Q' => break;
			case nc::KEY_ESCAPE => void;
			case nc::KEY_DEL => {
				pos = nc::get_cursor_position(typing_window);
				if (pos.y != 0 && pos.x != 0) {
					nc::mvwdelch(nc::stdscr, pos.y, pos.x - 1);
				};
			};
			case nc::KEY_CTRL_A => void;
			case nc::KEY_CTRL_B => void;
			case nc::KEY_CTRL_C => void;
			case nc::KEY_CTRL_D => void;
			case nc::KEY_CTRL_E => void;
			case nc::KEY_CTRL_F => void;
			case nc::KEY_CTRL_G => void;
			case nc::KEY_CTRL_H => void;
			// case nc::KEY_CTRL_I => void; // ^I -> TAB
			case nc::KEY_CTRL_J => void;
			case nc::KEY_CTRL_K => void;
			case nc::KEY_CTRL_L => void;
			// case nc::KEY_CTRL_M => void; // ^M -> CR
			case nc::KEY_CTRL_N => void;
			case nc::KEY_CTRL_O => void;
			case nc::KEY_CTRL_P => void;
			case nc::KEY_CTRL_Q => void;
			case nc::KEY_CTRL_R => void;
			case nc::KEY_CTRL_S => void;
			case nc::KEY_CTRL_T => void;
			case nc::KEY_CTRL_U => void;
			case nc::KEY_CTRL_V => void;
			case nc::KEY_CTRL_W => void;
			case nc::KEY_CTRL_X => void;
			case nc::KEY_CTRL_Y => void;
			case nc::KEY_CTRL_Z => void;

			case nc::KEY_CR => {
				//
				// Manually add new line character, as `nonl`
				// disable `\n` translation.
				//
				nc::waddch(typing_window, '\n');

				//
				// Fix new line start typing position
				//
				pos = nc::get_cursor_position(typing_window);
				nc::wmove(typing_window, pos.y, start_col);
			};
			case nc::KEY_TAB => {
				//
				// Manually add tab character
				//
				nc::waddch(typing_window, '\t');
			};
			//
			// Default: Print the pressed key
			//
			case => nc::wprintw(typing_window, c::nulstr("%s\0"), nc::keyname(c));
		};
		nc::wrefresh(typing_window);

		//
		//
		//
		pos = nc::get_cursor_position(typing_window);
		update_cursor_position(status_window, pos.y, pos.x);

		c = nc::wgetch(typing_window);
	};


	return 0;
};
