table 50001 "Sales Transaction"
{

    Caption = 'Sales Transaction';
    fields
    {
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(20; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser" where("Commission %" = filter(> 0));
        }
        field(30; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = "G/L Account",Item,Resource;
            OptionCaption = 'G/L Account,Item,Resource';
        }
        field(40; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Resource)) Resource;
        }
        field(50; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }

    }
    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }
}