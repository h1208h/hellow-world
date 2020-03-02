import sys

filename=sys.argv[1]
f=open(filename,"r")
g=open("%s_table.txt"%filename.split(".")[0],"w")

for line in f:
	if line.startswith(">"):
		header=line.strip()
		newheader=header.replace(">","")
		replicate=newheader.split("_")[-1]
		biom_table=newheader+"\t"+replicate
		g.write(biom_table+"\n")
