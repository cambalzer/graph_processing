# CoW data files

### PHYSICAL CONTIGUITY network

data file: DirectContiguity320 / contdir.csv
graph type: UNDIRECTED

1. Separated by a land or river border
2. Separated by 12 miles of water or less
3. Separated by 24 miles of water or less (but more than 12 miles) 
4. Separated by 150 miles of water or less (but more than 24 miles) 
5. Separated by 400 miles of water or less (but more than 150 miles) 



### DIPLOMATIC RELATIONSHIP network 

data file: Diplomatic_Exchange_2006v1.csv
graph type: UNDIRECTED

DE = 1 means at least one side had a high level representative in the other country


### DIRECTED ALLIANCES network 

data file: alliance_v4.1_by_directed.csv
graph type: UNDIRECTED (despite the name)

dyad alliances extended across years (one year for each row during which an alliance existed)

there are four types of alliance: defense, neutrality, nonaggression, entente
value sums the # of these in place per year & dyad


### EXPORTS / TRADE network 

data file: Dyadic_COW_4.0.csv *** NOTE 82MB filesize ***
graph type: DIRECTED

CoW Trade table contains contains two way import between each dyad, 1 from 2, and 2 from 1

translated this into a DIRECTED link of exports from country 1 to country 2

run it twice, reversed the second time, to get each EXPORT dyad

### TERRITORY EXCHANGE network 

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


### MILITARIZED DISPUTES network 

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
