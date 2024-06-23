#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
    uint64_t buf = 0;
    (void)argc;
    (void)argv;

    srandom(time(0));
    buf = random();

    buf = buf ^ (buf ^ (buf ^ (buf << 7)) << 15) << 31;
    printf("[rand]: 0x%016lx\n", buf);

    return 0;
}
