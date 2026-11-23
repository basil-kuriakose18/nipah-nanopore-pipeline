import sys
txt = open(sys.argv[1]).read().strip().split(">")[1:]
aln = {r.split("\n")[0].split()[0]: "".join(r.split("\n")[1:]).upper() for r in txt}
f = lambda s: next(i for i, c in enumerate(s) if c != "-") + 1
print("\n".join(k + "\tfirst_col=" + str(f(v)) + "\tlast_col=" + str(len(v.rstrip("-"))) + "\tACGT=" + str(sum(c in "ACGT" for c in v)) + "\tN=" + str(v.count("N")) for k, v in sorted(aln.items())))
