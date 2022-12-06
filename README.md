
# Pyramiden Core - 16-bit RV16U Microcore Processor

This is a CPU core based on the RISC-V ISA reduced in size to support 16-bit
data and memory operations with 21-bit instructions and 16 registers.
The full RISC-V base instruction set is supported with the exception of the
CSRs which were removed.  The design uses a Harvard memory architecture.
The design project evolved from a submission for the Tiny Tapeout project
where an 8-bit processor was implemented.  The external memory interface
for the chip employs a simple serdes to accomodate the limited I/O pins
available.  This reduces the effective processor clock by 8x in order to 
synchronize the instruction and data memory interfaces.  This was a compromise
that evolved as a solution to interface the chip to the larger I/O interface
of the processor core.

## I/O Pins

Inputs:

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

Outputs:

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

