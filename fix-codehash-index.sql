CREATE TABLE mapping AS (
    SELECT DISTINCT ON(hash) id, hash
        FROM codeHash
);

ALTER TABLE codeHash ADD COLUMN realCodeHashID int;
UPDATE codeHash
    SET realCodeHashID=mapping.id
    FROM mapping
    WHERE codeHash.hash=mapping.hash;

ALTER TABLE main ADD COLUMN realCodeHashID int;
UPDATE main
    SET realCodeHashID=codeHash.realCodeHashID
    FROM codeHash
    WHERE main.codeHashID=codeHash.id;

ALTER TABLE main
    DROP CONSTRAINT main_codehashid_fkey;
DELETE FROM codeHash
    WHERE id != realCodeHashID;
ALTER TABLE codeHash
    DROP COLUMN realCodeHashID;
DROP TABLE mapping;
-- DROP TABLE codeHash;
-- ALTER TABLE mapping RENAME TO codeHash;
-- ALTER TABLE codeHash
--     ADD CONSTRAINT codeHash_pkey
--     PRIMARY KEY (id);

ALTER TABLE main DROP COLUMN codeHashID;
ALTER TABLE main RENAME realCodeHashID TO codeHashID;
ALTER TABLE main
    ADD CONSTRAINT main_codehashid_fkey
    FOREIGN KEY (codeHashID)
    REFERENCES codeHash(id);

CREATE UNIQUE INDEX idx_codeHash_hash ON codeHash(hash);
