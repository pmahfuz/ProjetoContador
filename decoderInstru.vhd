library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port ( opcode : in std_logic_vector(3 downto 0);
         saida : out std_logic_vector(11 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";
  
  alias Hab_WR  :  std_logic is saida(0);
  alias Hab_RD  :  std_logic is saida(1);
  alias habFlag  :  std_logic is saida(2);
  alias Op  :  std_logic_vector(1  downto 0) is saida(4 downto 3);
  alias Hab_A  :  std_logic is saida(5);
  alias SelMux  :  std_logic is saida(6);
  alias Hab_JEQ  :  std_logic is saida(7);
  alias Hab_JSR  :  std_logic is saida(8);
  alias Hab_Ret  :  std_logic is saida(9);
  alias Hab_JMP  :  std_logic is saida(10);
  alias HabEscrita_Ret : std_logic is saida(11);
  

  begin
  
  Hab_WR <= '1' when (opcode = STA) else '0';
  Hab_RD <= '1' when (opcode = LDA or opcode = SOMA or opcode = SUB or opcode = CEQ) else '0';
  habFlag <= '1' when (opcode = CEQ) else '0';
  Op <= "01" when (opcode = SOMA) else "00" when (opcode = SUB or opcode = CEQ) else "10" when (opcode = LDA or opcode = LDI) else "00";
  Hab_A <= '1' when (opcode = LDA or opcode = SOMA or opcode = SUB or opcode = LDI) else '0';
  SelMux <= '1' when (opcode = LDI) else '0';
  Hab_JEQ <= '1' when (opcode = JEQ) else '0';
  Hab_JSR <= '1' when (opcode = JSR) else '0';
  Hab_Ret <= '1' when (opcode = RET) else '0';
  Hab_JMP <= '1' when (opcode = JMP) else '0';
  HabEscrita_Ret <= '1' when (opcode = JSR) else '0';
  
		
			
end architecture;