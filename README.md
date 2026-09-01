# Bioinformatics & Data Science Portfolio

A multi-module repository demonstrating end-to-end genomic data processing, machine learning, and statistical visualization. 

This portfolio emphasizes **reproducibility**, **fault-tolerant pipeline orchestration**, and **publication-ready data visualization**. Scripts are engineered to handle API timeouts and environment path variables gracefully, ensuring consistent execution across different local environments.

## Technical Stack
* **Languages:** R, Bash, Python
* **Genomics Tools:** GATK (Mutect2), Bowtie, Cutadapt, Rsamtools
* **Data Science & ML:** ggplot2, caret, e1071 (SVM), pheatmap
* **Methodologies:** Defensive programming (`tryCatch`), REST API integration, Mock data simulation for rapid testing

---

## Project Modules

### 1. `cancer_variants/` | Somatic Variant Calling & Clinical Annotation
Orchestrates a GATK Mutect2 pipeline to identify somatic variants in tumor/normal samples.
* Queries the live MyVariant.info REST API natively in R to annotate variants with clinical significance.
* Generates a publication-quality clinical landscape lollipop plot explicitly highlighting driver mutations (e.g., EGFR, TP53).

### 2. `mirnaseq/` | Small RNA Alignment & Fault-Tolerant Orchestration
An end-to-end workflow inspired by Kapoor et al. (2020), orchestrated entirely via R.
* Automates dynamic reference downloading and adapter trimming via Cutadapt.
* Implements rigorous fail-safes (synthetic fallback generation) to bypass local environment failures.
* Uses Bioconductor (`Rsamtools`) to read binary BAM alignments directly into R memory for downstream visualization.

### 3. `ML/` | Supervised & Unsupervised Machine Learning
Applies standard machine learning architectures to biological classification problems.
* **Supervised:** Trains a Support Vector Machine (linear SVM) to classify species, complete with confusion matrix evaluation.
* **Unsupervised:** Determines optimal clusters via the elbow method and applies K-means clustering (PCA-visualized) to discover unlabelled groupings.

### 4. `rnaseq/` | Differential Expression Visualization
* Simulates normalized read count matrices for control vs. treatment cohorts.
* Applies complete-linkage hierarchical clustering using Euclidean distance.
* Generates a highly customized `pheatmap` to visualize gene co-regulation blocks.