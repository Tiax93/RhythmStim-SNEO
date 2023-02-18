library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity acc18x18 is
    Generic ( start_from : signed(47 downto 0) );
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           A : in signed(17 downto 0);
           B : in signed(17 downto 0);
           acc : out signed(47 downto 0) );
end acc18x18;


architecture Behavioral of acc18x18 is
    
    signal A1, B1 : signed(17 downto 0) := (others => '0');
    signal P : signed(47 downto 0) := (others => '0');
    signal C : signed(47 downto 0) := start_from;
    

begin -- piplined 18x18 accumulator exploit DSP48A1
    process(clk)
    
    begin -- 4 clock cycles
        if rising_edge(clk) then
            if res = '1' then
                A1 <= (others => '0');
                B1 <= (others => '0');
                P <= (others => '0');
                C <= start_from;
                
            elsif en = '1' then
                -- clock 1
                A1 <= A;
                B1 <= B;
                
                -- clock 2
                P <= resize(A1 * B1, 48);
                
                -- clock 3
                C <= C + P;
                
                -- clock 4
                acc <= C;
            end if;
        
        end if;
    end process;
    
end Behavioral;