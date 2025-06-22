`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 06:57:01 PM
// Design Name: 
// Module Name: camera_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module camera_top(
    
        
      input logic Clk, 
        
      input logic start,
      
      input logic reset_n,
      
      input logic [7:0] D,
      
      input logic pclk,
      
      input logic vsync_camera,
      
      input logic href,
      
      inout logic sda,
      
      input logic btn_invert,
      
      input logic btn_grey,
      
      input logic btn_alien_raw,
      
      output logic scl,
      
      output logic led_output,
      
      output logic xclk,
      
      output logic reset_out,
      
      output logic locked1, //temp
      
      output logic vde1, //temp
      
      
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p

);


logic locked;

assign locked1 = locked;

logic clk_24MHz;
logic clk_25MHz;
logic clk_125MHz;

logic RESET_N;

assign reset_out = ~RESET_N;

logic START;
logic done;
logic busy;


logic BTN_GREY;
logic BTN_INVERT;
logic BTN_ALIEN_sync, BTN_ALIEN;
logic [8:0] scaled_x, scaled_y;

assign xclk = clk_24MHz;


i2c i2c_inst (

    .clk(Clk),
    .rst_n(~RESET_N),
    .start(START),
    .sda(sda),
    .scl(scl),
    .done(done),
    .busy(busy)

);

assign led_output = done;

clk_wiz_0 clk_wiz (
        .clk_out1(clk_24MHz),
        .clk_out2(clk_25MHz),
        .clk_out3(clk_125MHz),
        .reset(RESET_N),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    
logic vsync_controller;

logic [11:0] RGB_data;
logic [16:0] wr_address;
logic [16:0] read_address;
logic wr_enable;
logic [11:0] pixel_write_out;
logic [11:0] pixel_read_out;  

logic [9:0] drawX, drawY;
logic hsync, vde;
   

pixel_capture p1 (
    .D(D),
    .pclk(pclk), //coemes from camera
    .vsync(vsync_camera), 
    .href(href), //comes from camera

    .RGB(RGB_data),
    .wr_addr(wr_address),
    .wr_en(wr_enable)
);

logic [16:0] read_addr;


logic [8:0]  scaled_x_r;
logic [7:0]  scaled_y_r;
always_ff @(posedge clk_25MHz) begin
    scaled_x_r <= drawX >> 1;  
    scaled_y_r <= drawY >> 1;  
end


logic [16:0] mulA, mulB, sumAB;
logic [16:0] read_addr_r;
always_ff @(posedge clk_25MHz) begin
    // 320 = 256 + 64
    mulA        <= {scaled_y,8'd0};  // y<<8 = y256
    mulB        <= {scaled_y,6'd0};  // y<<6 = y* 64
    sumAB       <= mulA + mulB;        // = y*320
    read_addr_r <= sumAB + scaled_x; // final address
end



    blk_mem_gen_1 bram (
//writing pixel data from camera and reading to HDMI
    .addra(wr_address), //write address (rom index)
    .clka(pclk),  //pclk (camera pixel clock)
    .dina(RGB_data),  
    .douta(pixel_write_out), 
    .ena(1'b1),  
    .wea(wr_enable), //wr_en
    
   
    .addrb(read_addr_r), 
    .clkb(clk_25MHz), //pixel_clk for HDMI stuff
    .dinb(12'b0), //
    .doutb(pixel_read_out), 
    .enb(1'b1),  
    .web(1'b0) 
    
    
    );
    
    
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(RESET_N),
        .hs(hsync),
        .vs(vsync_controller),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );   
    
    
    wire[11:0] pix_in = pixel_read_out; //intermediate pixel val
    
    //greyscale  logic
    
    wire[5:0] sum  = pix_in[11:8] + pix_in[7:4] + pix_in [3:0]; //next two lines avg the pixel
    wire[3:0] intensity = sum[5:2]; //make it 4 bits
    
    wire[11:0] pix_gray = {intensity, intensity, intensity};
    
    //invert logic
    
    wire [11:0] pix_inv = 12'hFFF - pix_in;
    
    //mux to choose which one we doing.
    
    logic [11:0] pix_out_effects;
    
    always_comb begin
    
    if(BTN_INVERT)  pix_out_effects = pix_inv;
    
    else if(BTN_GREY) pix_out_effects = pix_gray;
    
    else pix_out_effects = pix_in;
    
    end
    
    
logic signed [10:0] dx, dy;
always_comb begin
  dx = $signed(drawX) - 320;  // 640-pixel width ? center at 320
  dy = $signed(drawY) - 240;  // 480-pixel height? center at 240
end



parameter logic [2:0] SCALE = 2;

logic signed [10:0] x_warp, y_warp;
always_comb begin
  if (BTN_ALIEN) begin
    // simple uniform bulge: multiply offset by SCALE
    x_warp = 320 + (dx <<< SCALE);
    y_warp = 240 + (dy <<< SCALE);
  end else begin
    // no warp
    x_warp = drawX;
    y_warp = drawY;
  end
    
// Clamp 
  if (x_warp < 0)       x_warp = 0;
  else if (x_warp > 639) x_warp = 639;
  if (y_warp < 0)       y_warp = 0;
  else if (y_warp > 479) y_warp = 479;
end

// Down-sample

always_ff @(posedge clk_25MHz) begin
  scaled_x <= x_warp[9:1];  // divide by 2
  scaled_y <= y_warp[8:1];  // divide by 2
end
    
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(RESET_N), //active low
        //Color and Sync Signals
        .red(pix_out_effects[11:8]),
        .green(pix_out_effects[7:4]),
        .blue(pix_out_effects[3:0]),
        .hsync(hsync),
        .vsync(vsync_controller),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

//logic reset_db;

sync_debounce reset (
		.clk  (Clk),

		.d    (reset_n),
		.q    (RESET_N) //intermiediate signals
	);
	
	
sync_debounce start1 (
		.clk  (Clk),

		.d    (start),
		.q    (START) //intermiediate signals
	);

sync_debounce db_inv (
		.clk  (Clk),

		.d    (btn_invert),
		.q    (BTN_INVERT) //intermiediate signals
	);	
	
sync_debounce db_grey (
		.clk  (Clk),

		.d    (btn_grey),
		.q    (BTN_GREY) //intermiediate signals
	);	


sync_debounce db_alien (
  .clk(clk_25MHz),
  .d  (btn_alien_raw),  
  .q  (BTN_ALIEN)
);	
endmodule