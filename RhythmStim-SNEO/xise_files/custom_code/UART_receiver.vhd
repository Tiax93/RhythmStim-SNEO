library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity UART_recv is
    Generic ( divider : integer;
              data_width : integer );
    Port ( clk : in STD_LOGIC;
           rx_bit : in STD_LOGIC;
           new_data : out STD_LOGIC;
           data : out STD_LOGIC_VECTOR (data_width-1 downto 0) );
end UART_recv;

architecture Behavioral of UART_recv is
    
    signal rx_reg : std_logic;
    signal clk_cyc : positive := 1;
    signal count : natural := data_width+1;
    signal parity_bit : std_logic := '0';
    signal rcvd : std_logic_vector(data_width-1 downto 0);
    
begin
    
	process(clk)

	begin
		if rising_edge(clk) then
            
            rx_reg <= rx_bit;
		
            if clk_cyc < divider then --clock_reducer
                clk_cyc <= clk_cyc+1;
            else
            
                if count > data_width then
                    new_data <= '0';
                    if rx_reg = '0' then
                        count <= 0;
                    end if;
                
                elsif count < data_width then
                    rcvd(count) <= rx_reg;
                    if rx_reg = '1' then
                        parity_bit <= not parity_bit;
                    end if;
                    count <= count+1;
                    
                elsif count = data_width then
                    if rx_reg = parity_bit then
                        data <= rcvd;
                    else
                        data <= std_logic_vector(to_signed(33, 8));
                    end if;
                    new_data <= '1';
                    parity_bit <= '0';
                    count <= count+1;
                end if;
                
                clk_cyc <= 1;
            end if;
            
		end if;
	end process;

end Behavioral;