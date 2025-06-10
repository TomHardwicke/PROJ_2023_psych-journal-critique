# Data variables

Both d_articles.csv and d_journals,csv represent processed versions of the two data sheets in the 'primary' folder. See 'analysis/preprocessing.Rmd' to reproduce data cleaning process. 

### In d_articles.csv:

- *sample_id*: indicates whether the article was drawn from the 'prominent' journals list or selected at 'random' from a pool of all psychology articles published in 2020 (according to Web of Science database, some articles may have different years listed depending on online or in print publication)

- *article_id*: corresponds to row number (excluding header) for easy identification with the articles' full details in the 'primary' folder. 

- *exclude*: binary response from primary coder whether to 'retain' or 'exclude' based on inclusion criteria (see article Methods section for details)

- *exclude_reason*: primary coder reason for exclusion (where applicable)

- *ppc_linked*: primary coder binary responses for included articles to indicate presence of a 'Linked' post-publication critique

**Note**: while no such cases were found, if an article were itself to satisfy our operational definition of a post-publication critique (see Supplementary Information B), it would be recognisable by containing the exclude_reason "IS PPC". 


### In d_journals.csv:

- *sample_id*:  indicates whether the journal was drawn from the 'prominent' journals list or selected at 'random' from a pool of all psychology journals.

- *journal_name*: copied and pasted in all upper case to match other records containing the journals' names.

- *is_empirical*: binary TRUE/FALSE response based on coder assessment of the journals 'scope' and/or 'article types' (or equivalent) section. For archived versions of journal webpages, see 'Materials' folder. For definition of empirical articles, see section 3.2.1.2 of the Preregistered Protocol (https://osf.io/nqj7b).

- *has_ppc*: final decision of whether any listed article types fit our operational definition of post-publication critique (for details, see Supplementary Information B)
	- NO IMPLICIT: no clear post-publication critique types listed
	- YES: explicit statement or post-publication critique article types listed
	- NO EXPLICIT: journal 'scope' or 'article types' contains statement that post-publication critiques will not be accepted.

- *ppc_type*: responses 'A', 'B', or 'C' correspond to the first, second, and third responses given by coders in the Google form (see 'Materials' folder) regarding post-publication critique types listed by a single journal.

- *ppc_name*: harmonised names of any post-publication article type copied from the journal's website as 'Commentary', 'Letters', 'Web comments', or 'Other'. For details on how names were harmonised, see Supplementary Information G. 

- *ppc_description*: verbatim description of any post-publication critique article type from the journal's website

- *ppc_length*: indicates length limits imposed on the post-publication critiques
	- NOT STATED: indicates no such limits were explicitly mentioned
	- Qualitative: indicates a non-numeric restriction (e.g., 'brief', 'short')
	- Numeric values correspond to word length. For information on word limit conversion, see Supplementary Information G.

- *ppc_time*: indicates time-to-submit limits imposed on the post-publication critiques
	- NOT STATED: indicates no such limits were explicitly mentioned
	- Qualitative: indicates a non-numeric restriction (e.g., 'timely', 'recent')
	- Numeric values correspond to weeks. For information on time limit conversion, see Supplementary Information G.

- *ppc_ref*: indicates reference limits imposed on the post-publication critiques
	- NOT STATED: indicates no such limits were explicitly mentioned
	- Qualitative: indicates a non-numeric restriction (e.g., 'some', 'few')
	- Numeric values correspond to number of references allowed by journal policy

- *ppc_review*: indicates whether post-publication critiques are sent for independent external peer review (reviewed not by journal editors or target article authors)
	- YES: they are sent for review
	- NOT STATED: indicates no such procedure was explicitly mentioned
	- NO: indicates an explicit statement that no such procedure in in place

- *cope*: binary TRUE/FALSE responses indicating whether the journal is listed as a member of the Committee on Publication Ethics according to their website (https://publicationethics.org/membership)

- *field*: indicates what category and (where applicable) subcategory each journal belongs to according to the Web of Science database

- *jif*: the 2021 Journal Impact Factor according to Clarivate Journal Citation Reports.
