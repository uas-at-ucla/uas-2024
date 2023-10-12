"""
Stateful representation of vision system
"""

import json
import redis


r = redis.Redis(host='redis', port=6379, db=0)


def update_targets(targets):
    """
    Update list of targets
    """
    target_json = json.dumps(targets)
    r.set('detector/targets', target_json)


def get_top_detections():
    """
    Returns the top N detections we are most confident in
    """

    # detections = json.loads(r.get('detector/detections'))
    # targets = json.lads(r.get('detector/targets'))

    # TODO: Use matching algarithm on detections and targets and return
    # the best matches
    return []


def process_queued_image(img):
    """
    Main routine for image processing
    """

    detections = json.loads(r.get('detector/detections'))

    # TODO: Get telemetry data from image metadata

    # TODO: Get emergent detectins
    # TODO: Get alphanumric detections

    # TODO: Add these detections to the detections variable

    json_detections = json.dumps(detections)
    r.set('detector/detections', json_detections)
