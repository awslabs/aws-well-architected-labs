
from http.server import BaseHTTPRequestHandler, HTTPServer
from functools import partial
from ec2_metadata import ec2_metadata
import sys
import getopt
import boto3
import traceback

html = """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Resiliency Workshop</title>
    </head>
    <body>
        <h1>Enjoy some classic television</h1>
        <p>{Message}</p>
        <p>{Content}</p>
        <p><a href="{Link}">click here to go to other page</a></p>
    </body>
</html>"""


class RequestHandler(BaseHTTPRequestHandler):
    def __init__(self, client, *args, **kwargs):
        self.client = client
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

            message += "<h1>What to watch next....</h1>"
            # Call our service dependency
            # @TODO replace userid with a randomly generated user (or maybe user input)
            try:
                response = self.client.get_item(
                    TableName="services",
                    Key={
                        'servicename': {
                            'S': 'recommendationService',
                        },
                        'userId': {
                            'N': '1',
                        }
                    }
                )

                message += '<br>' + 'Your personalized recommendation: '
                # Parses value of recommendation from DynsmoDB JSON return value
                # {'Item': {
                #     'servicename': {'S': 'recommendationService'}, 
                #     'userId': {'N': '1'}, 
                #     'recommendation': {'S': 'M*A*S*H'},  ...
                tvshow = response['Item']['recommendation']['S']
                message += '<br>' + str(tvshow)

            # If our dependency fails, and we cannot make a personalized recommendation
            # then give a pre-selected (static) recommendation
            except Exception as e:
                message += '<br>' + 'Everyone enjoys this classic:  <b>I Love Lucy</b>'
                message += '<br><br><br><h2>Diagnostic Info:</h2>'
                message += '<br>We are unable to provide personalized recommendations'
                message += '<br>If this persists, please report the following info to us:'
                message += str(traceback.format_exception_only(e.__class__, e))


            # Send response status code
            self.send_response(200)

            # Send headers
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(
                bytes(
                    html.format(Content=message, Message="Data from the metadata API", Link=link),
                    "utf-8"
                )
            )

        elif self.path == '/healthcheck':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(bytes("<html><head><title>healthcheck</title></head>", "utf-8"))
            self.wfile.write(bytes("<body>success</body></html>", "utf-8"))

            # @TODO Add check for service dependency - if not available return 503 Service Unavailable.

        return


def run(argv):
    try:
        opts, args = getopt.getopt(
            argv,
            "h:p:",
            [
                "help"
                "server_port=",
            ]
        )
    except getopt.GetoptError:
        print('server.py -p <server_port>)
        sys.exit(2)
    print(opts)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -p <server_port> ')
            sys.exit()
        elif opt in ("-p", "--server_port"):
            server_port = int(arg)

    # Setup client for DDB -- we will use this to similate a service dependency
    client = boto3.client('dynamodb', ec2_metadata.region)

    print('starting server...')
    server_address = ('0.0.0.0', server_port)

    handler = partial(RequestHandler, client)
    httpd = HTTPServer(server_address, handler)
    print('running server...')
    httpd.serve_forever()


if __name__ == "__main__":
    run(sys.argv[1:])