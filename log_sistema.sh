#!/bin/bash

# Nome do diretório onde vai salvar os logs
DIR_LOG="/home/ec2-user/logs"
# Nome do arquivo de log (data e hora embutidas)
ARQUIVO_LOG="log_$(date '+%Y-%m-%d_%H-%M-%S').txt"
# Nome do bucket S3 (troca pelo teu bucket real, viado!)
BUCKET_S3="s3://meu-bucket-de-log"

# Cria diretório se não existir
sudo mkdir -p $DIR_LOG

# Coleta informações do sistema
{
    echo "===== LOG DO SISTEMA - $(date) ====="
    echo ""
    echo "--- UPTIME ---"
    uptime
    echo ""
    echo "--- USO DE CPU ---"
    top -bn1 | head -n 10
    echo ""
    echo "--- USO DE MEMÓRIA ---"
    free -h
    echo ""
    echo "--- USO DE DISCO ---"
    df -h
    echo ""
    echo "--- PROCESSOS ATIVOS ---"
    ps aux --sort=-%mem | head -n 10
    echo ""
} > "$DIR_LOG/$ARQUIVO_LOG"

# Envia pro S3
aws s3 cp "$DIR_LOG/$ARQUIVO_LOG" "$BUCKET_S3"

echo "Log salvo em $DIR_LOG/$ARQUIVO_LOG e enviado para $BUCKET_S3"
