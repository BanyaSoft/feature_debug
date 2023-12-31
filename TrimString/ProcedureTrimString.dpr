program ProcedureTrimString;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.StrUtils;

procedure TrimString(var str: string);
const
  doubleSpace = '  ';
begin
  str := Trim(str);
  while Pos(doubleSpace, str) <> 0 do
    Delete(str, Pos(doubleSpace, str), 1);
end;

var
  s: string;

begin
  s := 'UpperCase is the hardest task ever';
  TrimString(s);
  writeln(s);
  s := '        Gfh hf a a  a  a a      fhj   ';
  TrimString(s);
  writeln(s);
  readln;
end.
