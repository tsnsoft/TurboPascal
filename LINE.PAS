uses Graph;

var
  grDriver : Integer;
  grMode : Integer;
  ErrCode : Integer;

begin
  grDriver := Detect;
  InitGraph(grDriver, grMode, 'P:\BP\BGI');
  ErrCode := GraphResult;
  if ErrCode = grOk then begin

     { Графика }
     Line(0, 0, GetMaxX, GetMaxY);
{     writeln( GetMaxX, '  ',GetMaxY);}
     ReadLn;

     CloseGraph;
  end
  else
   WriteLn('Ошибка инициализации графики:', GraphErrorMsg(ErrCode));
end.