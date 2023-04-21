library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
		  
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
		  
  begin
      -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
      -- Inicializa os endereços:
      tmp(0) := "0100000000001";	-- LDI $1  	  
		tmp(1) := "0101000001111";	-- STA @15
		tmp(2) := "0101111111111";	-- STA @511  	    	# Limpa KEY0
		tmp(3) := "0100000000000";	-- LDI $0          	# Carrega 0 no acumulador
		tmp(4) := "0101000001101";	-- STA @13         	# salva 0 no MEM[13]
		tmp(5) := "0100000001010";	-- LDI $10         	# Carrega 10
		tmp(6) := "0101000001110";	-- STA @14         	# salva 10 no MEM[14]
		tmp(7) := "0000000000000";	-- Inicio:
		tmp(8) := "0001101100000";	-- LDA @352        	# Armazena o valor lido no KEY0 (ler KEY0)
		tmp(9) := "1000000001101";	-- CEQ @13  	    	# CEQ compara o valor de MEM[13] (zero) com o valor do KEY0
		tmp(10) := "0111000001100";	-- JEQ @Pula1  		# JEQ para PULA 1 (temp 20)
		tmp(11) := "1001000001111";	-- JSR @Incrementa 	# JSR para INCREMENTA (temp 32)
		tmp(12) := "0000000000000";	-- Pula1:
		tmp(13) := "1001001001001";	-- JSR @Display 		# JSR para DISPLAY (tmp 50)
		tmp(14) := "0110000000111";	-- JMP @Inicio  		# JMP para INCIO
		tmp(15) := "0000000000000";	-- Incrementa:
		tmp(16) := "0101111111111";	-- STA @511  	    	# Limpa KEY0
		tmp(17) := "0001000000000";	-- LDA @0  	    	# Carrega valor da unidade
		tmp(18) := "0010000001111";	-- SOMA @15        	# soma 1
		tmp(19) := "1000000001110";	-- CEQ @14         	# Compara o incremento com 10
		tmp(20) := "0111000010111";	-- JEQ @Dezena     	# Pula para Dezena tmp(40)
		tmp(21) := "0101000000000";	-- STA @0  	    	# Salva o valor da unidade
		tmp(22) := "1010000000000";	-- RET  	        	# Retorno pela unidade
		tmp(23) := "0000000000000";	-- Dezena:
		tmp(24) := "0100000000000";	-- LDI $0  	    	# carrega 0
		tmp(25) := "0101000000000";	-- STA @0          	# Limpa unidade
		tmp(26) := "0001000000001";	-- LDA @1          	# carrega dezena
		tmp(27) := "0010000001111";	-- SOMA @15        	# soma 1
		tmp(28) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
		tmp(29) := "0111000100000";	-- JEQ @Centena    	# Pula para Centena
		tmp(30) := "0101000000001";	-- STA @1          	# salva na dezena
		tmp(31) := "1010000000000";	-- RET  	        	# Retorno pela dezena
		tmp(32) := "0000000000000";	-- Centena:
		tmp(33) := "0100000000000";	-- LDI $0          	# carrega 0
		tmp(34) := "0101000000001";	-- STA @1          	# limpa dezena 
		tmp(35) := "0001000000010";	-- LDA @2          	# carrega centena 
		tmp(36) := "0010000001111";	-- SOMA @15        	# soma 1
		tmp(37) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
		tmp(38) := "0111000101001";	-- JEQ @Milhar     	# pula para milhar
		tmp(39) := "0101000000010";	-- STA @2          	# salva na centena
		tmp(40) := "1010000000000";	-- RET             	# retorno pela centena
		tmp(41) := "0000000000000";	-- Milhar:
		tmp(42) := "0100000000000";	-- LDI $0          	# carrega 0
		tmp(43) := "0101000000010";	-- STA @2          	# limpa centena 
		tmp(44) := "0001000000011";	-- LDA @3          	# carrega milhar 
		tmp(45) := "0010000001111";	-- SOMA @15        	# soma 1
		tmp(46) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
		tmp(47) := "0111000110010";	-- JEQ @DezenaMilhar    	# pula para dezena de milhar 
		tmp(48) := "0101000000011";	-- STA @3          	# salva no milhar
		tmp(49) := "1010000000000";	-- RET             	# retorno pelo milhar
		tmp(50) := "0000000000000";	-- DezenaMilhar:
		tmp(51) := "0100000000000";	-- LDI $0          	# carrega 0
		tmp(52) := "0101000000011";	-- STA @3          	# limpa milhar 
		tmp(53) := "0001000000100";	-- LDA @4          	# carrega dezena de milhar 
		tmp(54) := "0010000001111";	-- SOMA @15        	# soma 1
		tmp(55) := "1000000001110";	-- CEQ @14        	# compara o incremento com 10
		tmp(56) := "0111000111011";	-- JEQ @CentenaMilhar   	# pula para centena de milhar 
		tmp(57) := "0101000000100";	-- STA @4          	# salva na dezena de milhar 
		tmp(58) := "1010000000000";	-- RET             	# retorno pela dezena de milhar
		tmp(59) := "0000000000000";	-- CentenaMilhar:
		tmp(60) := "0100000000000";	-- LDI $0          	# carrega 0
		tmp(61) := "0101000000100";	-- STA @4          	# limpa dezena de milhar 
		tmp(62) := "0001000000101";	-- LDA @5          	# carrega centena de milhar 
		tmp(63) := "0010000001111";	-- SOMA @15        	# soma 1
		tmp(64) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
		tmp(65) := "0111001000100";	-- JEQ @Estouro    	# pula para estouro da contagem
		tmp(66) := "0101000000101";	-- STA @5          	# salva na centena de milhar 
		tmp(67) := "1010000000000";	-- RET             	# retorno pela centena de milhar 
		tmp(68) := "0000000000000";	-- Estouro:
		tmp(69) := "0100011111111";	-- LDI $255        	# carrega 255 no acumulador
		tmp(70) := "0101100000000";	-- STA @256        	# armazena 255 em LEDR0 até LEDR7
		tmp(71) := "0000000000000";	-- FIM:
		tmp(72) := "0110001000111";	-- JMP @FIM        	# pula para o fim
		tmp(73) := "0000000000000";	-- Display:
		tmp(74) := "0001000000000";	-- LDA @0  	    	# Carrega valor da unidade
		tmp(75) := "0101100100000";	-- STA @288  	    	# Escrevendo no display HEX0
		tmp(76) := "0001000000001";	-- LDA @1  	    	# Carrega valor da dezena
		tmp(77) := "0101100100001";	-- STA @289  	    	# Escrevendo no display HEX1
		tmp(78) := "1010000000000";	-- RET             	# Retorna subrotina

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;