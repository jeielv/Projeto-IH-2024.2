--------------------------------------------------------------------------------
-- Title		: Registrador de Deslocamento
-- Project		: CPU Multi-ciclo
--------------------------------------------------------------------------------
-- File			: RegDesloc.vhd
-- Author		: Emannuel Gomes Macêdo <egm@cin.ufpe.br>
--				  Fernando Raposo Camara da Silva <frcs@cin.ufpe.br>
--				  Pedro Machado Manhães de Castro <pmmc@cin.ufpe.br>
--				  Rodrigo Alves Costa <rac2@cin.ufpe.br>
-- Organization : Universidade Federal de Pernambuco
-- Created		: 10/07/2002
-- Last update	: 26/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade responsável pelo deslocamento de um vetor de 32 
--                bits para a direita e para a esquerda. 
--				  Entradas:
--				  	* N: vetor de 5 bits que indica a quantidade de 
--					deslocamentos   
--				  	* Shift: vetor de 3 bits que indica a função a ser 
--					realizada pelo registrador   
--				  Abaixo seguem os valores referentes a entrada shift e as 
--                respectivas funções do registrador: 
--				  
--				  Shift					FUNÇÃO DO REGISTRADOR
--				  000					faz nada
--				  001					carrega vetor (sem deslocamentos)
--				  010					deslocamento à esquerda n vezes
--				  011					deslocamento à direita lógico n vezes
--				  100					deslocamento à direita aritmético n vezes
--				  101					rotação à direita n vezes
--				  110					rotação à esquerda n vezes
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 2
-- Revision Number	: 1.2
-- Version			: 1.2
-- Date				: 26/11/2002
-- Modifier			: Marcus Vinicius Lima e Machado <mvlm@cin.ufpe.br>
--				  	  Paulo Roberto Santana Oliveira Filho <prsof@cin.ufpe.br>
--					  Viviane Cristina Oliveira Aureliano <vcoa@cin.ufpe.br>
-- Description		:
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Revisions		: 3
-- Revision Number	: 1.3
-- Version			: 1.3
-- Date				: 08/08/2008
-- Modifier			: João Paulo Fernandes Barbosa (jpfb@cin.ufpe.br)
-- Description		: Os sinais de entrada e saída passam a ser do tipo std_logic.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Revisions		: 4
-- Revision Number	: 1.4
-- Version			: 1.4
-- Date				: 31/01/2021
-- Modifier			: André Soares da Silva Filho <assf@cin.ufpe.br>
-- Description		: As operações passam a ser feitas utilizando lógica de inteiros 
--                    para que funcione sem levantar warnings ou erros no modelsim versão 20.1.1.
--					  -Utilizando a biblioteca NUMERIC_STD e retirando a STD_LOGIC_ARITH uma vez que conflitam entre si
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Revisions		: 5
-- Revision Number	: 1.5
-- Version			: 1.5
-- Date				: 13/05/2024
-- Modifier			: João Victor da Silva <jvs2@cin.ufpe.br>
-- Description		: A atribuição ao sinal n_shift não depende mais do clock nem da operação de load
--								mantendo assim o mesmo comportamento da versão 1.3.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_ARITH.ALL; 							-- Retirado na versão 1.4
-- USE IEEE.STD_LOGIC_UNSIGNED.ALL;							-- Retirado na versão 1.4
USE IEEE.NUMERIC_STD.ALL;

-- Short name: desl
ENTITY RegDesloc IS
		PORT(
			Clk		: IN	STD_LOGIC;	-- Clock do sistema
		 	Reset	: IN	STD_LOGIC;	-- Reset
			Shift 	: IN	STD_LOGIC_vector (2 downto 0);	-- Função a ser realizada pelo registrador 
			N		: IN	STD_LOGIC_vector (4 downto 0);	-- Quantidade de deslocamentos
			Entrada : IN	STD_LOGIC_vector (31 downto 0);	-- Vetor a ser deslocado
			Saida	: OUT	STD_LOGIC_vector (31 downto 0)	-- Vetor deslocado
		);
END RegDesloc;

-- Arquitetura que define o comportamento do registrador de deslocamento
-- Simulation
ARCHITECTURE behavioral_arch OF RegDesloc IS
	
	signal temp		: STD_LOGIC_VECTOR(31 downto 0);	-- Vetor temporário
	signal n_shift	: integer;							-- natural que possuirá o número de shifts a serem realizados. (v 1.4)
	
	begin
		n_shift <= TO_INTEGER(unsigned(N));

	-- Clocked process
	process (Clk, Reset)
		begin

			if(Reset = '1') then
				temp <= "00000000000000000000000000000000";

			elsif (Clk = '1' and Clk'event) then
				case Shift is
					when "000" => 						-- Faz nada
						temp <= temp;
					when "001" => 						-- Carrega vetor de entrada, não faz deslocamentos
						temp <= Entrada;
					when "010" =>						-- Deslocamento à esquerda N vezes
						temp <= STD_LOGIC_VECTOR(shift_left(signed(temp), n_shift));
					when "011" =>						-- Deslocamento à direita lógico N vezes
						temp <= STD_LOGIC_VECTOR(shift_right(unsigned(temp), n_shift));
					when "100" =>						-- Deslocamento à direita aritmético N vezes
						temp <= STD_LOGIC_VECTOR(shift_right(signed(temp), n_shift));
					when "101" =>						-- Rotação à direita N vezes
						temp <= STD_LOGIC_VECTOR(rotate_right(unsigned(temp), n_shift));
					when "110" =>						-- Rotação à esquerda N vezes
						temp <= STD_LOGIC_VECTOR(rotate_left(unsigned(temp), n_shift));
					-- Funcionalidade não definida
					when others =>
					-- Faz nada					
				end case;
			end if;
			Saida <= temp;	
	end process;
END behavioral_arch;