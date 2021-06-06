#ifndef __mem_layout_h__
#define __mem_layout_h__

#ifdef __cplusplus
extern "C"
{
#endif

#define CACHE_LINE_SIZE 32

#define DMA_ALIGN __attribute__((aligned(CACHE_LINE_SIZE)))

#define D1_BUFFER __attribute__((section(".d1_buffer"))) __attribute__((aligned(CACHE_LINE_SIZE)))
#define D2_BUFFER __attribute__((section(".d2_buffer"))) __attribute__((aligned(CACHE_LINE_SIZE)))
#define D3_BUFFER __attribute__((section(".d3_buffer"))) __attribute__((aligned(CACHE_LINE_SIZE)))

#define D1_DATA __attribute__((section(".d1_data"))) __attribute__((aligned(CACHE_LINE_SIZE)))
#define D2_DATA __attribute__((section(".d2_data"))) __attribute__((aligned(CACHE_LINE_SIZE)))
#define D3_DATA __attribute__((section(".d3_data"))) __attribute__((aligned(CACHE_LINE_SIZE)))

#ifdef __cplusplus
}
#endif

#endif // __mem_layout_h__