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
    def __init__(self, url_image, db, *args, **kwargs):
        self.url_image = url_image
        self.db = db
        super().__init__(*args, **kwargs)

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
            self.cursor = self.db.cursor()
            sql = "INSERT INTO hits(ip) VALUES ('{IPAddress}')".format(IPAddress=self.client_address[0])
            self.cursor.execute(sql)
            self.db.commit()

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

            self.cursor = self.db.cursor()
            sql = "SELECT * from hits order by time desc limit 10"
            self.cursor.execute(sql)

            results = self.cursor.fetchall()
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
    image_url = "https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/images/Cirque_of_the_Towers.jpg"
    try:
        opts, args = getopt.getopt(
            argv,
            "hu:p:s:w:d:o:",
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
        if opt in ("-h", "--help"):
            print('server.py -u <image_url> -p <server_port> -s <db_user> -w <db_pswd> -d <db_name> -o <db_host>')
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
    db = pymysql.connect(host=db_host, user=db_user, password=db_pswd, database=db_name)

    print('starting server...')
    server_address = ('0.0.0.0', server_port)

    handler = partial(RequestHandler, image_url, db)
    httpd = HTTPServer(server_address, handler)
    print('running server...')
    httpd.serve_forever()


if __name__ == "__main__":
    run(sys.argv[1:])
