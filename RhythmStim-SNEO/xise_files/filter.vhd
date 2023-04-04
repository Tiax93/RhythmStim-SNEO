library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity filter is
    Generic ( channels_number : positive );
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           channel_in : in natural range 0 to channels_number-1;
           sample_in : in signed(15 downto 0);
           busy : out std_logic;
           sample_out : out signed(15 downto 0);
           channel_out : out natural range 0 to channels_number-1;
           done : out std_logic );
end filter;


architecture Behavioral of filter is

    component mult35x18 is
        Port ( clk : in std_logic;
               A : in signed(34 downto 0);
               B : in signed(17 downto 0);
               S : in signed(47 downto 0);
               P : out signed(52 downto 0) );
    end component;
    
    component BRAM_signed is
    Generic ( width  : positive;
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
    
    -- 300Hz 3dr order highpass butterworth filter constants multiplied by 2^15
    type coeff_array is array(natural range <>) of signed(17 downto 0);
    constant filt_a : coeff_array(1 to 3) := (to_signed(-93364, 18),
                                                 to_signed(88789, 18),
                                                 to_signed(-28180, 18));
    constant filt_b : coeff_array(0 to 3) := (to_signed(30388, 18),
                                                 to_signed(-91163, 18),
                                                 to_signed(91163, 18),
                                                 to_signed(-30388, 18));
    
    signal clock_cycle : natural := 0;
    signal busy_i : std_logic := '0';
    signal done_i : std_logic := '0';
    signal channel_r : natural range 0 to channels_number-1;
    signal sample_r : signed(15 downto 0) := (others => '0');
    
    signal A : signed(34 downto 0) := (others => '0');
    signal B : signed(17 downto 0) := (others => '0');
    signal S : signed(47 downto 0) := (others => '0');
    signal P : signed(52 downto 0) := (others => '0');
    
    signal n : natural := 0;
    
    signal sum_in_wr : std_logic := '0';
    signal sum_in_wr_addr : natural;
    signal sum_in_rd_addr : natural;
    signal sum_in_di : signed(47 downto 0);
    signal sum_in_do : signed(47 downto 0);
    signal sum_out_wr : std_logic := '0';
    signal sum_out_wr_addr : natural;
    signal sum_out_rd_addr : natural;
    signal sum_out_di : signed(47 downto 0);
    signal sum_out_do : signed(47 downto 0);
    
    
begin
    
    cmpt_mult35x18 : mult35x18
    port map ( clk => clk,
               A => A,
               B => B,
               S => S,
               P => P );
    
    busy <= busy_i;
    done <= done_i;
    
    cmpt_BRAM_sum_in : BRAM_signed
    generic map ( width => 48,
                  deepth => 3*channels_number)
    port map ( CLK => clk,
               RES => res,
               WR => sum_in_wr,
               WR_ADDR => sum_in_wr_addr,
               RD_ADDR => sum_in_rd_addr,
               DI => sum_in_di,
               DO => sum_in_do);
    
    cmpt_BRAM_sum_out : BRAM_signed
    generic map ( width => 48,
                  deepth => 3*channels_number)
    port map ( CLK => clk,
               RES => res,
               WR => sum_out_wr,
               WR_ADDR => sum_out_wr_addr,
               RD_ADDR => sum_out_rd_addr,
               DI => sum_out_di,
               DO => sum_out_do);
    
    
    process(clk)
    
    begin -- makes use of 2 pipelined cascade DSP48A1 for each multiplication (https://www.xilinx.com/publications/archives/books/dsp.pdf, pg. 49)
        if rising_edge(clk) then
            --Reset process
            if res = '1' then
                clock_cycle <= 0;
                busy_i <= '0';
                done_i <= '0';
                sum_in_wr <= '0';
                sum_out_wr <= '0';
            else
                case clock_cycle is
                    when 0 =>
                        sum_in_wr <= '0';
                        sum_out_wr <= '0';
                        if en = '1' then
                            clock_cycle <= 1;
                            busy_i <= '1';
                            channel_r <= channel_in;
                            sample_r <= sample_in;
                        end if;
                    when 1 =>
                        -- BRAM provide the output the clock cycle after the next
                        sum_in_rd_addr <= channel_r;
                        sum_out_rd_addr <= channel_r;
                        clock_cycle <= 2;
                    when 2 =>
                        clock_cycle <= 3;
                        
                        sum_in_rd_addr <= channels_number+channel_r;
                    when 3 =>
                        A <= sample_r - resize(shift_right(sum_in_do, 15), 35);
                        B <= filt_b(0); --filt_data <= resize(shift_right(unfilt_d * filt_b(0) + sum_out(channel_d(2), channel(2), 1), 15), 16);
                        S <= sum_out_do;
                        clock_cycle <= 4;
                        
                        sum_out_rd_addr <= channels_number+channel_r;
                    when 4 =>
                        B <= filt_a(1); --sum_in(channel)(1) <= unfilt_d * filt_a(1) + sum_in(channel)(2);
                        S <= sum_in_do;
                        clock_cycle <= 5;
                        
                        sum_in_rd_addr <= 2*channels_number+channel_r;
                    when 5 =>
                        B <= filt_b(1); --sum_out(channel)(1) <= unfilt_d * filt_b(1) + sum_out(channel)(2);
                        S <= sum_out_do;
                        clock_cycle <= 6;
                        
                        sum_out_rd_addr <= 2*channels_number+channel_r;
                    when 6 =>
                        B <= filt_a(2); --sum_in(channel)(2) <= unfilt_d * filt_a(2) + sum_in(channel)(3);
                        S <= sum_in_do;
                        clock_cycle <= 7;
                    when 7 =>
                        B <= filt_b(2); --sum_out(channel)(2) <= unfilt_d * filt_b(2) + sum_out(channel)(3);
                        S <= sum_out_do;
                        clock_cycle <= 8;
                    when 8 =>
                        B <= filt_a(3); --sum_in(channel)(3) <= unfilt_d * filt_a(3) + 2**14; -- for rounding
                        S <= (14 => '1', others => '0');
                        clock_cycle <= 9;
                    when 9 =>
                        B <= filt_b(3); --sum_out(channel)(3) <= unfilt_d * filt_b(3) + 2**14; -- for rounding
                        S <= (14 => '1', others => '0');
                        
                        sample_out <= resize(shift_right(P, 15), 16);
                        channel_out <= channel_r;
                        done_i <= '1';
                        clock_cycle <= 10;
                    when 10 =>
                        sum_in_wr <= '1';
                        sum_out_wr <= '0';
                        sum_in_wr_addr <= channel_r;
                        sum_in_di <= resize(P, 48);
                        
                        done_i <= '0';
                        clock_cycle <= 11;
                    when 11 =>
                        sum_in_wr <= '0';
                        sum_out_wr <= '1';
                        sum_out_wr_addr <= channel_r;
                        sum_out_di <= resize(P, 48);
                        
                        clock_cycle <= 12;
                    when 12 =>
                        sum_in_wr <= '1';
                        sum_out_wr <= '0';
                        sum_in_wr_addr <= channels_number+channel_r;
                        sum_in_di <= resize(P, 48);
                        
                        clock_cycle <= 13;
                    when 13 =>
                        sum_in_wr <= '0';
                        sum_out_wr <= '1';
                        sum_out_wr_addr <= channels_number+channel_r;
                        sum_out_di <= resize(P, 48);
                        
                        clock_cycle <= 14;
                    when 14 =>
                        sum_in_wr <= '1';
                        sum_out_wr <= '0';
                        sum_in_wr_addr <= 2*channels_number+channel_r;
                        sum_in_di <= resize(P, 48);
                        
                        clock_cycle <= 15;
                    when 15 =>
                        sum_in_wr <= '0';
                        sum_out_wr <= '1';
                        sum_out_wr_addr <= 2*channels_number+channel_r;
                        sum_out_di <= resize(P, 48);
                        
                        busy_i <= '0';
                        clock_cycle <= 0;
                    when others =>
                        sum_in_wr <= '0';
                        sum_out_wr <= '0';
                        clock_cycle <= 0;
                        done_i <= '0';
                        busy_i <= '1';
                end case;
                
            end if;
        end if;
    end process;
    
end Behavioral;