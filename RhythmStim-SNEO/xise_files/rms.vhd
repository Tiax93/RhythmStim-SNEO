library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity threshold is
    Generic ( channels_number : positive;
              rms_samples_exp : positive );
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           channel_in : in natural range 0 to channels_number-1;
           sample_in : in signed(34 downto 0);
           th_mult : in unsigned(7 downto 0);
           curr_ch_threshold : out signed(34 downto 0);
           new_threshold_val : out signed(31 downto 0);
           channel_out : out natural range 0 to channels_number-1;
           busy : out std_logic;
           done : out std_logic );
end threshold;


architecture Behavioral of threshold is
    
    component mult35x35 is
        Port ( clk : in std_logic;
               en : in std_logic;
               res : in std_logic;
               A : in signed(34 downto 0);
               B : in signed(34 downto 0);
               P : out signed(69 downto 0);
               done : out std_logic );
    end component;
    
    component sqrt is
        Port ( clk : in std_logic;
               en : in std_logic;
               res : in std_logic;
               value : in unsigned(69 downto 0);
               root : out unsigned(34 downto 0);
               busy : out std_logic;
               done : out std_logic );
    end component;
    
    component BRAM_signed is
    Generic ( width : positive;
              deepth : positive;
              init_val : signed );
    Port ( CLK     : in std_logic;
           RES     : in std_logic;
           WR      : in std_logic;
           WR_ADDR : in natural;
           RD_ADDR : in natural;
           DI      : in signed(width-1 downto 0);
           DO      : out signed(width-1 downto 0)
    );
    end component;
    
    constant max_threshold35 : signed(61 downto 0) := (33 downto 0 => '1', others => '0');
    constant max_threshold32 : signed(61 downto 0) := (30 downto 0 => '1', others => '0');
    
    signal rms_clock_cycle : natural := 0;
    signal th_clock_cycle : natural := 0;
    signal done_i : std_logic := '0';
    signal busy_i : std_logic := '0';
    signal channel_r : natural range 0 to channels_number-1;
    signal sample_r : signed(34 downto 0) := (others => '0');
    
    signal counter : natural range 0 to 2**rms_samples_exp := 0;
    signal new_threshold : boolean := false;
    signal do_sqrt : boolean := false;
    
    signal en_mult : std_logic := '0';
    signal done_mult : std_logic;
    signal A, B : signed(34 downto 0);
    signal P : signed(69 downto 0);
    
    signal en_sqrt : std_logic := '0';
    signal busy_sqrt : std_logic;
    signal done_sqrt : std_logic;
    signal sqrt_value : unsigned(69 downto 0);
    signal root : unsigned(34 downto 0);
    signal channel_sqrt : natural range 0 to channels_number-1;
    
    signal squared_sum_wr : std_logic := '0';
    signal squared_sum_wr_addr : natural;
    signal squared_sum_rd_addr : natural;
    signal squared_sum_di : signed(69+rms_samples_exp downto 0);
    signal squared_sum_do : signed(69+rms_samples_exp downto 0);
    
    signal prev_rms_wr : std_logic := '0';
    signal prev_rms_wr_addr : natural;
    signal prev_rms_rd_addr : natural;
    signal prev_rms_di : signed(34 downto 0);
    signal prev_rms_do : signed(34 downto 0);
    
    signal thresholds_wr : std_logic := '0';
    signal thresholds_wr_addr : natural;
    signal thresholds_rd_addr : natural;
    signal thresholds_di : signed(34 downto 0);
    signal thresholds_do : signed(34 downto 0);
    
    
begin
      
    cmpt_mult35x35 : mult35x35
    port map ( clk => clk,
               en => en_mult,
               res => res,
               A => A,
               B => B,
               P => P,
               done => done_mult );
   
   cmpt_sqrt : sqrt
    port map ( clk => clk,
               en => en_sqrt,
               res => res,
               value => sqrt_value,
               root => root,
               busy => busy_sqrt,
               done => done_sqrt );
    
    cmpt_BRAM_squared_sum : BRAM_signed
    generic map ( width => 70+rms_samples_exp,
                  deepth => channels_number,
                  init_val => "01" & (1 to rms_samples_exp-1 => '0') )
    port map ( CLK => clk,
               RES => res,
               WR => squared_sum_wr,
               WR_ADDR => squared_sum_wr_addr,
               RD_ADDR => squared_sum_rd_addr,
               DI => squared_sum_di,
               DO => squared_sum_do);
    
    cmpt_BRAM_prev_rms : BRAM_signed
    generic map ( width => 35,
                  deepth => channels_number,
                  init_val => (1 to 35 => '1') )
    port map ( CLK => clk,
               RES => res,
               WR => prev_rms_wr,
               WR_ADDR => prev_rms_wr_addr,
               RD_ADDR => prev_rms_rd_addr,
               DI => prev_rms_di,
               DO => prev_rms_do);
    
    cmpt_BRAM_thresholds : BRAM_signed
    generic map ( width => 35,
                  deepth => channels_number,
                  init_val => (1 => '0', 2 to 35 => '1') )
    port map ( CLK => clk,
               RES => res,
               WR => thresholds_wr,
               WR_ADDR => thresholds_wr_addr,
               RD_ADDR => thresholds_rd_addr,
               DI => thresholds_di,
               DO => thresholds_do);
    
    done <= done_i;
    busy <= busy_i;
    curr_ch_threshold <= thresholds_do;
    
    process(clk)
        
        variable total_sum : unsigned(69+rms_samples_exp downto 0);
        variable th_tot : signed(69 downto 0);
        
    begin
        if rising_edge(clk) then
            
            --Reset process
            if res = '1' then
                counter <= 0;
                rms_clock_cycle <= 0;
                th_clock_cycle <= 0;
                done_i <= '0';
                en_mult <= '0';
                en_sqrt <= '0';
                squared_sum_wr <= '0';
                prev_rms_wr <= '0';
                thresholds_wr <= '0';
                
            else
                case rms_clock_cycle is
                    when 0 =>
                        squared_sum_wr <= '0';
                        if en = '1' then
                            rms_clock_cycle <= 1;
                            channel_r <= channel_in;
                            sample_r <= sample_in;
                            busy_i <= '1';
                            -- this let the MNEO block to access the threshold BRAM in 2 clock_cycle
                            thresholds_rd_addr <= channel_in;
                            prev_rms_rd_addr <= channel_in;
                        end if;
                    when 1 =>
                        if channel_r = 0 then
                            if counter < 2**rms_samples_exp-1 then
                                counter <= counter + 1;
                                new_threshold <= false;
                            else
                                counter <= 0;
                                new_threshold <= true;
                            end if;
                        end if;
                        rms_clock_cycle <= 2;
                    when 2 =>
                        if sample_r <= thresholds_do then -- to exclude spikes from rms
                            A <= sample_r;
                            B <= sample_r;
                        else
                            A <= signed(prev_rms_do);
                            B <= signed(prev_rms_do);
                        end if;
                        en_mult <= '1';
                        squared_sum_rd_addr <= channel_r;
                        rms_clock_cycle <= 9;
                    when 9 =>
                        en_mult <= '0';
                        if done_mult = '1' then
                            total_sum := unsigned(squared_sum_do + P);
                            if new_threshold then
                                squared_sum_di <= (rms_samples_exp-1 => '1', others => '0');--reset accumulator
                                sqrt_value <= resize(shift_right(total_sum, rms_samples_exp), 70);
                                do_sqrt <= true;
                            else
                                squared_sum_di <= signed(total_sum);
                            end if;
                            squared_sum_wr_addr <= channel_r;
                            squared_sum_wr <= '1';
                            busy_i <= '0';
                            channel_out <= channel_r;
                            rms_clock_cycle <= 0;
                        end if;
                    when others =>
                        rms_clock_cycle <= 0;
                        busy_i <= '0';
                        squared_sum_wr <= '0';
                        en_mult <= '0';
                end case;
                
                -- threshold update can be done asynchronously
                -- (sqrt require a lot of cycles, less than the entire samples window
                -- but maybe more than the others component togheter)
                if do_sqrt then
                    if busy_sqrt = '0' then
                        en_sqrt <= '1';
                        channel_sqrt <= channel_r;
                        do_sqrt <= false;
                    end if;
                else
                    en_sqrt <= '0';
                end if;
                
                case th_clock_cycle is
                    when 0 =>
                        done_i <= '0';
                        thresholds_wr <= '0';
                        if done_sqrt = '1' then
                            prev_rms_wr <= '1';
                            prev_rms_wr_addr <= channel_sqrt;
                            prev_rms_di <= signed(root);
                            A <= signed(root);
                            B <= resize(signed('0' & th_mult), 35); -- keep as positive whatever happen
                            en_mult <= '1';
                            th_clock_cycle <= 1;
                        end if;
                    when 1 =>
                        en_mult <= '0';
                        prev_rms_wr <= '0';
                        th_clock_cycle <= 7;
                    when 7 =>
                        if done_mult = '1' then
                            thresholds_wr <= '1';
                            thresholds_wr_addr <= channel_sqrt;
                            th_tot := shift_right(P + 1, 1);
                            if th_tot <= max_threshold35 then --to use
                                thresholds_di <= resize(th_tot, 35);
                            else
                                thresholds_di <= (34 => '0', others => '1');
                            end if;
                            if th_tot <= max_threshold32 then --to write out
                                new_threshold_val <= resize(th_tot, 32);
                            else
                                new_threshold_val <= (31 => '0', others => '1');
                            end if;
                            done_i <= '1';
                            th_clock_cycle <= 0;
                        end if;
                    when others =>
                        th_clock_cycle <= 0;
                        done_i <= '0';
                        en_sqrt <= '0';
                        en_mult <= '0';
                        prev_rms_wr <= '0';
                        thresholds_wr <= '0';
                end case;
                
            end if;
        end if;
    end process;
    
end Behavioral;