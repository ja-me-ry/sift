from fastapi import FastAPI

app = FastAPI(title="sift", version="0.0.1")


@app.get("/health")
def health() -> dict[str, str]:
    """Liveness check. Deliberately trivial — will grow into a real
    findings API starting Phase 2."""
    return {"status": "ok"}
