CHALLENGE 1

#STEP 1
select t.title_id, 
		ta.au_id,
		t.advance*ta.royaltyper / 100 as advance,
		t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
from titles t
join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id;

#STEP 2

select title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as sales_royalties
from 
(select t.title_id, 
		ta.au_id,
		t.advance*ta.royaltyper / 100 as advance,
		t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
from titles t
join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id)
as prev_table
group by title_id, au_id;

#STEP 3

select au_id, total_advance + sales_royalties as tot_royalties 
from
(select title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as sales_royalties
from 
(select t.title_id, 
		ta.au_id,
		t.advance*ta.royaltyper / 100 as advance,
		t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
from titles t
join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id)
as prev_table
group by title_id, au_id)
as prev_table2
group by au_id, tot_royalties
order by tot_royalties
desc
limit 3;


CHALLENGE 2

#STEP 1
CREATE TEMPORARY TABLE authors_advances
select t.title_id, 
		ta.au_id,
		t.advance*ta.royaltyper / 100 as advance,
		t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
from titles t
join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id;

#STEP 2

CREATE TEMPORARY TABLE sum_authors_advances
select title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as sales_royalties
from 
authors_advances
group by title_id, au_id;

#STEP 3

select au_id, total_advance + sales_royalties as tot_royalties 
from
sum_authors_advances
group by au_id, tot_royalties
order by tot_royalties
desc
limit 3;

CHALLENGE 3

create table most_profiting_authors as

select au_id, total_advance + sales_royalties as tot_royalties 
from
(select title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as sales_royalties
from 
(select t.title_id, 
		ta.au_id,
		t.advance*ta.royaltyper / 100 as advance,
		t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 as sales_royalty
from titles t
join titleauthor ta on t.title_id = ta.title_id
join sales s on t.title_id = s.title_id)
as prev_table
group by title_id, au_id)
as prev_table2
group by au_id, tot_royalties
order by tot_royalties
desc
limit 3;