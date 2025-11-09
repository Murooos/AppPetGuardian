"""
Script de inicialização para produção (Render.com)
"""
import uvicorn
import os

if __name__ == "__main__":
    # Render.com fornece a porta através da variável de ambiente PORT
    port = int(os.environ.get("PORT", 8000))
    
    uvicorn.run(
        "Backend.API.main:app",
        host="0.0.0.0",
        port=port,
        log_level="info"
    )

