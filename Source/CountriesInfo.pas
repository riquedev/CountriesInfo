{*******************************************************}
{                                                       }
{               Countries Info                          }
{                                                       }
{     Este obra est� licenciado com uma Licen�a         }
{     Creative Commons Atribui��o 4.0 Internacional.    }
{   ( https://creativecommons.org/licenses/by/4.0/ )    }
{                                                       }
{   Esta source foi desenvolvida para facilitar o uso   }
{   da API (https://restcountries.eu) em Pascal.        }
{                                                       }
{   Todos cr�ditos s�o de seus desenvolvedores          }
{   oficiais, dados entregues por esta API podem estar  }
{   desatualizados, problemas relacionados ao retorno   }
{   dado pela requisi��o devem ser avisados ao seus     }
{   desenvolvedores oficiais.                           }
{                                                       }
{   Desenvolvedor: Henrique da Silva Santos (rique_dev) }
{                                                       }
{   GitHub: https://github.com/riquedev                 }
{                                                       }
{   Site do projeto original: https://restcountries.eu  }
{                                                       }
{   Issues:                                             }
{   https://github.com/fayder/restcountries/issues      }
{                                                       }
{   GitHub: https://github.com/fayder/restcountries     }
{                                                       }
{   Agradecimentos extras:                              }
{   onryldz (https://github.com/onryldz) pelo           }
{   XSuperJson e XSuperObject que s�o ess�nciais para   }
{   o funcionamento desta source.                       }
{                        2017                           }
{                                                       }
{*******************************************************}
unit CountriesInfo;

interface

uses
  IdHTTP, System.Classes, SysUtils, XSuperJson, XSuperObject;

const
  { Armazenamento dos dados (somente para requisi��o de todos pa�ses) }
  SavePathTempJSON = 'tmp/all/';

  { Vers�o da API }
  AppVersion = 'v2';

  { Host  }
  BaseURL = 'https://restcountries.eu/';

  { Path no Host  }
  CallPath = 'rest';

type

  { Cordenadas G. do Pa�s  }
  TResponseCoords = record
    lat: variant;
    lng: variant;
  end;
  { Cordenadas G. do Pa�s  }

  { Tradu��es }

  TResponseCountryTranslation = record
    de: string;
    es: string;
    fr: string;
    ja: string;
    it: string;
  end;
  { Tradu��es }

  { Inf. Sobre a Moeda  }

  TCountryCurrency = record
    code: string;
    name: string;
    symbol: string;
  end;
  { Inf. Sobre a Moeda  }

  { Lista de Moedas utilizadas no pa�s  }

  TCountryCurrencyList = record
    List: array of TCountryCurrency;
  end;
  { Lista de Moedas utilizadas no pa�s  }


  { Idioma do Pa�s }

  TCountryLanguage = record
    iso693_1: string;
    iso639_2: string;
    name: string;
    nativename: string;
  end;
  { Idioma do Pa�s }


  { Lista de Idiomas que s�o utilizados no pa�s }

  TCountryLanguagesList = record
    List: array of TCountryLanguage;
  end;
  { Lista de Idiomas que s�o utilizados no pa�s }

  { Response geral para qualquer pa�s }

  TResponseAllCountries = record
    FileAndPath: string;
    Json: string;
    Nome: string;
    TopLevelsDomain: array of string;
    Alpha2Code: string;
    Alpha3Code: string;
    CallingCodes: array of string;
    Capital: string;
    AltSpelling: array of string;
    Region: string;
    Subregion: string;
    Translations: TResponseCountryTranslation;
    Population: Integer;
    Coord: TResponseCoords;
    Demonym: string;
    Area: string;  //km� (mi�)
    Gini: string; //Coeficiente de Gini.
    Timezones: array of string;
    Borders: array of string; //fronteiras
    Nativename: string;
    NumericCode: integer;
    Currencies: TCountryCurrencyList;
    Languages: TCountryLanguagesList;
  end;
  { Response geral para qualquer pa�s }

  { Listagem de informa��es sobre um grupo de pa�ses }

  TResponseAllContriesList = record
    List: array of TResponseAllCountries;
  end;

  { Apenas a m�gica }
  TCountries = record
    function RequetAllCountries(CreateNewFile: boolean = false): TResponseAllContriesList;
    function RequestCountryInfoByName(Text: string; isPartial: Boolean = false): TResponseAllCountries;
    function RequestByCode(Code: string): TResponseAllCountries;
    function RequestByListCodes(Codes: array of string): TResponseAllContriesList;
    function RequestByCurrency(Currency: string): TResponseAllContriesList;
    function RequestByLanguage(lang: string): TResponseAllContriesList;
    function RequestByCapital(Capital: string): TResponseAllCountries;
    function RequestByCallingCode(Code: string): TResponseAllCountries;
    function RequestByRegion(Region: string): TResponseAllContriesList;
  end;

  TJsonCountryTratament = class
  public
    constructor Create(AJson: string);
    function Tratament: TResponseAllCountries;
  private
    Json: string;
  end;
  { Apenas a m�gica }

implementation
{ TCountries }

{                                                                              }
{                 BUSCA PELO C�DIGO DE CHAMADA [Ex:55]                         }
{                                                                              }

function TCountries.RequestByCallingCode(Code: string): TResponseAllCountries;
const
  Point = 'callingcode';
var
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  Data: TJsonCountryTratament;
  DataA : ISuperArray;
  DataO : ISuperObject;
begin
  try
    Http := TidHttp.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Code, ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  try
    DataA := SA(ResponseStream.DataString);
    DataO := DataA.O[0];
    Data := TJsonCountryTratament.Create(DataO.AsJSON(false));
  finally
    Result := Data.Tratament;
    FreeAndNil(Data);
    FreeAndNil(ResponseStream);
  end;
end;

{                                                                              }
{                 BUSCA PELO C�DIGO DE CHAMADA [Ex:55]                         }
{                                                                              }


{                                                                              }
{                 BUSCA DE ACORDO COM CAPITAL [Ex: Brasilia]                   }
{                                                                              }

function TCountries.RequestByCapital(Capital: string): TResponseAllCountries;
const
  Point = 'capital';
var
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  Data: TJsonCountryTratament;
  DataA : ISuperArray;
  DataO : ISuperObject;
begin
  try
    Http := TidHttp.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Capital, ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  try
    DataA := SA(ResponseStream.DataString);
    DataO :=  DataA.O[0];
    Data := TJsonCountryTratament.Create(DataO.AsJSON(false));
  finally
    Result := Data.Tratament;
    FreeAndNil(Data);
    FreeAndNil(ResponseStream);
  end;
end;

{                                                                              }
{                 BUSCA DE ACORDO COM CAPITAL [Ex: Brasilia]                   }
{                                                                              }


{                                                                              }
{                 BUSCA DE ACORDO COM C�DIGO DO PA�S                           }
{                                                                              }

function TCountries.RequestByCode(Code: string): TResponseAllCountries;
const
  Point = 'alpha';
var
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  Data: TJsonCountryTratament;
begin
  try
    Http := TidHttp.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Code, ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  try
    Data := TJsonCountryTratament.Create(ResponseStream.DataString);
  finally
    Result := Data.Tratament;
    FreeAndNil(Data);
    FreeAndNil(ResponseStream);
  end;
end;


{                                                                              }
{                 BUSCA DE ACORDO COM C�DIGO DO PA�S                           }
{                                                                              }


{                                                                              }
{                 BUSCA DE ACORDO COM MOEDA                                    }
{                                                                              }
function TCountries.RequestByCurrency(Currency: string): TResponseAllContriesList;
const
  Point = 'currency';
var
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  Data: TJsonCountryTratament;
  I: Integer;
  ResponseArr: ISuperArray;
  ResponseObj: ISuperObject;
begin
  try
    Http := TidHttp.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Currency, ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  ResponseArr := SA(ResponseStream.DataString);
  for I := 0 to ResponseArr.Length - 1 do
  begin
    ResponseObj := ResponseArr.O[I];
    SetLength(Result.List, Length(Result.List) + 1);
    try
      Data := TJsonCountryTratament.Create(ResponseObj.AsJSON(false));
    finally
      Result.List[Length(Result.List) - 1] := Data.Tratament;
      FreeAndNil(Data);
      FreeAndNil(ResponseStream);
    end;
  end;
end;

{                                                                              }
{                 BUSCA DE ACORDO COM MOEDA                                    }
{                                                                              }


{                                                                              }
{                 BUSCA DE ACORDO COM O IDIOMA                                 }
{                                                                              }
function TCountries.RequestByLanguage(lang: string): TResponseAllContriesList;
const
  Point = 'lang';
var
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  Data: TJsonCountryTratament;
  I: Integer;
  ResponseArr: ISuperArray;
  ResponseObj: ISuperObject;
begin
  try
    Http := TidHttp.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Lang, ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  ResponseArr := SA(ResponseStream.DataString);
  for I := 0 to ResponseArr.Length - 1 do
  begin
    ResponseObj := ResponseArr.O[I];
    SetLength(Result.List, Length(Result.List) + 1);
    try
      Data := TJsonCountryTratament.Create(ResponseObj.AsJSON(false));
    finally
      Result.List[Length(Result.List) - 1] := Data.Tratament;
      FreeAndNil(Data);
      FreeAndNil(ResponseStream);
    end;
  end;
end;

{                                                                              }
{                 BUSCA DE ACORDO COM O IDIOMA                                 }
{                                                                              }


{                                                                              }
{                 BUSCA DE ACORDO COM LISTA DE C�DIGOS                         }
{                                                                              }
function TCountries.RequestByListCodes(Codes: array of string): TResponseAllContriesList;
const
  Point = 'alpha?codes';
var
  I: Integer;
  Query: string;
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  Data: TJsonCountryTratament;
  ResponseArr: ISuperArray;
  ResponseObj: ISuperObject;
begin
  Query := '';
  for I := 0 to Length(Codes) - 1 do
  begin
    Query := Query + Codes[I] + ';';
  end;
  Delete(Query, Length(Query), 1);

  try
    Http := TidHttp.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '=' + Query, ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  ResponseArr := SA(ResponseStream.DataString);
  for I := 0 to ResponseArr.Length - 1 do
  begin
    ResponseObj := ResponseArr.O[I];
    SetLength(Result.List, Length(Result.List) + 1);
    try
      Data := TJsonCountryTratament.Create(ResponseObj.AsJSON(false));
    finally
      Result.List[Length(Result.List) - 1] := Data.Tratament;
      FreeAndNil(Data);
      FreeAndNil(ResponseStream);
    end;
  end;

end;

{                                                                              }
{                 BUSCA DE ACORDO COM LISTA DE C�DIGOS                         }
{                                                                              }


{                                                                              }
{                 BUSCA DE ACORDO COM REGI�O                                   }
{                                                                              }
function TCountries.RequestByRegion(Region: string): TResponseAllContriesList;
const
  Point = 'region';
var
  I: Integer;
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  Data: TJsonCountryTratament;
  ResponseArr: ISuperArray;
  ResponseObj: ISuperObject;
begin
  try
    Http := TidHttp.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Region, ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  ResponseArr := SA(ResponseStream.DataString);
  for I := 0 to ResponseArr.Length - 1 do
  begin
    ResponseObj := ResponseArr.O[I];
    SetLength(Result.List, Length(Result.List) + 1);
    try
      Data := TJsonCountryTratament.Create(ResponseObj.AsJSON(false));
    finally
      Result.List[Length(Result.List) - 1] := Data.Tratament;
      FreeAndNil(Data);
      FreeAndNil(ResponseStream);
    end;
  end;
end;
{                                                                              }
{                 BUSCA DE ACORDO COM REGI�O                                   }
{                                                                              }

{                                                                              }
{                 BUSCA DE ACORDO COM NOME DO PA�S                             }
{                                                                              }

function TCountries.RequestCountryInfoByName(Text: string; isPartial: Boolean = false): TResponseAllCountries;
const
  Point = 'name';
var
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  JsonA: ISuperArray;
  JsonO: ISuperObject;
  Data: TJsonCountryTratament;
begin
  try
    Http := TIdHTTP.Create(nil);
    ResponseStream := TStringStream.Create;
    with Http do
    begin
      if isPartial then
        Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Text, ResponseStream)
      else
        Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point + '/' + Text + '?fullText=True', ResponseStream)
    end;
  finally
    Http.Disconnect;
    FreeAndNil(Http);
  end;

  try
    JsonA := SA(ResponseStream.DataString);
    JsonO := JsonA.O[0];
    Data := TJsonCountryTratament.Create(JsonO.AsJSON(False));
    Result := Data.Tratament;
  finally
    FreeAndNil(ResponseStream);
  end;

end;

{                                                                              }
{                 BUSCA DE ACORDO COM NOME DO PA�S                             }
{                                                                              }

{                                                                              }
{                 RETORNA TODOS.                                               }
{                                                                              }
function TCountries.RequetAllCountries(CreateNewFile: boolean = false): TResponseAllContriesList;
const
  Point = 'all'; //Queremos dados de todos paises
  EmptyResponseResult: TResponseAllCountries = ();
var
  Http: TIdHTTP;
  ResponseStream: TStringStream;
  ResponseResult: TResponseAllCountries;
  JsonText: TStringList;
  Json: ISuperArray;
  Country: ISuperObject;
  Countries: TResponseAllContriesList;
  I: Integer;
  JsonTratament: TJsonCountryTratament;
begin
  //Atualizar dados do json?
  if (CreateNewFile) then
  begin
    try
      Http := TIdHTTP.Create(nil);
      ResponseStream := TStringStream.Create;
      with Http do
      begin
        Get(BaseURL + CallPath + '/' + AppVersion + '/' + Point, ResponseStream);
      end;
    finally
      ResponseStream.SaveToFile(SavePathTempJSON + 'response.json');    // Salvando informa��es em response.json
      Http.Disconnect;
      FreeAndNil(Http);
      FreeAndNil(ResponseStream);
    end;
  end;
  ResponseResult.FileAndPath := SavePathTempJSON + 'response.json';
  JsonText := TStringList.Create;
  JsonText.LoadFromFile(ResponseResult.FileAndPath);
  Json := SA(JsonText.Text);

  for I := 0 to Json.Length - 1 do
  begin
    //  Empty
    ResponseResult := EmptyResponseResult;
    { INICIALIZADOR }
    Country := Json.O[I];
    { INICIALIZADOR }
    try
      JsonTratament := TJsonCountryTratament.Create(Country.AsJSON(false));
      SetLength(Result.List, Length(Result.List) + 1);
      Result.List[Length(Result.List) - 1] := JsonTratament.Tratament;
    finally
      FreeAndNil(JsonTratament);
    end;

  end;
end;
{                                                                              }
{                 RETORNA TODOS.                                               }
{                                                                              }

{ TJsonCountryTratament }

constructor TJsonCountryTratament.Create(AJson: string);
begin
  Self.Json := AJson;
end;

function TJsonCountryTratament.Tratament: TResponseAllCountries;
const
  EmptyResponseResult: TResponseAllCountries = ();
var
  Country: ISuperObject;
  I: Integer;
  tmpCurrency: ISuperObject;
  tmpLang: ISuperObject;
  tmpCoord: ISuperArray;
begin

  Result := EmptyResponseResult;
  Country := SO(Self.Json);
  Result.Json := Self.Json;
  Result.FileAndPath := '.';

  Result.Nome := Country['name'].AsString;

  { DOM�NIOS NA INTERNET }
  for I := 0 to Country['topLevelDomain'].AsArray.Length - 1 do
  begin
    SetLength(Result.TopLevelsDomain, Length(Result.TopLevelsDomain) + 1);
    Result.TopLevelsDomain[Length(Result.TopLevelsDomain) - 1] := Country['topLevelDomain'].AsArray.S[I];
  end;
  { DOM�NIOS NA INTERNET }

  { ALPHA 2 CODE (SIG) }
  Result.Alpha2Code := Country['alpha2Code'].AsString;
  { ALPHA 2 CODE (SIG) }

  { ALPHA 3 CODE (SIG) }
  Result.Alpha3Code := Country['alpha3Code'].AsString;
  { ALPHA 3 CODE (SIG) }

  { C�DIGOS PARA LIGA��ES }
  for I := 0 to Country['callingCodes'].AsArray.Length - 1 do
  begin
    SetLength(Result.CallingCodes, Length(Result.CallingCodes) + 1);
    Result.CallingCodes[Length(Result.CallingCodes) - 1] := Country['callingCodes'].AsArray.S[I];
  end;
  { C�DIGOS PARA LIGA��ES }

  { CAPITAL }
  Result.Capital := Country['capital'].AsString;
  { CAPITAL }

  { FORMAS ALTERNATIVAS (NOME DO PA�S)  }
  for I := 0 to Country['altSpellings'].AsArray.Length - 1 do
  begin
    SetLength(Result.AltSpelling, Length(Result.AltSpelling) + 1);
    Result.AltSpelling[Length(Result.AltSpelling) - 1] := Country['altSpellings'].AsArray.S[I];
  end;
  { FORMAS ALTERNATIVAS (NOME DO PA�S)  }

  { REGI�O  }
  Result.Region := Country['region'].AsString;
  { REGI�O  }

  { SUB-REGI�O }
  Result.Subregion := Country['subregion'].AsString;
  { SUB-REGI�O }

  {
            TRADU��ES
       * Alemanha
       * Espanha
       * Fran�a
       * Jap�o
       * It�lia
    }
  Result.Translations.de := Country['translations.de'].AsString;
  Result.Translations.es := Country['translations.es'].AsString;
  Result.Translations.fr := Country['translations.fr'].AsString;
  Result.Translations.ja := Country['translations.ja'].AsString;
  Result.Translations.it := Country['translations.it'].AsString;
    {
            TRADU��ES
       * Alemanha
       * Espanha
       * Fran�a
       * Jap�o
       * It�lia
    }

    { Popula��o }
  Result.Population := Country['population'].AsInteger;
    { Popula��o}


  tmpCoord := Country['latlng'].AsArray;

    { Latitude }
  Result.Coord.lat := tmpCoord.V[0];
    { Latitude }

    { Longitude }
  Result.Coord.lng := tmpCoord.V[1];
    { Longitude }

    { COMO SE CHAMA A POPULA��O }
  Result.Demonym := Country['demonym'].AsString;
    { COMO SE CHAMA A POPULA��O }

    { �REA }
  Result.Area := Country['area'].AsString;
    { �REA }

    { COEFICIENTE DE GINI }
  Result.Gini := Country['gini'].AsString;
    { COEFICIENTE DE GINI }

    { TIMEZONES }
  for I := 0 to Country['timezones'].AsArray.Length - 1 do
  begin
    SetLength(Result.Timezones, Length(Result.Timezones) + 1);
    Result.Timezones[Length(Result.Timezones) - 1] := Country['timezones'].AsArray.S[I];
  end;
    { TIMEZONES }

    { FRONTEIRAS  }
  for I := 0 to Country['borders'].AsArray.Length - 1 do
  begin
    SetLength(Result.Borders, Length(Result.Borders) + 1);
    Result.Borders[Length(Result.Borders) - 1] := Country['borders'].AsArray.S[I];
  end;
    { FRONTEIRAS  }

    { NOME NATIVO }
  Result.Nativename := Country['nativeName'].AsString;
    { NOME NATIVO }

    { C�DIGO NUM�RICO }
  Result.NumericCode := Country['numericCode'].AsInteger;
    { C�DIGO NUM�RICO }

    { MOEDAS  }
  for I := 0 to Country['currencies'].AsArray.Length - 1 do
  begin
    SetLength(Result.Currencies.List, Length(Result.Currencies.List) + 1);
    tmpCurrency := Country['currencies'].AsArray.O[I];
    Result.Currencies.List[Length(Result.Currencies.List) - 1].code := tmpCurrency['code'].AsString;     //COD
    Result.Currencies.List[Length(Result.Currencies.List) - 1].name := tmpCurrency['name'].AsString;     //NOME
    Result.Currencies.List[Length(Result.Currencies.List) - 1].symbol := tmpCurrency['symbol'].AsString; //SIMBOLO
  end;
    { MOEDAS  }

    { IDIOMAS }
  for I := 0 to Country['languages'].AsArray.Length - 1 do
  begin
    SetLength(Result.Languages.List, Length(Result.Languages.List) + 1);
    tmpLang := Country['languages'].AsArray.O[I];
    Result.Languages.List[Length(Result.Languages.List) - 1].iso693_1 := tmpLang['iso639_1'].AsString;
    Result.Languages.List[Length(Result.Languages.List) - 1].iso639_2 := tmpLang['iso639_2'].AsString;
    Result.Languages.List[Length(Result.Languages.List) - 1].name := tmpLang['name'].AsString;
    Result.Languages.List[Length(Result.Languages.List) - 1].nativename := tmpLang['nativename'].AsString;
  end;
    { IDIOMAS }

end;

end.


