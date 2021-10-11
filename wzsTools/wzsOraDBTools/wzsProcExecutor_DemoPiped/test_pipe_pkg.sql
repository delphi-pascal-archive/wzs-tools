/*
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru

Test procedures TwzsOraProcExecutor demo from wzsOraDBTools Delphi components.
 
*/

create or replace package test_pipe_pkg as

function test_loop(p_in in varchar2, p_out out varchar2) return integer;

end;
/

create or replace package body test_pipe_pkg as

function test_loop(p_in in varchar2, p_out out varchar2) return integer is

i integer:=0;
maxrec integer:=64000; 
t number; 

begin
 -- always clear the pipe before actions
 ope_pipe.clear_messages;

 -- make test loop...
 for i in 0..maxrec loop
   
   -- select some data
   select empno into t from emp where rownum=1;
			
   -- uncomment line below to raise an exception (an catch it in OnThreadError event) 
			-- select empno into t from emp where empno=-1;
   
   -- send message to application (progress bar percent & text message)
   if mod(i, 100)=0 then
     ope_pipe.send_to_pipe((i/maxrec)*100, i||' loop iteration', null);
   end if; 
  
 end loop;

 commit;
 
 -- set progress bar percent to 100
 ope_pipe.send_to_pipe(100, null, null);
 
	-- set some output
	p_out:='tHE oUTPUT vALUE';
	
 -- return some value to application
 return 777;
end;

end test_pipe_pkg;
/

