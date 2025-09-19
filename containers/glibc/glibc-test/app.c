#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main() {
    time_t now;
    struct tm *local;
    char buffer[80];

    // get current time
    time(&now);
    local = localtime(&now);

    // format time
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", local);

    printf("GLIBC Test Program\n");
    printf("------------------\n");
    printf("Current Time : %s\n", buffer);
    printf("Process ID  : %d\n", getpid());

    // getenv demo
    const char *user = getenv("USER");
    if (user)
        printf("Environment USER: %s\n", user);
    else
        printf("Environment USER not set\n");

    // malloc + string demo
    char *msg = malloc(50);
    strcpy(msg, "This is a dynamically allocated string.");
    printf("Dynamic String : %s (length: %zu)\n", msg, strlen(msg));
    free(msg);

    // file I/O demo
    FILE *fp = fopen("output.txt", "w");
    if (fp) {
        fprintf(fp, "Log written at %s\n", buffer);
        fclose(fp);
        printf("Wrote log to output.txt\n");
    } else {
        perror("File open failed");
    }

    return 0;
}
