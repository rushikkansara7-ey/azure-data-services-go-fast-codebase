﻿SELECT DISTINCT
    c.COLUMN_ID,
    c.COLUMN_NAME, 
    c.DATA_TYPE,
    CAST(CASE c.NULLABLE WHEN 'Y' THEN 1 ELSE 0 END as NUMBER (3)) AS IS_NULLABLE, 
    c.DATA_PRECISION AS NUMERIC_PRECISION, 
    c.DATA_LENGTH AS CHARACTER_MAXIMUM_LENGTH, 
    c.DATA_SCALE AS NUMERIC_SCALE,  
    CAST(CASE c.IDENTITY_COLUMN WHEN 'YES' THEN 1 ELSE 0 END as NUMBER (3)) AS IS_IDENTITY,
    CAST(CASE c.VIRTUAL_COLUMN WHEN 'YES' THEN 1 ELSE 0 END as NUMBER (3)) AS IS_COMPUTED,
    CAST(CASE tc.CONSTRAINT_TYPE WHEN 'P' THEN 1 WHEN 'R' THEN 1 WHEN 'U' THEN 1 ELSE 0 END as NUMBER (3)) AS KEY_COLUMN,
    CAST(CASE tc.CONSTRAINT_TYPE WHEN 'P' THEN 1 ELSE 0 END as NUMBER (3)) AS PKEY_COLUMN
FROM ALL_TAB_COLS c
LEFT OUTER JOIN
    (SELECT Col.OWNER, Col.TABLE_NAME, Col.COLUMN_NAME, Tab.CONSTRAINT_TYPE
    FROM
        all_constraints Tab,
        all_cons_columns Col
    WHERE
        Col.table_name = Tab.table_name
        AND (Tab.constraint_type = 'P' OR Tab.constraint_type = 'R' OR Tab.constraint_type = 'U')
        AND Tab.constraint_name = Col.constraint_name
        AND Tab.owner = Col.owner) tc
ON c.OWNER = tc.OWNER and c.TABLE_NAME = tc.TABLE_NAME and c.COLUMN_NAME = tc.COLUMN_NAME
WHERE c.TABLE_NAME = UPPER('{tableName}') AND c.OWNER = UPPER('{tableSchema}') AND c.COLUMN_ID IS NOT NULL
ORDER BY COLUMN_ID