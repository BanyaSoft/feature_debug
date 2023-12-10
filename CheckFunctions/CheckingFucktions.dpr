﻿program CheckingFucktions;

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
    Result := true
  else
    Result := false;
end;

function IsValidS2(stageArr: TSetOfWords; numOfWords: Byte;
  userStr: string): boolean;
var
  checkWord: string;
  i: Byte;
  flag: boolean;
const
  space = ' ';
begin
  flag := true;
  userStr := concat(space, userStr, space);
  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := concat(space, checkWord, space);
    if pos(checkWord, userStr) = 0 then
    begin
      flag := false;
      break;
    end
    else
      Delete(userStr, pos(checkWord, userStr), length(checkWord) - 1);
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
    Result := true
  else
    Result := false;
end;

function IsValidS4(stageArr: TSetOfWords; numOfWords: Byte;
  userStr: string): boolean;
var
  i: Byte;
  checkWord: string;
  flag: boolean;
const
  space = ' ';
begin
  for i := 1 to numOfWords do
    stageArr[i] := ReverseString(stageArr[i]);
  userStr := concat(space, userStr, space);
  flag := true;
  userStr := concat(space, userStr, space);
  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := concat(space, checkWord, space);
    if pos(checkWord, userStr) = 0 then
    begin
      flag := false;
      break;
    end
    else
      Delete(userStr, pos(checkWord, userStr), length(checkWord) - 1);
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
  flag: boolean;
begin
  for i := 1 to ((numOfWords + 1) shr 1) do
  begin
    temp := stageArr[i];
    stageArr[i] := stageArr[numOfWords - i + 1];
    stageArr[numOfWords - i + 1] := temp;
  end;
  for i := 1 to numOfWords do
    stageArr[i] := ReverseString(stageArr[i]);
  checkString := String.Join(space, stageArr, 1, numOfWords);
  if checkString = userStr then
    Result := true
  else
    Result := false;
end;

end.
