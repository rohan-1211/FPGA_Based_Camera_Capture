# FPGA-Based Camera Capture and Real-Time Display System with Image Processing

ECE 385 Final Project Spring 2025 by Guy Robbins and Rohan Shah

This project interfaces an OV7670 camera with the AMD Urbana Board's Spartan 7 FPGA to create a real-time video pipeline capable of live display and simple image processing effects through SystemVerilog. The system captures QVGA-resolution (320×240) video using a custom I2C driver to configure the camera and stores pixel data in dual-port BRAM. A custom pixel capture module synchronizes with the camera's output, decodes RGB444 data, and writes it into memory for display. The video output is upscaled and converted from VGA to HDMI using an IP core. Image processing filters included grayscale, color inversion, and a “light tunnel” effect, that were applied live during the readback stage, with user input to select each filter through the FPGA buttons.

The project was built from scratch and required about 30 hours of debugging and hardware-software integration. Major technical challenges included implementing a reliable I2C interface, correctly configuring the OV7670, and resolving a persistent screen flickering issue due to mismatched camera (30 Hz) and display (60 Hz) frame rates. Referencing the OV7670 datasheet and amsacks github constantly was critical in picking up on simple issues with the camera configuration. Despite the complexity, the final result was a smooth live display with working image filters. 

Important Resources: 

https://github.com/amsacks/OV7670-camera

https://web.mit.edu/6.111/www/f2016/tools/OV7670_2006.pdf

https://www.ti.com/lit/an/sbaa565/sbaa565.pdf?ts=1750564770484
