/*delete from cmset_language;
delete from cmcard;
delete from cmset;
delete from cmsetblock;
delete from cmsettype;
delete from cmartist;
delete from cmrarity;
delete from cmlanguage;
delete from cmlayout;*/

--update cmset set my_keyrune_code = null;
--select * from cmset where code = 'aer';


select selectCards('lea', 'en')
