library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- common clock, 1 write, 1 read port BRAM
entity BRAM_signed is
    Generic ( width  : positive;
              deepth : positive;
              init_val : signed := "0" );
    Port ( CLK     : in std_logic;
           RES     : in std_logic;
           WR      : in std_logic;
           WR_ADDR : in natural range 0 to deepth-1;
           RD_ADDR : in natural range 0 to deepth-1;
           DI      : in signed(width-1 downto 0);
           DO      : out signed(width-1 downto 0)
    );
end BRAM_signed;

architecture Behavioral of BRAM_signed is

    type signed_array is array(0 to deepth-1) of signed(width-1 downto 0);
    signal ram_mem : signed_array;-- := (others => resize(init_val, width));
    signal valid : std_logic_vector(0 to deepth-1) := (others => '0');

begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            --reset
            if RES = '1' then
                valid <= (others => '0');
            end if;
            --read
            if valid(RD_ADDR) = '1' then
                DO <= ram_mem(RD_ADDR);
            else
                DO <= resize(init_val, width);
            end if;
            --write
            if (WR = '1') then
                ram_mem(WR_ADDR) <= DI;
                valid(WR_ADDR) <= '1';
            end if;
            
        end if;
    end process;

end Behavioral;

--signal reset_process, resetted : boolean := false;
--signal reset_addr : natural range 0 to deepth := 0;    

--if reset_process then
--    if reset_addr < deepth then
--        DI <= resize(init_val, width);
--        WR_ADDR <= reset_addr;
--        WR <= '1';
--        reset_addr <= reset_addr + 1;
--    else
--        reset_process <= false;
--    end if;
--elsif not resetted and RES = '1' then
--    reset_process <= true;
--    resetted <= true;
--    reset_addr <= 0;
--end if;
