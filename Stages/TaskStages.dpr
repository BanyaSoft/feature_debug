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
      if (number < 1040) or (number > 1071) then
        flag := false;
    end;
    if not flag then
      value := $10
    else
      value := $00;
  end;
  Result := value;
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

function IsValidS1(stageStr, userStr: string): boolean;
begin
  stageStr := ReverseString(stageStr);
  if stageStr = userStr then
    Result := true
  else
    Result := false;
end;

function IsValidS2(stageArr: TSetOfWords; numOfWords: byte;
  userStr: string): boolean;
const
  space = ' ';
var
  checkWord: string;
  i: byte;
  flag: boolean;
begin
  flag := true;
  userStr := Concat(space, userStr, space);

  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := Concat(space, checkWord, space);
    if Pos(checkWord, userStr) = 0 then
    begin
      flag := false;
      break;
    end
    else
      Delete(userStr, Pos(checkWord, userStr), Length(checkWord) - 1);
  end;
  Result := flag;
end;

function IsValidS3(stageArr: TSetOfWords; numOfWords: byte;
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

function IsValidS4(stageArr: TSetOfWords; numOfWords: byte;
  userStr: string): boolean;
// для этапа 1 тоже можно применить. numOfWords будет равно 1. В массиве только 1 элемент
const
  space = ' ';
var
  i: byte;
  checkWord: string;
  flag: boolean;
begin
  for i := 1 to numOfWords do
    stageArr[i] := ReverseString(stageArr[i]);
  userStr := Concat(space, userStr, space);

  flag := true;
  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := Concat(space, checkWord, space);
    if Pos(checkWord, userStr) = 0 then
    begin
      flag := false;
      break;
    end
    else
      Delete(userStr, Pos(checkWord, userStr), Length(checkWord) - 1);
  end;
  Result := flag;
end;

function IsValidS5(stageArr: TSetOfWords; numOfWords: byte;
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
    Result := true
  else
    Result := false;
end;

procedure Stage1(words: TDictionary);
var
  level, counter: integer;
  stageStr, inputStr: string;
begin
  stageStr := '';
  inputStr := '';

  level := 1;
  while level <= 4 do
  begin
    counter := 1;
    while counter <= 3 do
    begin
      writeln('Этап 1. Уровень ', level);
      stageStr := words[level][random(Length(words[level]))];
      writeln(stageStr);
      sleep(3000);
      ClearScreen();
      writeln('Этап 1. Уровень ', level, #13#10, 'Введите слово:');
      readln(inputStr);
      TrimString(inputStr);
      while IsValid(inputStr) <> $00 do
      begin
        writeln('Повторите ввод');
        readln(inputStr);
        TrimString(inputStr);
      end;
      if IsValidS1(stageStr, AnsiUpperCase(inputStr)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter := 1;
      end
      else
      begin
        writeln('ОТВЕТ ВЕРНЫЙ!');
        writeln('Прогресс: ', counter, ' из 3');
        Inc(counter);
      end;
      ClearScreen();
    end;
    Inc(level);
  end;

  writeln('Вы прошли Этап 1! Поздравляем!')
end;

procedure Stage2(words: TDictionary);
var
  level, counter: integer;
  inputword: string;
  setofwords: TSetOfWords;
begin
  level := 1;
  counter := 1;
  while level <= 4 do
  begin
    writeln('Этап 2. Уровень ', level);
    while counter <= 3 do
    begin
      setofwords := RandomArr(words, level + 4);
      for var i := 1 to level + 4 do
      begin
        if (i <> level + 4) then
          write(setofwords[i], ' ')
        else
          write(setofwords[i]);
      end;
      sleep(5000);
      ClearScreen();
      writeln('Этап 2. Уровень ', level, #13#10, 'Введите словa');
      readln(inputword);
      TrimString(inputword);
      while IsValid(inputword) <> $00 do
      begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValidS2(setofwords, level + 4, AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter := 1;
      end
      else
      begin
        writeln('ОТВЕТ ВЕРНЫЙ!');
        writeln('Прогресс: ', counter, ' из 3');
        Inc(counter);
      end;
      ClearScreen();
    end;
    Inc(level);
  end;
  writeln('Вы прошли второй этап! Поздравляем!')
end;

procedure Stage3(words: TDictionary);
begin
  var
    level, counter: integer;
  var
    inputword: string;
  var
    setofwords: TSetOfWords;
  level := 1;
  counter := 1;
  while level <= 4 do
  begin
    writeln('Этап 3. Уровень ', level);
    while counter <= 3 do
    begin
      setofwords := RandomArr(words, level + 4);
      for var i := 1 to level + 4 do
      begin
        if (i <> level + 4) then
          write(setofwords[i], ' ')
        else
          write(setofwords[i]);
      end;
      sleep(5000);
      ClearScreen();
      writeln('Этап 3. Уровень ', level, #13#10, 'Введите словa');
      readln(inputword);
      TrimString(inputword);
      while IsValid(inputword) <> $00 do
      begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValidS3(setofwords, level + 4, AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter := 1;
      end
      else
      begin
        writeln('ОТВЕТ ВЕРНЫЙ!');
        Inc(counter);
        writeln('Прогресс: ', counter, ' из 3');
      end;
      ClearScreen();
    end;

    Inc(level);
  end;
  writeln('Вы прошли третий этап! Поздравляем!')
end;

procedure Stage4(words: TDictionary);
begin
  var
    level, counter: integer;
  var
    inputword: string;
  var
    setofwords: TSetOfWords;
  level := 1;
  counter := 1;
  while level <= 4 do
  begin
    writeln('Этап 4. Уровень ', level);
    while counter <= 3 do
    begin
      setofwords := RandomArr(words, level + 4);
      for var i := 1 to level + 4 do
      begin
        if (i <> level + 4) then
          write(setofwords[i], ' ')
        else
          write(setofwords[i]);
      end;
      sleep(5000);
      ClearScreen();
      writeln('Этап 4. Уровень ', level, #13#10, 'Введите словa');
      readln(inputword);
      TrimString(inputword);
      while IsValid(inputword) <> $00 do
      begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValidS4(setofwords, level + 4, AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter := 1;
      end
      else
      begin
        writeln('ОТВЕТ ВЕРНЫЙ!');
        Inc(counter);
        writeln('Прогресс: ', counter, ' из 3');
      end;
      ClearScreen();
    end;

    Inc(level);
  end;
  writeln('Вы прошли четвертый этап! Поздравляем!')
end;

procedure Stage5(words: TDictionary);
begin
  var
    level, counter: integer;
  var
    inputword: string;
  var
    setofwords: TSetOfWords;
  level := 1;
  counter := 1;
  while level <= 4 do
  begin
    writeln('Этап 5. Уровень ', level);
    while counter <= 3 do
    begin
      setofwords := RandomArr(words, level + 4);
      for var i := 1 to level + 4 do
      begin
        if (i <> level + 4) then
          write(setofwords[i], ' ')
        else
          write(setofwords[i]);
      end;
      sleep(5000);
      ClearScreen();
      writeln('Этап 5. Уровень ', level, #13#10, 'Введите словa');
      readln(inputword);
      TrimString(inputword);
      while IsValid(inputword) <> $00 do
      begin
        writeln('Повторите ввод');
        readln(inputword);
        TrimString(inputword);
      end;
      if IsValidS5(setofwords, level + 4, AnsiUpperCase(inputword)) = false then
      begin
        writeln('ОТВЕТ НЕВЕРНЫЙ! Попробуйте еще раз.');
        counter := 1;
      end
      else
      begin
        writeln('ОТВЕТ ВЕРНЫЙ!');
        Inc(counter);
        writeln('Прогресс: ', counter, ' из 3')
      end;
      ClearScreen();
    end;
    Inc(level);
  end;
  writeln('Вы прошли пятый этап! Поздравляем!')
end;

begin

end.
