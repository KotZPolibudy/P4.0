page 50040 "Seminar Registration Headers"
{
    ApplicationArea = All;
    Caption = 'Seminar Registration Headers';
    PageType = List;
    SourceTable = "Seminar Registration Header";
    UsageCategory = Lists;
    CardPageId = 50041;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Seminar Code"; Rec."Seminar Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Code field.';
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Name field.';
                }
                field("Instructor Code"; Rec."Instructor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Instructor Code field.';
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Instructor Name field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Duration field.';
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Participants field.';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Participants field.';
                }
                field("Seminar Room Code"; Rec."Seminar Room Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Room Code field.';
                }
                field("Seminar Room Name"; Rec."Seminar Room Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Room Name field.';
                }
                field("Seminar Room Address"; Rec."Seminar Room Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Room Address field.';
                }
                field("Seminar Room Address 2"; Rec."Seminar Room Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Room Address 2 field.';
                }
                field("Seminar Room Post Code"; Rec."Seminar Room Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Room Post Code field.';
                }
                field("Seminar Room City"; Rec."Seminar Room City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Room City field.';
                }
                field("Seminar Room Phone No."; Rec."Seminar Room Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Room Phone No field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Price field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Export Seminars to XML")
            {
                Caption = 'Export seminars to XML';
                ApplicationArea = All;
                Image = XMLFile;
                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"ProjXMLPort");
                end;
            }
        }
    }
}
