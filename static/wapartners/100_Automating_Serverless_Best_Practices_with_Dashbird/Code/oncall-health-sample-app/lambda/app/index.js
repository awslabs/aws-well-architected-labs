// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

const randomBytes = require('crypto').randomBytes;


const AWSXRay = require('aws-xray-sdk');
const AWS = AWSXRay.captureAWS(require('aws-sdk'));

const ddb = new AWS.DynamoDB.DocumentClient();


const fleet = [
    {
        Name: 'TX5400',
        Color: 'Dark Blue',
        Year: '2020',
    },
    {
        Name: 'BXC500',
        Color: 'Light Blue',
        Year: '2021',
    },
    {
        Name: 'XSA003',
        Color: 'Regular Blue',
        Year: '2021',
    },
];

exports.handler = (event, context, callback) => {
    //console.log("See this event:",event);
    //console.log("See this context:",context);
    //console.log("See this callback:",callback);
    if (!event.requestContext.authorizer) {
      errorResponse('Authorization not configured', context.awsRequestId, callback);
      return;
    }

    const rideId = toUrlString(randomBytes(16));
    //console.log('Received event (', rideId, '): ', event);
    const username = event.requestContext.authorizer.claims['cognito:username'];
    const requestBody = JSON.parse(event.body);

    const pickupLocation = requestBody.PickupLocation;

    const carunit = findCarunit(pickupLocation);

    recordRide(rideId, username, carunit).then(() => {
        callback(null, {
            statusCode: 201,
            body: JSON.stringify({
                RideId: rideId,
                Carunit: carunit,
                CarunitName: carunit.Name,
                Eta: '30 seconds',
                Rider: username,
            }),
            headers: {
                'access-control-allow-origin': process.env.APP_URL ,
            },
        });
    }).catch((err) => {
        console.error(err);
        errorResponse(err.message, context.awsRequestId, callback)
    });
};

function findCarunit(pickupLocation) {
    //console.log('Finding carunit for ', pickupLocation.Latitude, ', ', pickupLocation.Longitude);
    return fleet[Math.floor(Math.random() * fleet.length)];
}

function recordRide(rideId, username, carunit) {
    return ddb.put({
        TableName: 'Rides',
        Item: {
            RideId: rideId,
            User: username,
            Carunit: carunit,
            CarunitName: carunit.Name,
            RequestTime: new Date().toISOString(),
        },
    }).promise();
}

function toUrlString(buffer) {
    return buffer.toString('base64')
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=/g, '');
}

function errorResponse(errorMessage, awsRequestId, callback) {
  callback(null, {
    statusCode: 500,
    body: JSON.stringify({
      Error: errorMessage,
      Reference: awsRequestId,
    }),
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  });
}

