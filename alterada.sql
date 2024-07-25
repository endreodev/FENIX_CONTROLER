create or replace TRIGGER "TRG_FEX_MOVFIN"
BEFORE UPDATE OR DELETE ON TGFFIN
FOR EACH ROW
DECLARE
    P_VALIDAR BOOLEAN;
    ERRMSG VARCHAR2(4000);
    ERROR EXCEPTION;
    P_VLRTITULOORIGINAL_REAL FLOAT;
    P_VLRTITULOBAIXADO_REAL FLOAT;
    P_VLRTITULOORIGINAL_USD FLOAT;
    P_VLRTITULOBAIXA_USD FLOAT;
    P_VLRTITULOCAMBIALBAIXA_USD FLOAT;
    P_VLRCOTCAMBIO FLOAT;
    P_RESTOCONTA FLOAT;
    P_AD_IDCBROMANEIO NUMBER;
    P_NUFINUSD INT;
    P_CODCTABCOINT INT;
    P_CODEMP INT;
    P_TIPMARCCHEQ VARCHAR2(5);
    P_VLRCHEQUE FLOAT;
    P_VLRVARCAMBIAL FLOAT;
    P_VLRMULTA FLOAT;
    P_VLRDESC FLOAT;
    P_NUBCO INT;
    P_NOVO_NUFIN INT;
    P_QTDROW INT;
    P_IDMESAORIGEM INT;
    P_FEXLOTECAMBIO NUMBER;
    P_TIPO VARCHAR2(5);
    P_DTACOMPMOV DATE;
    P_TIPO_MSG VARCHAR2(15);
    P_TOPFICHACLI INT;
    P_TIPFICHACLI INT;
    P_NATFICHACLI INT;
    P_MOEDAFICHACLI INT;
            
    PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

    SELECT NVL(GET_TSIPAR_INTEIRO('TOPGERAFIXACLI'), 9999991)   INTO P_TOPFICHACLI FROM DUAL;
    SELECT NVL(GET_TSIPAR_INTEIRO('TIPGERAFIXACLI'), 9999991)   INTO P_TIPFICHACLI FROM DUAL;
    SELECT NVL(GET_TSIPAR_INTEIRO('NATGERAFIXACLI'), 9999991)   INTO P_NATFICHACLI FROM DUAL;
    SELECT NVL(GET_TSIPAR_INTEIRO('MOEDAGERAFIXACL'), 9999991) INTO P_MOEDAFICHACLI FROM DUAL;

    IF UPDATING THEN

        -- Verifica se o registro foi alterado
        IF (:OLD.DHBAIXA IS NULL AND :NEW.DHBAIXA IS NOT NULL AND :NEW.RECDESP = 1) THEN
            -- Verifica se os campos adicionais estão preenchidos para poderem ser calculados os valores na baixa do título.
            IF(:NEW.AD_IDCBROMANEIO IS NOT NULL AND :NEW.AD_CODROMANEIO IS NOT NULL AND :NEW.DHBAIXA IS NOT NULL) THEN
                -- Carrega dados temporários do financeiro gerados em reais
                P_VLRTITULOORIGINAL_REAL := :NEW.vlrdesdob;
                P_VLRTITULOBAIXADO_REAL := (:NEW.VLRBAIXA - :NEW.VLRVARCAMBIAL);
                P_AD_IDCBROMANEIO := :NEW.AD_IDCBROMANEIO;
                P_VLRCOTCAMBIO := :NEW.AD_VLRMOEDA;
                P_FEXLOTECAMBIO := :NEW.FEXLOTECAMBIO;
                P_TIPO := :NEW.AD_TIPOCB;

                -- Alimenta tabela temporária para baixa do título dólar (FEXFIN_TEMP)
                INSERT INTO FEXFIN_TEMP (NUFIN, VLRBAIXA, VLRCOTCAMBIO, DHBAIXA, IDCBROMANEIO, NUDEST, TIPO, FEXLOTECAMBIO)
                VALUES (:NEW.NUFIN, (:NEW.VLRBAIXA - :NEW.VLRVARCAMBIAL), P_VLRCOTCAMBIO, :NEW.DHBAIXA, P_AD_IDCBROMANEIO, :NEW.AD_NUDEST, P_TIPO, P_FEXLOTECAMBIO);
            END IF;
        END IF;


        -- Realiza registro na ficha do cliente
        IF (:OLD.DHBAIXA IS NULL 
            AND :NEW.DHBAIXA IS NOT NULL 
            AND :NEW.CODTIPTIT  = P_TIPFICHACLI
            AND :NEW.CODTIPOPER = P_TOPFICHACLI 
            AND :NEW.CODNAT     = P_NATFICHACLI 
            AND :NEW.CODMOEDA   = P_MOEDAFICHACLI
            AND :NEW.RECDESP    = 1) THEN

            BEGIN
                -- Trava por data anterior ao parâmetro DTACOMPMOV
                SELECT GET_TSIPAR_DATA('DTACOMPMOV') INTO P_DTACOMPMOV FROM DUAL;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN 
                        P_DTACOMPMOV := NULL;
            END;

            IF(P_DTACOMPMOV IS NOT NULL AND :NEW.DHBAIXA IS NOT NULL AND :NEW.DHBAIXA <= P_DTACOMPMOV) THEN 
                RAISE_APPLICATION_ERROR(-20101, 'Período fechado para movimentação na ficha, entre em contato com a controladoria.');
            END IF;

            P_TIPO_MSG := 'RECEBIMENTO ';
            STP_GERA_FICHA(TO_CHAR(:NEW.DHBAIXA, 'DD/MM/YYYY'), :NEW.NUFIN, P_TIPO_MSG || ' NU:' || :NEW.NUFIN, NULL, (:NEW.VLRBAIXA * (-1)), NULL, NULL, 'F', :NEW.CODPARC, :NEW.CODEMP, :NEW.CODMOEDA, 1, 'C', 0, NULL, 1);
        END IF;

        -- Se estornado realiza a exclusão da ficha do cliente
        IF (:OLD.DHBAIXA IS NOT NULL 
            AND :NEW.DHBAIXA IS NULL  
            AND :NEW.CODTIPTIT  = P_TIPFICHACLI
            AND :NEW.CODTIPOPER = P_TOPFICHACLI
            AND :NEW.CODNAT     = P_NATFICHACLI 
            AND :NEW.CODMOEDA   = P_MOEDAFICHACLI
            AND :NEW.RECDESP = 1) THEN 
            P_TIPO_MSG := 'RECEBIMENTO ';
            STP_GERA_FICHA(TO_CHAR(:OLD.DHBAIXA, 'DD/MM/YYYY'), :NEW.NUFIN, P_TIPO_MSG || ' NU:' || :NEW.NUFIN, NULL, (:NEW.VLRBAIXA  * (-1)), NULL, NULL, 'F', :NEW.CODPARC, :NEW.CODEMP, :NEW.CODMOEDA, 1, 'C', 1, NULL, 1 );
        END IF;

        -- Se estornado realiza a exclusão da ficha 
        IF (:OLD.DHBAIXA IS NOT NULL AND :NEW.DHBAIXA IS NULL AND :NEW.RECDESP = -1) THEN
            IF :NEW.AD_GERADIANTAMENTO = 'S' THEN
                BEGIN
        SELECT GET_TSIPAR_DATA('DTACOMPMOV')
            INTO P_DTACOMPMOV
            FROM DUAL;
          EXCEPTION 
            WHEN NO_DATA_FOUND THEN 
              P_DTACOMPMOV := NULL;
    END;

    IF(P_DTACOMPMOV IS NOT NULL AND :NEW.DHBAIXA IS NOT NULL AND :NEW.DHBAIXA <= P_DTACOMPMOV) THEN
        RAISE_APPLICATION_ERROR(-20101,' Período fechado para movimentação na ficha, entre em contato com a controladoria. </p></p><P/>___________________________________________________<P/>');
    END IF;

    -- VERIFICA SE ESTA BAIXANDO OS REGISTRO DE COMPRA PARA PODER GERAR O TITULO DE RECEITA PENDENTE PARA COMPENSAÇÃO.
    P_NOVO_NUFIN := SNK_GET_NUFIN();
    :NEW.HISTORICO := :NEW.HISTORICO||' // TITULO GERADO PARA COMPENSAÇÃO NRO.UNICO FINANCEIRO: '||P_NOVO_NUFIN;

    INSERT INTO TGFFIN (NUFIN,DESDOBRAMENTO,DTVENC,CODNAT,VLRDESDOB,NUNOTA,ORIGEM,CODEMP,CODPARC,NUMNOTA,DTNEG,DHMOV,DTALTER,CODTIPTIT,RECDESP,HISTORICO,CODCENCUS)
    SELECT P_NOVO_NUFIN,DESDOBRAMENTO,DTVENC,CODNAT,:NEW.VLRBAIXA,NUNOTA,ORIGEM,CODEMP,CODPARC,NUMNOTA,DTNEG,SYSDATE,SYSDATE,CODTIPTIT,1,HISTORICO, NVL((SELECT INTEIRO FROM TSIPAR WHERE CHAVE = 'CRCAMBIOS'), CODCENCUS) FROM TGFFIN WHERE NUFIN = :NEW.NUFIN;

      P_IDMESAORIGEM := 0;

        BEGIN
            SELECT ID INTO P_IDMESAORIGEM FROM fexregopercp WHERE NUNOTA = :NEW.NUNOTA;
              EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                  P_IDMESAORIGEM := 0;
        END;



      IF NVL(:NEW.AD_EHIRRF,'N') = 'N' THEN
        P_TIPO_MSG := 'PAGAMENTO';
      ELSE
        P_TIPO_MSG := 'IRRF';
      END IF; 

                -- Realiza exclusão na ficha do fornecedor
                STP_GERA_FICHA(TO_CHAR(:OLD.DHBAIXA, 'DD/MM/YYYY'), :NEW.NUFIN, P_TIPO_MSG || ' NU:' || P_IDMESAORIGEM, NULL, (:NEW.VLRBAIXA * (-1)), NULL, NULL, 'F', :NEW.CODPARC, :NEW.CODEMP, 0, 1, 'F', 1, NULL, NULL);
            END IF;

            -- Realiza a limpeza do título dólar temporário 
            DELETE FROM FEXFIN_TEMP WHERE NUFIN = :OLD.NUFIN;
        END IF;
    END IF;

    -- Deletar registro
    IF DELETING THEN 
        IF :OLD.AD_GERADIANTAMENTO = 'S' OR :NEW.CODTIPTIT = P_TIPFICHACLI THEN
            IF :OLD.DHBAIXA IS NOT NULL THEN
                IF NVL(:OLD.AD_EHIRRF, 'N') = 'N' THEN
                    P_TIPO_MSG := 'PAGAMENTO';
                ELSE
                    P_TIPO_MSG := 'IRRF';
                END IF;

                P_IDMESAORIGEM := 0;
                BEGIN
                    SELECT ID INTO P_IDMESAORIGEM FROM fexregopercp WHERE NUNOTA = :OLD.NUNOTA;    
                    EXCEPTION 
                        WHEN NO_DATA_FOUND THEN 
                            P_IDMESAORIGEM := 0;
                END;

                -- Deleta o registro da ficha do fornecedor
                IF(:NEW.CODTIPTIT = P_TIPFICHACLI) THEN
                    P_TIPO_MSG := 'RECEBIMENTO ';
                    STP_GERA_FICHA(TO_CHAR(:OLD.DHBAIXA, 'DD/MM/YYYY'), :OLD.NUFIN, P_TIPO_MSG || ' NU:' || P_TIPO_MSG, NULL, (:OLD.VLRBAIXA * (-1)), NULL, NULL, 'F', :OLD.CODPARC, :OLD.CODEMP, :NEW.CODMOEDA, 1, 'F', 1, NULL, 1);
                ELSE
                    STP_GERA_FICHA(TO_CHAR(:OLD.DHBAIXA, 'DD/MM/YYYY'), :OLD.NUFIN, P_TIPO_MSG || ' NU:' || P_IDMESAORIGEM, NULL, (:OLD.VLRBAIXA * (-1)), NULL, NULL, 'F', :OLD.CODPARC, :OLD.CODEMP, 0, 1, 'F', 1, NULL, NULL);
                END IF;

                -- Realiza a limpeza do título dólar temporário 
                DELETE FROM FEXFIN_TEMP WHERE NUFIN = :OLD.NUFIN;
            END IF;
        END IF;

        -- Realiza a limpeza do título dólar temporário 
        DELETE FROM FEXFIN_TEMP WHERE NUFIN = :NEW.NUFIN;
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END;