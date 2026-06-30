from fastapi import FastAPI

app = FastAPI(
    title="Proyecto AWS EKS",
    version="1.0.0"
)

@app.get("/")
def home():
    return {
        "message": "Backend desplegado correctamente en Amazon EKS"
    }

@app.get("/health")
def health():
    return {
        "status": "OK"
    }

@app.get("/info")
def info():
    return {
        "project": "Proyecto AWS EKS Kubernetes",
        "environment": "dev",
        "version": "1.0.0"
    }