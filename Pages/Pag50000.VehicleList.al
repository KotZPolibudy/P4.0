page 50000 VehicleList
{
    ApplicationArea = All;
    Caption = 'VehicleList';
    PageType = List;
    SourceTable = Vehicle;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model field.';
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VIN field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Tranmission; Rec.Tranmission)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tranmission field.';
                }
                field("List Price"; Rec."List Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the List Price field.';
                }
                field("Date of Manufacturing"; Rec."Date of Manufacturing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Manufacturing field.';
                }
            }
        }
    }
}
