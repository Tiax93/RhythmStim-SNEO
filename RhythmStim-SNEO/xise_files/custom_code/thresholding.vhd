library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity thresholding is
    Generic ( channels_number : positive;
              rms_samples_exp : positive );
    Port ( clk : in std_logic;
           en : in std_logic;
           res : in std_logic;
           channel_in : in natural range 0 to channels_number-1;
           sample_in : in signed(15 downto 0);
           th_mult : in unsigned(7 downto 0);
           busy : out std_logic;
           new_spike : out std_logic;
           spike_ampl : out signed(15 downto 0);
           channel_out : out natural range 0 to channels_number-1;
           done : out std_logic;
           MNEO_val : out signed(31 downto 0);
           -- Debug signal
--           SNEO2_val : out signed(31 downto 0);
--           SNEO2_done : out std_logic;
           SNEO1_val : out signed(31 downto 0);
           SNEO1_done : out std_logic;
           new_threshold_val : out signed(31 downto 0);
           new_threshold : out std_logic );
end thresholding;


architecture Behavioral of thresholding is
	 
    component SNEO is
        Generic ( channels_number : positive;
                  K : positive );
        Port ( clk, en, res : in std_logic;
               channel_in : in natural range 0 to channels_number-1;
               nxt_smpl, cur_smpl, prv_smpl : in signed(15 downto 0);
               busy : out std_logic;
               SNEO_val : out signed(34 downto 0);
               done : out std_logic );
    end component;
               
    component threshold is
        Generic ( channels_number : positive;
                  rms_samples_exp : positive );
        Port ( clk, en, res : in std_logic;
               channel_in : in natural range 0 to channels_number-1;
               sample_in : in signed(34 downto 0);
               th_mult : in unsigned(7 downto 0);
               curr_ch_threshold : out signed(34 downto 0);
               new_threshold_val : out signed(31 downto 0);
               channel_out : out natural range 0 to channels_number-1;
               busy : out std_logic;
               done : out std_logic );
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
    
    constant k_max : positive := 4;
    
    signal clock_cycle_sneo : natural := 0;
    signal clock_cycle_mneo : natural := 0;
    signal busy_i : std_logic := '0';
    signal new_spike_i : std_logic := '0';
    signal done_i : std_logic := '0';
    signal channel_r : natural range 0 to channels_number-1;
    signal sample_r : signed(15 downto 0);
    
    signal en_threshold : std_logic := '0';
    signal threshold_busy : std_logic;
    signal threshold_channel : natural range 0 to channels_number-1;
    signal thresholds_do : signed(34 downto 0);
    
    signal MNEO_busy, MNEO_done, MNEO_detect : std_logic := '0';
    signal MNEO_val_i : signed(34 downto 0);
    
    signal en_SNEO : std_logic := '0';
    signal SNEO_in_port : natural range 0 to channels_number-1;
    
    type signed16_array is array(positive range<>) of signed(15 downto 0);
    signal SNEO1_samples: signed16_array(1 to 4);
    signal SNEO1_busy : std_logic := '0';
    signal SNEO1_val_i : signed(34 downto 0);
    signal SNEO1_out_port : natural range 0 to channels_number-1;
    signal SNEO1_done_i : std_logic;
--    signal SNEO2_samples : global_signed16_array(1 to 3);
--    signal SNEO2_busy : std_logic := '0';
--    signal SNEO2_val_i : signed(31 downto 0);
--    signal SNEO2_out_port : positive range 1 to channels_number;
--    signal SNEO2_done_i : std_logic;
    
    signal queue_ind : natural := 0;
    
    signal prev_data_wr : std_logic := '0';
    signal prev_data_wr_addr : natural;
    signal prev_data_rd_addr : natural;
    signal prev_data_di : signed(15 downto 0);
    signal prev_data_do : signed(15 downto 0);
    
    constant prev_data_deepth : natural := channels_number*(3*k_max+1);
    
    signal prev_mneo_wr : std_logic := '0';
    signal prev_mneo_wr_addr : natural;
    signal prev_mneo_rd_addr : natural;
    signal prev_mneo_di : signed(34 downto 0);
    signal prev_mneo_do : signed(34 downto 0); 
    
    signal prev_mneo_1 : signed(34 downto 0); 
    signal prev_mneo_2 : signed(34 downto 0); 
    
	 
begin
    
    cmpt_SNEO1 : SNEO
    generic map ( channels_number => channels_number,
                  K => 4 )
    port map ( clk => clk,
               en => en_SNEO,
               res => res,
               channel_in => SNEO_in_port,
               nxt_smpl => SNEO1_samples(1),
               cur_smpl => SNEO1_samples(2),
               prv_smpl => SNEO1_samples(3),
               busy => SNEO1_busy,
               SNEO_val => SNEO1_val_i,
               done => SNEO1_done_i );
    
--    cmpt_SNEO2 : SNEO
--    generic map ( ports_number => ports_number,
--                  channels_number => channels_number )
--    port map ( clk => clk,
--               en => en_SNEO,
--               res => res,
--               channel_in => SNEO_in_port,
--               nxt_smpl => SNEO2_samples(1),
--               cur_smpl => SNEO2_samples(2),
--               prv_smpl => SNEO2_samples(3),
--               busy => SNEO2_busy,
--               SNEO_val => SNEO2_val_i,
--               done => SNEO2_done_i );
    
    cmpt_threshold : threshold
    Generic map ( channels_number => channels_number,
                  rms_samples_exp => rms_samples_exp )
    Port map ( clk => clk,
               en => en_threshold,
               res => res,
               channel_in => channel_r,
               sample_in => MNEO_val_i,
               th_mult => th_mult,
               curr_ch_threshold => thresholds_do,
               new_threshold_val => new_threshold_val,
               channel_out => threshold_channel,
               busy => threshold_busy,
               done => new_threshold );
    
    cmpt_BRAM_prev_data : BRAM_signed
    generic map ( width => 16,
                  deepth => prev_data_deepth)
    port map ( CLK => clk,
               RES => res,
               WR => prev_data_wr,
               WR_ADDR => prev_data_wr_addr,
               RD_ADDR => prev_data_rd_addr,
               DI => prev_data_di,
               DO => prev_data_do);
    
    cmpt_BRAM_prev_mneo : BRAM_signed
    generic map ( width => 35,
                  deepth => 2*channels_number)
    port map ( CLK => clk,
               RES => res,
               WR => prev_mneo_wr,
               WR_ADDR => prev_mneo_wr_addr,
               RD_ADDR => prev_mneo_rd_addr,
               DI => prev_mneo_di,
               DO => prev_mneo_do);
    
    new_spike <= new_spike_i;
    busy <= busy_i or SNEO1_busy; -- or SNEO2_busy;
    done <= done_i;
    MNEO_val <= resize(MNEO_val_i, 32);
    
    SNEO1_val <= resize(SNEO1_val_i, 32);
    SNEO1_done <= SNEO1_done_i;
--    SNEO2_val <= SNEO2_out;
--    SNEO2_rd <= SNEO2_done;
    
    process(clk)
    
        variable diff : integer;
    
    begin 
        if rising_edge(clk) then
            -- reset process
            if res = '1' then
                clock_cycle_sneo <= 0;
                clock_cycle_mneo <= 0;
                done_i <= '0';
                busy_i <= '0';
                new_spike_i <= '0';
                en_threshold <= '0';
                queue_ind <= 0;
                prev_data_wr <= '0';
                prev_mneo_wr <= '0';
            else
                
                case clock_cycle_sneo is
                    when 0 =>
                        en_SNEO <= '0';
                        en_threshold <= '0';
                        if en = '1' then
                            busy_i <= '1';
                            channel_r <= channel_in;
                            sample_r <= sample_in;
                            clock_cycle_sneo <= 1;
                        end if;
                    when 1 =>
                        -- store sample in a cricular array in BRAM
                        prev_data_wr <= '1';
                        prev_data_wr_addr <= queue_ind;
                        prev_data_di <= sample_r;
                        prev_mneo_rd_addr <= channel_r; --now on, take out from RAM the previous SNEO value and shift them
                        clock_cycle_sneo <= 2;
                    when 2 =>
                        diff := queue_ind - channels_number*(k_max-4);
                        if diff >= 0 then
                            prev_data_rd_addr <= diff;
                        else
                            prev_data_rd_addr <= prev_data_deepth + diff;
                        end if;
                        prev_mneo_rd_addr <= channels_number+channel_r;
                        clock_cycle_sneo <= 3;
                    when 3 =>
                        prev_data_wr <= '0';
                        diff := queue_ind - channels_number*k_max;
                        if diff >= 0 then
                            prev_data_rd_addr <= diff;
                        else
                            prev_data_rd_addr <= prev_data_deepth + diff;
                        end if;
                        prev_mneo_1 <= prev_mneo_do;
                        clock_cycle_sneo <= 4;
                    when 4 =>
                        SNEO1_samples(1) <= prev_data_do;
                        --SNEO2_samples(1) <= prev_data(channel_r, (k_max-4)*channels_number);
                        diff := queue_ind - channels_number*(k_max+4);
                        if diff >= 0 then
                            prev_data_rd_addr <= diff;
                        else
                            prev_data_rd_addr <= prev_data_deepth + diff;
                        end if;
                        prev_mneo_2 <= prev_mneo_do;
                        prev_mneo_wr <= '1';
                        prev_mneo_wr_addr <= channels_number+channel_r;
                        prev_mneo_di <= prev_mneo_1;
                        clock_cycle_sneo <= 5;
                    when 5 =>
                        diff := queue_ind - channels_number*(k_max+8);
                        if diff >= 0 then
                            prev_data_rd_addr <= diff;
                        else
                            prev_data_rd_addr <= prev_data_deepth + diff;
                        end if;
                        if queue_ind < prev_data_deepth-1 then
                            queue_ind <= queue_ind + 1;
                        else
                            queue_ind <= 0;
                        end if;
                        SNEO1_samples(2) <= prev_data_do;
                        --SNEO2_samples(2) <= prev_data(channel_r, (k_max)*channels_number);
                        prev_mneo_wr <= '0';
                        clock_cycle_sneo <= 6;
                    when 6 =>
                        SNEO1_samples(3) <= prev_data_do;
                        --SNEO2_samples(3) <= prev_data(channel_r, (k_max+4)*channels_number);
                        
                        SNEO_in_port <= channel_r;
                        en_SNEO <= '1';
                        clock_cycle_sneo <= 7;
                    when 7 =>
                        SNEO1_samples(4) <= prev_data_do;
                        clock_cycle_sneo <= 0;
                    when others =>
                        clock_cycle_sneo <= 0;
                        prev_data_wr <= '1';
                        en_SNEO <= '0';
                end case;
                
                
                case clock_cycle_mneo is
                    when 0 =>
                        done_i <= '0';
                        --once SNEO is computed, find max
                        if SNEO1_done_i = '1' then --SNEO2 already finished
--                            if SNEO1_out > SNEO2_out then
                            MNEO_val_i <= SNEO1_val_i;
--                            else
--                                MNEO_val_i <= SNEO2_val_i;
--                            end if;
                            en_threshold <= '1';
                            clock_cycle_mneo <= 1;
                        end if;
                    when 1 =>
                        en_threshold <= '0';
                        clock_cycle_mneo <= 2;
                    when 2 =>
                        -- wait to retrive threshold
                        clock_cycle_mneo <= 3;
                    when 3 =>
                        prev_mneo_di <= MNEO_val_i;
                        prev_mneo_wr_addr <= channel_r;
                        prev_mneo_wr <= '1';
                        if prev_MNEO_1 > thresholds_do and prev_MNEO_1 > MNEO_val_i
                                and prev_MNEO_1 >= prev_MNEO_2 then
                            new_spike_i <= '1';
                        end if;
                        done_i <= '1';
                        channel_out <= channel_r;
                        --The bigger value is in the center of the trangular window (2*K_max value ago)
                        --and the value used for the last point of the triang is calculated on
                        --k_max sample ago: from this 3*K_max
                        --BUGIA!!! Introdotto local minimum finder in spike_detector
                        spike_ampl <= SNEO1_samples(4);
                        clock_cycle_mneo <= 4;
                    when 4 =>
                        prev_mneo_wr <= '0';
                        new_spike_i <= '0';
                        done_i <= '0';
                        if threshold_busy = '0' then
                            clock_cycle_mneo <= 0;
                            busy_i <= '0';
                        end if;
                    when others =>
                        clock_cycle_mneo <= 0;
                        en_threshold <= '0';
                        new_spike_i <= '0';
                        done_i <= '0';
                        busy_i <= '0';
                end case;
                
            end if;
        end if;
    end process;

end Behavioral;
