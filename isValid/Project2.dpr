program Project2;

function IsValid(var checkStr: string): byte;
var
  i, number: integer;
  flag: boolean;
begin
  flag := true;
  if length(checkStr) = 0 then
    IsValid := $01
  else
  begin
    for i := 1 to length(checkStr) do
    begin
      number := Ord(checkStr[i]);
      if (number < 1040) or (number > 1071) then
        flag := false;
    end;
    if not flag then
      IsValid := $10
    else
      IsValid := $00;
  end
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
