library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity sqrt is
    Port ( clk : in std_logic;
           res : in std_logic;
           en : in std_logic;
           value : in unsigned(69 downto 0);
           root : out unsigned(34 downto 0);
           busy : out std_logic;
           done : out std_logic );
end sqrt;

architecture Behavioral of sqrt is -- https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Binary_numeral_system_.28base_2.29
    
    signal clock_cycle : natural := 0;
    
    signal done_i : std_logic := '0';
    signal busy_i : std_logic := '0';
    
    signal value_r : unsigned(69 downto 0);
    signal rest : unsigned(69 downto 0);
    signal bit_n : unsigned(69 downto 0); -- The second-to-top bit is set: 1 << 30 for 32 bits
        
begin
    
    done <= done_i;
    busy <= busy_i;
    
    process(clk)
    
        variable sum : unsigned(69 downto 0);
    
    begin
        if rising_edge(clk) then
            if res = '1' then
                clock_cycle <= 0;
            else
                
                case clock_cycle is
                    when 0 =>
                        done_i <= '0';
                        rest <= (others => '0');
                        bit_n <= (68 => '1', others => '0');
                        if en = '1' then
                            busy_i <= '1';
                            value_r <= value;
                            clock_cycle <= 1;
                        end if;
                    when 1 => 
                        if bit_n > value_r then
                            bit_n <= shift_right(bit_n, 2);
                        else
                            clock_cycle <= 2;
                        end if;
                    when 2 =>
                        if bit_n /= 0 then
                            sum := rest + bit_n;
                            if value_r >= sum then
                                value_r <= value_r - sum;
                                rest <= shift_right(rest, 1) + bit_n;
                            else
                                rest <= shift_right(rest, 1);
                            end if;
                            bit_n <= shift_right(bit_n, 2); 
                        else
                            clock_cycle <= 3;
                        end if;
                    when 3 =>
                        done_i <= '1';
                        busy_i <= '0';
                        root <= resize(rest, 35);
                        clock_cycle <= 0;
                    when others =>
                        done_i <= '0';
                        busy_i <= '0';
                        clock_cycle <= 0;
                    end case;
                    
            end if;
        end if;
    end process;
    
end Behavioral;
