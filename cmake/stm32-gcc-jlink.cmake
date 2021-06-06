# name of targets
set(ELF_TARGET ${PROJECT_NAME}.elf)
set(BIN_TARGET ${PROJECT_NAME}.bin)
set(HEX_TARGET ${PROJECT_NAME}.hex)
set(MAP_TARGET ${PROJECT_NAME}.map)
set(LSS_TARGET ${PROJECT_NAME}.lss)


set(JLINK_EXE "C:\\Program Files (x86)\\SEGGER\\JLink\\JLINK.exe")

# flash
configure_file(${CMAKE_SOURCE_DIR}/cmake/scripts/jlink-flash-stm32.jlink ${CMAKE_CURRENT_BINARY_DIR}/jlink-flash-stm32.jlink)
add_custom_target(jlink_flash 
	COMMAND ${JLINK_EXE} -Device ${JLINK_DEVICE} -Speed auto -if SWD -CommanderScript ${CMAKE_CURRENT_BINARY_DIR}/jlink-flash-stm32.jlink
	DEPENDS ${ELF_TARGET}
	)

# erase
add_custom_target(jlink_erase 
	COMMAND ${JLINK_EXE} -Device ${JLINK_DEVICE} -Speed auto -if SWD -CommanderScript ${CMAKE_SOURCE_DIR}/cmake/scripts/jlink-erase-stm32.jlink
	)

# reset
add_custom_target(jlink_reset 
    COMMAND ${JLINK_EXE} -Device ${JLINK_DEVICE} -Speed auto -If SWD -CommanderScript ${CMAKE_SOURCE_DIR}/cmake/scripts/jlink-reset-stm32.jlink
)
