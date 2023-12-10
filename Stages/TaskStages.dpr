program TaskStages;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  System.StrUtils;

type
  TDictionary = array [1 .. 4] of array of string;
  TSetOfWords = array [1 .. 8] of string;

  function RandomArr(words: TDictionary; numberOfWords: byte): TSetOfWords;
var
  arrTemp: TSetOfWords;
  rIndex: word;
begin
  for var i := 1 to 8 do
    arrTemp[i] := '';
  for var j := 1 to numberOfWords do
  begin
    rIndex := random(4) + 1;
    arrTemp[j] := words[rIndex][random(Length(words[rIndex]))];
  end;
  Result := arrTemp;
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

procedure TrimString(var str: string);
const
  doubleSpace = '  ';
begin
  str := Trim(str);
  while Pos(doubleSpace, str) <> 0 do
    Delete(str, Pos(doubleSpace, str), 1);
end;

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

function ReverseStr(str: string): string;
var
  reversedStr: string;
  i: integer;
begin
  setlength(reversedStr, length(str));
  for i := 1 to length(str) do
    reversedStr[i] := str[length(str) - i + 1];
  Result := reversedStr;
end;

procedure ClearScreen();
var
  ConsoleSize, NumWritten: LongWord;
  Origin: Coord;
  ScreenBufferInfo: CONSOLE_SCREEN_BUFFER_INFO;
  hStdOut: THandle;
begin
  hStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(hStdOut, ScreenBufferInfo);
  ConsoleSize := ScreenBufferInfo.dwSize.X * ScreenBufferInfo.dwSize.Y;
  Origin.X := 0;
  Origin.Y := 0;
  FillConsoleOutputCharacter(hStdOut, ' ', ConsoleSize, Origin, NumWritten);
  FillConsoleOutputAttribute(hStdOut, ScreenBufferInfo.wAttributes, ConsoleSize,
    Origin, NumWritten);
  SetConsoleCursorPosition(hStdOut, Origin);
end;

function IsValid1(stage1Str, userStr: string): boolean;
begin
  stage1Str := ReverseStr(stage1Str);
  if stage1Str = userStr then
    Result := true
  else
    Result := false;
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

procedure Stage1(words: TDictionary);
begin
  var
    level, counter: integer;
  var
    stage1Str, inputword: string='';
  level := 1;
  counter:=1;
  while level <= 4 do
  begin
    writeln('Этап 1. Уровень ', level);
    while counter<=3 do
    begin
      stage1Str := words[level][random(length(words[level]))];
      writeln(stage1Str);
      sleep(3000);
      ClearScreen();
      writeln('Этап 1. Уровень ', level, #13#10, 'Введите слово');
      readln(inputword);
      TrimString(inputword);
      while IsValid(inputword) <>$00 do
       begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValid1(stage1Str, AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter:=1;
      end;
      else
      begin
      writeln('ОТВЕТ ВЕРНЫЙ!');
      inc(counter);
       writeln('Прогресс: ',counter,' из 3');
      end;
      ClearScreen();
    end;
    inc(level);
  end;
  writeln('Вы прошли первый этап! Поздравляем!')
end;

procedure Stage2(words: TDictionary);
begin
 var
    level, counter: integer;
  var
  inputword: string;
  var setofwords:TSetOfWords;
   level := 1;
  counter:=1;
  while level<=4 do
  begin
   writeln('Этап 2. Уровень ', level);
   while counter<=3 do
   begin
    setofwords:=RandomArr(words,level+4);
    for var i := 1 to level+4 do
      begin
      if (i<>level+4) then
       write(setofwords[i],' ')
       else
       write(setofwords[i]);
      end;
   sleep(5000);
   ClearScreen();
   writeln('Этап 2. Уровень ', level, #13#10, 'Введите словa');
   readln(inputword);
   TrimString(inputword);
    while IsValid(inputword) <>$00 do
       begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValid2(setofwords,level+4,AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter:=1;
      end;
      else
      begin
      writeln('ОТВЕТ ВЕРНЫЙ!');
      inc(counter);
       writeln('Прогресс: ',counter,' из 3');
      end;
      ClearScreen();
   end;
   inc(level);
  end;
   writeln('Вы прошли второй этап! Поздравляем!')
end;

procedure Stage3(words: TDictionary);
begin
 var
    level, counter: integer;
  var
  inputword: string;
  var setofwords:TSetOfWords;
  level := 1;
  counter:=1;
  while level<=4 do
  begin
  writeln('Этап 3. Уровень ', level);
  while counter<=3 do
   begin
    setofwords:=RandomArr(words,level+4);
    for var i := 1 to level+4 do
      begin
      if (i<>level+4) then
       write(setofwords[i],' ')
       else
       write(setofwords[i]);
      end;
   sleep(5000);
   ClearScreen();
   writeln('Этап 3. Уровень ', level, #13#10, 'Введите словa');
   readln(inputword);
   TrimString(inputword);
   while IsValid(inputword) <>$00 do
       begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValid3(setofwords,level+4,AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter:=1;
      end;
      else
      begin
      writeln('ОТВЕТ ВЕРНЫЙ!');
      inc(counter);
       writeln('Прогресс: ',counter,' из 3');
      end;
      ClearScreen();
   end;

   inc(level);
  end;
   writeln('Вы прошли третий этап! Поздравляем!')
end;

procedure Stage4(words: TDictionary);
begin
  var
    level, counter: integer;
  var
  inputword: string;
  var setofwords:TSetOfWords;
  level := 1;
  counter:=1;
  while level<=4 do
  begin
  writeln('Этап 4. Уровень ', level);
  while counter <= 3 do
   begin
    setofwords:=RandomArr(words,level+4);
    for var i := 1 to level+4 do
      begin
      if (i<>level+4) then
       write(setofwords[i],' ')
       else
       write(setofwords[i]);
      end;
   sleep(5000);
   ClearScreen();
   writeln('Этап 4. Уровень ', level, #13#10, 'Введите словa');
   readln(inputword);
   TrimString(inputword);
   while IsValid(inputword) <>$00 do
       begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValid4(setofwords,level+4,AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter:=1;
      end;
      else
      begin
      writeln('ОТВЕТ ВЕРНЫЙ!');
      inc(counter);
       writeln('Прогресс: ',counter,' из 3');
      end;
      ClearScreen();
      end;

   inc(level);
  end;
   writeln('Вы прошли четвертый этап! Поздравляем!')
end;

procedure Stage5(words: TDictionary);
begin
 var
    level, counter: integer;
  var
  inputword: string;
  var setofwords:TSetOfWords;
  level := 1;
  counter:=1;
  while level<=4 do
  begin
  writeln('Этап 5. Уровень ', level);
  while counter<= 3 do
   begin
    setofwords:=RandomArr(words,level+4);
    for var i := 1 to level+4 do
      begin
      if (i<>level+4) then
       write(setofwords[i],' ')
       else
       write(setofwords[i]);
      end;
   sleep(5000);
   ClearScreen();
   writeln('Этап 5. Уровень ', level, #13#10, 'Введите словa');
   readln(inputword);
   TrimString(inputword);
    while IsValid(inputword) <>$00 do
       begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValid5(setofwords,level+4,AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter:=1;
      end;
      else
      begin
      writeln('ОТВЕТ ВЕРНЫЙ!');
      inc(counter);
       writeln('Прогресс: ',counter,' из 3')
      end;
      ClearScreen();
      end;
   inc(level);
  end;
   writeln('Вы прошли пятый этап! Поздравляем!')
end;

begin

end.
