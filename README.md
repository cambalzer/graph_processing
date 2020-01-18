# graph comparison

### generate and compare graphs from multiple networks within the Correlates of War dataset

Correlates of War website contains numerous data sets detailing various types of geo political relationships between countries for the last two centuries or so: geographic contiguity, trade, diplomatic relationships, armed conflict, etc. 

Each data set is in effect an edgelist for a type of relationship in place for a given period. Some are directed graphs (exports from country a to country b). Others are undirected (physical contiguity between countries).

We loaded selected networks into SQL for easy consolidation / slicing. From there we exported a single data file (cow_edgelist_v2.csv), containing:

INPUT

- **node1, node2**: the country dyads
- **network**: the type of network mapping = directed or undirected
- **year**: 
 - CoW datafiles have all years represented
 - our analysis pulled four specific years: 1925, 1950, 1975, 2000
 - year = 1 means all historical records are consolidated into one edgelist
- **attribute**: the name of the weighting attribute corresponding to each network
- **value**: the attribute value for each dyad for the year. *can be used for weighting in future versions*

see end of notebook for details on each network


## operation

This script iterates through each network and year and generates metrics for each graph, saving them to results array and logging metric errors.

SETUP

home directory contains:

- input data file: cow_edgelist_v3.csv
- fig folder for image
- file folder for csv outputs
- list of graph analysis functions to be run for each graph
- list of node level functions to run on each graph

FUNCTIONALITY:

- iterates through all networks >> listed in variables
- runs aggregate graph metrics >> listed in variables
- runs digraph vs graph specific  
- saves aggregate csv file
- saves list of centrality metrics. NOTE: includes edgelist as dict in each row. XLS doesn't like this file!
