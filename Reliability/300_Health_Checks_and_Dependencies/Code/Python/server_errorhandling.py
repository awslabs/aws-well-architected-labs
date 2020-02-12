# This is a simple test server for use with the Well-Architected labs
# It simulates an engine for recommending TV shows

from http.server import BaseHTTPRequestHandler, HTTPServer
from functools import partial
from ec2_metadata import ec2_metadata
import sys
import getopt
import boto3
import traceback
import random

# html code for the default page served by this server
html = """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Resiliency Workshop</title>
    </head>
    <body>
        <h1>Enjoy some classic television</h1>
        <p>{Content}</p>
    </body>
</html>"""

# RequestHandler: Response depends on type of request made
class RequestHandler(BaseHTTPRequestHandler):
    def __init__(self, region, *args, **kwargs):
        self.region = region
        super().__init__(*args, **kwargs)

    def do_GET(self):
        print("path: ", self.path)


        # Default request URL without additional path info)
        if self.path == '/':

            # It would be more efficient to create the clients once on init
            # But in the lab we change permissions on the EC2 instance
            # and this way we are sure to pick up the new credentials
            session = boto3.Session()

            # Setup client for DDB -- we will use this to mock a service dependency
            ddb_client = session.client('dynamodb', self.region)

            # Setup client for SSM -- we use this for parameters used as switches 
            # in the lab
            ssm_client = session.client('ssm', region_name=self.region)

            message = "<h1>What to watch next....</h1>"

            # Call our service dependency
            # This currently uses a randomly generated user.
            # In the future maybe allow student to supply the user ID as input

            # Generate User ID between 1 and 4
            userId = str(random.randint(1, 4))

            # configure if mocked recomendation service is enabled or if it should simulate
            # disabled (unreachable)
            value = ssm_client.get_parameter(Name='RecommendationServiceEnabled')
            dependency_enabled = value['Parameter']['Value'] == "true"
            table_name = "serviceCallMocks" if dependency_enabled else "dependencyShouldFail"

            # Error handling:
            # surround the get_item call in a try catch

            try:
                # Call the recommendation service 
                # (actually just a simply lookup in a DynamoDB table, which is acting as a mock for the recommendation service)
                # If this call to the dependency fails, then the entire request fails
                response = ddb_client.get_item(
                    TableName=table_name,
                    Key={
                        'ServiceAPI': {
                            'S': 'getRecommendation',
                        },
                        'UserID': {
                            'N': userId,
                        }
                    }
                )

                # Parses value of recommendation from DynamoDB JSON return value
                # {'Item': {
                #     'ServiceAPI': {'S': 'getRecommendation'}, 
                #     'UserID': {'N': '1'}, 
                #     'Result': {'S': 'M*A*S*H'},  ...
                tv_show = response['Item']['Result']['S']
                user_name = response['Item']['UserName']['S']
                message += recommendation_message (user_name, tv_show, True)

            # Error handling:
            # If the service dependency fails, and we cannot make a personalized recommendation
            # then give a pre-selected (static) recommendation
            except Exception as e:
                message += recommendation_message ('Valued Customer', 'I Love Lucy', False)
                message += '<br><br><br><h2>Diagnostic Info:</h2>'
                message += '<br>We are unable to provide personalized recommendations'
                message += '<br>If this persists, please report the following info to us:'
                message += str(traceback.format_exception_only(e.__class__, e))

            # Include Metadata which can be useful to students 
            # For example to see which instance /  AWS AZ they are hitting
            message += '<br/><h1>EC2 Metadata</h1>'
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
                message += '<br>'.join(message_parts)
            except Exception:
                message += "Running outside AWS"

            # Send response status code
            self.send_response(200)

            # Send headers
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(
                bytes(
                    html.format(Content=message),
                    "utf-8"
                )
            )

        return

# Utility function to consistently format how recommendations are displayed
def recommendation_message (user_name, tv_show, is_custom_reco):
    if is_custom_reco:
        tag_line = "your recommendation is"
    else:
        tag_line = "everyone enjoys this classic"
    cell1 = "<b>" + user_name + "</b>, " + tag_line + ":"
    cell2 = "<b>" + tv_show + "</b>"
    reco_msg = "<table border=\"5\"><tr>" + "<td>" + cell1 + "</td>" + "<td>" + cell2 + "</td>" + "</tr></table>"
    return reco_msg


# Initialize server
def run(argv):
    try:
        opts, args = getopt.getopt(
            argv,
            "h:p:r:",
            [
                "help"
                "server_port=",
                "region="
            ]
        )
    except getopt.GetoptError:
        print('server.py -p <server_port> -r <AWS region>')
        sys.exit(2)
    print(opts)

    # Default value - will be over-written if supplied via args
    server_port = 80
    try:
        region = ec2_metadata.region
    except:
        region = 'us-east-2'

    for opt, arg in opts:
        if opt == '-h':
            print('test.py -p <server_port> ')
            sys.exit()
        elif opt in ("-p", "--server_port"):
            server_port = int(arg)
        elif opt in ("-r", "--region"):
            region = arg


    print('starting server...')
    server_address = ('0.0.0.0', server_port)

    handler = partial(RequestHandler, region)
    httpd = HTTPServer(server_address, handler)
    print('running server...')
    httpd.serve_forever()


if __name__ == "__main__":
    run(sys.argv[1:])