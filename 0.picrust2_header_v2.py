import sys

filename=sys.argv[1]
f=open(filename,"r")
g=open("%s_picrust2_header.fna"%filename.split(".")[0],"w")

for line in f:
	line=line.strip()
	if line.startswith(">"):
		genus_score=float(line.split(":")[-1])
		number_of_amplicon=str(line.split("|")[1].split("_")[0])
		if genus_score >= 0.8 :
			line=line.replace('+','_')
			line=line.replace('.','_')
			line=line.replace('|','_')
			line=line.replace(':','_')
			line=line.replace('=','_')
			line=line.replace('"','')
			line=line.replace('-','_')
			g.write(line+"_"+number_of_amplicon+"\n")
			g.write(next(f))

			#print (line)
