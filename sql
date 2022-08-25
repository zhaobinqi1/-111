SELECT 1;
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE [Users] (
  [UserName] text NOT NULL
, [Password] text NOT NULL
, [Level] text NOT NULL
, CONSTRAINT [sqlite_autoindex_Users_1] PRIMARY KEY ([UserName])
);
INSERT INTO [Users] ([UserName],[Password],[Level]) VALUES (
'100','1','Admin');
COMMIT;
