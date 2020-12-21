library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Spike_detector is
    Generic ( channels_per_port : positive := 16;
              ports_number : positive := 2;
              rms_samples_exp : positive
            );
    Port ( clk, en, reset : in  STD_LOGIC;
           timestep : in STD_LOGIC_VECTOR (31 downto 0);
           D1 : in  STD_LOGIC_VECTOR (15 downto 0);
           D2 : in  STD_LOGIC_VECTOR (15 downto 0);
           stimulation_trigger : in STD_LOGIC;
           channels_disabled : in STD_LOGIC_VECTOR (0 to 31);
           port_en : in  STD_LOGIC_VECTOR (0 to 1);
           new_samples : in STD_LOGIC;
           th_mult : in STD_LOGIC_VECTOR(7 downto 0);
           blind_window : in STD_LOGIC_VECTOR(7 downto 0);
           new_detection : out STD_LOGIC;
           tx_bit : out STD_LOGIC;
           VAL : out STD_LOGIC_VECTOR (15 downto 0);
           ID : out STD_LOGIC_VECTOR (7 downto 0);
           DT : out STD_LOGIC_VECTOR (31 downto 0);
           -- Debug signal
           filter_output : out signed(15 downto 0);
           SG_output : out signed(15 downto 0);
           MNEO_output : out signed(31 downto 0);
           new_filt_sample, new_SG_sample, new_MNEO_sample : out STD_LOGIC;
           SNEO1_out : out signed(31 downto 0);
           SNEO1_done : out STD_LOGIC;
--           SNEO2_done : out STD_LOGIC;
--           SNEO2_out : out signed(31 downto 0);
           threshold : out signed(31 downto 0);
           threshold_done : out std_logic );
end Spike_detector;


architecture Behavioral of Spike_detector is
	
    component filter is
        Generic ( channels_number : positive );
        Port ( clk, en, res : in std_logic;
               channel_in : in natural range 0 to channels_number-1;
               sample_in : in signed(15 downto 0);
               busy : out std_logic;
               sample_out : out signed(15 downto 0);
               channel_out : out natural range 0 to channels_number-1;
               done : out std_logic );
    end component;
    
    component SG_fit is
        Generic ( channels_number : positive );
        Port ( clk, en, res : in std_logic;
               channel_in : in natural range 0 to channels_number-1;
               sample_in : in signed(15 downto 0);
               busy : out std_logic;
               sample_out : out signed(15 downto 0);
               channel_out : out natural range 0 to channels_number-1;
               done : out std_logic );
        end component;
	 
    component thresholding is
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
               SNEO1_val : out signed(31 downto 0);
               SNEO1_done : out std_logic;
--               SNEO2_val : out signed(31 downto 0);
--               SNEO2_done : out std_logic;
               new_threshold_val : out signed(31 downto 0);
               new_threshold : out std_logic );
    end component;
    
    component min_finder is
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
    end component;
    
    component UART_send is
        Generic ( divider : integer;
                  data_width : integer );
        Port ( clk : in STD_LOGIC;
               en : in STD_LOGIC;
               data : in STD_LOGIC_VECTOR (data_width-1 downto 0);
               rdy : out STD_LOGIC;
               tx_bit : out STD_LOGIC );
    end component;
    
    component fifo_send_uart is
        port (
            clk : in STD_LOGIC;
            din : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            wr_en : in STD_LOGIC;
            rd_en : in STD_LOGIC;
            dout : out STD_LOGIC_VECTOR(7 DOWNTO 0);
            full : out STD_LOGIC;
            empty : out STD_LOGIC
        );
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
    
    constant channels : positive := ports_number*channels_per_port;
    
    signal stim_counter : natural := 0;
    
    signal res : std_logic := '0';
    signal prev_reset : std_logic := '0';
    signal timestep_r : unsigned(31 downto 0) := (others => '0');
    
    signal run_filter : boolean := false;
    signal port_en_r : std_logic_vector (0 to 1);
    signal stimulation_trigger_r : std_logic;
    
    type signed16_array is array(natural range <>) of signed(15 downto 0);
    signal data_port : signed16_array(0 to ports_number-1);
    
    signal channel : natural range 0 to channels-1 := 0;
    
    signal channels_disabled_r : std_logic_vector(0 to 31) := (others => '0');
    signal th_mult_r : unsigned(7 downto 0) := to_unsigned(11, 8);
    signal blind_window_r : natural := 10;
    
	signal en_filter : std_logic := '0';
    signal filter_port : natural range 0 to ports_number-1 := 0; -- current filtered port
    
    signal unfilt_channel, filt_channel : natural range 0 to channels-1;
    signal unfilt_data, filt_data : signed(15 downto 0);
    signal filt_done, filt_busy : std_logic;
    
    signal filtSG_data : signed(15 downto 0);
    signal filtSG_channel : natural range 0 to channels-1;
    signal filtSG_done, filtSG_busy : std_logic;
    
    signal MNEO_data : signed(31 downto 0);
    signal MNEO_sample_ampl : signed(15 downto 0);
    signal MNEO_channel : natural range 0 to channels-1;
    signal MNEO_busy, MNEO_detect : std_logic;
    signal MNEO_done : std_logic;
    
    signal ID_reg : std_logic_vector(7 downto 0);
    signal DT_reg : std_logic_vector(31 downto 0);
    signal VAL_reg : std_logic_vector(15 downto 0);
    
    signal uart_rdy_snd : std_logic;
    signal wr_uart_fifo : std_logic := '0';
    signal rd_uart_fifo : std_logic := '0';
    signal din_uart_fifo : std_logic_vector(7 downto 0);
    signal dout_uart_fifo : std_logic_vector(7 downto 0);
    signal uart_fifo_full : std_logic;
    signal uart_fifo_empty : std_logic;
    signal uart_fifo_empty_d : std_logic;
    
    signal send_uart : std_logic := '0';
    signal uart_byte : natural range 0 to 7 := 0;
    
--    signal spikes_step_wr : std_logic := '0';
--    signal spikes_step_wr_addr : natural;
--    signal spikes_step_rd_addr : natural;
--    signal spikes_step_di : signed(31 downto 0);
--    signal spikes_step_do : signed(31 downto 0);
    
    signal min : signed(15 downto 0);
    signal pos : signed(15 downto 0);
    
	 
begin
	
    uart_sender : UART_send
        generic map(
            divider => 100,
            data_width => 8
        )
        port map(
            clk => clk,
            en => send_uart,
            data => dout_uart_fifo,
            rdy => uart_rdy_snd,
            tx_bit => tx_bit
        );
        
    uart_fifo_empty_d <= uart_fifo_empty when rising_edge(clk);
    send_uart <= '1' when uart_rdy_snd = '1' and uart_fifo_empty_d = '0' else '0';
    rd_uart_fifo <= send_uart;
        
    fifo_uart : fifo_send_uart
        port map(
            clk => clk,
            din => din_uart_fifo,
            wr_en => wr_uart_fifo,
            rd_en => rd_uart_fifo,
            dout => dout_uart_fifo,
            full => uart_fifo_full,
            empty => uart_fifo_empty
        );
    
    cmpt_filter : filter
    generic map ( channels_number => channels )
    port map ( clk => clk,
               en => en_filter,
               res => res,
               channel_in => unfilt_channel,
               sample_in => unfilt_data,
               busy => filt_busy,
               sample_out => filt_data,
               channel_out => filt_channel,
               done => filt_done );
   
    cmpt_SG : SG_fit
    generic map ( channels_number => channels )
    port map ( clk => clk,
               en => filt_done,
               res => res,
               channel_in => filt_channel,
               sample_in => filt_data,
               busy => filtSG_busy,
               sample_out => filtSG_data,
               channel_out => filtSG_channel,
               done => filtSG_done );
    
    cmpt_thresholding : thresholding
    generic map ( channels_number => channels,
                  rms_samples_exp => rms_samples_exp )
    port map ( clk => clk,
               en => filtSG_done,
               res => res,
               channel_in => filtSG_channel,
               sample_in => filtSG_data,
               th_mult => th_mult_r,
               busy => MNEO_busy,
               new_spike => MNEO_detect,
               spike_ampl => MNEO_sample_ampl,
               channel_out => MNEO_channel,
               done => MNEO_done,
               MNEO_val => MNEO_data,
               
               SNEO1_val => SNEO1_out,
               SNEO1_done => SNEO1_done,
--               SNEO2_val => SNEO2_out,
--               SNEO2_rd => SNEO2_done,
               new_threshold_val => threshold,
               new_threshold => threshold_done );
   
    cmpt_local_min_finder : min_finder
    generic map ( channels_number => channels )
    port map ( clk => clk,
               en => filt_done,
               res => res,
               channel_in => filt_channel,
               sample_in => filt_data,
               min => min,
               pos => pos );
    
--    cmpt_spikes_step : BRAM_signed
--    generic map ( width => 32,
--                  deepth => channels )
--    port map ( CLK => clk,
--               WR => spikes_step_wr,
--               RES => res,
--               WR_ADDR => spikes_step_wr_addr,
--               RD_ADDR => spikes_step_rd_addr,
--               DI => spikes_step_di,
--               DO => spikes_step_do);
    
    filter_output(15 downto 0) <= filt_data;
    new_filt_sample <= filt_done;
    
    SG_output(15 downto 0) <= filtSG_data;
    new_SG_Sample <= filtSG_done;
    
    MNEO_output <= MNEO_data;
    new_MNEO_sample <= MNEO_done;
    
    ID <= ID_reg;
    DT <= DT_reg;
    VAL <= VAL_reg;
    
    process(clk)
    
    begin 
        if rising_edge(clk) then
            
            prev_reset <= reset;
            if prev_reset = '0' and reset = '1' then
                res <= '1';
            else
                res <= '0';
            end if;
            
            if res = '1' then
                --sample_n <= (others => '0');
                channel <= 0;
                en_filter <= '0';
                filter_port <= 0;
                new_detection <= '0';
                stim_counter <= 0;
            else
                
                
                
                if en = '1' and new_samples = '1'  then
                    run_filter <= true;
                    data_port(0) <= signed(D1);
                    data_port(1) <= signed(D2);
                    timestep_r <= unsigned(timestep);
                    port_en_r <= port_en;
                    stimulation_trigger_r <= stimulation_trigger;
                end if;
                
                if run_filter and en_filter = '0' and filt_busy = '0' and filt_done = '0' and
                   filtSG_busy = '0' and filtSG_done = '0' and MNEO_busy = '0' then
                    if port_en_r(filter_port) = '1' then
                        unfilt_data <= data_port(filter_port);
                        unfilt_channel <= filter_port*channels_per_port+channel;
                        en_filter <= '1';
                    else -- redundant
                        en_filter <= '0';
                    end if;
                    
                    if filter_port < ports_number-1 then
                        filter_port <= filter_port + 1;
                    else
                        run_filter <= false;
                        filter_port <= 0;
                    
                        if channel < channels_per_port-1 then
                            channel <= channel+1;
                        else
                            channel <= 0;
                            --sample_n <= sample_n + 1; -- keep samples number for DT
                            if stim_counter > 0 then -- count for blind window after a stimulation
                                stim_counter <= stim_counter - 1;
                            end if;
                            channels_disabled_r <= channels_disabled;
                            th_mult_r <= unsigned(th_mult);
                            blind_window_r <= to_integer(unsigned(blind_window));
                        end if;
                    end if;
                else
                    en_filter <= '0';
                end if;
                
                if stimulation_trigger_r = '1' then
                    stim_counter <= 25 * blind_window_r;
                end if;
                
--                spikes_step_rd_addr <= filtSG_channel; -- almeno estrae il ritardo corretto prima che serva
                -- no longer needed since spiking time is no more differential
                
                if channels_disabled_r(MNEO_channel) = '0' and MNEO_detect = '1' and stim_counter = 0 then
--                    spikes_step_wr <= '1';
--                    spikes_step_wr_addr <= MNEO_channel;
--                    spikes_step_di <= signed(sample_n);
                    
                    ID_reg <= std_logic_vector(to_unsigned(MNEO_channel, 8));
--                    DT_reg <= std_logic_vector(sample_n - unsigned(pos - spikes_step_do));
                    DT_reg <= std_logic_vector(timestep_r - unsigned(pos));
--                    VAL_reg <= std_logic_vector(MNEO_sample_ampl);
                    VAL_reg <= std_logic_vector(min);
                    
                    new_detection <= '1';
                    uart_byte <= 1;
                else
                    new_detection <= '0';
--                    spikes_step_wr <= '0';
                end if;
                
                if uart_byte = 1 then
                    din_uart_fifo <= ID_reg;
                    wr_uart_fifo <= '1';
                    uart_byte <= 2;
                elsif uart_byte = 2 then
                    din_uart_fifo <= DT_reg(7 downto 0);
                    uart_byte <= 3;
                elsif uart_byte = 3 then
                    din_uart_fifo <= DT_reg(15 downto 8);
                    uart_byte <= 4;
                elsif uart_byte = 4 then
                    din_uart_fifo <= DT_reg(23 downto 16);
                    uart_byte <= 5;
                elsif uart_byte = 5 then
                    din_uart_fifo <= DT_reg(31 downto 24);
                    uart_byte <= 6;
                elsif uart_byte = 6 then
                    din_uart_fifo <= VAL_reg(7 downto 0);
                    uart_byte <= 7;
                elsif uart_byte = 7 then
                    din_uart_fifo <= VAL_reg(15 downto 8);
                    uart_byte <= 0;
                else
                    wr_uart_fifo <= '0';
                end if;
                
            end if;
        end if;
    end process;

end Behavioral;
