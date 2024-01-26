/// Name Functions

// Get Class name
function class_name(ID)
{
	var a = ["Frigate", "Cruiser", "Scout", "Fighter", "Ranger", "Carrier", "Recon"];
	return a[ID];
}

// Random Character name
function char_name()
{
	var a = ["Carl", "Matthew", "Marcus", "Eric", "Mark", "Jeff", "Jones",
             "Jasper", "Chris", "Lee", "Ross", "Albert", "Travis", "Harold",
             "Henry", "Hank", "Rufus", "Scott", "Dominic", "Nathan", "John",
             "Hugh", "Robin", "Michael", "Noah", "Curtis", "Thomas", "Andy",
             "Robert", "Will", "Neil", "Joseph", "Caesar", "Jake", "Bobert",
			 
			 "Kris"];
	return a[irandom_range(0, array_length(a) - 1)];
}