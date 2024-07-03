#ifndef __COPYING_MACHINE_H__
#define __COPYING_MACHINE_H__

#include <errno.h>
#include <pthread.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#define LOG_SIZE         4
#define LOG_MESSAGE_SIZE 100

typedef uint8_t u8;
typedef uintptr_t usize;

typedef struct {
    char operation_log[LOG_SIZE][LOG_MESSAGE_SIZE];
    pthread_mutex_t internal_mutex;
    bool already_init_mutex;
} CopyingMachine;

CopyingMachine CM_init();

void CM_deinit(CopyingMachine *self);
void CM_make_copies(CopyingMachine *self,
                    const char *user_name,
                    const char *filename,
                    u8 copy_numbers);

#ifdef COPYING_MACHINE_IMPLEMENTATION

    #include <string.h>

///
///
///
CopyingMachine CM_init() {
    // CopyingMachine instance = {0};
    CopyingMachine instance = (CopyingMachine){
        .operation_log      = {0},
        .already_init_mutex = false,
    };
    if (pthread_mutex_init(&instance.internal_mutex, NULL) == 0) {
        instance.already_init_mutex = true;
    }

    return instance;
}

///
///
///
void CM_deinit(CopyingMachine *self) {
    if (self->already_init_mutex) {
        pthread_mutex_destroy(&self->internal_mutex);
        self->already_init_mutex = false;
    }
}

///
///
///
void CM_make_copies(CopyingMachine *self,
                    const char *user_name,
                    const char *copy_filename,
                    u8 copy_numbers) {
    char log_message[LOG_MESSAGE_SIZE] = {0};

    int lock_result = pthread_mutex_lock(&self->internal_mutex);
    if (lock_result == 0) {
        //
        // Step 1: Clear operation log
        //
        memset(self->operation_log, 0, sizeof(self->operation_log));

        //
        // Step 2: Open cover
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s' is opening the cover",
                 user_name);
        memcpy(&self->operation_log[0][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 3: Place copy file
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s' is placing the copy file: %s",
                 user_name,
                 copy_filename);
        memcpy(&self->operation_log[1][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 4: Select copy numvers
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s' is selecting the copy numbers: %d",
                 user_name,
                 copy_numbers);
        memcpy(&self->operation_log[2][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 5: Make copies
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s''s task is processing: Making %d copies from '%s'",
                 user_name,
                 copy_numbers,
                 copy_filename);
        memcpy(&self->operation_log[3][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 6: Print operation logs
        //
        printf("\n>>> [ Copying Machine ] - Operation Logs: ");
        for (usize index = 0; index < LOG_SIZE; index++) {
            printf("\n>>> \t%s", &self->operation_log[index][0]);
        }
        printf("\n>>> \tDone.");

        pthread_mutex_unlock(&self->internal_mutex);
    } else {
        printf("\n>>> Try lock mutex failed, error no: %d, error messge: %s",
               lock_result,
               strerror(lock_result));
    }
}

    #ifndef __APPLE__
///
///
///
void CM_make_copies_v2(CopyingMachine *self,
                       const char *user_name,
                       const char *copy_filename,
                       u8 copy_numbers) {
    char log_message[LOG_MESSAGE_SIZE] = {0};

    //
    // Try to acquire lock with a given timeout settings
    //
    struct timespec timeout = {0};
    clock_gettime(CLOCK_REALTIME, &timeout);
    timeout.tv_nsec += 500 * 1'000'000;

    int lock_result = pthread_mutex_timedlock(&self->internal_mutex, &timeout);
    if (lock_result == 0) {
        //
        // Step 1: Clear operation log
        //
        memset(self->operation_log, 0, sizeof(self->operation_log));

        //
        // Step 2: Open cover
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s' is opening the cover",
                 user_name);
        memcpy(&self->operation_log[0][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 3: Place copy file
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s' is placing the copy file: %s",
                 user_name,
                 copy_filename);
        memcpy(&self->operation_log[1][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 4: Select copy numvers
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s' is selecting the copy numbers: %d",
                 user_name,
                 copy_numbers);
        memcpy(&self->operation_log[2][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 5: Make copies
        //
        snprintf(log_message,
                 sizeof(log_message),
                 "'%s''s task is processing: Making %d copies from '%s'",
                 user_name,
                 copy_numbers,
                 copy_filename);
        memcpy(&self->operation_log[3][0], log_message, strlen(log_message));
        usleep(100 * 1000);

        //
        // Step 6: Print operation logs
        //
        printf("\n>>> [ Copying Machine ] - Operation Logs: ");
        for (usize index = 0; index < LOG_SIZE; index++) {
            printf("\n>>> \t%s", &self->operation_log[index][0]);
        }
        printf("\n>>> \tDone.");

        pthread_mutex_unlock(&self->internal_mutex);
    } else {
        printf("\n>>> Try lock mutex failed, error no: %d, error messge: %s",
               lock_result,
               strerror(lock_result));
    }
}
    #endif

#endif

#endif
