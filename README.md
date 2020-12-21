# RhythmStim-SNEO
Low-latency SNEO-based spike detector for IntanTech RHS Stim/Recording System
Paper currently under peer-review. These instruction will be updated soon.

Download the .zip file if you just want to run the modified version.

Otherwise, if you wish to customize the design to fit for you needs, you must:

1. download the sources of this page

2. download the original source code for the RHS Stim/Recording Controller from the official Intan website (http://intantech.com/downloads.html?tabSelect=Source)
   C++ source code: http://intantech.com/files/RhythmStim_API_Release_180814.zip
   FPGA Verilog HDL source code: http://intantech.com/files/RHS2000InterfaceXEM6010_release_180814.zip

3. open the QT project from Intan website and import the new file contained in the qt_files folder, overwriting the existing files

4. open the Xilinx ISE project from Intan website and import the new file contained in the xise_files folder, overwriting the existing files

5. modify whatever you needs
5a. if you modified the C++ source code, recompile the qt project
5b. if you modified the Verilog or VHDL code, re-generate the bitfile and copy it in the building folder of the C++ code

Use the Compile_standalone.bat in the qt_files folder to be able to run the application outside the QT editor.


This project is provided as-is under the GNU General Public License v2.0 (read LICENSE for further information), without any express or implied warranty
