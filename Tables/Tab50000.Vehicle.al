table 50000 Vehicle
{

    Caption = 'Vehicle';
    fields
    {
        field(10; Model; Code[20])
        {
            Caption = 'Model';
        }
        field(20; VIN; Code[20])
        {
            Caption = 'VIN';
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(40; Tranmission; Option)
        {
            Caption = 'Tranmission';
            OptionMembers = Automatic,"4-Speed","5-Speed";
            OptionCaption = 'Automatic,4-Speed,5-Speed';
        }
        field(50; "List Price"; Decimal)
        {
            Caption = 'List Price';
        }
        field(60; "Date of Manufacturing"; Date)
        {
            Caption = 'Date of Manufacturing';
        }
    }
    keys
    {
        key(PK; Model, VIN)
        {
            Clustered = true;
        }
    }
}