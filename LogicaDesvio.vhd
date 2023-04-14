library ieee;
use ieee.std_logic_1164.all;

entity LogicaDesvio is
  port ( JEQ : in std_logic;
			JMP : in std_logic;
			FlagZ : in std_logic;
			JSR : in std_logic;
			RET : in std_logic;
         saida : out std_logic_vector(1 downto 0)
  );
end entity;

architecture comportamento of LogicaDesvio is


  begin
  
  saida <= "01" when (JMP = '1') or (JEQ = '1' and FlagZ = '1') or JSR = '1'
			else "10" when RET = '1' else "00";
  
		
			
end architecture;