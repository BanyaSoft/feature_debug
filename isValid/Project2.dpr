program Project2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, System.StrUtils;

function IsValid(checkStr: string): byte;
var
  i, number: integer;
  flag: boolean;
  value: byte;
begin
  flag := true;
  value := $00;
  if Length(checkStr) = 0 then
    value := $01
  else
  begin
    for i := 1 to Length(checkStr) do
    begin
      number := Ord(checkStr[i]);
      if not ((number >= 1040) or (number <= 1071) or (number = 32)) then
        flag := false;
    end;
    if not flag then
      value := $10
    else
      value := $00;
  end;
  Result := value;
end;

var
  test: integer;
  testStr: string;

begin
  readln(testStr);
  test := IsValid(testStr);
  writeln(test);
  readln;
end.
