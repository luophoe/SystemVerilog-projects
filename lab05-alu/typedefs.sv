package typedefs;
   
   typedef enum logic [2:0]
   {HLT = 3'b000,
    SKZ = 3'b001,
    ADD = 3'b010,
    AND = 3'b011,
    XOR = 3'b100,
    LDA = 3'b101,
    STO = 3'b110,
    TMP = 3'b111} opcode_t;

    typedef enum 
    {INST_ADDR = 0,
     INST_FETCH = 1,
     INST_LOAD = 2,
     IDLE = 3,
     OP_ADDR = 4,
     OP_FETCH = 5,
     ALU_OP = 6,
     STORE = 7} state_t;

endpackage : typedefs
