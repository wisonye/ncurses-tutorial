use fmt;
use nc;
use types::c;

export fn main() void = {
	nc::initscr();
	defer nc::endwin();

	const term_size = nc::get_window_size(nc::stdscr);
	const popup = nc::create_popup_window(4, 1, 10, 3);
	const popup_rect = nc::get_window_rect(popup.win);
	nc::mvwprintw(nc::stdscr,
		1, 1,
		c::nulstr("Terminal window size: (%d, %d)\0"),
		term_size.width, term_size.height);
	nc::mvwprintw(nc::stdscr,
		2, 1,
		c::nulstr("popup window rect: (%d, %d) - (%d, %d)\0"),
		popup_rect.left,
		popup_rect.top,
		popup_rect.right,
		popup_rect.bottom);

	nc::mvwprintw(nc::stdscr,
		term_size.height - 2, 1,
		c::nulstr("Press any key to exit:)\0"));
	nc::wrefresh(nc::stdscr);
	nc::wgetch(nc::stdscr);
};
