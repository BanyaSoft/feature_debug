program FunctionRandomArr;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  TDictionary = array [1 .. 4] of array of string;
  TSetOfWords = array [1 .. 8] of string;

function RandomArr(words: TDictionary; numberOfWords: byte): TSetOfWords;
var
  arrTemp: TSetOfWords;
  rIndex: word;
begin
  Randomize;
  for var i := 1 to 8 do
    arrTemp[i] := '';
  for var j := 1 to numberOfWords do
  begin
    rIndex := random(4) + 1;
    arrTemp[j] := words[rIndex][random(Length(words[rIndex]))];
  end;
  Result := arrTemp;
end;

begin

end.
