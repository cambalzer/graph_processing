

/* 

Correlates of War datasets for network analysis

https://correlatesofwar.org/data-sets

NOTE: all queries filter out "small countries" which for convenience are defined as sum of all 2000 smoothflow1 < 10 

### NODE FILE ### 

NOTE: some queries filter out "small countries" which for convenience are defined as sum of all 2000 smoothflow1 < 10. Same countries also filtered from EDGELIST
 
*/


select 
	ccode as node,
	StateAbb as st,
	StateNme as state_name
from country_codes
-- where del != 1
order by node asc;


/* 

### EDGE FILE ###

each datasource concatenated together into single edgelist with cols:

	- node1
	- node2
	- attribute: for each specific network mapping, the edge weight/type attribute
	- value: numeric value of network, either a scale or a code
	- network: the specific Correlates of War network 
	- year: timeslice in this sample 


## EDGES ##


# PHYSICAL CONTIGUITY network #

data file: DirectContiguity320 / contdir.csv
graph type: UNDIRECTED

	1: Separated by a land or river border
	2: Separated by 12 miles of water or less
	3: Separated by 24 miles of water or less (but more than 12 miles) 
	4: Separated by 150 miles of water or less (but more than 24 miles) 
	5: Separated by 400 miles of water or less (but more than 150 miles) 

*/


select 
	state1no as node1,
	state2no as node2,
	'contiguity_type' as attribute,
	conttype as value, 
	'contiguity' as network,
	src.year as year 
from contiguity src
left join country_codes cc on cc.ccode = src.state1no
where
	-- cc.del != 1 and
	src.year in (1925, 1950, 1975, 2000)

-- ;
union

/*

# DIPLOMATIC RELATIONSHIP network #

data file: Diplomatic_Exchange_2006v1.csv
graph type: UNDIRECTED

DE = 1 means at least one side had a high level representative in the other country

*/

select 
	ccode1 as node1,
	ccode2 as node2,
	'dip_rel_exists' as attribute,
	1 as value, 
	'dip_exchange' as network,
	src.year as year 
from dip_exchange src
left join country_codes cc on cc.ccode = src.ccode1
where
	DE = 1 and
	cc.del != 1 and
	src.year in (1925, 1950, 1975, 2000)

-- ;
union

/*

# DIRECTED ALLIANCES network #

data file: alliance_v4.1_by_directed.csv
graph type: UNDIRECTED (despite the name)

dyad alliances extended across years (one year for each row during which an alliance existed)

there are four types of alliance: defense, neutrality, nonaggression, entente
value sums the # of these in place per year & dyad

*/

select 
	ccode1 as node1,
	ccode2 as node2,
	'alliance_types' as attribute,
	defense + neutrality + nonaggression + entente as value, 
	'dir_alliances' as network,
	src.year as year 
from directed_alliances src
left join country_codes cc on cc.ccode = src.ccode1
where
	cc.del != 1 and
	src.year in (1925, 1950, 1975, 2000)
	
-- ;
union
	
/*

# EXPORTS / TRADE network #

data file: Dyadic_COW_4.0.csv *** NOTE 82MB filesize ***
graph type: DIRECTED

CoW Trade table contains contains two way import between each dyad, 1 from 2, and 2 from 1

translated this into a DIRECTED link of exports from country 1 to country 2

run it twice, to get each EXPORT dyad

filtered for trade >= 100MM / year

*/

# exports from 1 to 2 = smoothflow 2
select 
	ccode1 as node1,
	ccode2 as node2,
	'exports_to' as attribute,
	smoothflow2 as value, 
	'trade' as network,
	src.year as year 
from trade src
left join country_codes cc on cc.ccode = src.ccode1
where
	smoothflow2 > 0 and
	-- cc.del != 1 and
	src.year in (1925, 1950, 1975, 2000)

-- ;
union

# exports from 2 to 1 = smoothflow 1
 select 
	ccode2 as node1,
	ccode1 as node2,
	'exports_to' as attribute,
	smoothflow1 as value, 
	'trade' as network,
	src.year as year 
from trade src
left join country_codes cc on cc.ccode = src.ccode1
where
	smoothflow1 > 0 and
	-- cc.del != 1 and
	src.year in (1925, 1950, 1975, 2000)

-- ;

/*

# TERRITORY EXCHANGE network #

data file: Territorial Change Data, 1816-2018 [cleaned from source]
graph type: DIRECTED

- directed exchange coded as from loser (node 1) to recipient (node2)
- including all years between 1930 and 2000
- passing conflict value in node list (1 = military conflict)

not passed but included in table:

- type of conflict:

	1. Conquest
	2. Annexation
	3. Cession
	4. Secession
	5. Unification
	6. Mandated territory

- land mass (Area of Unit Exchanged in Square Kilometers)
- population 
*/

union

select 
	loser as node1,
	gainer as node2,
	'armed_conflict' as attribute,
	conflict as value, 
	'terr_exchange' as network,
	1 as year 
from terr_exchange src
left join country_codes cc on cc.ccode = loser
where
	-- cc.del != 1 and 
	(src.year >= 1920 and src.year <= 2000)

/*

# MILITARIZED DISPUTES network #

data file: dyadic MIDs 3.1.csv
graph type: UNDIRECTED (data source is directed but this is flattened)

military conflicts with min 1000 troops deployed and min 100 deadline

hihost = highest hostility

1. None
2. Threat to use force
3. Display of force
4. Use of force
5. Interstate war

A lot of other columns available in source data

*/

union

select 
	statea as node1,
	stateb as node2,
	'highest_hostility' as attribute,
	hihost as value, 
	'military_conflict' as network,
	1 as year 
from military_conflict src
left join country_codes cc on cc.ccode = src.statea
where
	-- cc.del != 1 and
	(src.year >= 1920 and src.year <= 2000)
	
;


