library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mult35x18 is
    Port ( clk : in std_logic;
           A : in signed(34 downto 0);
           B : in signed(17 downto 0);
           S : in signed(47 downto 0);
           P : out signed(52 downto 0) );
end mult35x18;


architecture Behavioral of mult35x18 is
    
    signal A1, B1, A2, A2d, B2d : signed(17 downto 0) := (others => '0');
    signal Sd1, Sd2, prtP1, prtP2, prtS1, prtS2 : signed(47 downto 0) := (others => '0');
    signal prtS1d : signed(16 downto 0) := (others => '0');
    

begin -- 2 pipelined cascade DSP48A1 (https://www.xilinx.com/publications/archives/books/dsp.pdf, pg. 49)
    
    process(clk)
    
    begin -- 5 clock cycles
        if rising_edge(clk) then
            
            -- clock 1
            A1 <= '0' & A(16 downto 0);
            A2 <= A(34 downto 17);
            B1 <= B;
            Sd1 <= S;
            
            -- clock 2
            prtP1 <= resize(A1 * B1, 48);
            A2d <= A2;
            B2d <= B1;
            Sd2 <= Sd1;
            
            -- clock 3
            prtS1 <= prtP1 + Sd2;
            prtP2 <= resize(A2d * B2d, 48);
            
            -- clock 4
            prtS1d <= prtS1(16 downto 0);
            prtS2 <= shift_right(prtS1, 17) + prtP2;
            
            -- clock 5
            P(16 downto 0) <= prtS1d;
            P(52 downto 17) <= resize(prtS2, 36);
        
        end if;
    end process;
    
end Behavioral;