#include <pthread.h>
#include <stdio.h>

#define COPYING_MACHINE_IMPLEMENTATION
#include "copying_machine.h"

#define TP_TEST_THREAD_COUNT 5

///
/// Thread function state
///
typedef struct {
    const char *user_name;
    const char *copy_filename;
    u8 copy_numbers;

    CopyingMachine *cm;
} CopyingTask;

///
/// Thread funciton must take a `*void` as parameter and return a `*void`
///
void *make_copies(void *state) {
    CopyingTask *ct = (CopyingTask *)state;

    CM_make_copies(ct->cm, ct->user_name, ct->copy_filename, ct->copy_numbers);

#ifndef __APPLE__
    // CM_make_copies_v2(ct->cm, ct->user_name, ct->copy_filename,
    // ct->copy_numbers);
#endif

    return NULL;
}

///
///
///
int main(void) {
    CopyingMachine cm = CM_init();

    //
    // Threads and init thread attribute
    //
    pthread_t threads[TP_TEST_THREAD_COUNT] = {0};
    pthread_attr_t thread_attr              = {0};
    if (pthread_attr_init(&thread_attr) != 0) {
        perror("\n>>> Init thread attribute failed: ");

        CM_deinit(&cm);
        return -1;
    }

    //
    // Create a few copying tasks
    //
    CopyingTask copying_task[5] = {(CopyingTask){
                                       .user_name     = "Wison",
                                       .copy_filename = "123.pdf",
                                       .copy_numbers  = 5,
                                       .cm            = &cm,
                                   },
                                   (CopyingTask){
                                       .user_name     = "Fion",
                                       .copy_filename = "234.pdf",
                                       .copy_numbers  = 6,
                                       .cm            = &cm,
                                   },
                                   (CopyingTask){
                                       .user_name     = "Paul",
                                       .copy_filename = "456.pdf",
                                       .copy_numbers  = 7,
                                       .cm            = &cm,
                                   },
                                   (CopyingTask){
                                       .user_name     = "Wison",
                                       .copy_filename = "789.pdf",
                                       .copy_numbers  = 8,
                                       .cm            = &cm,
                                   },
                                   (CopyingTask){
                                       .user_name     = "David",
                                       .copy_filename = "910.pdf",
                                       .copy_numbers  = 9,
                                       .cm            = &cm,
                                   }};

    //
    // Create new threads
    //
    for (int index = 0; index < TP_TEST_THREAD_COUNT; index++) {
        int create_result = pthread_create(
            //
            // Pointer to `pthread *`
            //
            &threads[index],
            //
            // Pointer to `pthread_attr *`
            //
            // You also can pass `NULL` here for using the default thread
            // attribute
            //
            &thread_attr,
            //
            // Share thread funciton
            //
            make_copies,
            //
            // Parameter that passes into the thread function
            //
            (void *)&copying_task[index]);

        if (create_result != 0) {
            fprintf(stderr, "Failed to create thread with index: %d", index);
        }
    }

    //
    // Once a thread has been created, the thread attribute is no
    // longer needed, destroy it
    //
    pthread_attr_destroy(&thread_attr);

    printf("\n>>> [ main ] - All threads should be running in background.");

    //
    // Wait for all threads to finish
    //
    for (int index = 0; index < TP_TEST_THREAD_COUNT; index++) {
        int join_result = pthread_join(threads[index], NULL);

        if (join_result != 0) {
            fprintf(stderr, "Failed to join thread with index: %d", index);
        }
    }

    printf("\n>>> [ main ] - Done.");

    //
    // Make sure to `deinit`!!!
    //
    CM_deinit(&cm);
}
