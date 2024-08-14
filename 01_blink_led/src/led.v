// Objective: The led flashes every 0.5S.
//
// Reference:
// https://wiki.sipeed.com/hardware/en/tang/tang-primer-20k/examples/led.html
//
//
//              +---------------------------------------+
//              |                                       |
//  Clock ------+-> [count up to 0.5s]--Y-->[IO Flips]--+-> IO_Voltage
//              |        |   ^                          |
//              |        N   |                          |
//              |        v   |                          |
//              |       [count]                         |
//              +---------------------------------------+
//
// This module contains two ports: Clock and IO_voltage

module led(
    input  Clock,
    output IO_voltage
);

// In the dock schematic p.5 is written: U7 26MHz 20 PPM 3.3V
// In the Tang_Primer_20K_SOM-3961_Schematic is U10 H11_IOT27A_OSC_CK 27MHz Oscillator

// For time counter inside module, crystal oscillator on the Primer 20K core board is 27MHZ,
// so we have 27 million times rising edges per second, and we just need to count 13500000 times
// rising edges to get 0.5 seconds. The counter starts from 0, and to count 13500000 times
// rising edges, we count to 13499999. When counted to 0.5S, we set a flag to inform
// LED IO to flip its voltage. The overall count code is as follows:


// --- Counter ---
//parameter Clock_frequency = 27_000_000; // Crystal oscillator frequency is 27Mhz
// 0 .. 13_500_00 -> count up to 13_499_999

parameter count_value       = 13_499_999; // The number of times needed to time 0.5S
reg [23:0]  count_value_reg ; // counter_value
reg         count_value_flag; // IO chaneg flag

always @(posedge Clock) begin
    if ( count_value_reg <= count_value ) begin //not count to 0.5S
        count_value_reg  <= count_value_reg + 1'b1; // Continue counting
        count_value_flag <= 1'b0 ; // No flip flag
    end
    else begin //Count to 0.5S
        count_value_reg  <= 23'b0; // Clear counter,prepare for next time counting.
        count_value_flag <= 1'b1 ; // Flip flag
    end
end


// --- IO Voltage flip ---
// The code to change IO voltage are as follows:

reg IO_voltage_reg = 1'b0; // Initial state

always @(posedge Clock) begin
    if ( count_value_flag )  //  Flip flag 
        IO_voltage_reg <= ~IO_voltage_reg; // IO voltage filp
    else //  No flip flag
        IO_voltage_reg <= IO_voltage_reg; // IO voltage constant
end

// --- Extra line ---
// Because the IO_voltage is declared in the port position, which is wire type by default.
// To connect it to the reg variable IO_voltage_reg, we need to use assign.
assign IO_voltage = IO_voltage_reg;

endmodule


