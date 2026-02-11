import asyncio
import json
import random
import os
from datetime import datetime, timezone, timedelta
from azure.eventhub.aio import EventHubProducerClient
from azure.eventhub import EventData

#CONNECTION_STR = os.getenv("CONNECTION_STR")
#EVENTHUB_NAME = os.getenv("EVENTHUB_NAME")
CONNECTION_STR = os.environ["CONNECTION_STR"]
EVENTHUB_NAME = os.environ["EVENTHUB_NAME"]


async def run():
    producer = EventHubProducerClient.from_connection_string(
        conn_str=CONNECTION_STR, 
        #eventhub_name=EVENTHUB_NAME
    )
    current_time = datetime(2026, 2, 9, 6, 0, tzinfo=timezone.utc)  # start
    
    async with producer:
        for i in range(100):
            event_time = current_time.isoformat()
            occupied_prob = random.uniform(0, 1) 
            for j in range(20):
                event_data_batch = await producer.create_batch()
                status = random.choices(["occupied", "free"], weights=[occupied_prob, 1-occupied_prob])[0]  
                event_body = {
                    "id": f"S{j}",
                    "status": status,
                    "event_time": event_time
                }
                #event_body = {"id": i, "message": f"Event number {i}"}
                event_data_batch.add(EventData(json.dumps(event_body)))
                await producer.send_batch(event_data_batch)
                print(f"Sent event for spot {event_body['id']} at {event_time}")
                #event_data_batch = await producer.create_batch() # reset batch
            current_time += timedelta(hours=1) 
            if current_time.hour > 22:
                current_time += timedelta(hours=7)
            await asyncio.sleep(3)


    
asyncio.run(run())
