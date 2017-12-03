----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2017 12:20:02 PM
-- Design Name: 
-- Module Name: lab6 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 ENTITY half_adder IS             --- Half Adder
PORT(a,b:IN BIT; s,c :OUT BIT);
END half_adder;

ARCHITECTURE half_adder_beh OF half_adder IS
BEGIN
s <= a XOR b;             -- Implements Sum for Half Adder
c <= a AND b;             -- Implements Carry for Half Adder
END half_adder_beh;  


ENTITY full_adder IS             --- Full Adder
PORT(a,b,c: IN BIT ;
  sum, carry : OUT BIT);
END full_adder;

ARCHITECTURE full_adder_beh OF full_adder IS

BEGIN
  PROCESS(a,b,c)                -- Sensitive on all the three bits
    VARIABLE temp :BIT;
     BEGIN                       --- DOES the addition in one DELTA time
       temp := a XOR b;
       sum <= temp XOR c;
       carry <= (a AND b) OR (temp AND c);
     END PROCESS ;
END full_adder_beh; 

ENTITY carry_prop_adder IS                        --- Carry Propagate Adder
PORT(x: IN BIT_VECTOR(15 DOWNTO 0);
  y :IN BIT_VECTOR(15 DOWNTO 0);
  sum: OUT BIT_VECTOR(15 DOWNTO 0)
);
END carry_prop_adder;
ARCHITECTURE carry_prop_adder_beh OF carry_prop_adder IS
COMPONENT half_adder                             -- Half Adder Used as a Component
port(a,b :IN BIT; s,c :OUT BIT);
END COMPONENT;
COMPONENT full_adder                             -- Full Adder Used as a Component
PORT(a,b,c:IN BIT; sum,carry:OUT BIT);
END COMPONENT;
FOR ALL:half_adder USE ENTITY WORK.half_adder(half_adder_beh);
FOR ALL:full_adder USE ENTITY WORK.full_adder(full_adder_beh);
SIGNAL cout_cin :BIT_VECTOR(15 DOWNTO 1);

BEGIN
sum(0) <= x(0);
HA1:half_adder PORT MAP(
    a=>x(1),b=>y(1),s=>sum(1),c=>cout_cin(1));    -- Instaciating H.A
FA2_7:FOR i in 2 TO 15 GENERATE                  
           FA:full_adder PORT MAP(a=>x(i),b=>y(i),c=>cout_cin(i-1),sum=>sum(i),carry=>cout_cin(i));
          END GENERATE;
END carry_prop_adder_beh;


entity lab6 is
PORT(a: IN BIT_VECTOR(7 DOWNTO 0);
  b :IN BIT_VECTOR(7 DOWNTO 0);
  prod: OUT BIT_VECTOR(15 DOWNTO 0)
);
end lab6;

architecture Behavioral of lab6 is
COMPONENT carry_prop_adder                           
PORT( x :IN BIT_VECTOR(15 DOWNTO 0); y :IN BIT_VECTOR(15 DOWNTO 0); sum :OUT BIT_VECTOR(15 DOWNTO 0));
END COMPONENT;
FOR ALL:carry_prop_adder USE ENTITY WORK.carry_prop_adder(carry_prop_adder_beh);

SIGNAL cout_cin :BIT_VECTOR(15 DOWNTO 1);
SIGNAL dummyprod : BIT_VECTOR(15 DOWNTO 0);
TYPE sr IS ARRAY (0 to 7) OF BIT_VECTOR(15 DOWNTO 0);
SIGNAL r :sr;
SIGNAL dummysignal : sr;
--SIGNAL d2 : BIT_VECTOR(15 DOWNTO 0);
begin
  r(0) <= "00000000" & a WHEN b(0)='1' ELSE "0000000000000000";
  r(1) <= "0000000" & a & "0" WHEN b(1)= '1' ELSE "0000000000000000";
  r(2) <= "000000" & a & "00" WHEN b(2)= '1' ELSE "0000000000000000" ;
  r(3) <= "00000" & a & "000"  WHEN b(3)= '1' ELSE "0000000000000000" ;
  r(4) <= "0000" & a & "0000"  WHEN b(4)= '1' ELSE "0000000000000000" ;
  r(5) <= "000" & a & "00000"  WHEN b(5)= '1' ELSE "0000000000000000" ;
  r(6) <= "00" & a & "000000"  WHEN b(6)= '1' ELSE "0000000000000000" ;
  r(7) <= "0" & a & "0000000"  WHEN b(7)= '1' ELSE "0000000000000000" ; 
   
INSTANTIATE : carry_prop_adder PORT MAP(x=>r(0),y=>r(1),sum=>dummysignal(1));
MPLY: FOR i in 2 to 7 GENERATE
    MTP: carry_prop_adder PORT MAP(x=>dummysignal(i-1), y=>r(i), sum=>dummysignal(i));
    END GENERATE;
    prod <= dummysignal(7);
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 ENTITY half_adder IS             --- Half Adder
PORT(a,b:IN BIT; s,c :OUT BIT);
END half_adder;

ARCHITECTURE half_adder_beh OF half_adder IS
BEGIN
s <= a XOR b;             -- Implements Sum for Half Adder
c <= a AND b;             -- Implements Carry for Half Adder
END half_adder_beh;  


ENTITY full_adder IS             --- Full Adder
PORT(a,b,c: IN BIT ;
  sum, carry : OUT BIT);
END full_adder;

ARCHITECTURE full_adder_beh OF full_adder IS

BEGIN
  PROCESS(a,b,c)                -- Sensitive on all the three bits
    VARIABLE temp :BIT;
     BEGIN                       --- DOES the addition in one DELTA time
       temp := a XOR b;
       sum <= temp XOR c;
       carry <= (a AND b) OR (temp AND c);
     END PROCESS ;
END full_adder_beh; 

ENTITY carry_save_adder IS                        --- Carry Propagate Adder
PORT(x: IN BIT_VECTOR(15 DOWNTO 0);
  y :IN BIT_VECTOR(15 DOWNTO 0);
  z :IN BIT_VECTOR(15 DOWNTO 0);
  s: OUT BIT_VECTOR(15 DOWNTO 0);
  c: OUT BIT_VECTOR(15 DOWNTO 0)
);
END carry_save_adder;

ARCHITECTURE carry_save_adder_beh OF carry_save_adder IS
COMPONENT full_adder                             -- Full Adder Used as a Component
PORT(a,b,c:IN BIT; sum,carry:OUT BIT);
END COMPONENT;
FOR ALL:full_adder USE ENTITY WORK.full_adder(full_adder_beh);
SIGNAL cout_cin :BIT_VECTOR(15 DOWNTO 1);

BEGIN
FA2_7:FOR i in 0 TO 15 GENERATE                  
           FA:full_adder PORT MAP(a=>x(i),b=>y(i),c=>z(i),sum=>s(i),carry=>c(i));
          END GENERATE;
END carry_save_adder_beh;


ENTITY carry_prop_adder IS                        --- Carry Propagate Adder
PORT(x: IN BIT_VECTOR(15 DOWNTO 0);
  y :IN BIT_VECTOR(15 DOWNTO 0);
  sum: OUT BIT_VECTOR(15 DOWNTO 0)
);
END carry_prop_adder;
ARCHITECTURE carry_prop_adder_beh OF carry_prop_adder IS
COMPONENT half_adder                             -- Half Adder Used as a Component
port(a,b :IN BIT; s,c :OUT BIT);
END COMPONENT;
COMPONENT full_adder                             -- Full Adder Used as a Component
PORT(a,b,c:IN BIT; sum,carry:OUT BIT);
END COMPONENT;
FOR ALL:half_adder USE ENTITY WORK.half_adder(half_adder_beh);
FOR ALL:full_adder USE ENTITY WORK.full_adder(full_adder_beh);
SIGNAL cout_cin :BIT_VECTOR(15 DOWNTO 1);

BEGIN
sum(0) <= x(0);
HA1:half_adder PORT MAP(
    a=>x(1),b=>y(1),s=>sum(1),c=>cout_cin(1));    -- Instaciating H.A
FA2_7:FOR i in 2 TO 15 GENERATE                  
           FA:full_adder PORT MAP(a=>x(i),b=>y(i),c=>cout_cin(i-1),sum=>sum(i),carry=>cout_cin(i));
          END GENERATE;
END carry_prop_adder_beh;


entity lab6m is
PORT(a: IN BIT_VECTOR(7 DOWNTO 0);
  b :IN BIT_VECTOR(7 DOWNTO 0);
  prod: OUT BIT_VECTOR(15 DOWNTO 0)
);
end lab6m;

architecture Behavioral of lab6m is
COMPONENT carry_save_adder                           
PORT( x :IN BIT_VECTOR(15 DOWNTO 0); y, z :IN BIT_VECTOR(15 DOWNTO 0); s, c :OUT BIT_VECTOR(15 DOWNTO 0));
END COMPONENT;
FOR ALL:carry_save_adder USE ENTITY WORK.carry_save_adder(carry_save_adder_beh);

COMPONENT carry_prop_adder                           
PORT( x :IN BIT_VECTOR(15 DOWNTO 0); y :IN BIT_VECTOR(15 DOWNTO 0); sum :OUT BIT_VECTOR(15 DOWNTO 0));
END COMPONENT;
FOR ALL:carry_prop_adder USE ENTITY WORK.carry_prop_adder(carry_prop_adder_beh);

SIGNAL cout_cin :BIT_VECTOR(15 DOWNTO 1);
SIGNAL dummyprod : BIT_VECTOR(15 DOWNTO 0);
TYPE sr IS ARRAY (0 to 7) OF BIT_VECTOR(15 DOWNTO 0);
SIGNAL r :sr;
SIGNAL ds : sr;
SIGNAL dc : sr;
--SIGNAL d2 : BIT_VECTOR(15 DOWNTO 0);
begin
  r(0) <= "00000000" & a WHEN b(0)='1' ELSE "0000000000000000";
  r(1) <= "0000000" & a & "0" WHEN b(1)= '1' ELSE "0000000000000000";
  r(2) <= "000000" & a & "00" WHEN b(2)= '1' ELSE "0000000000000000" ;
  r(3) <= "00000" & a & "000"  WHEN b(3)= '1' ELSE "0000000000000000" ;
  r(4) <= "0000" & a & "0000"  WHEN b(4)= '1' ELSE "0000000000000000" ;
  r(5) <= "000" & a & "00000"  WHEN b(5)= '1' ELSE "0000000000000000" ;
  r(6) <= "00" & a & "000000"  WHEN b(6)= '1' ELSE "0000000000000000" ;
  r(7) <= "0" & a & "0000000"  WHEN b(7)= '1' ELSE "0000000000000000" ; 
   
INSTANTIATE : carry_save_adder PORT MAP(x=>r(0),y=>r(1),z=>r(2),s=>ds(2),c=>dc(2));
MPLY: FOR i in 3 to 7 GENERATE
    MTP: carry_save_adder PORT MAP(x=>ds(i-1), y=>dc(i-1), z=>r(i) ,s=>ds(i), c=> dc(i));
    END GENERATE;
    
FINAL : carry_prop_adder PORT MAP(x=>ds(7),y=>dc(7),sum=>prod);
end Behavioral;