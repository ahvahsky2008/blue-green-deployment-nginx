import os
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def root():
    service_name = os.environ['SERVICE_80_NAME']
    return {"active service is": service_name}

@app.get("/status")
def root():
    return 'Alive'