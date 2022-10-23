# iOSGatitos

* Neste desafio era preciso criar um aplicativo para listagem de raças de 
gatos. O app precisava ter como tela principal uma lista(UITableView) de 
raças de gatos.
4
Cada uma das células deve conter apenas o nome da raça do gato e ao ser 
clicada, deverá ser redirecionada para a próxima tela passando o objeto 
com as insformações da raça, que seriam: nome da raça, imagem da raça, 
temperamento e descrição.

* API Utilizada: 
https://docs.thecatapi.com

* SPMs utilizados no desenvolvimento:
  - Alamofire 5.6.2
      - Utilizado apenas para verificar a conexão do usuário com a internet.
      
  - Kingfisher 7.4.0
      - Utilizado para realizar o download das imagens das raças.
      
  - Lottie 3.5.0
      - Utilizado para realizar a animação da Splash e também para a animação do Loading.
      
* Arquitetura utilizada
  - MVVM-C
  
* OBS:
  - Projeto desenvolvido totalmente em viewCode.
  - Notei que algumas vezes a API retornava success, porém o objeto retornava vazio. Realizei 
  tratamento para este caso também. No vídeo em anexo demonstro isso.
  
* Vídeo do projeto desenvolvido

https://user-images.githubusercontent.com/70459328/197410536-b623d40b-5ef1-4629-8be8-d30b6f8cd5ba.mov

