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

     { ��䨪� }
     Line(0, 0, GetMaxX, GetMaxY);
{     writeln( GetMaxX, '  ',GetMaxY);}
     ReadLn;

     CloseGraph;
  end
  else
   WriteLn('�訡�� ���樠����樨 ��䨪�:', GraphErrorMsg(ErrCode));
end.