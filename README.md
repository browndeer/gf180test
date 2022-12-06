
# Pyramiden Core - 16-bit RV16U Microcore processor

This is a CPU core based on the RISC-V ISA reduced in size to support 16-bit
data and memory operations with 21-bit instructions and 16 registers.
The full RISC-V base instruction set is supported with the exception of the
CSRs which were removed.  The design uses a Harvard memory architecture.
The design project evolved from a submission for the Tiny Tapeout project
where an 8-bit processor was implemented.  The external memory interface
for the chip employs a simple serdes to accomodate the limited I/O pins
available.  This reduces the effective processor clock by 8x in order to 
synchronize the instruction and data memory interfaces.  This was a compromise
that evolved as a solution to interface to the larger I/O interface of the
processor core.

## I/O Pins

  inputs:
    - clock
    - reset
    - enable
    - imem_rdy
    - dmem_bsy
    - dmem_rdy
    - serdes input bit 0
    - serdes input bit 1
    - serdes input bit 2
    - serdes input bit 3
    - serdes input bit 4
    - serdes input bit 5
    - serdes input bit 6
    - serdes input bit 7
    - serdes input bit 8
    - serdes input bit 9
    - serdes input bit 10
    - serdes input bit 11
    - serdes input bit 12

  outputs:
    - halt
    - dmem_we
    - dmem_en
    - serdes output bit 0
    - serdes output bit 1
    - serdes output bit 2
    - serdes output bit 3
    - serdes output bit 4
    - serdes output bit 5
    - serdes output bit 6
    - serdes output bit 7
    - serdes output bit 8
    - serdes output bit 9
    - serdes output bit 10
    - serdes output bit 11
    - serdes output bit 12
    - serdes output bit 13
    - serdes output bit 14
    - serdes output bit 15


# Tiny User Project

(Below are the original instructions used to submit the design.)

Template for submitting [TinyTapeout](https://tinytapeout.com) based projects to the [Open MPW shuttle](https://developers.google.com/silicon) program.

## Usage

1. [Generate](https://github.com/proppy/tiny_user_project/generate) a new project based on this template

1. [Set GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part) `Sources` as `GitHub Actions`.

1. Create a new [Wokwi](https://wokwi.com/projects/339800239192932947) project.

1. Update [`info.yaml`](info.yaml) with your `wokwi_id` and make sure the `documentation` for `inputs` and `outputs` matches the Wokwi design.

1. Commit, push and check the [![user_project_ci](https://github.com/proppy/tiny_caravel_user_project/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/proppy/tiny_caravel_user_project/actions/workflows/user_project_ci.yml) workflow summary (if successful a new commit including the hardened files will be automatically created).

1. [Submit](https://platform.efabless.com/projects/create?project_definition=Open+MPW&shuttle=GFMPW-0) your project github repository to the next [Open MPW shuttle](https://platform.efabless.com/shuttles/GFMPW-0).





--- 
# TinyTapeout project information
project:
  wokwi_id:    0        # If using wokwi, set this to your project's ID
  source_files:        # If using an HDL, set wokwi_id as 0 and uncomment and list your source files here. Source files must be in ./src
    - verilog/rtl/pyramiden_core.v
    - verilog/rtl/des.v
    - verilog/rtl/registers.v
  top_module:  "pyramiden_core"      # put the name of your top module here, make it unique by prepending your github username

# As everyone will have access to all designs, try to make it easy for someone new to your design to know what
# it does and how to operate it.
#
# Here is an example: https://github.com/mattvenn/tinytapeout_m_segments/blob/main/info.yaml
#
# This info will be automatically collected and used to make a datasheet for the chip.
documentation: 
  author:       "David Richie"      # Your name
  discord:      ""      # Your discord handle
  title:        "RV16U - 16-bit RISC-V Microcore Processor"      # Project title
  description:  "16-bit processor based on RISC-V ISA"      # Short description of what your project does
  how_it_works: "Executes reduced RISC-V based ISA"      # Longer description of how the project works
  how_to_test:  "Requires interfacing to external memory"      # Instructions on how someone could test your project, include things like what buttons do what and how to set the clock if needed
  external_hw:  ""      # Describe any external hardware needed
  language:     "verilog" # other examples include Verilog, Amaranth, VHDL, etc
  doc_link:     ""      # URL to longer form documentation, eg the README.md in your repository
  clock_hz:     1000       # Clock frequency in Hz (if required)
  picture:      ""      # relative path to a picture in your repository

