drop table if exists lab_02.table1 cascade;
drop table if exists lab_02.table2 cascade;

create table lab_02.table1 (
id integer,
var1 text,
valid_from_dttm date,
valid_to_dttm date
);

create table lab_02.table2 (
id integer,
var2 text,
valid_from_dttm date,
valid_to_dttm date
);

insert into lab_02.table1 (id, var1, valid_from_dttm, valid_to_dttm)
values (1, 'A', '2018-09-01', '2018-09-15');
insert into lab_02.table1 (id, var1, valid_from_dttm, valid_to_dttm)
values (1, 'B', '2018-09-16', '5999-12-31');

insert into lab_02.table2 (id, var2, valid_from_dttm, valid_to_dttm)
values (1, 'A', '2018-09-01', '2018-09-18');
insert into lab_02.table2 (id, var2, valid_from_dttm, valid_to_dttm)
values (1, 'B', '2018-09-19', '5999-12-31');

select * from lab_02.table1;
select * from lab_02.table2;


drop table if exists lab_02.from_table cascade; 

select *, row_number() over () as num
into lab_02.from_table
from (
select id, coalesce(max(var1), max(var2)) as var1, valid_from_dttm
from 
(
select id, var1, null as var2, valid_from_dttm 
from lab_02.table1 t1
union
select id, null as var1, var2, valid_from_dttm
from lab_02.table2 t2
) ut1
group by id, valid_from_dttm
order by valid_from_dttm
) ft;

drop table if exists lab_02.to_table cascade; 

select *, row_number() over () as num
into lab_02.to_table
from (
select id, coalesce(max(var1), max(var2)) as var2, valid_to_dttm
from 
(
select id, var1, null as var2, valid_to_dttm 
from lab_02.table1 t1
union
select id, null as var1, var2, valid_to_dttm
from lab_02.table2 t2
) ut1
group by id, valid_to_dttm
order by valid_to_dttm
) tt;

select ft.id, var1, var2, valid_from_dttm, valid_to_dttm
from lab_02.from_table ft join lab_02.to_table tt on ft.num = tt.num;


