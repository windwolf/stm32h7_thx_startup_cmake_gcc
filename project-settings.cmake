# TODO: 项目名称
set(PROJECT_NAME "startup")

# TODO: 目标MCU
set(TARGET_MCU "STM32H750VBT6")

# 导入目标对应的变量或者选项. 这行不要动
include(${CMAKE_SOURCE_DIR}/cmake/target-port.cmake)



option(USE_LL_LIB "Enable LL library" ON)
option(USE_HAL_LIB "Enable HAL library" ON)

option(USE_SYSTEM_VIEW "Enable Segger SystemView library" OFF)


option(USE_FULL_ASSERT "Use full assert" OFF)


set(DRIVERS_OS "threadx")
set(DRIVERS_BSP "STM32H750")


# cubemx没有集成threadx的情况下, 额外引入
# string(REPLACE "-" "_" THREADX_ARCH ${CPU})
# message(STATUS "THREADX_ARCH=${THREADX_ARCH}")
# set(THREADX_TOOLCHAIN "gnu")
# message(STATUS "THREADX_TOOLCHAIN=${THREADX_TOOLCHAIN}")
# set(TX_USER_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Src/applications/inc/tx_user.h)
# add_project_library(threadx azrtos::threadx)

# cubemx集成threadx
file(GLOB_RECURSE CUBEMX_MW_SOURCES_PATH 
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Middlewares/ST/threadx/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Middlewares/ST/threadx/*.S
)
list(APPEND PROJECT_SOURCES_PATH ${CUBEMX_MW_SOURCES_PATH})

list(APPEND PROJECT_INCLUDES_PATH 
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Middlewares/ST/threadx/common/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Middlewares/ST/threadx/ports/cortex_m7/gnu/inc
)
# target_compile_definitions(${ELF_TARGET} 
#         PUBLIC -DTX_INCLUDE_USER_DEFINE_FILE)

# cubemx集成filex
file(GLOB_RECURSE CUBEMX_MW_SOURCES_PATH 
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Middlewares/ST/filex/*.c
)
list(APPEND PROJECT_SOURCES_PATH ${CUBEMX_MW_SOURCES_PATH})

list(APPEND PROJECT_INCLUDES_PATH 
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Middlewares/ST/filex/common/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Middlewares/ST/filex/ports/generic/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/FileX/App
)


# target_compile_definitions(${ELF_TARGET} 
#         PUBLIC -DFX_INCLUDE_USER_DEFINE_FILE)


# TODO: 内部组件
add_project_component(common)
# add_project_component(uart_print)
add_project_component(rtt_print)
