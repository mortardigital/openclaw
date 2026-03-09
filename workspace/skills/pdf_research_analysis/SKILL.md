---
name: pdf_research_analysis
description: Analyze and extract structured knowledge from research PDFs.
metadata:
  openclaw:
    requires:
      bins:
        - python3
---
\# PDF Research Analysis
Use this skill when reading academic papers.
Workflow:
1\. Extract PDF text.
python extract\_pdf.py <file>
2\. Identify sections:
\- Title
\- Authors
\- Abstract
\- Methodology
\- Results
\- Limitations
3\. Produce structured summary.
Rules:
\- Never fabricate metadata.
\- Only report content visible in the document.
\- Quote evidence when possible.
