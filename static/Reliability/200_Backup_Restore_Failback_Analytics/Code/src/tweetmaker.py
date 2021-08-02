# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# or in the "license" file accompanying this file. This file is distributed 
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
# express or implied. See the License for the specific language governing 
# permissions and limitations under the License.

import logging
from faker import Faker
import time
import requests
import json
import argparse
import traceback

def generate_one_record(gen):
    p = gen.simple_profile()
    r = gen.simple_profile()
    return {
        "coordinates": {
            "type": "latlon",
            "coordinates": [float(gen.latitude()), float(gen.longitude())]
        },
        "retweeted": gen.pybool(),
        "source": gen.user_agent(),
        "entities": {
            "hashtags": [
                {
                    "text": gen.word(),
                    "indices": [gen.pyint()]
                }
            ],
            "urls": [
                {
                    "url": gen.url(),
                    "expanded_url": gen.url(),
                    "display_url": gen.url(),
                    "indices": [gen.pyint()]
                }
            ],
        },
        "reply_count": gen.pyint(),
        "favorite_count": gen.pyint(),
        "geo": {
            "type": "latlon",
            "coordinates": [float(gen.latitude()), float(gen.longitude())]
        },
        "id_str": gen.pystr(),
        "timestamp_ms": int(time.time() * 1000),
        "truncated": gen.pybool(),
        "retweet_count": gen.pyint(),
        "id": gen.pyint(),
        "possibly_sensitive": gen.pybool(),
        "filter_level": gen.random_choices(elements=('low', 'medium', 'high')),
        "quote_count": gen.pyint(),
        "lang": "en",
        "favorited": gen.pybool(),
        "is_quote_status": gen.pybool(),
        "created_at": gen.city(),
        "in_reply_to_screen_name": r['username'],
        "in_reply_to_user_id_str": r['username'],
        "text": gen.sentence(),
        "place": {
            "id": str(gen.pyint()),
            "url": gen.url(),
            "place_type": gen.random_choices(elements=('P1', 'P2', 'P3')),
            "name": gen.city(),
            "full_name": gen.city(),
            "country_code": gen.country_code(),
            "country": gen.country(),
            "bounding_box": {
                "type": "latlon",
                "coordinates": [
                    [[float(gen.latitude()), float(gen.longitude())], [float(gen.latitude()), float(gen.longitude())]],
                    [[float(gen.latitude()), float(gen.longitude())], [float(gen.latitude()), float(gen.longitude())]]
                ]
            }
        },
        "user": {
            "id": gen.pyint(),
            "id_str": str(gen.pyint()),
            "name": p['name'],
            "screen_name": p['username'],
            "location": p['address'],
            "url": p['mail'],
            "description": gen.sentence(),
            "translator_type": gen.random_choices(elements=('T1', 'T2', 'T3')),
            "protected": gen.pybool(),
            "verified": gen.pybool(),
            "followers_count": gen.pyint(),
            "listed_count": gen.pyint(),
            "friends_count": gen.pyint(),
            "favourites_count": gen.pyint(),
            "statuses_count": gen.pyint(),
            "default_profile": gen.pybool(),
            "default_profile_image": gen.pybool(),
            "profile_use_background_image": gen.pybool(),
            "utc_offset": gen.pyint(),
            "geo_enabled": gen.pybool(),
            "contributors_enabled": gen.pybool(),
            "is_translator": gen.pybool(),
            "lang": "en",
            "created_at": gen.city(),
            "time_zone": gen.timezone(),
            "profile_background_color": gen.color_name(),
            "profile_background_image_url": gen.image_url(),
            "profile_background_image_url_https": gen.image_url(),
            "profile_background_tile": gen.pybool(),
            "profile_link_color": gen.color_name(),
            "profile_sidebar_border_color": gen.color_name(),
            "profile_sidebar_fill_color": gen.color_name(),
            "profile_text_color": gen.color_name(),
            "profile_image_url": gen.image_url(),
            "profile_image_url_https": gen.image_url(),
            "profile_banner_url": gen.url()
        }
    }

if __name__ == "__main__":
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    fileHandler = logging.FileHandler("tweetmaker.log")
    logger.addHandler(fileHandler)
    consoleHandler = logging.StreamHandler()
    logger.addHandler(consoleHandler)
    parser = argparse.ArgumentParser(description='Send fake tweets')
    parser.add_argument('--endpoint', help='Endpoint', required=True)
    parser.add_argument('--sleep', default=10, type=int, help='Seconds to sleep between posts')
    args = parser.parse_args()
    endpoint = f"http://{args.endpoint}/"
    fake = Faker()
    while True:
        try:
            j = generate_one_record(fake)
            data = json.dumps(j)
            logger.info(f"Sending record {data} to {endpoint}")
            requests.post(url = endpoint, data = data)
            logger.debug(f"Sent record {data}")
            time.sleep(args.sleep)
        except Exception as e:
            trc = traceback.format_exc()
            logger.warn(f"Failed to send message {j}: {str(e)}\n\n{trc}")


