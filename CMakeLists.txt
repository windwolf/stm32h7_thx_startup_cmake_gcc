# =================NOTE================================
# | 这个文件是所有cmake结构的组织者, 不要随意改动      |
# =================NOTE================================
# CMAKE版本检查
cmake_minimum_required(VERSION 3.17.0)
message(STATUS "CMake version: ${CMAKE_VERSION}")

# 防止启动检测
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# # 设置编译环境
set(CROSS_COMPILE_PREFIX arm-none-eabi)
include(${CMAKE_SOURCE_DIR}/cmake/gcc-arm-none-eabi.cmake)

include(${CMAKE_SOURCE_DIR}/cmake/utilities.cmake)

list(APPEND PROJECT_SOURCES_PATH)
list(APPEND PROJECT_INCLUDES_PATH)
list(APPEND PROJECT_LINKS_NAME)

# 导入目标文件定义
include(${CMAKE_CURRENT_SOURCE_DIR}/project-settings.cmake)

project(${PROJECT_NAME} C CXX ASM)
set(CMAKE_CXX_STANDARD 17)

# 获取链接文件
# file(GLOB_RECURSE __TEMP_LD__
#         ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/*.ld
#     )
# list(GET __TEMP_LD__ 0 LINKER_SCRIPT)
file(GLOB_RECURSE __TEMP_LD__
        ${CMAKE_CURRENT_SOURCE_DIR}/Src/startup/*.ld
        )
list(GET __TEMP_LD__ 0 LINKER_SCRIPT)


message(STATUS "Building project: ${PROJECT_NAME}")


# 设置BUILD_TYPE
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif ()
if (CMAKE_BUILD_TYPE MATCHES Debug)
    message(STATUS "Build type: Debug")
elseif (CMAKE_BUILD_TYPE MATCHES Release)
    message(STATUS "Build type: Release")
endif ()


## 设置编译选项
set(MCU_FLAGS "-mcpu=${CPU} -mthumb -mfpu=${FPU} -mfloat-abi=${FLOAT_ABI}")
set(LINK_FLAGS "${MCU_FLAGS} -Wl,--gc-sections")
set(EXTRA_LINK_FLAGS "-Wl,-Map=${PROJECT_NAME}.map,--cref,--no-warn-mismatch -specs=nano.specs -specs=nosys.specs")
include(${CMAKE_SOURCE_DIR}/cmake/stm32-gcc-flags.cmake)


# 打印配置信息
message(STATUS "Specified C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "Linker script: ${LINKER_SCRIPT}")
message(STATUS "Use LL library: ${USE_LL_LIB}")
message(STATUS "Use HAL library: ${USE_HAL_LIB}")
message(STATUS "Use Segger SystemView library: ${USE_SYSTEM_VIEW}")


## 版本信息
set(VERSION_MAJOR 0 CACHE STRING "Project major version number.")
set(VERSION_MINOR 1 CACHE STRING "Project minor version number.")
set(VERSION_PATCH 0 CACHE STRING "Project patch version number.")


if (USE_SYSTEM_VIEW)
    add_definitions("-DENABLE_SYSTEMVIEW")
endif ()


file(GLOB_RECURSE HAL_DRIVER_HAL_SRC
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Drivers/${MCU_SERIES}_HAL_Driver/Src/*_hal.c
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Drivers/${MCU_SERIES}_HAL_Driver/Src/*_hal_*.c)
list(FILTER HAL_DRIVER_HAL_SRC EXCLUDE REGEX "(_template.c)$")

file(GLOB_RECURSE HAL_DRIVER_LL_SRC
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Drivers/${MCU_SERIES}_HAL_Driver/Src/*_ll_*.c)
list(FILTER HAL_DRIVER_LL_SRC EXCLUDE REGEX "(_template.c)$")

file(GLOB HAL_CORE_SRC
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Core/Src/*.*
        # ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/*.s
        )


if (USE_HAL_LIB)
    set(HAL_DRIVER_LIB_SRC ${HAL_DRIVER_HAL_SRC} ${HAL_DRIVER_LL_SRC})
else ()
    set(HAL_DRIVER_LIB_SRC ${HAL_DRIVER_LL_SRC})
endif ()


file(GLOB_RECURSE PROJECT_APP_AND_STARTUP_SOURCES_PATH
        ${CMAKE_CURRENT_SOURCE_DIR}/Src/applications/*.*
        ${CMAKE_CURRENT_SOURCE_DIR}/Src/startup/*.s
        ${CMAKE_CURRENT_SOURCE_DIR}/Src/startup/*.c
        )

add_executable(${PROJECT_NAME}
        ${HAL_CORE_SRC}
        ${HAL_DRIVER_LIB_SRC}
        ${PROJECT_APP_AND_STARTUP_SOURCES_PATH}
        ${PROJECT_SOURCES_PATH}
        ${PROJECT_CUBEMX_SOURCES_PATH}
        )

target_compile_definitions(${PROJECT_NAME}
        PUBLIC
        -D${MCU_LINE}
        )

target_include_directories(${PROJECT_NAME}
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Core/Inc
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Drivers/${MCU_SERIES}_HAL_Driver/Inc
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Drivers/${MCU_SERIES}_HAL_Driver/Inc/Legacy
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Drivers/CMSIS/Device/ST/${MCU_SERIES}/Include
        ${CMAKE_CURRENT_SOURCE_DIR}/cubemx/Drivers/CMSIS/Include

        ${CMAKE_CURRENT_SOURCE_DIR}/Src/applications/inc
        ${PROJECT_INCLUDES_PATH}
        )

target_compile_definitions(${PROJECT_NAME}
        PUBLIC
        -DTX_INCLUDE_USER_DEFINE_FILE
        -DFX_INCLUDE_USER_DEFINE_FILE
        )

# libs
target_link_libraries(${PROJECT_NAME}
        PUBLIC
        ${PROJECT_LINKS_NAME}
        -lc -lm -lnosys
        )


# drivers
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/Src/drivers)
#target_link_libraries(${PROJECT_NAME}
#        PUBLIC
#        drivers
#        )


# ld
target_link_libraries(${PROJECT_NAME}
        PRIVATE
        -T${LINKER_SCRIPT} ${EXTRA_LINK_FLAGS}
        )

# cubemx
if (USE_LL_LIB)
    target_compile_definitions(${PROJECT_NAME}
            PUBLIC -DUSE_FULL_LL_DRIVER)
endif ()
if (USE_HAL_LIB)
    target_compile_definitions(${PROJECT_NAME}
            PUBLIC -DUSE_HAL_DRIVER)
endif ()

if (USE_FULL_ASSERT)
    target_compile_definitions(${PROJECT_NAME}
            PUBLIC -DUSE_FULL_ASSERT)
endif ()

# post build
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/stm32-gcc-postbuild.cmake)

message(STATUS "cmake config finish.")

# # debug
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/stm32-gcc-jlink.cmake)
