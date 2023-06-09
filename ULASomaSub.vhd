library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic ( larguraDados : natural := 8 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(1 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
		saidaNor:  out STD_LOGIC
    );
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal passa : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal saida_inter : STD_LOGIC_VECTOR((larguraDados -1) downto 0);
    begin
      
		soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
		passa     <= entradaB;
      
		saida_inter <= soma when (seletor = "01") else 
					subtracao when (seletor = "00") else 
					passa;
					
		saidaNor <= not (saida_inter(7) or saida_inter(6) or saida_inter(5) or saida_inter(4) or saida_inter(3) or saida_inter(2) or saida_inter(1) or saida_inter(0));
		
		saida <= saida_inter;

end architecture;