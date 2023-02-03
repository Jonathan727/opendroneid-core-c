#add_library(opendroneid SHARED opendroneid.c wifi.c)
add_library(opendroneid STATIC opendroneid.c wifi.c)

configure_file(libopendroneid.pc.cmake libopendroneid.pc @ONLY)

install(TARGETS opendroneid DESTINATION lib)
