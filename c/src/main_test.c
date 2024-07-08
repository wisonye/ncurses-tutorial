#include <ncurses.h>
#include <string.h>

typedef struct PopupWindow {
    WINDOW *win;
    int win_height;
    int win_width;
    int win_top;
    int win_left;
} PopupWindow;

PopupWindow create_popup_window(int screen_width, int screen_height) {
    PopupWindow w = (PopupWindow){
        .win_height = (int)(screen_height / 2),
        .win_width  = (int)(screen_width / 2),
        .win_top    = (int)(screen_height / 4),
        .win_left   = (int)(screen_width / 4),
        .win        = NULL,
    };
    w.win = newwin(w.win_height, w.win_width, w.win_top, w.win_left);
    // refresh();

    // Draw a box with default border to the given window (area)
    box(w.win, 0, 0);
    // Refresh  only the window (area)
    wrefresh(w.win);

    return w;
}

void print_question_and_answer(int screen_width, int screen_height) {
    char input_char = 0;

    // Clear the screen output and move cursor to init position
    // clear();
    move(0, 0);

    // Create new popup windows
    const PopupWindow popup = create_popup_window(screen_width, screen_height);

    //
    // Print inside the popup window: Move cursor relative by the given window
    // and print somthing
    //
    int row_in_popup = 2;
    int col_in_popup = 4;
    mvwprintw(popup.win,
              row_in_popup,
              col_in_popup,
              "Which one is your favored OS:");

    row_in_popup++;
    mvwprintw(popup.win, row_in_popup, col_in_popup, "1. FreeBSD");

    row_in_popup++;
    mvwprintw(popup.win, row_in_popup, col_in_popup, "2. OpenBSD");

    row_in_popup++;
    mvwprintw(popup.win, row_in_popup, col_in_popup, "3. ArchLinux");
    wrefresh(popup.win);  // Draw once after all `wprintw` calls have been done.

    noecho();
    input_char = getch();

    row_in_popup += 2;

    mvwprintw(popup.win,
              row_in_popup,
              col_in_popup,
              "You choose: %c",
              input_char);
    mvwprintw(popup.win,
              row_in_popup + 2,
              col_in_popup,
              "Press any key to close the popup window.");
    wrefresh(popup.win);  // Draw once after all `wprintw` calls have been done.

    //
    // Press a key to destory the popup window
    //
    wgetch(popup.win);
    wclear(popup.win);
    wrefresh(popup.win);

    //
    // Because `delwin` deletes the named window, freeing all memory associated
    // with it, but it DOES NOT actually erase the window's screen image!!!
    //
    // That's why you have to either:
    //
    // 1. Call `wclear()` and `wrefresh()` before `delwin()`.
    //
    // 2. Call `redrawwin(parent_window)` after `delwin()` to update the parent
    //    window on screen.
    //
    delwin(popup.win);

    // redrawwin(stdscr);
}

//
//
//
void get_and_print_cursor_and_window_size(void) {
    int x, y, left_top_x, left_top_y, right_bottom_y, right_bottom_x;

    // Get cursor position
    move(10, 10);
    getyx(stdscr, y, x);
    printw("(%d,%d)", x, y);

    // Get window left top position
    move(0, 0);
    getbegyx(stdscr, left_top_y, left_top_x);
    printw("(%d,%d)", left_top_x, left_top_y);

    // Get window right bottom position, or say window's height and width
    getmaxyx(stdscr, right_bottom_y, right_bottom_x);
    move(right_bottom_y - 1, right_bottom_x - 8);
    printw("(%d,%d)", right_bottom_x, right_bottom_y);

    // Draw some text in the center
    const char *draw_text =  "Press a key to show a popup window:)";
    int draw_x = (int)(right_bottom_x / 2) - (int)(strlen(draw_text) / 2);
    int draw_y = (int)(right_bottom_y / 2);
    mvprintw(draw_y, draw_x, "%s", draw_text);
    refresh();
}

int main() {
    initscr();

    get_and_print_cursor_and_window_size();

    getch();

    //
    // Get window right bottom position, or say window's height and width
    //
    int main_window_width, main_window_height;
    getmaxyx(stdscr, main_window_height, main_window_width);
    print_question_and_answer(main_window_width, main_window_height);

    //
    // Draw the exit message
    //
    const char *draw_text =  "Press a key to exit the program:)";
    int draw_x = (int)(main_window_width / 2) - (int)(strlen(draw_text) / 2);
    int draw_y = (int)(main_window_height / 2);

    // You should clear the entire line to remove the previ drawn text
    move(draw_y, 0);
    clrtoeol();

    // draw new message on the same line
    mvprintw(draw_y, draw_x, "%s", draw_text);

    // Press any key to exit.
    getch();
    endwin();
}

