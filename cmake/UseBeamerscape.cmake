
cmake_minimum_required(VERSION 2.8.3)

include(CMakeParseArguments)

# Find the location of myself while originally executing.  If you do this
# inside of a macro, it will recode where the macro was invoked.
set(BEAMERSCAPE_LOCATION  ${CMAKE_CURRENT_LIST_DIR}
  CACHE INTERNAL "Location of Beamerscape" FORCE)
set(USE_BEAMERSCAPE_LOCATION ${CMAKE_CURRENT_LIST_FILE}
  CACHE INTERNAL "Location of UseBeamerscape.cmake file." FORCE)

set(EXPORT_OVERLAYS_LOCATION  ${BEAMERSCAPE_LOCATION}/../bin/export_overlays
  CACHE INTERNAL "Location of Beamerscape" FORCE)

# Function to add a beamerscape overlay
function(add_beamerscape_overlay SVG_FILE)

  # Get the basename of the svg file
  get_filename_component(SVG_BASENAME "${SVG_FILE}" NAME_WE)
  get_filename_component(SVG_PATH "${SVG_FILE}" PATH)
  get_filename_component(SVG_ABSPATH "${SVG_FILE}" ABSOLUTE)

  # Optionally change the output path
  cmake_parse_arguments(ARGS "" "IMAGE_DIR" "" ${ARGN})
  if(${ARGS_IMAGE_DIR})
    set(IMAGE_DIR "${ARGS_IMAGE_DIR}")
  else()
    set(IMAGE_DIR "${SVG_PATH}")
  endif()

  set(OVERLAY_OUTPUT_DIR "${PROJECT_BINARY_DIR}/${IMAGE_DIR}")
  set(OVERLAY_OUTPUT_FILE "${PROJECT_BINARY_DIR}/${IMAGE_DIR}/${SVG_BASENAME}/overlay.tex")

  message("Adding beamerscape SVG: ${SVG_BASENAME} -> ${OVERLAY_OUTPUT_DIR}")

  # Add the command to generate the overlays
  add_custom_command(
    OUTPUT ${OVERLAY_OUTPUT_FILE}
    DEPENDS ${SVG_ABSPATH}
    COMMAND ${EXPORT_OVERLAYS_LOCATION} ${SVG_ABSPATH} ${OVERLAY_OUTPUT_DIR}
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "Generating beamerscape pdf overlays from \"${SVG_BASENAME}\"")
  
  # Add the target for this overlay
  add_custom_target(${SVG_BASENAME} ALL DEPENDS ${OVERLAY_OUTPUT_FILE})

  # Add the target to the list of beamerscape overlays
  set(BEAMERSCAPE_OVERLAY_TARGETS "${OVERLAY_OUTPUT_FILE};${BEAMERSCAPE_OVERLAY_TARGETS}" PARENT_SCOPE)
endfunction()
