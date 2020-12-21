library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SNEO is
    Generic ( channels_number : positive;
              K : positive );
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           channel_in : in natural range 0 to channels_number-1;
           nxt_smpl : in signed(15 downto 0);
           cur_smpl : in signed(15 downto 0);
           prv_smpl : in signed(15 downto 0);
           busy : out std_logic;
           SNEO_val : out signed(34 downto 0);
           done : out std_logic );
end SNEO;


architecture Behavioral of SNEO is

    component acc35x18 is
        Generic ( start_from : signed(47 downto 0) );
        Port ( clk : in std_logic;
               en : in std_logic;
               res : in std_logic;
               A : in signed(34 downto 0);
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
    
    signal clock_cycle : natural := 0;
    signal busy_i : std_logic := '0';
    signal done_i : std_logic := '0';
    signal channel_r : natural range 0 to channels_number-1;
    
    type positive_array is array(natural range<>) of integer range -131072 to 131071; -- Bartlett is a triang + two 0s
    constant triang : positive_array(0 to 4*4) := (7282,14564,21845,29127,36409,43691,50972,58254,65536,58254,50972,43691,36409,29127,21845,14564,7282); --sprintf('%d,', round(triang(4*k+1)'*2^16))
    
    type signed16_array is array(positive range<>) of signed(15 downto 0);
    signal samples_r : signed16_array(1 to 3) := (others => (others => '0'));
    
    --type signed35_array is array(positive range<>, positive range<>) of signed(34 downto 0);
    --signal prev_NEO : signed35_array(1 to channels_number, 1 to triang'length) := (others => (others => (others => '0')));
    
    signal squared, mult : signed(31 downto 0);
    
    signal ar_pos : natural range 0 to triang'length := 1;
    
    signal res_acc : std_logic := '0';
    signal en_acc : std_logic := '0';
    signal A : signed(34 downto 0);
    signal B : signed(17 downto 0);
    signal acc : signed(47 downto 0);
    
    signal prev_NEO_wr : std_logic := '0';
    signal prev_NEO_wr_addr : natural;
    signal prev_NEO_rd_addr : natural;
    signal prev_NEO_di : signed(34 downto 0);
    signal prev_NEO_do : signed(34 downto 0);   
    
    
begin
    
    cmpt_acc35x18 : acc35x18
    generic map ( start_from => (15 => '1', others => '0') ) --for rounding
    port map ( clk => clk,
               en => en_acc,
               res => res_acc,
               A => A,
               B => B,
               acc => acc );
    
    cmpt_BRAM_prev_NEO : BRAM_signed
    generic map ( width => 35,
                  deepth => channels_number*triang'length+1)
    port map ( CLK => clk,
               RES => res,
               WR => prev_NEO_wr,
               WR_ADDR => prev_NEO_wr_addr,
               RD_ADDR => prev_NEO_rd_addr,
               DI => prev_NEO_di,
               DO => prev_NEO_do);
    
    busy <= busy_i;
    done <= done_i;
    
    process(clk)
    
        variable prev_NEO : signed(34 downto 0);
    
    begin
        if rising_edge(clk) then
            if res = '1' then
                res_acc <= '1';
                en_acc <= '0';
                clock_cycle <= 0;
                busy_i <= '0';
                done_i <= '0';
                ar_pos <= 1;
                prev_NEO_wr <= '0';
            else
                case clock_cycle is
                    when 0 =>
                        done_i <= '0';
                        res_acc <= '0';
                        if en = '1' then
                            clock_cycle <= 1;
                            busy_i <= '1';
                            channel_r <= channel_in;
                            samples_r(1) <= nxt_smpl;
                            samples_r(2) <= cur_smpl;
                            samples_r(3) <= prv_smpl;
                        end if;
                    when 1 =>
                        squared <= samples_r(2)*samples_r(2);
                        mult <= samples_r(1)*samples_r(3);
                        prev_NEO_rd_addr <= channel_r * triang'length;
                        ar_pos <= 0;
                        clock_cycle <= 2;
                    when 2 to triang'length+1 =>
                        prev_NEO_rd_addr <= prev_NEO_rd_addr + 1;
                        prev_NEO_wr_addr <= prev_NEO_rd_addr;
                        prev_NEO_wr <= '1';
                        if clock_cycle = 2 then
                            prev_NEO := resize(squared - mult, 35);
                            prev_NEO_di <= prev_NEO;
                            A <= prev_NEO;
                        else
                            prev_NEO_di <= prev_NEO_do;
                            A <= prev_NEO_do;
                        end if;
                        B <= to_signed(triang(ar_pos), 18);
                        ar_pos <= ar_pos + 1;
                        en_acc <= '1';
                        clock_cycle <= clock_cycle + 1;
                    when triang'length+2 to triang'length+7 =>
                        prev_NEO_wr <= '0';
                        clock_cycle <= clock_cycle + 1;
                        --and wait accumulator to compute
                    when triang'length+8 =>
                        SNEO_val <= resize(shift_right(acc, 16), 35);
                        busy_i <= '0';
                        done_i <= '1';
                        en_acc <= '0';
                        res_acc <= '1';
                        clock_cycle <= 0;
                    when others =>
                        clock_cycle <= 0;
                        prev_NEO_wr <= '0';
                        done_i <= '0';
                        en_acc <= '0';
                        res_acc <= '1';
                end case;
                
            end if;
        end if;
    end process;

end Behavioral;