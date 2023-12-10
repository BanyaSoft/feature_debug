program CheckingFucktions;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, System.StrUtils;

type
  TSetOfWords = array [1 .. 8] of string;

function IsValid1(stageStr, userStr: string): boolean;
begin
  stageStr := ReverseString(stageStr);
  if stageStr = userStr then
    Result := True
  else
    Result := False;
end;

function IsValidS2(stageArr: TSetOfWords; numOfWords: Byte;
  userStr: string): boolean;
const
  space = ' ';
var
  checkWord: string;
  i: Byte;
  flag: boolean;
begin
  flag := True;
  userStr := Concat(space, userStr, space);

  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := Concat(space, checkWord, space);
    if Pos(checkWord, userStr) = 0 then
    begin
      flag := False;
      break;
    end
    else
      Delete(userStr, Pos(checkWord, userStr), Length(checkWord) - 1);
  end;
  Result := flag;
end;

function IsValidS3(stageArr: TSetOfWords; numOfWords: Byte;
  userStr: string): boolean;
const
  space = ' ';
var
  checkString: string;
begin
  checkString := String.Join(space, stageArr, 1, numOfWords);
  if checkString = userStr then
    Result := True
  else
    Result := False;
end;

function IsValidS4(stageArr: TSetOfWords; numOfWords: Byte;
  userStr: string): boolean;
// для этапа 1 тоже можно применить. numOfWords будет равно 1. В массиве только 1 элемент
const
  space = ' ';
var
  i: Byte;
  checkWord: string;
  flag: boolean;
begin
  for i := 1 to numOfWords do
    stageArr[i] := ReverseString(stageArr[i]);
  userStr := Concat(space, userStr, space);

  flag := True;
  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := Concat(space, checkWord, space);
    if Pos(checkWord, userStr) = 0 then
    begin
      flag := False;
      break;
    end
    else
      Delete(userStr, Pos(checkWord, userStr), Length(checkWord) - 1);
  end;
  Result := flag;

end;

function IsValidS5(stageArr: TSetOfWords; numOfWords: Byte;
  userStr: string): boolean;
const
  space = ' ';
var
  i: integer;
  temp, checkString: string;
begin
  for i := 1 to ((numOfWords + 1) div 2) do
  begin
    temp := stageArr[i];
    stageArr[i] := stageArr[numOfWords - i + 1];
    stageArr[numOfWords - i + 1] := temp;
  end;
  for i := 1 to numOfWords do
    stageArr[i] := ReverseString(stageArr[i]);
  checkString := String.Join(space, stageArr, 1, numOfWords);
  if checkString = userStr then
    Result := True
  else
    Result := False;
end;

end.
