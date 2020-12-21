library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_send is
    Generic ( divider : integer;
              data_width : integer );
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (data_width-1 downto 0);
           rdy : out STD_LOGIC;
           tx_bit : out STD_LOGIC );
end UART_send;

architecture Behavioral of UART_send is
    
    signal clk_cyc : positive := 1;
    signal count : natural := data_width+2;
    signal parity_bit : std_logic := '0';
    
begin
    
    process(clk)
    
    begin
        if rising_edge(clk) then
            
            if en = '1' then
                count <= 0;
                rdy <= '0';
            end if;
            
            if clk_cyc < divider then --clock_reducer
                clk_cyc <= clk_cyc + 1;
            else
                
                if count = 0 then
                    tx_bit <= '0';
                    count <= count+1;
                elsif count <= data_width then
                    tx_bit <= data(count-1);
                    if data(count-1) = '1' then
                        parity_bit <= not parity_bit;
                    end if;
                    count <= count+1;
                elsif count = data_width+1 then
                    tx_bit <= parity_bit;
                    parity_bit <= '0';
                    count <= count+1;
                else
                    tx_bit <= '1';
                    rdy <= '1';
                end if;
                
                clk_cyc <= 1;
            end if;
            
        end if;
    end process;

end Behavioral;
