#include <ncurses.h>

typedef struct StatusBar {
    WINDOW *win;
    int height;
    int width;
    int top;
    int left;
} StatusBar;

StatusBar create_status_bar(int screen_width, int screen_height) {
    const int bar_height = 3;
    StatusBar w          = (StatusBar){
                 .height = bar_height,
                 .width  = screen_width,
                 .top    = (int)(screen_height - bar_height - 1),
                 .left   = 0,
                 .win    = NULL,
    };
    w.win = newwin(w.height, w.width, w.top, w.left);
    refresh();

    // Draw a box with default border to the given window (area)
    box(w.win, 0, 0);
    wborder(w.win, 'l', 'r', 't', 'b', '<', '>', '{', '}');
    // Refresh  only the window (area)
    wrefresh(w.win);

    return w;
}

typedef struct WindowSize {
    int width;
    int height;
} WindowSize;

WindowSize get_window_size(const WINDOW *win) {
    int window_width, window_height;
    getmaxyx(win, window_height, window_width);
    return (WindowSize){.width = window_width, .height = window_height};
}

typedef struct {
    int left;
    int top;
    int width;
    int height;
} WindowRect;

WindowRect get_window_rect(const WINDOW *win) {
    return (WindowRect){
        .left   = getbegx(win),
        .top    = getbegy(win),
        .width  = getmaxx(win),
        .height = getmaxy(win),
    };
}

int main() {
    /* printf("size of chtype: %zu", sizeof(chtype)); */
    /* return 0; */

    initscr();

    const WindowSize main_win_size = get_window_size(stdscr);
    mvwprintw(stdscr,
              0,
              0,
              "main window size -> row: %d, col: %d",
              main_win_size.width,
              main_win_size.height);

    const StatusBar status_bar =
        create_status_bar(main_win_size.width, main_win_size.height);

    WindowRect status_bar_rect = get_window_rect(status_bar.win);
    mvwprintw(stdscr,
              0,
              0,
              "Status bar rect -> left: %d, top: %d, width: %d, height: %d",
              status_bar_rect.left,
              status_bar_rect.top,
              status_bar_rect.width,
              status_bar_rect.height);
    mvwprintw(status_bar.win, 1, 1, "[ NORMAL ]");
    wrefresh(status_bar.win);

    // Press any key to exit.
    getch();
    endwin();
    return 0;
}

/* int main() { */
/*     initscr(); */
/*     mvwprintw(stdscr, */
/*               0, */
/*               0, */
/*               "Hello world from ncurses"); */
/*     // Press any key to exit. */
/*     getch(); */
/*     endwin(); */
/* } */
