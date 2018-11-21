project(citysim C CXX)
cmake_minimum_required(VERSION 3.0)

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)

set(CMAKE_AUTOMOC ON)

# Components PATH
execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
    OUTPUT_VARIABLE ARCH_TRIPLET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(QT_IMPORTS_DIR "lib/${ARCH_TRIPLET}")

# Set install paths
set(CMAKE_INSTALL_PREFIX /)
set(DATA_DIR /)

# This command figures out the target architecture for use in the manifest file
execute_process(
  COMMAND dpkg-architecture -qDEB_HOST_ARCH
  OUTPUT_VARIABLE CLICK_ARCH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

configure_file(manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})

install(FILES "city.desktop" DESTINATION ${DATA_DIR})
install(FILES "city.apparmor" DESTINATION ${DATA_DIR})

file(GLOB GAME_FILES *.qml *.png *.svg *.js)
install(FILES ${GAME_FILES} DESTINATION ${DATA_DIR})
install(DIRECTORY assets DESTINATION ${DATA_DIR})
install(DIRECTORY components DESTINATION ${DATA_DIR})
install(DIRECTORY scripts DESTINATION ${DATA_DIR})

add_subdirectory(plugins)
