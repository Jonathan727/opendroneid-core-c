add_library(opendroneid opendroneid.c wifi.c)

configure_file(libopendroneid.pc.cmake libopendroneid.pc @ONLY)

install(TARGETS opendroneid DESTINATION lib)
