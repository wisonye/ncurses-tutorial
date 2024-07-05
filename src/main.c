#include <ncurses.h>
#include <string.h>

#include "color.h"

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
    // wborder(w.win, 'l', 'r', 't', 'b', '<', '>', '{', '}');
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

int main_2() {
    /* printf("size of chtype: %zu", sizeof(chtype)); */
    /* return 0; */

    initscr();

    const WindowSize main_win_size = get_window_size(stdscr);
    mvwprintw(stdscr,
              2,
              0,
              "main window size -> row: %d, col: %d",
              main_win_size.width,
              main_win_size.height);

    const StatusBar status_bar =
        create_status_bar(main_win_size.width, main_win_size.height);

    WindowRect status_bar_rect = get_window_rect(status_bar.win);
    mvwprintw(stdscr,
              2,
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

int main_4() {
    initscr();

    if (!has_colors()) {
        printf("\n>>> Terminal doesn't support colors");
        return -1;
    }
    start_color();

    ColorTheme theme = CT_init();
    mvwprintw(stdscr, 0, 0, "Loaded color theme: %s", theme.name);

    move(2, 0);
    // for (int index = 0; index < COLOR_PAIR_SIZE; index++) {
    for (int index = 0; index < 4; index++) {
        const ColorPair *cp        = &theme.pairs[index];
        const short selected_color = COLOR_PAIR(cp->color_pair_index);
        attron(selected_color);

        wprintw(
            stdscr,
            "[ Color pair name ] {\n\tname: %s\n\tcp_index: "
            "%d\n\tforeground_color_index: %d\n\t"
            "background_color_index: %d\n\tforeground: {\n\t\tr: %d\n\t\tg: "
            "%d\n\t\tb: %d\n\t}\n}\n",
            cp->name,
            cp->color_pair_index,
            cp->foreground_color_index,
            cp->background_color_index,
            cp->foreground.r,
            cp->foreground.g,
            cp->foreground.b);

        attroff(selected_color);
    }

    // Press any key to exit.
    getch();
    endwin();
    return 0;
}

// #define CUSTOM_COLOR_START_INDEX 9

/* int main() { */
/*     initscr(); */

/*     if (!has_colors()) { */
/*         printf("\n>>> Terminal doesn't support colors"); */
/*         return -1; */
/*     } */
/*     start_color(); */

/*     // */
/*     // Create your own color */
/*     // */
/*     short color_index                  = CUSTOM_COLOR_START_INDEX; */
/*     const short foreground_color_index = color_index; */
/*     init_color(foreground_color_index, */
/*                (float)((float)0xF4 / (float)256) * 1000, */
/*                (float)((float)0x47 / (float)256) * 1000, */
/*                (float)((float)0x47 / (float)256) * 1000); */
/*     color_index += 1; */

/*     const short background_color_index = color_index; */
/*     init_color(background_color_index, */
/*                (float)((float)0x23 / (float)256) * 1000, */
/*                (float)((float)0x21 / (float)256) * 1000, */
/*                (float)((float)0x1B / (float)256) * 1000); */
/*     color_index += 1; */

/*     const short my_color_pair_index = 1; */
/*     init_pair(my_color_pair_index, */
/*               foreground_color_index, */
/*               background_color_index); */
/*     const short selected_color_attr = COLOR_PAIR(my_color_pair_index); */

/*     // */
/*     // Use selected color to draw */
/*     // */
/*     wattron(stdscr, selected_color_attr); */
/*     wprintw(stdscr, "Here is the selected color:)"); */
/*     wattroff(stdscr, selected_color_attr); */

/*     // Press any key to exit. */
/*     getch(); */
/*     endwin(); */
/*     return 0; */
/* } */

int main() {
    initscr();
    noecho();
    raw();
    keypad(stdscr, true);

    if (!has_colors() || !can_change_color()) {
        printf("\n>>> Terminal doesn't support colors");
        return -1;
    }
    start_color();

    wprintw(stdscr, "Press 'Q' key to exit:)\n\n");

    uint8_t c = 0;
    while ((c = wgetch(stdscr)) != 'Q') {
        //
        // 1. Compare string with `keyname(c)`
        //
        const char *typed_key = keyname(c);
        if (strcmp(typed_key, "^A") == 0) {
            wprintw(stdscr, "You pressed: <C-A>, HEX: 0x%.2X\n", c);
        }
        //
        // 2. Like this
        //
		else if (c == ('I' & 0x1F)) {
            wprintw(stdscr, "You pressed: <C-I>, HEX: 0x%.2X\n", c);
        }
		else {
            wprintw(stdscr,
                    "You pressed: %s, HEX: 0x%.2X %s\n",
                    typed_key,
                    c,
                    typed_key[0] == '^' ? "(modify key: CTRL)" : "");
        }
    }

    endwin();
    return 0;
}
