//========================================================================
// openCologne * NLnet-sponsored open-source design ware for GateMate
//------------------------------------------------------------------------
//                   Copyright (C) 2024 Chili.CHIPS*ba
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// 1. Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//------------------------------------------------------------------------
// Adapted from ulx3s-misc: https://github.com/emard/ulx3s-misc/tree/master/examples/ps2/kbd/hdl/top
// Original Author: Paul Ruiz
//========================================================================
// AUTHOR=Paul Ruiz
// LICENSE=BSD

module top (
    input  wire       clk,
    input  wire       ps2_clk,
    input  wire       ps2_data,
    output wire [7:0] led
);

`ifndef SIMULATION
  wire clk0, usr_ref_out;
  wire usr_pll_lock_stdy, usr_pll_lock;

  CC_PLL #(
      .REF_CLK        ("10.0"),     // reference input in MHz
      .OUT_CLK        ("25.0"),     // pll output frequency in MHz
      .PERF_MD        ("ECONOMY"),  // LOWPOWER, ECONOMY, SPEED
      .LOW_JITTER     (1),          // 0: disable, 1: enable low jitter mode
      .CI_FILTER_CONST(2),          // optional CI filter constant
      .CP_FILTER_CONST(4)           // optional CP filter constant
  ) pll_inst (
      .CLK_REF(clk),
      .CLK_FEEDBACK(1'b0),
      .USR_CLK_REF(1'b0),
      .USR_LOCKED_STDY_RST(1'b0),
      .USR_PLL_LOCKED_STDY(usr_pll_lock_stdy),
      .USR_PLL_LOCKED(usr_pll_lock),
      .CLK0(clk0),
      .CLK_REF_OUT(usr_ref_out)
  );
`else
  // Use the input clock directly for simulation
  wire clk0 = clk;
`endif

  ps2kbd kbd (
      .clk     (clk0),
      .ps2_clk (ps2_clk),
      .ps2_data(ps2_data),
      .ps2_code(led),
      .strobe  (),
      .err     ()
  );

  //============================//
  //    For simulation only     //
  //============================//
  `ifdef SIMULATION
  initial begin
    $dumpfile("ps2_waves.vcd");
    $dumpvars;
  end
  `endif

endmodule
