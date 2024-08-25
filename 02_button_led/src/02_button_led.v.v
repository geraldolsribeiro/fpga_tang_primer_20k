module top(
  input wire buttonS0,
  input wire buttonS1,
  input wire buttonS2,
  input wire buttonS3,
  input wire buttonS4,
  output wire [4:0] leds
);

  assign leds[0] = buttonS0;
  assign leds[1] = buttonS1;
  assign leds[2] = buttonS2;
  assign leds[3] = buttonS3;
  assign leds[4] = buttonS4;

endmodule