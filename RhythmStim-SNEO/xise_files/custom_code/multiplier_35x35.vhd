library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mult35x35 is
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           A : in signed(34 downto 0);
           B : in signed(34 downto 0);
           P : out signed(69 downto 0);
           done : out std_logic );
end mult35x35;


architecture Behavioral of mult35x35 is

    signal clock_cycle : positive := 1;
    signal done_i : std_logic := '0';
    signal A_r, B_r : signed(34 downto 0);
    signal M, S : signed(47 downto 0);
    
begin -- single slice DSP48A1 mult 35x35 (https://www.xilinx.com/publications/archives/books/dsp.pdf, pg. 46)
    
    done <= done_i;
    
    process(clk)
    
    begin
        if rising_edge(clk) then
            if res = '1' then
                done_i <= '0';
                clock_cycle <= 1;
            end if;
            
            case clock_cycle is
                when 1 =>
                    if en = '1' then
                        A_r <= A;
                        B_r <= B;
                        clock_cycle <= 2;
                    end if;
                    done_i <= '0';
                when 2 =>
                    M <= resize(('0' & A_r(16 downto 0)) * ('0' & B_r(16 downto 0)), 48);
                    clock_cycle <= 3;
                when 3 =>
                    M <= resize(A_r(34 downto 17) * ('0' & B_r(16 downto 0)), 48);
                    S <= 0 + M;
                    clock_cycle <= 4;
                when 4 =>
                    M <= resize(('0' & A_r(16 downto 0)) * B_r(34 downto 17), 48);
                    S <= M + shift_right(S, 17);
                    P(16 downto 0) <= S(16 downto 0);
                    clock_cycle <= 5;
                when 5 =>
                    M <= resize(B_r(34 downto 17) * B_r(34 downto 17), 48);
                    S <= S + M;
                    clock_cycle <= 6;
                when 6 =>
                    S <= M + shift_right(S, 17);
                    P(33 downto 17) <= S(16 downto 0);
                    clock_cycle <= 7;
                when 7 =>
                    P(69 downto 34) <= S(35 downto 0);
                    done_i <= '1';
                    clock_cycle <= 1;
                when others =>
                    done_i <= '0';
                    clock_cycle <= 1;
            end case;
        end if;
    end process;
    
end Behavioral;