--
-- MIT No Attribution
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this
-- software and associated documentation files (the "Software"), to deal in the Software
-- without restriction, including without limitation the rights to use, copy, modify,
-- merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
-- PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--

CREATE DATABASE IF NOT EXISTS iptracker;
USE iptracker;
CREATE TABLE IF NOT EXISTS hits(ip varchar(20),
                  time DATETIME DEFAULT CURRENT_TIMESTAMP
);
call mysql.rds_set_configuration('binlog retention hours', 24);
GRANT ALTER, CREATE, DROP, INDEX, INSERT, UPDATE, DELETE, SELECT ON myschema.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON awsdms_control.* TO 'admin'@'%';
