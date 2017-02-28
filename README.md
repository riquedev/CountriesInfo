Countries Info
===================

Seja bem-vindo(a), pois bem vou-lhe explicar o que é o "Countries Info".
Basicamente é apenas o uso da API ["REST Countries"](https://github.com/fayder/restcountries), na qual é utilizado seu retorno JSON para a alimentação dos dados que são utilizados nesta source. 

----------


Explicações
-------------

Primeiro, a minha intenção foi basicamente fornecer algo já preparado para vocês utilizarem, acredito que consegui cumprir isso (haha).
Segundo, todos os créditos são dos ["desenvolvedores oficiais"](https://twitter.com/restcountries), é uma API totalmente Free, mas caso você possa ajuda-los doando basta acessar o ["site oficial"](https://restcountries.eu).

>**Notas:**
> - É um projeto que gera custos para os desenvolvedores oficiais, então pode ser que em algum momento a mesma possa ser fechada.
> - Erros no retorno da API devem ser tratados como **Issues** nesta página, por favor utilize o GitHub oficial dos desenvolvedores para relatar problemas relacionados aos retornos da API.
> - Disponibilizei uma pasta com a Source que foi criada por mim e uma chamada **EXE** com o projeto pronto **(Delphi 10.1 Berlin)**.
> - É necessário o uso das Sources XSuperObject e XSuperJSON de ["Onryldz"](https://github.com/onryldz) [["Download"](https://github.com/onryldz/x-superobject)].

#### Como funciona

É bem simples, você pode exigir o retorno completo (sem parâmetro algum) ou passar parte de uma informação e receber o retorno relacionado. 

#### Exemplo Prático
``` Delphi

procedure RequisitandoTudo;
var
  Request : TCountries; //Record com todas funções que serão utilizadas
  Resp : TResponseAllContriesList; //Listagem de vários países.
begin
  Resp := Request.RequetAllCountries(true); //Caso você passe o parâmetro true todos os dados no json serão atualizados (o json que deve se encontrar em ./tmp/all/response.json).
  {
    Agora a variável Resp virou um array de TResponseAllCountries (Este que é o dado de cada país).
  }
  Resp.List[10].Json;  //Quero o Json do 11º país encontrado.
  Resp.List[10].Nome; //Agora quero o nome.
  Resp.List[10].Capital; //Agora sua capital...
  /// ....
end;
 
```

>** Retorno JSON **
``` json
  {
  "name":"Brazil",
  "topLevelDomain":  
  [
".br"  
  ],
  "alpha2Code":"BR",
  "alpha3Code":"BRA",
  "callingCodes":  
  [
"55"  
  ],
  "capital":"Bras\u00c3\u00adlia",                     
  "altSpellings":  
  [
"BR",
"Brasil",
"Federative Republic of Brazil",
"Rep\u00c3\u00bablica Federativa do Brasil"  
  ],
  "region":"Americas",
  "translations":  
  {
    "de":"Brasilien",
    "es":"Brasil",
    "fr":"Br\u00c3\u00a9sil",
    "ja":"\u00e3\u0192\u2013\u00e3\u0192\u00a9\u00e3\u201a\u00b8\u00e3\u0192\u00ab",
    "it":"Brasile"  
  },
  "population":  206135893,
  "latlng":  
  [
    -10,
    -55  
  ],
  "demonym":"Brazilian",
  "area":  8515767,
  "gini":54.7,
  "timezones":  
  [
"UTC-05:00",
"UTC-04:00",
"UTC-03:00",
"UTC-02:00"  
  ],
  "borders":  
  [
"ARG",
"BOL",
"COL",
"GUF",
"GUY",
"PRY",
"PER",
"SUR",
"URY",
"VEN"  
  ],
  "nativeName":"Brasil",
  "numericCode":"076",
  "currencies":  
  [
    {
      "code":"BRL",
      "name":"Brazilian real",
      "symbol":"R$"    
    }  
  ],
  "languages":  
  [
    {
      "iso639_1":"pt",
      "iso639_2":"por",
      "name":"Portuguese",
      "nativeName":"portugu\u00c3\u00aas"    
    }  
  ]
}
```
> Funções disponíveis:
> - **RequetAllCountries** : Não exige parâmetro, apenas o opcional de atualizar o json em ./tmp/all/response.json e seu retorno é uma lista de todos países (TResponseAllContriesList).
> - **RequestCountryInfoByName** : Deve ser passado como parâmetro o nome do país (parcial ou completo), caso seja parcial é necessário passar o segundo parâmetro como True (isPartial), seu retorno é apenas um país (TResponseAllCountries).
> - **RequestByCode** : Exige como parâmetro o código do país (ex: es), seu retorno é apenas um país.
> - **RequestByListCodes** : Exige como parâmetro uma lista de códigos (ex: es,us,br,it), seu retorno é uma lista com os países correspondentes ao código.
> - **RequestByCurrency**  : Exige como parâmetro a moeda do país (ex: brl), seu retorno são todos países que utilizam a moeda.
> - **RequestByLanguage**  : Exige o idioma do país como parâmetro (ex: portuguese), seu retorno serão todos países que usam o idioma.
> - **RequestByCapital**   : Exige como parâmetro a capital do país (ex: Brasilia), seu retorno será o país cuja a capital seja correspondente ao parâmetro.
> - **RequestByCallingCode** : Exige como parâmetro o código de ligações do país (ex: 55), seu retorno é apenas o país correspondente.
> - **RequestByRegion** : Exige uma região como parâmetro (ex: Europe), seu retorno é todos países que estiverem na região correspondente.
