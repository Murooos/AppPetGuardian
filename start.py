import uvicorn
from pathlib import Path
import sys

# garante que o Python ache o pacote Backend
BASE_DIR = Path(__file__).resolve().parent
sys.path.append(str(BASE_DIR / "Backend" / "API"))

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="127.0.0.1",
        port=8000,
        reload=True
    )
