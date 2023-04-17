library ieee;
use ieee.std_logic_1164.all;

entity Aula8 is

  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 3;
        simulacao : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic_vector(3 downto 0);
    SW: in std_logic_vector(9 downto 0);
    LEDR  : out std_logic_vector(9 downto 0);
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0)
  );
end entity;


architecture arquitetura of Aula8 is

-- Faltam alguns sinais:
  signal ROMout : std_logic_vector(12 downto 0);
  signal RAMWr : std_logic;
  signal RAMRd : std_logic;
  signal RAMDL : std_logic_vector(7 downto 0);
  signal RAMDE : std_logic_vector(7 downto 0);
  signal DataAddress : std_logic_vector(8 downto 0);
  signal Decout : std_logic_vector(7 downto 0);
  signal Decout2 : std_logic_vector(7 downto 0);
  signal CLK : std_logic;
  signal FF1_Hab : std_logic;
  signal FF1out : std_logic;
  signal FF2_Hab : std_logic;
  signal FF2out : std_logic;
  signal Reg8out : std_logic_vector(7 downto 0);
  signal Reg8_Hab : std_logic;
  signal ROM_end : std_logic_vector(8 downto 0);
  signal R0Hab, R1Hab, R2Hab, R3Hab, R4Hab, R5Hab: std_logic;
  signal R0out, R1out, R2out, R3out, R4out, R5out : std_logic_vector(3 downto 0);
  signal H0out, H1out, H2out, H3out, H4out, H5out : std_logic_vector(6 downto 0);
  
begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY(0);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
end generate;

ROM1 : entity work.memoriaROM   generic map (dataWidth => 13, addrWidth => 9)
          port map (Endereco => ROM_end, Dado => ROMout);
			 
DECODER3x8 : entity work.decoder3x8
          port map (entrada => DataAddress(8 downto 6), saida => Decout);
			 
DECODER3x82 : entity work.decoder3x8
          port map (entrada => DataAddress(2 downto 0), saida => Decout2);

RAM1 : entity work.memoriaRAM  generic map (dataWidth => 8, addrWidth => 8)
			 port map(addr => DataAddress(5 downto 0), we => RAMWr, re => RAMRd, 
						 habilita => Decout(0), 
						 clk => CLK,
						 dado_in => RAMDE,
						 dado_out => RAMDL);
			 
FF1 : entity work.flipflop  
			 port map (DIN => RAMDE(0), DOUT => FF1out, ENABLE => FF1_Hab, CLK => CLK, RST=> '0');
			 
FF2 : entity work.flipflop  
			 port map (DIN => RAMDE(0), DOUT => FF2out, ENABLE => FF2_Hab, CLK => CLK, RST=> '0');
			 
REG8 : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => RAMDE(7 downto 0), DOUT => Reg8out, ENABLE => Reg8_Hab, CLK => CLK, RST => '0');
			 
CPU : entity work.CPU
			 port map(ROMdado => ROMout, RAMDL => RAMDL, ROMend => ROM_end, RAMWr => RAMWr, 
						 RAMRd => RAMRd, RAMDE => RAMDE, DataAddress => DataAddress, Clock => CLK);
						 
REG0 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => RAMDE(3 downto 0), DOUT => R0out, ENABLE => R0Hab, CLK => CLK, RST => '0');

REG1 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => RAMDE(3 downto 0), DOUT => R1out, ENABLE => R1Hab, CLK => CLK, RST => '0');
			 
REG2 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => RAMDE(3 downto 0), DOUT => R2out, ENABLE => R2Hab, CLK => CLK, RST => '0');

REG3 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => RAMDE(3 downto 0), DOUT => R3out, ENABLE => R3Hab, CLK => CLK, RST => '0');
			 
REG4 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => RAMDE(3 downto 0), DOUT => R4out, ENABLE => R4Hab, CLK => CLK, RST => '0');
			 
REG5 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => RAMDE(3 downto 0), DOUT => R5out, ENABLE => R5Hab, CLK => CLK, RST => '0');
			 
CHEX0 :  entity work.conversorHex7Seg
        port map(dadoHex => R0out,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => H0out);
				
CHEX1 :  entity work.conversorHex7Seg
        port map(dadoHex => R1out,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => H1out);
					
CHEX2 :  entity work.conversorHex7Seg
        port map(dadoHex => R2out,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => H2out);
					 
CHEX3 :  entity work.conversorHex7Seg
        port map(dadoHex => R3out,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => H3out);
					  
CHEX4 :  entity work.conversorHex7Seg
        port map(dadoHex => R4out,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => H4out);
					  
CHEX5 :  entity work.conversorHex7Seg
        port map(dadoHex => R5out,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => H5out);
					  
	

-- I/O
--chavesY_MUX_A <= SW(3 downto 0);
--chavesX_ULA_B <= SW(9 downto 6);

-- Ligação do display

HEX0 <= H0out;
HEX1 <= H1out;
HEX2 <= H2out;
HEX3 <= H3out;
HEX4 <= H4out;
HEX5 <= H5out;

---- A ligacao dos LEDs:
LEDR (9) <= FF1out;
LEDR (8) <= FF2out;
LEDR (7 downto 0) <= Reg8out;

FF1_Hab <= (Decout(4) and RAMWr and Decout2(2) and not(DataAddress(5)));
FF2_Hab <= (Decout(4) and RAMWr and Decout2(1) and not(DataAddress(5)));
Reg8_Hab <= (Decout(4) and RAMWr and Decout2(0) and not(DataAddress(5)));
R0Hab <= (RAMWr and Decout(4) and DataAddress(5) and Decout2(0));
R1Hab <= (RAMWr and Decout(4) and DataAddress(5) and Decout2(1));
R2Hab <= (RAMWr and Decout(4) and DataAddress(5) and Decout2(2));
R3Hab <= (RAMWr and Decout(4) and DataAddress(5) and Decout2(3));
R4Hab <= (RAMWr and Decout(4) and DataAddress(5) and Decout2(4));
R5Hab <= (RAMWr and Decout(4) and DataAddress(5) and Decout2(5));


end architecture;