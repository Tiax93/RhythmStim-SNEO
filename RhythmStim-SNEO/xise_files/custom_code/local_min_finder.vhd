library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity min_finder is
    Generic ( channels_number : positive );
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           channel_in : in natural range 0 to channels_number-1;
           sample_in : in signed(15 downto 0);
           min : out signed(15 downto 0);
           pos : out signed(15 downto 0);
           busy : out std_logic;
           done : out std_logic );
end min_finder;


architecture Behavioral of min_finder is
    
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
    signal prev_filt : signed(15 downto 0);
    signal current_min : signed(15 downto 0) := (others => '0');
    signal current_pos : signed(15 downto 0) := (others => '0');
    
    signal prev_filt_wr : std_logic := '0';
    signal prev_filt_wr_addr : natural;
    signal prev_filt_rd_addr : natural;
    signal prev_filt_di : signed(15 downto 0);
    signal prev_filt_do : signed(15 downto 0);
    
    constant prev_filt4min : natural := 4*4+1;
    constant prev_filt_deepth : natural := channels_number * prev_filt4min;
    signal queue_ind : natural range 0 to prev_filt_deepth-1 := 0;

begin
    
    cmpt_BRAM_prev_filt : BRAM_signed
    generic map ( width => 16,
                  deepth => prev_filt_deepth )
    port map ( CLK => clk,
               WR => prev_filt_wr,
               RES => res,
               WR_ADDR => prev_filt_wr_addr,
               RD_ADDR => prev_filt_rd_addr,
               DI => prev_filt_di,
               DO => prev_filt_do);
        
    min <= current_min;
    pos <= current_pos;
    
    process(clk)
        
        variable prev_filt_addr : natural;
        variable diff : integer;
    
    begin
        
        if rising_edge(clk) then            
            if res = '1' then
                clock_cycle <= 0;
                queue_ind <= 0;
                prev_filt_wr <= '0';
            else
    
                case clock_cycle is
                    when 0 =>
                        if en = '1' then
                            prev_filt_addr := queue_ind + channel_in;
                            prev_filt_rd_addr <= prev_filt_addr;
                            prev_filt_wr_addr <= prev_filt_addr;
                            prev_filt_di <= sample_in;
                            prev_filt_wr <= '1';
                            current_min <= (others => '0');
                            current_pos <= (others => '0');
                            clock_cycle <= 1;
                        end if;
                        
                    when 1 =>
                        prev_filt_wr <= '0';
                        if channel_in = channels_number-1 then
                            if queue_ind < prev_filt_deepth-1 - channels_number then
                                queue_ind <= queue_ind + channels_number;
                            else
                                queue_ind <= 0;
                            end if;
                        end if;
                        
                        diff := prev_filt_rd_addr - channels_number;
                        if diff >= 0 then
                            prev_filt_rd_addr <= diff;
                        else
                            prev_filt_rd_addr <= prev_filt_deepth + diff;
                        end if;
                        clock_cycle <= 2;
                        
                    when 2 to prev_filt4min =>
                        diff := prev_filt_rd_addr - channels_number;
                        
                        if diff >= 0 then
                            prev_filt_rd_addr <= diff;
                        else
                            prev_filt_rd_addr <= prev_filt_deepth + diff;
                        end if;
                        
                        if prev_filt_do < current_min then
                            current_min <= prev_filt_do;
                            current_pos <= to_signed(clock_cycle-1, 16);
                        end if;
                        
                        clock_cycle <= clock_cycle + 1;
                        
                    when prev_filt4min+1 =>
                        if prev_filt_do < current_min then
                            current_min <= prev_filt_do;
                            current_pos <= to_signed(clock_cycle-1, 16);
                        end if;
                        clock_cycle <= prev_filt_deepth + 1;
                        
                    when prev_filt4min+2 =>
                        if prev_filt_do < current_min then
                            current_min <= prev_filt_do;
                            current_pos <= to_signed(clock_cycle-1, 16);
                        end if;
                        clock_cycle <= 0;
                        
                    when others =>
                        clock_cycle <= 0;
                        prev_filt_wr <= '0';
                end case;
                
            end if;
        end if;
    end process;

end Behavioral;