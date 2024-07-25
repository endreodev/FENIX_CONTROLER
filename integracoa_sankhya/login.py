import requests

# Requisição GET
headers_get = {
    "Application-Id": "2",
    "Accept": "application/json",
    "Referer": "http://52.12.83.176:8481/mge/",
    "Application-Origin": "sankhya-login",
    "Application-Secret": "$2y$10$c0aexjzdcu.uvJUH.a0YZ.q.DymR4VYhKUvhjk4lPj9R8C2h7SKvK",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Navegador/1.3.369 Chrome/87.0.4280.141 Electron/11.5.0 Safari/537.36"
}

response_get = requests.get("https://account-api.sankhya.com.br/", headers=headers_get)
print("GET Response Status Code:", response_get.status_code)
print("GET Response Headers:", response_get.headers)
print("GET Response Body:", response_get.text)

# Requisição OPTIONS
headers_options = {
    "method": "OPTIONS",
    "authority": "account-api.sankhya.com.br",
    "scheme": "https",
    "path": "/",
    "accept": "*/*",
    "access-control-request-method": "GET",
    "access-control-request-headers": "application-id,application-origin,application-secret",
    "origin": "http://52.12.83.176:8481",
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Navegador/1.3.369 Chrome/87.0.4280.141 Electron/11.5.0 Safari/537.36",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "cross-site",
    "sec-fetch-dest": "empty",
    "referer": "http://52.12.83.176:8481/mge/",
    "accept-encoding": "gzip, deflate, br",
    "accept-language": "pt-BR"
}

# response_options = requests.options("https://account-api.sankhya.com.br/", headers=headers_options)
# print("OPTIONS Response Status Code:", response_options.status_code)
# print("OPTIONS Response Headers:", response_options.headers)
# print("OPTIONS Response Body:", response_options.text)

# # Requisição POST
# headers_post = {
#     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Navegador/1.3.369 Chrome/87.0.4280.141 Electron/11.5.0 Safari/537.36",
#     "Accept": "*/*",
#     "Origin": "http://52.12.83.176:8481",
#     "Referer": "http://52.12.83.176:8481/mge/",
#     "Accept-Encoding": "gzip, deflate",
#     "Accept-Language": "pt-BR",
#     "Content-Type": "text/plain",
#     "Cookie": "JSESSIONID=SjvTdt98p7EvclCSntPBRwq5G39AxHj2lk5BMKRy.master; _ga=GA1.1.238915614.1720386853; isB2B=N; __zlcmid=1Mdmqpvl8w6jVlH; _gid=GA1.1.1117081024.1721180487; _ga_ZQK18B28LT=GS1.1.1721355515.1.0.1721355689.0.0.0; _ga_488LKXVVBY=GS1.1.1721351887.23.1.1721355735.0.0.0; _ga_YDQR2C04C1=GS1.1.1721351887.23.1.1721355735.0.0.0"
# }

# body_post = (
#     "callCount=1\n"
#     "c0-scriptName=DWRController\n"
#     "c0-methodName=execute\n"
#     "c0-id=5128_1721355836472\n"
#     "c0-e1=string:login\n"
#     "c0-e2=string:CQkRC45pa0%2FqrDzYKEVD1MCQlwdN16SUAUuT6Bdzj6%2FgBgLBRgDx4lC3oHwBLBjvKKGmDpDoBbQ7o96TgzosneQhlzRmRMdIGJYvZQ58fP6x2OAqxt3TUkfbpmGGISv1NcYFcJ047i7IFZiQEeKq5aWF%2BEHvlw075ysMBZTaSYM%3D\n"
#     "c0-e3=string:X%2FpVtCsBQOhsCDTdILNlyaI8EJ5FBo7CFB5E9XEYQsSA9hNEAhIvG5bkqSOTiai3vBFU036zketaCKAIdXA5dMCCntKdR3CJqYENN9KljbxZ9Ok0vVOMIQj%2BXpETF7xQHFiPxWqqkG%2F6AfCQlszK4MbLr6RoFLlrgd8sXnJf9qE%3D\n"
#     "c0-e4=string:eyJ4LXNrdy0xIjoieDUyNzE4NiIsIngtc2t3LTIiOiJ4NGI5NWY5IiwieC1za3ctMyI6InhiM2IxMTciLCJ4LXNrdy00IjoieDJlZTNhNiIsIngtc2t3LTUiOiJ4YzdlZmJhIiwieC1za3ctYXBwS2V5IjoiMWI0YWY3NDQwMzExOTY1YTMxYzI2M2IzYzE4NjVmMGI0ODIzNWYzYTRiOTA1YWFlYjA2ZGU3ZjZlNGVkODgxMjUwOTk3MzczZDdkOTQ0ZTNjMTc0N2NkNGZjMDk4ZmY2ZDc5MzMxOWY5MTQxMWRmODc2NmQ3NWU5M2Y0ZDRiZGUxIn0%3D\n"
#     "c0-e5=string:off\n"
#     "c0-param0=Object:{acao:reference:c0-e1, accountUser:reference:c0-e2, passUsu:reference:c0-e3, info:reference:c0-e4, typeLogin:reference:c0-e5}\n"
#     "xml=true\n"
# )

# response_post = requests.post("http://52.12.83.176:8481/mge/dwr/exec/DWRController.execute.dwr", headers=headers_post, data=body_post)
# print("POST Response Status Code:", response_post.status_code)
# print("POST Response Headers:", response_post.headers)
# print("POST Response Body:", response_post.text)
