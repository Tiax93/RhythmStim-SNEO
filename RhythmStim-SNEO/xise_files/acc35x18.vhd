library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity acc35x18 is
    Generic ( start_from : signed(47 downto 0) );
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           A : in signed(34 downto 0);
           B : in signed(17 downto 0);
           acc : out signed(47 downto 0) );
end acc35x18;


architecture Behavioral of acc35x18 is
    
    signal A1, B1, A2, A2d, B2d : signed(17 downto 0) := (others => '0');
    signal prtP1, prtP2, prtS1, prtS2 : signed(47 downto 0) := (others => '0');
    signal S : signed(47 downto 0) := start_from;
    signal prtS1d : signed(16 downto 0) := (others => '0');
    

begin -- 2 pipelined cascade DSP48A1 (https://www.xilinx.com/publications/archives/books/dsp.pdf, pg. 49)
    
    process(clk)
    
    begin -- 6 clock cycles
        if rising_edge(clk) then
            if res = '1' then
                A1 <= (others => '0');
                A2 <= (others => '0');
                B1 <= (others => '0');
                prtP1 <= (others => '0');
                A2d <= (others => '0');
                B2d <= (others => '0');
                prtS1 <= (others => '0');
                prtP2 <= (others => '0');
                prtS1d <= (others => '0');
                prtS2 <= (others => '0');
                S <= start_from;
                
            elsif en = '1' then
                -- clock 1
                A1 <= '0' & A(16 downto 0);
                A2 <= A(34 downto 17);
                B1 <= B;
                
                -- clock 2
                prtP1 <= resize(A1 * B1, 48);
                A2d <= A2;
                B2d <= B1;
                
                -- clock 3
                prtS1 <= prtP1 + to_signed(0, 48);
                prtP2 <= resize(A2d * B2d, 48);
                
                -- clock 4
                prtS1d <= prtS1(16 downto 0);
                prtS2 <= prtP2 + shift_right(prtS1, 17);
                
                -- clock 5
                S <= S + (prtS2(30 downto 0) & prtS1d);
                
                -- clock 6
                acc <= S;
            end if;
            
        end if;
    end process;
    
end Behavioral;