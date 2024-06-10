tableextension 50000 "Salesperson Ext." extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Sales"; Decimal)
        {
            Caption = 'Sales';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Transaction".Amount where("Salesperson Code" = field(Code)));
            Editable = false;
        }
        field(50001; "Type Filter"; Option)
        {
            Caption = 'Type Filter';
            OptionMembers = "G/L Account",Item,Resource;
            OptionCaption = 'G/L Account,Item,Resource';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}