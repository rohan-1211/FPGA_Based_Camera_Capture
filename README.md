# FPGA-Based Camera Capture System

This project interfaces an Arduino OV7670 camera with the AMD Urbana Board’s Spartan-7 FPGA to create a real-time video pipeline capable of live display and simple image processing using SystemVerilog.

## Overview

The system captures QVGA-resolution (320×240) video using a custom I2C driver to configure the camera by writing to its internal registers and stores pixel data in dual-port BRAM. A pixel capture module synchronizes with the camera’s pixel clock and VSYNC/HSYNC signals, decodes RGB444 data, and writes it into memory. Video is then read back, processed with optional image effects, and displayed via HDMI using an IP-based VGA-to-HDMI converter.

Image processing filters include:
- Grayscale
- Color inversion
- Light tunnel effect

These filters are applied in real time and selected through FPGA button inputs.

## Features

- OV7670 camera interface via custom I2C controller
- QVGA frame capture using dual-port BRAM
- Real-time image filters applied during memory readback
- HDMI video output using IP cores
- Modular RTL design written in SystemVerilog
- User-controlled filter selection via hardware buttons

## Testing and Simulation

Testbenches and waveform configuration files are provided for:
- I2C controller verification (register write sequence)
- Pixel capture timing and synchronization

## Tools and Technologies

- Vivado 2023.1  
- SystemVerilog / Verilog  
- OV7670 Camera Module  
- Spartan-7 FPGA (AMD Urbana Board)  
- HDMI TX, Clock Wizard, and BRAM IP Cores  

## Additional Resources

- [Final Report](./ECE_385_Final_Project_Report.pdf)
- [OV7670 Camera Datasheet](https://web.mit.edu/6.111/www/f2016/tools/OV7670_2006.pdf)
- [amsacks GitHub](https://github.com/amsacks/OV7670-camera)
- [Spartan-7 FPGA Overview](https://www.amd.com/en/products/adaptive-socs-and-fpgas/fpga/spartan-7.html)
