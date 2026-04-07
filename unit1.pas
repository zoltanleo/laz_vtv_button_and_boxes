unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, laz.VirtualTrees;

type
  PMyRec = ^TMyRec;
  TMyRec = record
    aCaption: String;
    //aCheckImageKind: TCheckImageKind;//ckSystemDefault
    aCheckState: TCheckState;// csCheckedNormal/csUncheckedNormal
    aCheckType: TCheckType;  // ctCheckBox/ctRadioButton
    aChildIsDepend: Boolean; // дизейблить ли детей при отметке checkbox
    aSiblingIsDepend: Boolean; // дизейблить ли узлы этого же уровня при отметке checkbox
  end;

  { TForm1 }

  TForm1 = class(TForm)
    vst: TLazVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure vstChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure vstFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.vstFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if Assigned(Sender.GetNodeData(Node)) then Finalize(PMyRec(Sender.GetNodeData(Node))^);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Node: PVirtualNode = nil;
  chNode: PVirtualNode = nil;
  chchNode: PVirtualNode = nil;
  Data: PMyRec = nil;
begin
  with VST do
  begin
    HintMode := hmTooltip;
    ShowHint := True;
    CheckImageKind:= ckSystemDefault;

    with Header do
    begin
      Columns.Clear;
      Columns.Add;
      Columns[0].Text := '';

      //AutoSizeIndex := 0;
      //Height := Canvas.TextHeight('W') * 3 div 2;
      Options := Options + [hoAutoResize,
        hoOwnerDraw, hoShowHint,
        hoShowImages
        //, hoVisible
        ];
      //Height := Canvas.TextHeight('W') * 3 div 2;
    end;

    with TreeOptions do
    begin
      AutoOptions := AutoOptions +
        [toAutoScroll, toAutoSpanColumns] - [];

      MiscOptions := MiscOptions
                  + [toCheckSupport]
                  - [toAcceptOLEDrop, toEditOnClick]
                  ;
      PaintOptions := PaintOptions
        + [toShowButtons]
        - [toShowDropmark,
        toShowTreeLines];

      SelectionOptions := SelectionOptions +
        [toExtendedFocus, toFullRowSelect, toCenterScrollIntoView,
        toAlwaysSelectNode] - [];
    end;
  end;

  //========= root 1 ===========
  Node:= vst.AddChild(nil);
  if Assigned(Node) then
  begin
    Data:= vst.GetNodeData(Node);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:1 idx:1';
      Data^.aCheckType:= ctCheckBox;
      Data^.aCheckState:= csUncheckedNormal;
      Data^.aChildIsDepend:= True;
      Data^.aSiblingIsDepend:= True;
    end;
  end;

  //=== checkbox ===
  chNode:= vst.AddChild(Node);
  if Assigned(chNode) then
  begin
    Data:= vst.GetNodeData(chNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:2 idx:1';
      Data^.aCheckType:= ctCheckBox;
      Data^.aCheckState:= csUncheckedNormal;
      Data^.aChildIsDepend:= True;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  //==== radiobuttons ====
  chchNode:= vst.AddChild(chNode);
  if Assigned(chchNode) then
  begin
    Data:= vst.GetNodeData(chchNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:3 idx:1';
      Data^.aCheckType:= ctRadioButton;
      Data^.aCheckState:= cscheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  chchNode:= vst.AddChild(chNode);
  if Assigned(chchNode) then
  begin
    Data:= vst.GetNodeData(chchNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:3 idx:2';
      Data^.aCheckType:= ctRadioButton;
      Data^.aCheckState:= csUncheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  chchNode:= vst.AddChild(chNode);
  if Assigned(chchNode) then
  begin
    Data:= vst.GetNodeData(chchNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:3 idx:3';
      Data^.aCheckType:= ctRadioButton;
      Data^.aCheckState:= csUncheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  //=== checkbox ===
  chNode:= vst.AddChild(Node);
  if Assigned(chNode) then
  begin
    Data:= vst.GetNodeData(chNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:2 idx:2';
      Data^.aCheckType:= ctCheckBox;
      Data^.aCheckState:= csUncheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  //========= root 2 ===========
  Node:= vst.AddChild(nil);
  if Assigned(Node) then
  begin
    Data:= vst.GetNodeData(Node);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:1 idx:2';
      Data^.aCheckType:= ctCheckBox;
      Data^.aCheckState:= csCheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  //==== radiobuttons ====
  chNode:= vst.AddChild(Node);
  if Assigned(chNode) then
  begin
    Data:= vst.GetNodeData(chNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:2 idx:1';
      Data^.aCheckType:= ctRadioButton;
      Data^.aCheckState:= cscheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  chNode:= vst.AddChild(Node);
  if Assigned(chNode) then
  begin
    Data:= vst.GetNodeData(chNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:2 idx:2';
      Data^.aCheckType:= ctRadioButton;
      Data^.aCheckState:= csUncheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  chNode:= vst.AddChild(Node);
  if Assigned(chNode) then
  begin
    Data:= vst.GetNodeData(chNode);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:2 idx:2';
      Data^.aCheckType:= ctRadioButton;
      Data^.aCheckState:= csUncheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  //========= root 3 ===========
  Node:= vst.AddChild(nil);
  if Assigned(Node) then
  begin
    Data:= vst.GetNodeData(Node);
    if Assigned(Data) then
    begin
      Data^.aCaption:= 'level:1 idx:3';
      Data^.aCheckType:= ctNone;
      Data^.aCheckState:= csCheckedNormal;
      Data^.aChildIsDepend:= False;
      Data^.aSiblingIsDepend:= False;
    end;
  end;

  vst.FullExpand;

  Node:= vst.GetFirst;
  while Assigned(Node) do
  begin
    vst.ReinitNode(Node,True);
    Node:= Node^.NextSibling;
  end;

  Node:= vst.GetFirst;
  if Assigned(Node) then
  begin
    vst.Selected[Node]:= True;
    vstChecked(vst, Node);
  end;

  if vst.CanSetFocus then vst.SetFocus;


end;

procedure TForm1.vstChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PMyRec;
  IsChecked: Boolean;
  SiblingNode: PVirtualNode = nil;

  // Локальная процедура для обхода дочерних узлов
  procedure SetChildrenDisabledState(ParentNode: PVirtualNode; Disable: Boolean);
  var
    ChildNode: PVirtualNode;
  begin
    // Получаем первого ребенка
    ChildNode := Sender.GetFirstChild(ParentNode);
    while Assigned(ChildNode) do
    begin
      // Включаем или выключаем узел
      Sender.IsDisabled[ChildNode] := Disable;

      // Если нужно дизейблить всю иерархию рекурсивно (детей детей),
      // раскомментируйте следующую строку:
       SetChildrenDisabledState(ChildNode, Disable);

      // Переходим к следующему узлу на этом же уровне
      ChildNode := Sender.GetNextSibling(ChildNode);
    end;
  end;
begin
  Data := Sender.GetNodeData(Node);

  if not Assigned(Data) then Exit;

  // 1. Синхронизируем ваши данные с новым состоянием в дереве
  Data^.aCheckState := Sender.CheckState[Node];

  // 2. Если дети зависят от состояния родителя
  if Data^.aChildIsDepend then
  begin
    // Проверяем, отмечен ли чекбокс (учитываем обычное и "нажатое" состояние)
    IsChecked := (Data^.aCheckState = csCheckedNormal) or (Data^.aCheckState = csCheckedPressed);

    // Если отмечен, то Disable = False (энейблим). Иначе Disable = True (дизейблим).
    SetChildrenDisabledState(Node, not IsChecked);
  end;

  // 3. Если узлы того же уровня зависят от состояния данного узла
  if Data^.aSiblingIsDepend then
  begin
    // Узлы активны если текущий узел отмечен или в смешанном состоянии
    IsChecked := (Data^.aCheckState = csCheckedNormal)
              or (Data^.aCheckState = csCheckedPressed)
              or (Data^.aCheckState = csMixedNormal)
              or (Data^.aCheckState = csMixedPressed);

    // Обходим всех братьев (sibling) текущего узла
    // Первый брат — первый ребёнок родителя
    if Assigned(Node^.Parent) then
      SiblingNode := (Node^.Parent)^.FirstChild
    else
      SiblingNode := Sender.GetFirst;
    while Assigned(SiblingNode) do
    begin
      // Пропускаем сам текущий узел
      if (SiblingNode <> Node) then Sender.IsDisabled[SiblingNode] := not IsChecked;
      if (SiblingNode^.ChildCount > 0) then SetChildrenDisabledState(SiblingNode, not IsChecked);
      //SiblingNode := Sender.GetNextSibling(SiblingNode);
      SiblingNode := SiblingNode^.NextSibling;
    end;
  end;
end;

procedure TForm1.vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var NewState: TCheckState; var Allowed: Boolean);
var
  Data: PMyRec = nil;
  NodeLvl: SizeInt = -1;
begin
  NodeLvl:= Sender.GetNodeLevel(Node);
  Data:= Sender.GetNodeData(Node);
  if Assigned(Data) then Allowed:= Data^.aSiblingIsDepend or (NodeLvl > 0);
end;

procedure TForm1.vstGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TMyRec);
end;

procedure TForm1.vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PMyRec = nil;
begin
  Data := vst.GetNodeData(Node);
  if not Assigned(Data) then Exit;

  case Column of
    0: CellText := Data^.aCaption;
    else;
  end;
end;

procedure TForm1.vstInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PMyRec = nil;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    // Устанавливаем тип (чекбокс, радиокнопка или ничего)
    Node^.CheckType:= Data^.aCheckType;

    // Устанавливаем текущее состояние (отмечен/не отмечен)
    Sender.CheckState[Node] := Data^.aCheckState;
  end;
end;

end.

