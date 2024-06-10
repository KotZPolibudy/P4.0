Table 50040 "Seminar Registration Header"
{
    DataCaptionFields = "No.";
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate();
            begin
                if (XRec."No." <> '') and (xRec."No." <> "No.") then
                    Error('Nie można zmienić nazwy rekordu.');
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            trigger OnValidate();
            begin
                if (xRec."Starting Date" <> "Starting Date") and (Status <> Status::Planning) then
                    Error('Można zmienić wartość pola Starting Date tylko, gdy status ma wartość Planowane.');
            end;
        }
        field(3; "Seminar Code"; Code[20])
        {
            Caption = 'Seminar Code';
            TableRelation = "Seminar";
            trigger OnValidate();
            var
                Seminar: Record Seminar;
                SeminarRegistrationLineRec: Record "Seminar Registration Line";

            begin
                if Seminar.Get("Seminar Code") then begin
                    if Seminar.Blocked then
                        Error('Wybrane szkolenie jest zablokowane.');

                    "Seminar Name" := Seminar.Name;
                    "Seminar Duration" := Seminar."Seminar Duration";
                    "Minimum Participants" := Seminar."Minimum Participants";
                    "Maximum Participants" := Seminar."Maximum Participants";
                    "Seminar Price" := Seminar."Seminar Price";
                end;
                if xRec."Seminar Code" <> "Seminar Code" then begin
                    begin
                        SeminarRegistrationLineRec.SetRange("Seminar Registration No.", "No.");
                        if SeminarRegistrationLineRec.FindFirst() then
                            Error('Pole Seminar Code można zmienić (czyli wybrać inną wartość) tylko, gdy wiersze rejestracji szkolenia nie zostały jeszcze zarejestrowane.');
                    end;
                end;
            end;
        }
        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }
        field(5; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = "Instructor";
            trigger OnValidate();
            begin
                if xRec."Instructor Code" <> "Instructor Code" then
                    CalcFields("Instructor Name");
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            TableRelation = "Instructor".Name;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Instructor".Name where("Code" = Field("Instructor Code")));
        }
        // field(7; Status; Text[250])
        // {
        //     Caption = 'Status';
        // }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "Planning","Registration","Finished","Cancelled";
            OptionCaption = 'Planning,Registration,Finished,Cancelled';
        }
        field(8; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(9; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(10; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(11; "Seminar Room Code"; Code[20])
        {
            Caption = 'Seminar Room Code';
            TableRelation = "Seminar Room";
            trigger OnValidate();
            var
                SeminarRoom: Record "Seminar Room";
            begin
                if SeminarRoom.Get("Seminar Room Code") then begin
                    if SeminarRoom."Maximum Participants" < "Maximum Participants" then
                        Message('Uwaga: Wybrana sala ma pojemność (%1) mniejszą niż maksymalna liczba uczestników wybranego szkolenia (%2).', SeminarRoom."Maximum Participants", "Maximum Participants");

                    "Seminar Room Name" := SeminarRoom.Name;
                    "Seminar Room Address" := SeminarRoom.Address;
                    "Seminar Room Address 2" := SeminarRoom."Address 2";
                    "Seminar Room Post Code" := SeminarRoom."Post Code";
                    "Seminar Room City" := SeminarRoom.City;
                    "Seminar Room Phone No." := SeminarRoom."Phone No.";
                end;
            end;
        }
        field(12; "Seminar Room Name"; Text[50])
        {
            Caption = 'Seminar Room Name';
        }
        field(13; "Seminar Room Address"; Text[50])
        {
            Caption = 'Seminar Room Address';
        }
        field(14; "Seminar Room Address 2"; Text[50])
        {
            Caption = 'Seminar Room Address 2';
        }
        field(15; "Seminar Room Post Code"; Code[20])
        {
            Caption = 'Seminar Room Post Code';
            TableRelation = "Post Code";
        }
        field(16; "Seminar Room City"; Text[30])
        {
            Caption = 'Seminar Room City';
        }
        field(17; "Seminar Room Phone No."; Text[30])
        {
            Caption = 'Seminar Room Phone No';
        }
        field(18; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            trigger OnValidate();
            begin
                if (xRec."Seminar Price" <> "Seminar Price") and (Status <> Status::Cancelled) then
                    if Confirm('Czy zaktualizować pole Seminar Price i zaktualizować wszystkie niezarejestrowane wiersze?') then
                        UpdateSeminarPrice();
            end;
        }
        field(20; Amount; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Seminar Registration Line".Amount where("Seminar Registration No." = Field("No.")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert();
    begin
        "Posting Date" := WorkDate;
    end;

    trigger OnDelete();
    begin
        if (Status <> Status::Planning) and (Status <> Status::Cancelled) then
            Error('Można usuwać tylko rekordy ze statusem Planowane lub Odwołane.');
    end;

    procedure UpdateSeminarPrice();
    var
        SeminarRegLine: Record "Seminar Registration Line";
    begin
        SeminarRegLine.SetRange("Seminar Registration No.", "No.");
        if SeminarRegLine.FindSet() then
            repeat
                if SeminarRegLine.Registered = false then begin
                    SeminarRegLine."Seminar Price" := "Seminar Price";
                    SeminarRegLine."Line Discount %" := 0;
                    SeminarRegLine."Line Discount Amount" := 0;
                    SeminarRegLine."Amount" := "Seminar Price";
                    SeminarRegLine.Modify();
                end;

            until SeminarRegLine.Next() = 0;

        CalcFields(Amount);
    end;


    procedure RecalculateAmount()
    var
        SeminarRegLine: Record "Seminar Registration Line";
    begin
        SeminarRegLine.SetRange("Seminar Registration No.", "No.");
        if SeminarRegLine.FindSet() then
            repeat
                CalcFields(Amount);
            until SeminarRegLine.Next() = 0;
    end;


    trigger OnModify();
    begin
        CalcFields(Amount);
    end;


}