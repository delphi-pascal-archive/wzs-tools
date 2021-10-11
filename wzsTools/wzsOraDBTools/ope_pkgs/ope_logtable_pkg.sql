/*
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru

Package for using with TwzsOraProcExecutor
from wzsOraDBTools Delphi components in emLogTable mode.

Log table structure:

drop table ope_log;
create table ope_log
(
  pk   timestamp default systimestamp,
  num  number,
  str  varchar2(1024),
  dat  date,
  sid number
);
*/

create or replace package ope_logtable as

procedure clear_logtable;
procedure insert_logtable(n integer, s varchar2, d date);
function session_id return integer;
function recreate_logtable return boolean; 

end;
/

create or replace package body ope_logtable as

logtable_create_ddl constant varchar2(1024):=
  'drop table ope_log; '||
  'create table ope_log ('||
  'pk   timestamp default systimestamp,'||
  'num  number,'||
  'str  varchar2(1024),'||
  'dat  date,'||
  'sid number);';

function recreate_logtable return boolean is
c integer:=0;
begin
  select count(*) into c from user_tables where lower(table_name) = 'ope_log';
  
  if c = 0 then
    execute immediate (logtable_create_ddl);
  end if;
end;
  
function session_id return integer is
r integer:=0;
begin
  select SYS_CONTEXT('USERENV','SESSIONID') into r from dual; 
  return r;
exception
  when others then
  null;
end;

procedure clear_logtable is
pragma autonomous_transaction;
begin
  delete from ope_log;
  commit;
exception
  when others then
  null;  
end;

procedure insert_logtable(n integer, s varchar2, d date) is 
pragma autonomous_transaction;
c integer:=0;
begin
  
   
  select count(*) into c from ope_log where sid = session_id;
  
  if c = 0 then
    insert into ope_log (num, str, dat, sid) values (n, s, d, session_id);
  else
    update ope_log set pk=systimestamp, num=n, str=s, dat=d where sid = session_id;
  end if;
 
  commit;
  
exception
  when others then
  rollback;
end;

end ope_logtable;
/


