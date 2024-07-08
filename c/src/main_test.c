#include <locale.h>
#include <ncurses.h>
#include <string.h>

// #define _XOPEN_SOURCE_EXTENDED

typedef struct PopupWindow {
    WINDOW *win;
    int left;
    int top;
    int width;
    int height;
} PopupWindow;

PopupWindow create_popup_window(int left, int top, int width, int height) {
    PopupWindow w = (PopupWindow){
        .left   = left,
        .top    = top,
        .width  = width,
        .height = height,
        .win    = NULL,
    };
    w.win = newwin(w.height, w.width, w.top, w.left);
    refresh();

    // Draw a box with default border to the given window (area)
    box(w.win, 0, 0);
    // Refresh  only the window (area)
    wrefresh(w.win);

    return w;
}

int main() {
    setlocale(LC_ALL, "");
    initscr();

    move(2,2);
    wprintw(stdscr, "Unicode symboles: %lc, %lc", L'╝', L'╮');

    move(4,2);
    addstr("╝");
    addstr("┏━┓");

    // Press any key to exit.
    getch();
    endwin();

    return 0;
}
