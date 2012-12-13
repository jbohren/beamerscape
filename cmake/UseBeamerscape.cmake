
cmake_minimum_required(VERSION 2.8.3)

include(CMakeParseArguments)

# Find the location of myself while originally executing.  If you do this
# inside of a macro, it will recode where the macro was invoked.
set(BEAMERSCAPE_LOCATION  ${CMAKE_CURRENT_LIST_DIR}
  CACHE INTERNAL "Location of Beamerscape" FORCE)
set(USE_BEAMERSCAPE_LOCATION ${CMAKE_CURRENT_LIST_FILE}
  CACHE INTERNAL "Location of UseBeamerscape.cmake file." FORCE)

# Function to add a beamerscape overlay
function(add_beamerscape_overlay SVG_FILE)

  # Get the basename of the svg file
  get_filename_component(SVG_BASENAME "${SVG_FILE}" NAME_WE)
  get_filename_component(SVG_ABSPATH "${SVG_FILE}" ABSOLUTE)

  message("Adding beamerscape SVG: ${SVG_BASENAME}")

  # Add the command to generate the overlays
  add_custom_command(
    OUTPUT "${SVG_BASENAME}/overlay.tex"
    COMMAND "${BEAMERSCAPE_LOCATION}/export_overlays" ${SVG_ABSPATH} ${CMAKE_CURRENT_BINARY_DIR}
    WORKING_DIRECTORY "${CMAKE_CURRENT_BUILD_DIR}"
    COMMENT "Generating beamerscape pdf overlays from \"${SVG_BASENAME}\"")
  
  # Add the target for this overlay
  add_custom_target(${SVG_BASENAME} ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${SVG_BASENAME}/overlay.tex")
endfunction()
