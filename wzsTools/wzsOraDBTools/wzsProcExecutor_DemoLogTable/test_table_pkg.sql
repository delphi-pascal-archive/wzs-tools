/*
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru

Test procedures TwzsOraProcExecutor demo from wzsOraDBTools Delphi components.
*/

create or replace package test_logtable_pkg as

function test_loop(p1 varchar2) return integer;

end;
/

create or replace package body test_logtable_pkg as

function test_loop(p1 varchar2) return integer is

i integer:=0;
t number;
maxrec integer:=5000;
s varchar2(255); 

begin
 
 -- clear log table
 ope_logtable.clear_logtable;
 
 -- make a test loop...
 for i in 0..maxrec loop
 
  -- select some data
  select empno into t from scott.emp where rownum=1;
  
  -- insert into log table and commit in autonomous transation
  ope_logtable.insert_logtable((i/maxrec)*100, i||'th loop iteration', null);
  
  
 end loop;

 ope_logtable.insert_logtable(100, 'finished.', null);

 -- return some value to application
 return 777;
end;

end test_logtable_pkg;
/

