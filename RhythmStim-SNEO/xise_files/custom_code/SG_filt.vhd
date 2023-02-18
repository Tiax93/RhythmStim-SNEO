library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SG_fit is
    Generic ( channels_number : positive );
    Port ( clk, en, res : in std_logic;
           channel_in : in natural range 0 to channels_number-1;
           sample_in : in signed(15 downto 0);
           busy : out std_logic;
           sample_out : out signed(15 downto 0);
           channel_out : out natural range 0 to channels_number-1;
           done : out std_logic );
end SG_fit;


architecture Behavioral of SG_fit is

    component acc18x18 is
    Generic ( start_from : signed(47 downto 0) );
        Port ( clk : in std_logic;
               en : in std_logic;
               res : in std_logic;
               A : in signed(17 downto 0);
               B : in signed(17 downto 0);
               acc : out signed(47 downto 0) );
    end component;
    
    component BRAM_signed is
    Generic ( width : positive;
              deepth : positive );
    Port ( CLK     : in std_logic;
           RES     : in std_logic;
           WR      : in std_logic;
           WR_ADDR : in natural;
           RD_ADDR : in natural;
           DI      : in signed(width-1 downto 0);
           DO      : out signed(width-1 downto 0)
    );
    end component;
    
    -- Savitzki Golay 7 coefficients for a 2nd grade polynomial fitting multiplied by 2^18
    type coeff_array is array(natural range<>) of integer range -2**17 to 2**17-1;
    constant coeff : coeff_array(0 to 6) := (-24966,37449,74898,87381,74898,37449,-24966);
    
    signal clock_cycle : natural := 0;
    signal busy_i : std_logic := '0';
    signal done_i : std_logic := '0';
    signal channel_r : natural range 0 to channels_number-1;
    signal sample_r : signed(15 downto 0);
    
    signal ar_pos : natural range 0 to coeff'length+1 := 0;
    
    signal en_acc : std_logic := '0';
    signal res_acc : std_logic := '0';
    signal A, B : signed(17 downto 0);
    signal acc : signed(47 downto 0);
    
    signal prev_samples_wr : std_logic := '0';
    signal prev_samples_wr_addr : natural;
    signal prev_samples_rd_addr : natural;
    signal prev_samples_di : signed(15 downto 0);
    signal prev_samples_do : signed(15 downto 0);   
    
begin
    
    cmpt_acc18x18 : acc18x18
    generic map ( start_from => (17 => '1', others => '0') ) --for rounding
    port map ( clk => clk,
               en => en_acc,
               res => res_acc,
               A => A,
               B => B,
               acc => acc );
    
    cmpt_BRAM_prev_samples : BRAM_signed
    generic map ( width => 16,
                  deepth => channels_number*coeff'length+1)
    port map ( CLK => clk,
               RES => res,
               WR => prev_samples_wr,
               WR_ADDR => prev_samples_wr_addr,
               RD_ADDR => prev_samples_rd_addr,
               DI => prev_samples_di,
               DO => prev_samples_do);
    
    busy <= busy_i;
    done <= done_i;
    
    process(clk)
    begin
        if rising_edge(clk) then
            --Reset process
            if res = '1' then
                res_acc <= '1';
                en_acc <= '0';
                clock_cycle <= 0;
                busy_i <= '0';
                done_i <= '0';
                ar_pos <= 0;
                prev_samples_wr <= '0';
            else
                case clock_cycle is
                    when 0 =>
                        done_i <= '0';
                        res_acc <= '0';
                        if en = '1' then
                            clock_cycle <= 1;
                            busy_i <= '1';
                            sample_r <= sample_in;
                            channel_r <= channel_in;
                        end if;
                    when 1 =>
                        prev_samples_rd_addr <= channel_r * coeff'length;
                        ar_pos <= 0;
                        clock_cycle <= 2;
                    when 2 to coeff'length+1 =>
                        prev_samples_rd_addr <= prev_samples_rd_addr + 1;
                        prev_samples_wr_addr <= prev_samples_rd_addr;
                        if clock_cycle = 2 then
                            prev_samples_di <= sample_r;
                            prev_samples_wr <= '1';
                            A <= resize(sample_r, 18);
                        else
                            prev_samples_di <= prev_samples_do;
                            A <= resize(prev_samples_do, 18);
                        end if;
                        B <= to_signed(coeff(ar_pos), 18);
                        ar_pos <= ar_pos + 1;
                        en_acc <= '1';
                        clock_cycle <= clock_cycle + 1;
                    when coeff'length+2 to coeff'length+5 =>
                        prev_samples_wr <= '0';
                        clock_cycle <= clock_cycle + 1;
                        --and wait accumulator to complete
                    when coeff'length+6 =>
                        en_acc <= '0';
                        res_acc <= '1';
                        sample_out <= resize(shift_right(acc, 18), 16);
                        busy_i <= '0';
                        done_i <= '1';
                        channel_out <= channel_r;
                        clock_cycle <= 0;
                        
                    when others =>
                        clock_cycle <= 0;
                        prev_samples_wr <= '0';
                        done_i <= '0';
                        busy_i <= '1';
                        en_acc <= '0';
                        res_acc <= '1';
                end case;
                
            end if;
        end if;
    end process;
    
end Behavioral;