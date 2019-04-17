#
# MIT No Attribution
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
if [ $# -ne 6 ]; then
  echo "Usage: $0 <mysql host> <mysql user> <bootstrap bucket> <bootstrap prefix> <region where bootstrap code is> <imageurl>"
  exit 1
fi

# Retrieve the SQL file that will create the table
wget https://s3.$5.amazonaws.com/$3/$4createIPTable.sql

# Execute the SQL - note, yes the password is hardcoded to make this easy to understand - this violates the Security Pillar of Well-Architected!
mysql -h $1 -u $2 -pfoobar123 <createIPTable.sql

# Retrieve the executable web server
wget https://s3.$5.amazonaws.com/$3/$4FragileWebApp

# Change the owner and group and make it executable
chown root FragileWebApp
chgrp root FragileWebApp
chmod +x FragileWebApp

# Run this with the logging and errors swallowed so it doesn't fill the tiny disk provisioned (also violates the Security Pillar of Well-Architected!)
nohup ./FragileWebApp --endpoint $1 --imageurl $6 > /dev/null 2>/dev/null &
