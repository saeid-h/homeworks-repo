-- GP2_Problem1_Group 16

-- Creating index for the column YEARS_OF_EXPERIENCE from table PERFORMER
CREATE INDEX PE_INDEX ON PERFORMER(YEARS_OF_EXPERIENCE);

-- The query that will take advantage of using an index in PERFORMER for YEARS_OF_EXPERIENCE will be the following:

SELECT DISTINCT Pe.Pname FROM DIRECTOR Di, Movie Mo, Acted Ac, Performer Pe 
WHERE Di.DID = Mo.DID and Mo.MNAME = Ac.MNAME and Pe.PID = Ac.PID and Pe.YEARS_OF_EXPERIENCE >= 20 and Di.dname = 'Black';

/* 
EXPLANATIONS:
- This table and search key are chosen because we have numbers which can be sorted to optimize the retrieval time. 
- This index is a SECONDARY INDEX, because it was not made in the search key, but in other attribute
- As a comment, we can say that this is a range search with respect of YEARS_OF_EXPERIENCE, we would prefer to use a B+- index for this column.
*/

