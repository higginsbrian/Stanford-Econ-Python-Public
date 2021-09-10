*cd "/Users/djavierjh/Dropbox/Stanford/TA files/Prog Camp/Diego/2020/"
cd "C:\Users\email\Dropbox\Prog Camp\Diego\2021"

cap ssc install statastates
cap ssc install geodist
cap ssc install distinct

* OPEN THE DATASET -------------------------------------------------------------
import delimited restaurants.csv, encoding(utf8) clear
save restaurants, replace

* 1: UNDERSTANDING THE DATA ----------------------------------------------------
summ rating, detail

* 2: AVERAGE RATING BY DOLLAR SIGNS --------------------------------------------
*make string numeric 
encode pricelevel, gen(pricelevel_numeric)
g pricelevel_str = pricelevel
drop pricelevel 
rename pricelevel_numeric pricelevel
	
table pricelevel, statistic(mean rating) 

* 3: CLOSEST CAFES  ------------------------------------------------------------
generate latitudeClassroom = 37.428769
generate longitudeClassroom = -122.165958

geodist latitude longitude latitudeClassroom longitudeClassroom, generate(milesDistance) miles
format milesDistance %4.3f
list name milesDistance in 1/10

* 4: CHAINS --------------------------------------------------------------------
use restaurants, clear

/* step 1 of cleaning strings
keep all unique string name combinations, transform to lowercase and remove
apostrophes */
contract name
gen name_final = name // this is where the final name will be stored
gen name_lower = lower(name) // transform everything to lowercase
replace name_lower = subinstr(name_lower,"'","",.) // remove apostrophes

/* step 2 of cleaning strings
find all cases where two contiguous names are similar (defined as string1 can 
be contained fully within string2) */
sort name_lower
gen check = 0
replace check = 1 if (strpos(name_lower,name_lower[_n+1]) != 0 | strpos(name_lower[_n+1],name_lower) != 0) & _n != _N
replace check = 1 if (strpos(name_lower,name_lower[_n-1]) != 0 | strpos(name_lower[_n-1],name_lower) != 0) & _n != 1
list name if check, sep(1000) noobs


/* step 3 of cleaning strings 
manually propagate the changes listed in step 2
that gives us 34 new restaurants that belongs to chains (first group observations
into clusters, then keep the most frequent name within cluster, or the shortest) 
save into a new dataset to merge with final data*/
gen cluster_aux = 1 - check
gen cluster = sum(cluster_aux)
by cluster, sort: replace cluster = . if _n == 1

gsort cluster -_freq name
bysort cluster: replace name_final = name_final[1] if !missing(cluster)
drop check cluster_aux cluster name_lower

/* step 4 of cleaning strings 
repeat step 2 but now using only the first word in the name
the reason we do this is we noticed a few instances (e.g. ike's) where the
locations across the area have slightly different names, although they are 
obviously a chain */

bysort name_final: gen n = _n
bysort name_final: egen freq = sum(_freq)
drop _freq
reshape wide name, i(name_final) j(n) // we first store our prespecified names


gen name_lower = lower(name_final) 
replace name_lower = subinstr(name_lower,"'","",.) // remove apostrophes

split name_lower, gen(stub) // we remove the most common first words as stub as they flag false positives
replace stub1 = stub2 if inlist(stub1,"the","las","taco","tacos","pho","vino")
replace stub1 = stub2 if inlist(stub1,"le","el","cafe","la","il","sushi","taqueria")
replace stub1 = stub2 if inlist(stub1,"tea","little","ristorante","st","blue","black")
replace stub1 = stub2 if inlist(stub1,"chef","china","corner","donut","bistro","falafel")
sort stub1 stub2

gen check = 0
replace check = 1 if (strpos(stub1,stub1[_n+1]) != 0 | strpos(stub1[_n+1],stub1) != 0) & _n != _N
replace check = 1 if (strpos(stub1,stub1[_n-1]) != 0 | strpos(stub1[_n-1],stub1) != 0) & _n != 1
list name_final if check, sep(1000) noobs

/* step 5 of cleaning strings 
manually propagate list of restaurants we found --- gives us 30 new restaurants */
replace name_final = "Armadillo Willy's Ranch Grill" if name_final == "Armadillo Willy's Ranch Grill"
replace name_final = "Chef Zhao Bistro" if name_final == "Chef Zhao Kitchen"
replace name_final = "Crepevine" if name_final == "Crepe Vine"
replace name_final = "Dish n Dash" if name_final == "Dishdash"
replace name_final = "El Grullense" if name_final == "El Grullense Grill"
replace name_final = "El Grullense" if name_final == "El Grullense E & E"
replace name_final = "El Grullense" if name_final == "El Grullense II"
replace name_final = "Erik's DeliCafe" if name_final == "Erik's DeliCafe Mountain View Grant St."
replace name_final = "Erik's DeliCafe" if name_final == "Erik's DeliCafe Mountain View Charleston Road"
replace name_final = "Erik's DeliCafe" if name_final == "Erik's DeliCafe Redwood City"
replace name_final = "Ike's" if name_final == "Ike's Cold"
replace name_final = "Ike's" if name_final == "Ike's Lair"
replace name_final = "Ike's" if name_final == "Ike's Place"
replace name_final = "Izzy's" if name_final == "Izzy's Brooklyn Bagels"
replace name_final = "Izzy's" if name_final == "Izzy's San Carlos CA"
replace name_final = "L&L Hawaiian Barbeque" if name_final == "L & L Hawaiian Barbecue"
replace name_final = "Little India" if name_final == "Little India cafe"
replace name_final = "Little India" if name_final == "Little India Restaurant"
replace name_final = "Los Altos Grill" if name_final == "Los Altos Bar & Grill"
replace name_final = "Lulu's" if name_final == "LuLu's on Main Street"
replace name_final = "Lulu's" if name_final == "Lulu's on the Alameda"
replace name_final = "Patxi's Pizza" if name_final == "Patxi's Chicago Pizza"
replace name_final = "Peet's Coffee & Tea" if name_final == "Peet's Coffee & Tea- Redwood City"
replace name_final = "Sajj" if name_final == "Sajj Street Eats"
replace name_final = "Su Hong" if name_final == "Su Hong To Go"
replace name_final = "Su Hong" if name_final == "Su Hong Eatery-Palo Alto"
replace name_final = "Subway" if name_final == "Subway Store # 48336-0"
replace name_final = "Tacos El Grullense" if name_final == "Taqueria El Grullense"
replace name_final = "The Refuge" if name_final == "Refuge"
replace name_final = "Wildberry Yogurt" if name_final == "Wild Berry Yogurt"

drop stub* check name_lower freq
gen id_obs = _n
reshape long name, i(id_obs) j(aux_var)
drop id_obs aux_var
drop if name == ""

merge 1:m name using restaurants, assert(3) nogenerate

/* step 6 of cleaning strings
remove locations that are duplicates based on the distance coordinates.
we define a restaurant to be duplicate if the closest neighbor within the 
same chain is less than 100 meters away */
egen branchGroup = group(name_final)
bysort name_final: gen totalBranches = _N
bysort name_final: gen branchNumber = _n

keep if totalBranches > 1

expand 2 // we will compute all pairwise distances using nnmatch
bysort placeid: gen n = _n
gen treatment = n - 1

* hack -- we don't care about the Treatment Effects but that generates the nearest neighbors 
* (in euclidean distance) without having to manually do it
capture teffects nnmatch ///
	(placeid latitude longitude) ///
	(treatment), nneighbor(2) ematch(branchGroup) osample(overlap)
qui teffects nnmatch ///
	(placeid latitude longitude) ///
	(treatment) if !overlap, nneighbor(2) ematch(branchGroup) gen(nneighbor) // 

gen latitudeClosest = latitude[nneighbor2] // closest neighbor is stored in 2nd obs
gen longitudeClosest = longitude[nneighbor2]
gen placeidClosest = placeid[nneighbor2]

drop n treatment overlap nneighbor*
duplicates drop

sort branchGroup // for chains with only 2 restaurants, nnmatch doesn't work so do it manually
foreach var in latitude longitude placeid {
	by branchGroup: replace `var'Closest = `var'[1] if totalBranches == 2 & _n == 2
	by branchGroup: replace `var'Closest = `var'[2] if totalBranches == 2 & _n == 1 
}

geodist latitude longitude latitudeClosest longitudeClosest, generate(distanceClosest) miles
gen duplicate = distanceClosest <= .1
sort branchGroup distanceClosest
bysort branchGroup duplicate: gen n = _n
drop if n == 2 & duplicate == 1
drop n duplicate *Closest branchGroup totalBranches branchNumber

/* step 7 of locating chains
do the simple thing and list branches in the cleaned data */
egen branchGroup = group(name_final)
bysort name_final: gen totalBranches = _N
bysort name_final: gen branchNumber = _n
keep if totalBranches > 1

distinct branchGroup placeid

/* step 8 computing results */
tab name_final, plot sort // list biggest chains
gen topChain = inlist(name_final,"Starbucks", "Subway", "McDonald's", "Peet's Coffee & Tea", "Baskin-Robbins", "Round Table Pizza")
reg rating ibn.topChain , nocons // chains are rated worse than non top chains


* 6: OTHER CAFES BESIDES COUPA -------------------------------------------------
use restaurants, clear

gen Cafe = 0
foreach var of varlist cuisine* {
	replace Cafe = 1 if `var' == "Cafe"
}

generate latitudeClassroom = 37.428769
generate longitudeClassroom = -122.165958
geodist latitude longitude latitudeClassroom longitudeClassroom, generate(milesDistance) miles
keep if Cafe
sort milesDistance
list name in 1/10


* 7: CONSTRUCTING REGRESSORS  --------------------------------------------------
import delimited using ratings, encoding(utf8) delimiter(",") bindquotes(strict) maxquotedrows(100) clear

foreach var in Great Friendly Fresh Ok {
	gen is`var' = strpos(lower(text + " " + title),lower("`var'")) != 0
}



* 7: CORRELATION WITH RATINGS  -------------------------------------------------
merge m:1 placeid using restaurants, keepusing(pricelevel) assert(2 3) nogenerate keep(3)
encode pricelevel, gen(priceLevelEncoded)

eststo clear
eststo: reg rating is* 
eststo: reg rating is* i.priceLevelEncoded

estout, cells(b(fmt(3)) se(par)) ///
	stat(N r2, label("observations" "r-squared") fmt(0 3)) ///
	keep(is*) ///
	indicate(price level fixed effects = 1.priceLevelEncoded) ///
	style(smcl)  varwidth(25) numbers

	
* 8: THE HARSHNESS HYPOTHESIS --------------------------------------------------


import delimited using ratings, encoding(utf8) delimiter(",") bindquotes(strict) maxquotedrows(100) clear
keep placeid rating userlocation

/* step 1:
split string and mark user locations */
split userlocation, parse(",")

* For non-US, this is just iterating over the parsed user locations
foreach var in Mexico India Japan China Italy France {
	gen userFrom`var' = 0
	forvalues j = 1/3 {
		replace userFrom`var' = 1 if strpos(lower(userlocation`j'),lower("`var'")) != 0 & userFrom`var' == 0
	}
}

* For the US case, you need to also check for abbreviations, useful to include statastates
gen userFromUS = 0
forvalues j = 1/3 {
	replace userFromUS = 1 if strpos(lower(userlocation`j'),lower("United States")) != 0 & userFromUS == 0
}

forvalues j = 1/3 {

	* Look for any of the states in the US
	gen aux = strtrim(userlocation`j')

	statastates,  name(aux) 

	replace userFromUS = 1 if _merge == 3
	drop if _merge == 2
	drop _merge state_*

	* Look for abbreviations
	statastates,  abbreviation(aux) 

	replace userFromUS = 1 if _merge == 3
	drop if _merge == 2
	drop _merge state_* aux

}

/* step 2:
merge restaurant data to keep the cuisine information and mark restaurants */
merge m:1 placeid using restaurants, assert(2 3) keep(3) nogenerate keepusing(cuisine*)

foreach var in Mexican Indian Japanese Chinese American Italian French {
	gen cuisine`var' = 0
	forvalues j = 0/7 {
		replace cuisine`var' = 1 if strpos(lower(cuisine`j'),lower("`var'")) != 0 & cuisine`var' == 0
	}	
}

/* step 3:
make a table with results (with program syntax) */
capture program drop show_results
program show_results
	syntax, cuisine(string) user(string)
	
	table cuisine`cuisine' if userFrom`user', statistic(freq) stat(mean rating) stat(sd rating)
	table userFrom`user' if cuisine`cuisine', statistic(freq) stat(mean rating) stat(sd rating)

end

show_results, cuisine(Mexican) user(Mexico) 
show_results, cuisine(Indian) user(India) 
show_results, cuisine(Japanese) user(Japan) 
show_results, cuisine(Chinese) user(China) 
show_results, cuisine(American) user(US) 
show_results, cuisine(Italian) user(Italy) 
show_results, cuisine(French) user(France) 
