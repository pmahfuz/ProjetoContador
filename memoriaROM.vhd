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
      tmp(0) := "0000000000000";	-- Reset:
tmp(1) := "0100000000000";	-- LDI $0          	# Carrega o acumulador com o valor 0
tmp(2) := "0101100100000";	-- STA @288        	# Armazena o valor do acumulador em HEX0
tmp(3) := "0101100100001";	-- STA @289        	# Armazena o valor do acumulador em HEX1
tmp(4) := "0101100100010";	-- STA @290        	# Armazena o valor do acumulador em HEX2
tmp(5) := "0101100100011";	-- STA @291        	# Armazena o valor do acumulador em HEX3
tmp(6) := "0101100100100";	-- STA @292        	# Armazena o valor do acumulador em HEX4
tmp(7) := "0101100100101";	-- STA @293        	# Armazena o valor do acumulador em HEX5
tmp(8) := "0101100000000";	-- STA @256        	# Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(9) := "0101100000001";	-- STA @257        	# Armazena o valor do bit0 do acumulador no LDR8 
tmp(10) := "0101100000010";	-- STA @258        	# Armazena o valor do bit0 do acumulador no LDR9 
tmp(11) := "0101000000000";	-- STA @0				# Armazena o valor do acumulador em MEM[0] (unidades)
tmp(12) := "0101000000001";	-- STA @1				# Armazena o valor do acumulador em MEM[1] (dezenas)
tmp(13) := "0101000000010";	-- STA @2				# Armazena o valor do acumulador em MEM[2] (centenas)
tmp(14) := "0101000000011";	-- STA @3				# Armazena o valor do acumulador em MEM[3] (unidades de milhar)
tmp(15) := "0101000000100";	-- STA @4				# Armazena o valor do acumulador em MEM[4] (dezenas de milhar)
tmp(16) := "0101000000101";	-- STA @5				# Armazena o valor do acumulador em MEM[5] (centenas de milhar)
tmp(17) := "0101000000110";	-- STA @6				# Armazena o valor do acumulador em MEM[6] (limite unidade)
tmp(18) := "0101000000111";	-- STA @7				# Armazena o valor do acumulador em MEM[7] (limite dezena)
tmp(19) := "0101000001000";	-- STA @8				# Armazena o valor do acumulador em MEM[8] (limite centena)
tmp(20) := "0101000001001";	-- STA @9				# Armazena o valor do acumulador em MEM[9] (limite unidade de milhar)
tmp(21) := "0101000001010";	-- STA @10				# Armazena o valor do acumulador em MEM[10] (limite dezena de milhar)
tmp(22) := "0101000001011";	-- STA @11				# Armazena o valor do acumulador em MEM[11] (limite centena de milhar)
tmp(23) := "0101100000000";	-- STA @256        	# Limpa LEDR(0-7)
tmp(24) := "0101100000001";	-- STA @257        	# Limpa LEDR(8)
tmp(25) := "0101100000010";	-- STA @258        	# Limpa LEDR(9)
tmp(26) := "0100000000001";	-- LDI $1  	    	# Carrega 1 no acumulador
tmp(27) := "0101000001111";	-- STA @15         	# Salva acumulador no 15
tmp(28) := "0101111111111";	-- STA @511  	    	# Limpa KEY0
tmp(29) := "0101111111110";	-- STA @510        	# limpa KEY1
tmp(30) := "0101111111101";	-- STA @509        	# limpa Reset
tmp(31) := "0100000000000";	-- LDI $0          	# Carrega 0 no acumulador
tmp(32) := "0101000001101";	-- STA @13         	# salva 0 no MEM[13]
tmp(33) := "0100000001010";	-- LDI $10         	# Carrega 10
tmp(34) := "0101000001110";	-- STA @14         	# salva 10 no MEM[14]
tmp(35) := "0000000000000";	-- Limite:
tmp(36) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(37) := "0101100100000";	-- STA @288        	# Escreve no HEX0
tmp(38) := "0001101100001";	-- LDA @353        	# Le KEY1
tmp(39) := "1000000001101";	-- CEQ @13         	# Compara o valor de MEM[13] (zero) com o valor do KEY1
tmp(40) := "0111000100011";	-- JEQ @Limite     	# Pula para Limite
tmp(41) := "0101111111110";	-- STA @510        	# Limpa KEY1
tmp(42) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(43) := "0101000000110";	-- STA @6          	# Salva o valor do limite da unidade
tmp(44) := "0000000000000";	-- LimDez:
tmp(45) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(46) := "0101100100001";	-- STA @289        	# Escreve no HEX1
tmp(47) := "0001101100001";	-- LDA @353        	# Le KEY1
tmp(48) := "1000000001101";	-- CEQ @13         	# Compara o valor de MEM[13] (zero) com o valor do KEY1
tmp(49) := "0111000101100";	-- JEQ @LimDez     	# Pula para LimDez
tmp(50) := "0101111111110";	-- STA @510        	# Limpa KEY1
tmp(51) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(52) := "0101000000111";	-- STA @7          	# Salva o valor do limite da dezena
tmp(53) := "0000000000000";	-- LimCen:
tmp(54) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(55) := "0101100100010";	-- STA @290        	# Escreve no HEX2
tmp(56) := "0001101100001";	-- LDA @353        	# Le KEY1
tmp(57) := "1000000001101";	-- CEQ @13         	# Compara o valor de MEM[13] (zero) com o valor do KEY1
tmp(58) := "0111000110101";	-- JEQ @LimCen     	# Pula para LimCen
tmp(59) := "0101111111110";	-- STA @510        	# Limpa KEY1
tmp(60) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(61) := "0101000001000";	-- STA @8          	# Salva o valor do limite da centena
tmp(62) := "0000000000000";	-- LimUnidMil:
tmp(63) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(64) := "0101100100011";	-- STA @291        	# Escreve no HEX3
tmp(65) := "0001101100001";	-- LDA @353        	# Le KEY1
tmp(66) := "1000000001101";	-- CEQ @13         	# Compara o valor de MEM[13] (zero) com o valor do KEY1
tmp(67) := "0111000111110";	-- JEQ @LimUnidMil 	# Pula para LimUnidMil
tmp(68) := "0101111111110";	-- STA @510        	# Limpa KEY1
tmp(69) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(70) := "0101000001001";	-- STA @9          	# Salva o valor do limite da unidade de milhar
tmp(71) := "0000000000000";	-- LimDezMil:
tmp(72) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(73) := "0101100100100";	-- STA @292        	# Escreve no HEX4
tmp(74) := "0001101100001";	-- LDA @353        	# Le KEY1
tmp(75) := "1000000001101";	-- CEQ @13         	# Compara o valor de MEM[13] (zero) com o valor do KEY1
tmp(76) := "0111001000111";	-- JEQ @LimDezMil  	# Pula para LimDezMil
tmp(77) := "0101111111110";	-- STA @510        	# Limpa KEY1
tmp(78) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(79) := "0101000001010";	-- STA @10         	# Salva o valor do limite da dezena de milhar
tmp(80) := "0000000000000";	-- LimCenMil:
tmp(81) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(82) := "0101100100101";	-- STA @293        	# Escreve no HEX5
tmp(83) := "0001101100001";	-- LDA @353        	# Le KEY1
tmp(84) := "1000000001101";	-- CEQ @13         	# Compara o valor de MEM[13] (zero) com o valor do KEY1
tmp(85) := "0111001010000";	-- JEQ @LimCenMil  	# Pula para LimCenMil
tmp(86) := "0101111111110";	-- STA @510        	# Limpa KEY1
tmp(87) := "0001101000000";	-- LDA @320        	# Le SW(0 - 7)
tmp(88) := "0101000001011";	-- STA @11         	# Salva o valor do limite da centena de milhar
tmp(89) := "0000000000000";	-- Inicio:
tmp(90) := "0001101100000";	-- LDA @352        	# Armazena o valor lido no KEY0 (ler KEY0)
tmp(91) := "1000000001101";	-- CEQ @13  	    	# CEQ compara o valor de MEM[13] (zero) com o valor do KEY0
tmp(92) := "0111001011110";	-- JEQ @Pula1  		# JEQ para PULA 1 (temp 20)
tmp(93) := "1001001100010";	-- JSR @Incrementa 	# JSR para INCREMENTA (temp 32)
tmp(94) := "0000000000000";	-- Pula1:
tmp(95) := "1001010111101";	-- JSR @Display 		# JSR para DISPLAY 
tmp(96) := "1001010011111";	-- JSR @Compara    	# JSR para COMPARA 
tmp(97) := "0110001011001";	-- JMP @Inicio  		# JMP para INCIO
tmp(98) := "0000000000000";	-- Incrementa:
tmp(99) := "0101111111111";	-- STA @511  	    	# Limpa KEY0
tmp(100) := "0001000000000";	-- LDA @0  	    	# Carrega valor da unidade
tmp(101) := "0010000001111";	-- SOMA @15        	# soma 1
tmp(102) := "1000000001110";	-- CEQ @14         	# Compara o incremento com 10
tmp(103) := "0111001101010";	-- JEQ @Dezena     	# Pula para Dezena tmp(40)
tmp(104) := "0101000000000";	-- STA @0  	    	# Salva o valor da unidade
tmp(105) := "1010000000000";	-- RET  	        	# Retorno pela unidade
tmp(106) := "0000000000000";	-- Dezena:
tmp(107) := "0100000000000";	-- LDI $0  	    	# carrega 0
tmp(108) := "0101000000000";	-- STA @0          	# Limpa unidade
tmp(109) := "0001000000001";	-- LDA @1          	# carrega dezena
tmp(110) := "0010000001111";	-- SOMA @15        	# soma 1
tmp(111) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
tmp(112) := "0111001110011";	-- JEQ @Centena    	# Pula para Centena
tmp(113) := "0101000000001";	-- STA @1          	# salva na dezena
tmp(114) := "1010000000000";	-- RET  	        	# Retorno pela dezena
tmp(115) := "0000000000000";	-- Centena:
tmp(116) := "0100000000000";	-- LDI $0          	# carrega 0
tmp(117) := "0101000000001";	-- STA @1          	# limpa dezena 
tmp(118) := "0001000000010";	-- LDA @2          	# carrega centena 
tmp(119) := "0010000001111";	-- SOMA @15        	# soma 1
tmp(120) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
tmp(121) := "0111001111100";	-- JEQ @UnidadeMilhar     	# pula para unidade milhar
tmp(122) := "0101000000010";	-- STA @2          	# salva na centena
tmp(123) := "1010000000000";	-- RET             	# retorno pela centena
tmp(124) := "0000000000000";	-- UnidadeMilhar:
tmp(125) := "0100000000000";	-- LDI $0          	# carrega 0
tmp(126) := "0101000000010";	-- STA @2        	# limpa centena 
tmp(127) := "0001000000011";	-- LDA @3          	# carrega unidade milhar 
tmp(128) := "0010000001111";	-- SOMA @15        	# soma 1
tmp(129) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
tmp(130) := "0111010000101";	-- JEQ @DezenaMilhar    	# pula para dezena de milhar 
tmp(131) := "0101000000011";	-- STA @3          	# salva no unidade milhar
tmp(132) := "1010000000000";	-- RET             	# retorno pelo unidade milhar
tmp(133) := "0000000000000";	-- DezenaMilhar:
tmp(134) := "0100000000000";	-- LDI $0          	# carrega 0
tmp(135) := "0101000000011";	-- STA @3          	# limpa unidade milhar 
tmp(136) := "0001000000100";	-- LDA @4          	# carrega dezena de milhar 
tmp(137) := "0010000001111";	-- SOMA @15        	# soma 1
tmp(138) := "1000000001110";	-- CEQ @14        	# compara o incremento com 10
tmp(139) := "0111010001110";	-- JEQ @CentenaMilhar   	# pula para centena de milhar 
tmp(140) := "0101000000100";	-- STA @4          	# salva na dezena de milhar 
tmp(141) := "1010000000000";	-- RET             	# retorno pela dezena de milhar
tmp(142) := "0000000000000";	-- CentenaMilhar:
tmp(143) := "0100000000000";	-- LDI $0          	# carrega 0
tmp(144) := "0101000000100";	-- STA @4          	# limpa dezena de milhar 
tmp(145) := "0001000000101";	-- LDA @5          	# carrega centena de milhar 
tmp(146) := "0010000001111";	-- SOMA @15        	# soma 1
tmp(147) := "1000000001110";	-- CEQ @14         	# compara o incremento com 10
tmp(148) := "0111010010111";	-- JEQ @Estouro    	# pula para estouro da contagem
tmp(149) := "0101000000101";	-- STA @5          	# salva na centena de milhar 
tmp(150) := "1010000000000";	-- RET             	# retorno pela centena de milhar 
tmp(151) := "0000000000000";	-- Estouro:
tmp(152) := "0100011111111";	-- LDI $255        	# carrega 255 no acumulador
tmp(153) := "0101100000000";	-- STA @256        	# armazena 255 em LEDR0 até LEDR7
tmp(154) := "0000000000000";	-- FIM:
tmp(155) := "0001101100100";	-- LDA @356        	# carrega o valor do RESET
tmp(156) := "1000000001101";	-- CEQ @13         	# compara com o valor de MEM[13] (zero)
tmp(157) := "0111000000000";	-- JEQ @Reset      	# pula para o começo
tmp(158) := "0110010011010";	-- JMP @FIM        	# pula para o fim
tmp(159) := "0000000000000";	-- Compara:
tmp(160) := "0001000000000";	-- LDA @0          	# carrega unidade
tmp(161) := "1000000000110";	-- CEQ @6          	# compara com o limite da unidade
tmp(162) := "0111010100100";	-- JEQ @ComparaDez 	# pula para compara dezena
tmp(163) := "1010000000000";	-- RET             	# retorna
tmp(164) := "0000000000000";	-- ComparaDez:
tmp(165) := "0001000000001";	-- LDA @1          	# carrega dezena
tmp(166) := "1000000000111";	-- CEQ @7          	# compara com o limite da dezena
tmp(167) := "0111010101001";	-- JEQ @ComparaCen 	# pula para compara centena
tmp(168) := "1010000000000";	-- RET             	# retorna
tmp(169) := "0000000000000";	-- ComparaCen:
tmp(170) := "0001000000010";	-- LDA @2          	# carrega centena
tmp(171) := "1000000001000";	-- CEQ @8          	# compara com o limite da centena
tmp(172) := "0111010101110";	-- JEQ @ComparaUnidMilhar 	# pula para compara unidade de milhar
tmp(173) := "1010000000000";	-- RET             	# retorna
tmp(174) := "0000000000000";	-- ComparaUnidMilhar:
tmp(175) := "0001000000011";	-- LDA @3          	# carrega unidade de milhar
tmp(176) := "1000000001001";	-- CEQ @9          	# compara com o limite da unidade de milhar
tmp(177) := "0111010110011";	-- JEQ @ComparaDezMilhar 	# pula para compara dezena de milhar
tmp(178) := "1010000000000";	-- RET             	# retorna
tmp(179) := "0000000000000";	-- ComparaDezMilhar:
tmp(180) := "0001000000100";	-- LDA @4          	# carrega dezena de milhar
tmp(181) := "1000000001010";	-- CEQ @10         	# compara com o limite da dezena de milhar
tmp(182) := "0111010111000";	-- JEQ @ComparaCenMilhar 	# pula para compara centena de milhar
tmp(183) := "1010000000000";	-- RET             	# retorna
tmp(184) := "0000000000000";	-- ComparaCenMilhar:
tmp(185) := "0001000000101";	-- LDA @5          	# carrega centena de milhar
tmp(186) := "1000000001011";	-- CEQ @11         	# compara com o limite da centena de milhar
tmp(187) := "0111010010111";	-- JEQ @Estouro    	# pula para o estouro
tmp(188) := "1010000000000";	-- RET             	# retorna
tmp(189) := "0000000000000";	-- Display:
tmp(190) := "0001000000000";	-- LDA @0  	    	# Carrega valor da unidade
tmp(191) := "0101100100000";	-- STA @288  	    	# Escrevendo no display HEX0
tmp(192) := "0001000000001";	-- LDA @1  	    	# Carrega valor da dezena
tmp(193) := "0101100100001";	-- STA @289  	    	# Escrevendo no display HEX1
tmp(194) := "0001000000010";	-- LDA @2  	    	# Carrega valor da centena
tmp(195) := "0101100100010";	-- STA @290  	    	# Escrevendo no display HEX2
tmp(196) := "0001000000011";	-- LDA @3  	    	# Carrega valor da unidade milhar
tmp(197) := "0101100100011";	-- STA @291  	    	# Escrevendo no display HEX3
tmp(198) := "0001000000100";	-- LDA @4  	    	# Carrega valor da dezena milhar
tmp(199) := "0101100100100";	-- STA @292  	    	# Escrevendo no display HEX4
tmp(200) := "0001000000101";	-- LDA @5  	    	# Carrega valor da centena milhar
tmp(201) := "0101100100101";	-- STA @293  	    	# Escrevendo no display HEX5
tmp(202) := "1010000000000";	-- RET             	# Retorna subrotina










 
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;