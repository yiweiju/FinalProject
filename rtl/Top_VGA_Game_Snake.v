module Top_VGA_Game_Snake(
    input         sys_clk_50,      
    input         sys_rst_n,       
    input  [ 3:0] key,                 
    
    output [15:0] vga_rgb,         
    output        vga_hs,          
    output        vga_vs,          
    
    output        vga_blank        
    
);


wire        locked_w;
wire        rst_n_w; 
wire        vga_clk_25_w;
wire [ 9:0] pixel_xpos_w;
wire [ 9:0] pixel_ypos_w;
wire [23:0] data_start_w;
wire [23:0] data_speed_w;
wire [23:0] data_play_w;
wire [23:0] data_end_w;
wire [ 3:0] state_m_w;     
wire        speed_m_w;     
wire [ 3:0] move_d_w;      
wire        game_over_w;   
wire [ 5:0] game_score_w;  



assign vga_clk_25 = vga_clk_25_w;
assign rst_n_w = locked_w & sys_rst_n; 
assign vga_sync = 1'b0;


pll_clk	u_pll_clk(
	.areset     (~sys_rst_n  ),  
	.inclk0     (sys_clk_50  ),
    
	.c0         (vga_clk_25_w),
	.locked     (locked_w    )   
);


VGA_Driver u_VGA_Driver(
    .vga_clk_25   (vga_clk_25_w),
    .rst_n        (rst_n_w     ),
    .state_m      (state_m_w   ),
    .data_start   (data_start_w),  
    .data_speed   (data_speed_w),  
    .data_play    (data_play_w ), 
    .data_end     (data_end_w  ),
                
    .vga_rgb      (vga_rgb     ),
    .vga_hs       (vga_hs      ),
    .vga_vs       (vga_vs      ),
    .vga_blank    (vga_blank   ),
    .pixel_xpos   (pixel_xpos_w),  
    .pixel_ypos   (pixel_ypos_w)
);

Key_Ctrl u_Key_Ctrl(   
    .clk          (sys_clk_50 ),           
    .rst_n        (rst_n_w    ),
    .key          (key        ),         
    .game_over    (game_over_w),   

    .state_m      (state_m_w  ),   
    .move_d       (move_d_w   ),   
    .speed_m      (speed_m_w  )    
);

Game_Start u_Game_Start( 
    .vga_clk_25  (vga_clk_25_w),      
    .rst_n       (rst_n_w     ),            
    .pixel_xpos  (pixel_xpos_w),     
    .pixel_ypos  (pixel_ypos_w),    
    
    .pixel_data  (data_start_w)       
);

Game_Speed u_Game_Speed( 
    .vga_clk_25  (vga_clk_25_w),      
    .rst_n       (rst_n_w     ),            
    .pixel_xpos  (pixel_xpos_w),     
    .pixel_ypos  (pixel_ypos_w),    
    
    .pixel_data  (data_speed_w)      
);

Game_Play u_Game_Play( 
    .vga_clk_25  (vga_clk_25_w),  
    .rst_n       (rst_n_w     ),  
    .pixel_xpos  (pixel_xpos_w),  
    .pixel_ypos  (pixel_ypos_w),
    .state_m     (state_m_w   ),  
    .speed_m     (speed_m_w   ),  
    .move_dirt   (move_d_w    ),  
    
    .game_over   (game_over_w ),  
    .game_score  (game_score_w),  
    .pixel_data  (data_play_w )   
);

Game_End u_Game_End( 
    .vga_clk_25  (vga_clk_25_w),  
    .rst_n       (rst_n_w     ),  
    .pixel_xpos  (pixel_xpos_w),  
    .pixel_ypos  (pixel_ypos_w), 
    .game_score  (game_score_w),  
    
    .pixel_data  (data_end_w )       
);

endmodule 