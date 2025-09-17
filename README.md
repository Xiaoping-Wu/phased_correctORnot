## Verify phased data by trio samples

### Concept

	•	Phasing determines which alleles come from the same chromosome (haplotype).
	•	Trio information provides a natural reference:
	•	Each child allele must match one allele from the mother and one from the father.
	•	Mendelian inheritance violations indicate either genotyping errors or phasing errors.

### Steps to verify phasing with trios

Step 1: Identify heterozygous sites
	•	Focus on heterozygous SNPs in the child, because homozygous sites are uninformative for phasing.

Step 2: Compare with parental genotypes
	•	For each heterozygous child SNP:
	•	If the mother is heterozygous AB and father is homozygous AA, the child should inherit A from father and either A or B from mother.
	•	Phasing check:
	•	Phased child haplotypes should reflect one haplotype matching maternal alleles, the other matching paternal alleles.

Step 3: Count switch errors
	•	A switch error occurs when consecutive SNPs are phased incorrectly between parental haplotypes:
	•	Example: if haplotype 1 of the child starts matching father but suddenly switches to maternal alleles without a recombination event, that’s a switch error.

Step 4: Detect Mendelian inconsistencies
	•	If the child carries an allele not present in either parent, that indicates: Genotyping error, or Rare de novo mutation.
	•	For phasing verification, Mendelian-consistent sites are the focus.

### Tools for trio-based phasing validation

	•	PLINK: can detect Mendelian inconsistencies (--mendel) and output basic statistics.
	•	HapCUT2 / SHAPEIT / Eagle:

### What I did here

Here I do Visual check by:
1. select a small region and convert to vcf file;
2. Identify heterozygous SNPs in the child;
3. compare child, mother and father genotype  manually/visually



