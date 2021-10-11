/*

wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru

Package for using with TwzsOraProcExecutor
from wzsOraDBTools Delphi components. These functions may also
be used separately for sending piped messages.

To enable pipe functions you need grant execution of
dbms_pipe as following 
(from SYS connection or from SYSTEM as SYSDBA):
 
grant execute on dbms_pipe to <user or role>

*/

create or replace package ope_pipe as

procedure clear_messages;
procedure send_to_pipe(num integer, str varchar2, dat date);
function get_pipename return varchar2;

end;
/


create or replace package body ope_pipe as

/* use named pipe */
-- pipe_name constant varchar2(255):='qwe';

/* use unique pipe name per session */ 
pipe_name varchar2(255):=sys.dbms_pipe.unique_session_name;

procedure clear_messages is
begin
  sys.dbms_pipe.purge(pipe_name);
end;


procedure send_to_pipe(num integer, str varchar2, dat date) is
r integer;
begin
 --dbms_pipe.purge(pipe_name);
 
 if num is not null then
   sys.dbms_pipe.pack_message(num);
 end if;
 
 if str is not null then
   sys.dbms_pipe.pack_message(str);
 end if;
 
 if dat is not null then
   sys.dbms_pipe.pack_message(dat);
 end if;  
 
 
 r:=sys.dbms_pipe.send_message(pipe_name);
 
 if r != 0 then
    raise_application_error(-20099, 'ope_pipe.send_to_pipe error');
 end if;
 
end;

function get_pipename return varchar2 is
begin
 return pipe_name;
end;

end ope_pipe;
/


