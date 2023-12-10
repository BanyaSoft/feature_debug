program CheckingFucktions;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  TSetOfWords = array [1 .. 8] of string;

function ReverseStr(str: string): string; // можно дополнить если добавить на вход массив строк с которыми будет работать эта функция
var
  reversedStr: string;
  i: integer;
begin
  setlength(reversedStr, length(str));
  for i := 1 to length(str) do
    reversedStr[i] := str[length(str) - i + 1];
  Result := reversedStr;
end;



function ConcatArr(stageArr:TSetOfWords;numOfWords:Byte):string;
var str:string; i:integer; const space = ' ';
  begin
  str := '';
  for i := 1 to numOfWords do
    str := concat(str,stageArr[i],space);
  str := Trim(str);
  Result := str;
  end;


  function IsValid1(stage1Str,userStr:string): boolean;
    begin
    stage1Str := ReverseStr(stage1Str);
    if stage1Str = userStr then
      result := true
    else
      result := false;
    end;


function IsValidS2(stage2Arr: TSetOfWords; numOfWords: Byte; userStr: string): Boolean; // Всю эту функцию можно впендюрить в функцию IsValidS4
var
  checkWord: string;
  i: Byte;
const
  space = ' ';
begin
  userStr := concat(space,userStr,space);
  for i := 1 to numOfWords do
  begin
    checkWord := stage2Arr[i];
    checkWord := concat(space,checkWord,space);
    case pos(checkWord, userStr) of
      0:
        begin
          Result := false;
          exit
        end;
    end;
    Delete(userStr,pos(checkWord,userStr),length(checkWord)-1);
  end;
  Result := true;
end;


function IsValidS3(stage3Arr: TSetOfWords; numOfWords: Byte; userStr: string): Boolean;
var
  checkString: string;
  flag: Boolean;
begin
  checkString := ConcatArr(stage3Arr, numOfWords);
  if checkString = userStr then
    flag := true
  else
    flag := false;
  Result := flag;
end;


function IsValidS4(stage4Arr: TSetOfWords; numOfWords: Byte; // для этапа 1 тоже можно применить. numOfWords будет равно 1. В массиве только 1 элемент
  userStr: string): Boolean;
var
  i: Byte;
  checkWord: string;
const
  space = ' ';
begin
  for i := 1 to numOfWords do
    stage4Arr[i] := ReverseStr(stage4Arr[i]);
  userStr := concat(space, userStr, space);                          // вот эту часть отмеченную слешами можно впендюрить функцию IsValidS2
  for i := 1 to numOfWords do                                        //
  begin                                                              //
    checkWord := stage4Arr[i];                                       //
    checkWord := concat(space, checkWord, space);                    //
    case pos(checkWord, userStr) of                                  //
      0:                                                             //
        begin                                                        //
          Result := false;                                           //
          exit                                                       //
        end;                                                         //
    end;                                                             //
    Delete(userStr, pos(checkWord, userStr), length(checkWord) - 1); //
  end;                                                               //
  Result := true;                                                    //

end;


function IsValidS5(stage5Arr: TSetOfWords; numOfWords: Byte;
  userStr: string): Boolean;
 var i:integer; temp,checkString: string; flag:Boolean;
   begin
   for i := 1 to ((numOfWords+1) shr 1) do
     begin
     temp := stage5Arr[i];
       stage5Arr[i] := stage5Arr[numOfWords - i + 1];
       stage5Arr[numOfWords - i + 1] := temp;
     end;
     for i := 1 to numOfWords do
       stage5Arr[i] := ReverseStr(stage5Arr[i]);
     checkString := ConcatArr(stage5Arr, numOfWords);  // можно вставить IsValid3
     if checkString = userStr then                     //
       flag := true                                    //
     else                                              //
       flag := false;                                  //
     Result := flag;                                   //
   end;
 end.
