*** Variables ***
# ==========================================
# Configurações de Navegador e Rotas
# ==========================================
${BROWSER}                  chrome
${URL}                      https://lampi.ifce.edu.br/mobak/login
${URL_BASE}                 https://lampi.ifce.edu.br/mobak
${URL_PERFIL_TERCEIRO}      ${URL_BASE}/perfil/9999
${URL_LISTAGEM}             ${URL_BASE}/registros
${URL_RELATORIOS}           ${URL_BASE}/relatorios

# ==========================================
# Localizadores (XPaths e IDs)
# ==========================================
${USER_FIELD}               xpath=/html/body/div/main/div/div/form/div[1]/div/input
${PASS_FIELD}               xpath=/html/body/div/main/div/div/form/div[2]/div/input
${LOGIN_BUTTON}             xpath=/html/body/div/main/div/div/form/button
${DASHBOARD_EL}             xpath=//h1
${LOGOUT_BTN}               id=logout-btn
${REGISTER_BTN}             id=btn-cadastro
${NEW_EMAIL_FIELD}          id=novo-email

# ==========================================
# Credenciais
# ==========================================
${USER_VALIDO}              admin@mobak.com
${SENHA_VALIDA}             SenhaSegura123!
${USER_INEXISTENTE}         ghost@mobak.com
${SENHA_INCORRETA}          SenhaIncorreta404
${USER_OPERADOR}            operador@mobak.com

# ==========================================
# Payloads de Teste (Validação e Segurança)
# ==========================================
${PAYLOAD_EMOJI}            usuario😊
${PAYLOAD_ESPECIAL}         user!@#$
${PAYLOAD_SQLI}             admin' OR '1'='1
${STRING_GIGANTE}           ${{"A" * 256}}
${PAYLOAD_ESPACOS}          ${SPACE * 5}
${PAYLOAD_XSS}              <script>alert('XSS')</script>
${PAYLOAD_UNICODE}          ユーザー名
${EMAIL_INVALIDO}           usuario.com@
${BUSCA_METACARACTERE}      %_busca_*
${DATA_INICIAL_MAIOR}       2026-12-01
${DATA_FINAL_MENOR}         2026-01-01

# ==========================================
# Mensagens Esperadas na Interface
# ==========================================
${MSG_ERRO_OBRIGATORIO}     Campo obrigatório
${MSG_ERRO_LOGIN}           Credenciais inválidas
${MSG_ERRO_BLOQUEIO}        Conta temporariamente bloqueada
${MSG_ERRO_403}             403 Forbidden
${MSG_ERRO_DUPLICIDADE}     E-mail já cadastrado
${MSG_SUCESSO_RECUPERACAO}  E-mail de recuperação enviado
${MSG_NENHUM_REGISTRO}      Nenhum resultado encontrado
${MSG_ERRO_DATA}            Data inicial excede a final
${MSG_SUCESSO_DELECAO}      Registro removido com sucesso