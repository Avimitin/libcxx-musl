## Current issue

- libcxx is now trying to link agains futex. However the current musl source doesn't have bare metal build support. Needs to add `__linux__` or `_GNU_SOURCE` header identifier into musl source code to avoid building `syscall` and `futex`.
