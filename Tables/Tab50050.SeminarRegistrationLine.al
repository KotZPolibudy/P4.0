table 50050 "Seminar Registration Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            TableRelation = "Seminar Registration Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = "Customer";
            trigger OnValidate()
            begin
                if Registered then
                    Error('Nie można zmienić Bill-to-Customer dla zarejestrowanych linii.');
            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            TableRelation = Contact;

            trigger OnLookup()
            var
                Contact: Record Contact;
                Filter: Text;
            begin
                Filter := GetRelatedContacts("Bill-to Customer No.");
                if Filter = '' then
                    Error('Brak powiązanych kontaktów dla tego klienta.');

                Contact.SetFilter("Company No.", Filter);
                if PAGE.RunModal(PAGE::"Contact List", Contact) = ACTION::LookupOK then
                    Rec.Validate("Participant Contact No.", Contact."No.");
            end;
        }

        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("Contact".Name WHERE("No." = Field("Participant Contact No.")));
            Editable = false;
        }
        field(6; "Register Date"; Date)
        {
            Caption = 'Register Date';
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = false;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
        }
        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 2;
            trigger OnValidate()
            begin
                CalcLineDiscountAmount;
                CalcAmount;
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            trigger OnValidate()
            begin
                CalcLineDiscountAmount;
                CalcAmount;
            end;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            AutoFormatType = 1;
            trigger OnValidate()
            begin
                CalcLineDiscountPercent;
                CalcAmount;
            end;
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
            trigger OnValidate()
            begin
                CalcOnAmountChange;
            end;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            trigger OnValidate()
            begin
                if Registered then
                    "Register Date" := WorkDate;
            end;
        }
        field(15; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Sales Header" WHERE("Document Type" = CONST(Invoice));
            //Editable = false;

        }
    }

    keys
    {
        key(Key1; "Seminar Registration No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }

    trigger OnInsert()
    begin
        InitializeDefaultValues;
        RecalculateHeaderAmount();
    end;

    trigger OnDelete()
    begin
        if Registered then
            Error('Nie można usunąć zarejestrowanych linii.');
        RecalculateHeaderAmount();
    end;

    trigger OnModify()
    begin
        RecalculateHeaderAmount();
    end;


    local procedure RecalculateHeaderAmount()
    var
        SeminarRegHeader: Record "Seminar Registration Header";
    begin
        if SeminarRegHeader.Get("Seminar Registration No.") then
            SeminarRegHeader.RecalculateAmount();
    end;


    local procedure InitializeDefaultValues()
    var
        SeminarRegHeader: Record "Seminar Registration Header";
    begin
        if SeminarRegHeader.Get("Seminar Registration No.") then begin
            "Seminar Price" := SeminarRegHeader."Seminar Price";
            CalcAmount;
        end;
    end;

    local procedure CalcAmount()
    begin
        Amount := "Seminar Price" - "Line Discount Amount";
    end;

    local procedure CalcLineDiscountAmount()
    begin
        "Line Discount Amount" := "Seminar Price" * "Line Discount %" / 100;
    end;

    local procedure CalcLineDiscountPercent()
    begin
        if "Seminar Price" <> 0 then
            "Line Discount %" := ("Line Discount Amount" / "Seminar Price") * 100;
    end;

    local procedure CalcOnAmountChange()
    begin
        "Line Discount %" := (1.0 - "Amount" / "Seminar Price") * 100;
        "Line Discount Amount" := "Seminar Price" * "Line Discount %" / 100;
    end;

    local procedure GetRelatedContacts(CustomerNo: Code[20]): Text
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        ContactNos: Text;
        First: Boolean;
    begin
        First := true;
        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SetRange("No.", CustomerNo);
        if ContactBusinessRelation.FindSet() then
            repeat
                if not First then
                    ContactNos += '|';
                ContactNos += ContactBusinessRelation."Contact No.";
                First := false;
            until ContactBusinessRelation.Next() = 0;
        exit(ContactNos);
    end;
}
