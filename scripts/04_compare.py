import sys
txt = open(sys.argv[1]).read().strip().split(">")[1:]
aln = {r.split("\n")[0].split()[0]: "".join(r.split("\n")[1:]).upper() for r in txt}
ours = sorted(k for k in aln if k.startswith("SRR"))
theirs = sorted(k for k in aln if not k.startswith("SRR"))
def d(x, y): return [a != b for a, b in zip(x, y) if a in "ACGT" and b in "ACGT"]
print("ours\t" + "\t".join(theirs))
print("\n".join(o + "\t" + "\t".join(str(sum(d(aln[o], aln[t]))) + "/" + str(len(d(aln[o], aln[t]))) for t in theirs) for o in ours))
