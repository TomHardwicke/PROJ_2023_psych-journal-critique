# Data variables

### In articles.csv:

- *article id*: corresponds to row number (excluding header)

- *primary coder*: initials of first data curator

- *secondary coder*: initials of subsequent data curator

- *doi, link, title, authors, journal, publication_year*: these columns were all pre-populated from the shuffled Web of Science lists (see prepareSample (this folder) and analysis/prepareSamples for details)

- *1_exclusion*: binary response from primary coder whether to 'retain' or 'exclude' based on inclusion criteria (see article Methods section for details)

- *1_exclusionReason*: primary coder reason for exclusion (where applicable)

- *1_Is article linked to PPC*: primary coder binary responses for included articles to indicate presence of a 'Linked' post-publication critique

- *1_Additional notes*: open response for primary coder comments about article

- *2_exclusion*: binary response from secondary coder whether to 'retain' or 'exclude' based on inclusion criteria (see article Methods section for details)

- *2_exclusionReason*: secondary coder reason for exclusion (where applicable)

- *2_Is article linked to PPC*: secondary coder binary responses for included articles to indicate presence of a 'Linked' post-publication critique

- *2_Additional notes*: open response for secondary coder comments about article

- *sample_id*: indicates whether the article was drawn from the 'prominent' journals list or selected at 'random' from a pool of all psychology articles published in 2020 (according to Web of Science database, some articles may have different years listed depending on online or in print publication)

### In journals.csv:

Responses generated through Google form (see 'Materials' folder on the OSF for full questionnaire). Unlike articles.csv where secondary coder responses are reported in additional columns, here each coder's response generate a new row.

- *Anything additional, unusual, or interesting to note?*: open response for coder comments about journal

- *Timestamp*: Date and time when response was recorded. Note, this is NA for all FINAL (TEH) entries as these were added manually after inspecting both primary and secondary coder responses  to resolve any disagreements.

- *Coder's Initials*: to identify which author entered the responses

- *Journal Name*: copied and pasted in all upper case to match other records containing the journals' names

- *Does the journal publish empirical research?*: binary Yes/No response based on coder assessment of the journals 'scope' and/or 'article types' (or equivalent) section. For archived versions of journal webpages, see 'Materials' folder. For definition of empirical articles, see section 3.2.1.2 of the Preregistered Protocol (https://osf.io/nqj7b)

- *Check the article types page and check for web comments ‚Äî does the journal offer any type of PPC?*: coder assessment of whether any listed article types fit our operational definition of post-publication critique (for details, see Supplementary Information B)

- *A. Enter the name of the PPC type offered by the journal*: verbatim name of any post-publication article type copied from the journal's website

- *A. Enter the verbatim description of this type of PPC provided by the journal*: copy-pasted from the journal's website

- *A. Are there any length limits for this type of PPC?*: 
	- YES answers should always include the stated limit, either numeric or qualitative, copied directly from the journal's website. These limits are harmonised into word-length in the analysis/preprocessing.Rmd file. For information on word limit conversion, see Supplementary Information G
	- NOT STATED: indicates no such limits were explicitly mentioned
	- NO: indicates an explicit statement that no such restrictions apply

- *A. Are there any time limits for submission of this type of PPC?*:
	- YES answers should always include the stated limit, either numeric or qualitative, copied directly from the journal's website. These limits are harmonised into weeks in the analysis/preprocessing.Rmd file. For information on time limit conversion, see Supplementary Information G
	- NOT STATED: indicates no such limits were explicitly mentioned
	- NO: indicates an explicit statement that no such restrictions apply

- *A. Are there any reference limits for this type of PPC?*:
	- YES answers should always include the stated limit, either numeric or qualitative, copied directly from the journal's website. Quantitative limits were not converted, qualitative limits were recoded as 'qualitative' in analysis/preprocessing.Rmd
	- NOT STATED: indicates no such limits were explicitly mentioned
	- NO: indicates an explicit statement that no such restrictions apply

- *A. Is this type of PPC sent for independent external peer review?*:
	- YES answers should always include the stated policy copied directly from the journal's website. 
	- NOT STATED: indicates no such procedure was explicitly mentioned
	- NO: indicates an explicit statement that no such procedure in in place

- *A. Anything additional, unusual, or interesting to note?*:
	- Section for open response for coders to add comments

- *A. Are there any other types of PPC in this journal? (Remember to check for web comments!)*:
	- Binary YES/NO response 
	- YES: prompts a repeat of the above "A. ..." questions (appended with B. for second post-publication critique type, C. for third, etc.)
	- NO: submits form (responses recorded in this file)

- .*..38*: Blank column

- *sample_id*:  indicates whether the journal was drawn from the 'prominent' journals list or selected at 'random' from a pool of all psychology journals 

- *cope*: binary TRUE/FALSE responses indicating whether the journal is listed as a member of the Committee on Publication Ethics according to their website (https://publicationethics.org/membership)

- *field*: indicates what category and (where applicable) subcategory each journal belongs to according to the Web of Science database

- *jif*: the 2021 Journal Impact Factor according to Clarivate Journal Citation Reports.
