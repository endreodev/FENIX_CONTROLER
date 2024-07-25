


fetch("http://52.12.83.176:8481/mge/service.sbr?serviceName=DatasetSP.save&application=RegistroOperacoes&outputType=json", {
  "headers": {
    "accept": "application/json, text/plain, */*",
    "accept-language": "pt-BR",
    "content-type": "application/json; charset=UTF-8",
    "cookie": "JSESSIONID=SjvTdt98p7EvclCSntPBRwq5G39AxHj2lk5BMKRy.master"
    
  },
  "referrerPolicy": "no-referrer-when-downgrade",
  "body": "{\"serviceName\":\"DatasetSP.save\",\"requestBody\":{\"dataSetID\":\"00J\",\"entityName\":\"FexRegistroOperacoes\",\"standAlone\":false,\"fields\":[\"PESOTOTALRESTVE\",\"DHOPER\",\"STATUSCAMB\",\"PESOTOTALG\",\"OBS\",\"TIPO\",\"CODUSULCO\",\"Usuario.NOMEUSU\",\"VLRTOTAL\",\"STATUSVEN\",\"STATUSOPER\",\"CODFORFICHA\",\"Parceiro.NOMEPARC\",\"CODEMP\",\"Empresa.NOMEFANTASIA\",\"QTD\",\"VLRTOTALRESTCB\",\"STATUSCP\",\"CODCONTROLE\"],\"records\":[{\"values\":{\"5\":\"EX\",\"13\":\"44\",\"14\":\"GRAMA METAIS DO BRASIL LTDA\"}}],\"ignoreListenerMethods\":\"\",\"clientEventList\":{\"clientEvent\":[{\"$\":\"br.com.sankhya.actionbutton.clientconfirm\"}]}}}",
  "method": "POST",
  "mode": "cors"
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error('Erro:', error));
