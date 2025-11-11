# 🔧 Solução: Erro psycopg2 com Python 3.13

## ❌ Erro Encontrado

```
undefined symbol: _PyInterpreterState_Get
```

Este erro ocorre porque o `psycopg2-binary` não foi compilado para Python 3.13 ainda, causando incompatibilidade.

## ✅ Solução Aplicada

### 1. Downgrade para Python 3.12.7

Python 3.12 é mais estável e amplamente suportado pelo `psycopg2-binary`.

**Arquivos alterados:**
- `render.yaml`: `PYTHON_VERSION: 3.12.7`
- `runtime.txt`: `3.12.7`

### 2. Atualização do requirements.txt

Mantido `psycopg2-binary>=2.9.9` que é compatível com Python 3.12.

## 📋 Próximos Passos

1. **Faça commit das alterações:**
```bash
git add render.yaml runtime.txt requirements.txt
git commit -m "Fix: Downgrade Python para 3.12.7 para compatibilidade com psycopg2"
git push
```

2. **O Render fará o deploy automaticamente**

3. **Aguarde o build completar** (pode levar alguns minutos)

4. **Teste novamente:**
```bash
curl -X 'GET' \
  'https://apppetguardian.onrender.com/animais/' \
  -H 'accept: application/json'
```

## 🔍 Verificações

Após o deploy, verifique os logs no Render:
- ✅ Build deve completar sem erros
- ✅ Aplicação deve iniciar corretamente
- ✅ Conexão com PostgreSQL deve ser estabelecida

## 🐛 Se o Erro Persistir

### Opção 1: Usar psycopg2 (não binary)

Se ainda houver problemas, podemos usar `psycopg2` (sem binary) que compila na instalação:

```txt
# Em requirements.txt, substitua:
psycopg2>=2.9.9

# E adicione no buildCommand do render.yaml:
apt-get update && apt-get install -y libpq-dev python3-dev
```

### Opção 2: Verificar versão do psycopg2-binary

Certifique-se de que está usando a versão mais recente:
```bash
pip install --upgrade psycopg2-binary
```

## 📝 Notas

- Python 3.13 foi lançado recentemente e muitas bibliotecas ainda não têm suporte completo
- Python 3.12 é a versão LTS recomendada para produção
- O `psycopg2-binary` é um pacote pré-compilado, então precisa ser compilado para cada versão do Python

## ✅ Status

- [x] Python downgrade para 3.12.7
- [x] requirements.txt atualizado
- [x] runtime.txt atualizado
- [ ] Deploy no Render (aguardando)
- [ ] Teste da API (após deploy)

