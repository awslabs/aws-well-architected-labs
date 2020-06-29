from http.server import BaseHTTPRequestHandler, HTTPServer
from functools import partial
from ec2_metadata import ec2_metadata
import sys
import getopt
import pymysql
html = """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Resiliency Workshop!</title>
    </head>
    <body>
        <h1>Welcome to the Resiliency Workshop!</h1>
        <p>{Message}</p>
        <p>{Content}</p>
        <p><a href="{Link}">click here to go to other page</a></p>
        <img src="{WebSiteImage}" alt="" width="700">
    </body>
</html>"""
class RequestHandler(BaseHTTPRequestHandler):
    def __init__(self, url_image, db_host, db_user, db_pswd, db_name, *args, **kwargs):
        self.url_image = url_image
        self.db_host = db_host
        self.db_user = db_user
        self.db_pswd = db_pswd
        self.db_name = db_name
        super().__init__(*args, **kwargs)

    def _execute_db_sql(self, sql, return_results=False):
        db = pymysql.connect(self.db_host, self.db_user, self.db_pswd, self.db_name)
        try:
            with db.cursor() as cursor:
              cursor.execute(sql)
              results = cursor.fetchall() if return_results else None
              db.commit()
        finally:
            db.close()
        return results

    def do_GET(self):
        print("path: ", self.path)
        if self.path == '/':
            link = "data"
            try:
                message_parts = [
                    'account_id: %s' % ec2_metadata.account_id,
                    'ami_id: %s' % ec2_metadata.ami_id,
                    'availability_zone: %s' % ec2_metadata.availability_zone,
                    'instance_id: %s' % ec2_metadata.instance_id,
                    'instance_type: %s' % ec2_metadata.instance_type,
                    'private_hostname: %s' % ec2_metadata.private_hostname,
                    'private_ipv4: %s' % ec2_metadata.private_ipv4
                ]
                message = '<br>'.join(message_parts)
            except Exception:
                message = "Running outside AWS"
            # Write data into the Database
            sql = "INSERT INTO hits(ip) VALUES ('{IPAddress}')".format(IPAddress=self.client_address[0])
            self._execute_db_sql(sql, return_results=False)
            # Send response status code
            self.send_response(200)
            # Send headers
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(
                bytes(
                    html.format(Content=message, WebSiteImage=self.url_image, Message="Data from the metadata API", Link=link),
                    "utf-8"
                )
            )
        elif self.path == '/data':
            link = ".."
            sql = "SELECT * from hits order by time desc limit 10"
            results = self._execute_db_sql(sql, return_results=True)
            message = []
            for row in results:
                ip = row[0]
                time = row[1]
                message.append("ip = %s   time = %s" % (ip, time))
            msg = '<br>'.join(message)
            self.send_response(200)
            # Send headers
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(
                bytes(
                    html.format(Content=msg, WebSiteImage="", Message="Data from the Database", Link=link),
                    "utf-8"
                )
            )
        return
def run(argv):
    image_url = "https://s3.us-east-2.amazonaws.com/arc327-well-architected-for-reliability/Cirque_of_the_Towers.jpg"
    try:
        opts, args = getopt.getopt(
            argv,
            "h:u:p:s:w:d:o:",
            [
                "help"
                "image_url=",
                "server_port=",
                "db_user=",
                "db_pswd=",
                "db_name=",
                "db_host=",
            ]
        )
    except getopt.GetoptError:
        print('server.py -u <image_url> -p <server_port> -s <db_user> -w <db_pswd> -d <db_name> -o <db_host>')
        sys.exit(2)
    print(opts)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -u <image_url> -p <server_port> -s <db_user> -w <db_pswd> -d <db_name> -o <db_host>')
            sys.exit()
        elif opt in ("-u", "--image_url"):
            image_url = arg
        elif opt in ("-p", "--server_port"):
            server_port = int(arg)
        elif opt in ("-s", "--db_user"):
            db_user = arg
        elif opt in ("-w", "--db_pswd"):
            db_pswd = arg
        elif opt in ("-d", "--db_name"):
            db_name = arg
        elif opt in ("-o", "--db_host"):
            db_host = arg
    # Setup DB
    print(db_host, db_user, db_pswd, db_name)
    print('starting server...')
    server_address = ('0.0.0.0', server_port)
    handler = partial(RequestHandler, image_url, db_host, db_user, db_pswd, db_name)
    httpd = HTTPServer(server_address, handler)
    print('running server...')
    httpd.serve_forever()
if __name__ == "__main__":
    run(sys.argv[1:])
