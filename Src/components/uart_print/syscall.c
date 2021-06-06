// #include "main.h"

// #include "stm32h7xx_ll_usart.h"

// #include <stdio.h>
// #include <stdarg.h>
// #include <sys/types.h>
// #include <sys/stat.h>
// #include <stdarg.h>

// #undef errno
// extern int errno;
// extern int _end;

// caddr_t _sbrk(int incr)
// {
//     static unsigned char *heap = NULL;
//     unsigned char *prev_heap;

//     if (heap == NULL)
//     {
//         heap = (unsigned char *)&_end;
//     }
//     prev_heap = heap;

//     heap += incr;

//     return (caddr_t)prev_heap;
// }

// int link(char *old, char *new)
// {
//     return -1;
// }

// int _close(int file)
// {
//     return -1;
// }

// int _fstat(int file, struct stat *st)
// {
//     st->st_mode = S_IFCHR;
//     return 0;
// }

// int _isatty(int file)
// {
//     return 1;
// }

// int _lseek(int file, int ptr, int dir)
// {
//     return 0;
// }

// int _read(int file, char *ptr, int len)
// {
//     return 0;
// }

// void abort(void)
// {
//     /* Abort called */
//     while (1)
//         ;
// }

// int _write(int file, char *ptr, int len)
// {
//     uint16_t todo;
//     for (todo = 0; todo < len; todo++)
//     {

//         /* 堵塞判断串口是否发送完成 */
//         while (LL_USART_IsActiveFlag_TC(USART1) == 0)
//             ;

//         /* 串口发送完成，将该字符发送 */
//         LL_USART_TransmitData8(USART1, (uint8_t)*ptr++);
//     }
//     return len;
// }