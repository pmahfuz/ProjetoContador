library ieee;
use ieee.std_logic_1164.all;

entity CPU is

  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 3;
        simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
  
	 ROMdado : in std_logic_vector(12 downto 0);
	 RAMDL : in std_logic_vector(7 downto 0);
	 ROMend : out std_logic_vector(8 downto 0);
	 RAMWr : out std_logic;
	 RAMRd : out std_logic;
	 RAMDE : out std_logic_vector(7 downto 0);
	 DataAddress : out std_logic_vector(8 downto 0);
	 Clock : in std_logic
	 
  );
end entity;


architecture arquitetura of CPU is

-- Faltam alguns sinais:
  signal chavesX_ULA_B : std_logic_vector (larguraDados-1 downto 0);
  signal chavesY_MUX_A : std_logic_vector (larguraDados-1 downto 0);
  signal MUX_REG1 : std_logic_vector (larguraDados-1 downto 0);
  signal REG1_ULA_A : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  signal Sinais_Controle : std_logic_vector (11 downto 0);
  signal Endereco : std_logic_vector (8 downto 0);
  signal proxPC : std_logic_vector (8 downto 0);
  signal Mux2_sai : std_logic_vector(8 downto 0);
  signal Chave_Operacao_ULA : std_logic;
  signal CLK : std_logic;
  signal SelMUX : std_logic;
  signal Habilita_A : std_logic;
  signal Reset_A : std_logic;
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal opcode_entrada : std_logic_vector(12 downto 0);
  signal habLeituraMEM : std_logic;
  signal habEscritaMEM : std_logic;
  signal jmp : std_logic;
  signal jeq : std_logic;
  signal FlagZ : std_logic;
  signal saidaLD : std_logic_vector(1 downto 0);
  signal saidaNor : std_logic;
  signal HabFlagZ : std_logic;
  signal saidaRetorno : std_logic_vector(8 downto 0);
  signal HabEscritaRetorno : std_logic;
  signal Retorno : std_logic;
  signal jsr : std_logic;

begin

-- Instanciando os componentes:
CLK <= Clock;
--else generate
--detectorSub0: work.edgeDetector(bordaSubida)
--        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
--end generate;

-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => chavesY_MUX_A,
                 entradaB_MUX =>  opcode_entrada(7 downto 0),
                 seletor_MUX => SelMUX,
                 saida_MUX => MUX_REG1);

MUX2 :  entity work.muxGenerico4x1  generic map (larguraDados => 9)
        port map( entrada0_MUX => proxPC,
                 entrada1_MUX =>  opcode_entrada(8 downto 0),
					  entrada2_MUX => saidaRetorno,
					  entrada3_MUX => "000000000",
                 seletor_MUX => saidaLD,
                 saida_MUX => Mux2_sai);
					  
-- O port map completo do Acumulador.
REGA : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => REG1_ULA_A, ENABLE => Habilita_A, CLK => CLK, RST => '0');
			 
ENDERECORET : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => proxPC, DOUT => saidaRetorno, ENABLE => HabEscritaRetorno, CLK => CLK, RST => '0');

-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => Mux2_sai, DOUT => Endereco, ENABLE => '1', CLK => CLK, RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => 9, constante => 1)
        port map( entrada => Endereco, saida => proxPC);


-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA => REG1_ULA_A, entradaB => MUX_REG1, saida => Saida_ULA, seletor => Operacao_ULA, saidaNor => saidaNor);
			 
DECODER : entity work.decoderInstru
          port map (opcode => opcode_entrada(12 downto 9), saida => Sinais_Controle);
			 
LD : entity work.LogicaDesvio 
			 port map (JEQ => jeq, JMP => jmp, Flagz => FlagZ, JSR => jsr, RET => Retorno, saida => saidaLD);
			 
FLAGZ1 : entity work.flipflop
          port map (DIN => saidaNor, DOUT => FlagZ, ENABLE => HabFlagZ, CLK => CLK, RST => '0');


HabEscritaRetorno <= Sinais_Controle(11);
jmp <= Sinais_Controle(10);
Retorno <= Sinais_Controle(9);
jsr <= Sinais_Controle(8);
jeq <= Sinais_Controle(7);
selMUX <= Sinais_Controle(6);
Habilita_A <= Sinais_Controle(5);
Operacao_ULA <= Sinais_Controle(4 downto 3);
HabFlagZ <= Sinais_Controle(2);
habLeituraMEM <= Sinais_Controle(1);
habEscritaMEM<= Sinais_Controle(0);

-- I/O
--chavesY_MUX_A <= SW(3 downto 0);
--chavesX_ULA_B <= SW(9 downto 6);

---- A ligacao dos LEDs:
--LEDR (9) <= SelMUX;
--LEDR (8) <= Habilita_A;
--LEDR (7) <= Reset_A;
--LEDR (6) <= Operacao_ULA;
--LEDR (5) <= '0';    -- Apagado.
--LEDR (4) <= '0';    -- Apagado.
--LEDR (3 downto 0) <= REG1_ULA_A;

opcode_entrada	<= ROMdado;
chavesY_MUX_A <= RAMDL; 
end architecture;