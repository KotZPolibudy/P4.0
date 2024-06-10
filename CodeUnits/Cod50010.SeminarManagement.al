Codeunit 50010 "Seminar Management"
{
    trigger OnRun()
    begin
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        InvoiceLinesCreatedMsg: label 'Invoice lines have been created';
        InvoiceNotCreatedMsg: label 'Invoice has not been created';
        DescriptionTemplateTxt: label 'Seminar ''%1'' participant ''%2''';

    procedure CreateSalesInvoice(PSeminarRegHeader: Record "Seminar Registration Header")
    var
        SeminarRegLine: Record "Seminar Registration Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LineN0: Integer;
        LineCreated: Boolean;
    begin
        SalesSetup.Get();
        SalesSetup.TestField("G/L Account No.");
        //TODO: sprawdź czy rejestracja ma ustawiony Stan na "zakończone" (faktury mają być wystawiane tylko dla zakończonych rejestracji)
        PSeminarRegHeader.TestField(PSeminarRegHeader.Status, PSeminarRegHeader.Status::Finished);
        PSeminarRegHeader.TestField("Posting Date");

        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Seminar Registration No.", PSeminarRegHeader."No.");
        //TODO: ogranicz przetwarzane SRL do krotek z zaznaczonym polem "Do fakturowania" (faktury mają być wystawiane tylko dla uczestników z zaznaczonym polem "Do fakturowania")
        SeminarRegLine.SetRange("To Invoice", true);
        //TODO: ogranicz przetwarzane SRL do krotek, które nie miały już wcześniej wystawionych faktur (uczestnicy, którzy mieli już wystawine faktury, nie mają ich ponownie wystawianych)
        SeminarRegLine.SetRange("Invoice No.", '');
        if SeminarRegLine.FindSet() then begin
            LineCreated := true;
            repeat
                //CreateSalesInvoiceHeader - Tworzenie nagłówka faktury sprzedaży
                Clear(SalesHeader);
                SalesHeader.Reset();
                //TODO: ogranicz przetwarzane SalesHeader tylko do dokumentów typu faktury
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                //TODO: ogranicz przetwarzane SalesHeader tylko do dokumentów wystawionych na nabywcę zgodnego z polem "Nr odbiorcy faktury" w wierszu rejestracji
                SalesHeader.SetRange(SalesHeader."Sell-to Customer No.", SeminarRegLine."Bill-to Customer No.");
                SalesHeader.SetRange("External Document No.", PSeminarRegHeader."No.");


                //If not FindFirst zaczyna od pobrania rekordu. Jeśli go nie ma to wykonuje się to co w IF, a jeśli jest to już mamy w tej zmiennej nagłówek faktury i możemy do niej dopisywać następne wiersze (poza IF'em do którego nie wchodzimy).
                if not SalesHeader.FindFirst() then begin
                    SalesHeader.Init();
                    //TODO: ustaw by dokument był typu "faktura"
                    //SalesHeader."No." := '';
                    SalesHeader.Validate(SalesHeader."Document Type", "Sales Document Type"::Invoice);
                    SalesHeader.Validate(SalesHeader."No.", '');

                    SalesHeader.Validate("Posting Date", PSeminarRegHeader."Posting Date");
                    SalesHeader.Validate("Document Date", PSeminarRegHeader."Posting Date");
                    SalesHeader.Validate("ITI Sales Date", PSeminarRegHeader."Posting Date");
                    //TODO: ustaw by nabywca w nagłówku faktury był zgodny z polem "Nr odbiorcy faktury" w wierszu rejestracji
                    SalesHeader.Validate("Sell-to Customer No.", SeminarRegLine."Bill-to Customer No.");

                    SalesHeader."External Document No." := PSeminarRegHeader."No.";
                    SalesHeader.Insert(true);
                end;

                //CreateSalesInvoiceLines - Tworzenie wierszy faktury
                Clear(SalesLine);
                SalesLine.SetRange("Document Type", SalesLine."document type"::Invoice);
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindLast() then
                    LineN0 := SalesLine."Line No.";

                LineN0 := LineN0 + 10000;
                Clear(SalesLine);
                SalesLine."Document Type" := SalesLine."document type"::Invoice;
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := LineN0;
                SalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                //TODO: ustaw "Typ" w wierszu faktury na "Konto K/G"
                SalesLine.Validate(SalesLine.Type, SalesLine.Type::"G/L Account");
                //TODO: ustaw "Nr" w wierszu faktury na nr konta prowadzonego w "Ustawieniach sprzedaży i należn."
                SalesLine.Validate("No.", SalesSetup."G/L Account No.");
                //TODO: ustaw "ilość" w wierszu faktury na wartość 1
                SalesLine.Validate(SalesLine.Quantity, 1);
                SalesLine.Validate(SalesLine."Unit Price", SeminarRegLine.Amount);

                SalesLine.Validate("Unit Price", SeminarRegLine.Amount);
                //TODO: wymuś przeliczenie wartości pola z "Nazwą uczestnika"
                SeminarRegLine.CalcFields(SeminarRegLine."Participant Name");
                //SalesLine.Description := StrSubstNo(DescriptionTemplateTxt, //TODO: wprowadź dwa pola wymagane w opisie wiersza faktury );
                SalesLine.Description := StrSubstNo(DescriptionTemplateTxt, SeminarRegLine."Seminar Registration No.", SeminarRegLine."Participant Name");
                SalesLine.Insert();
                SeminarRegLine."Invoice No." := SalesHeader."No.";
                SeminarRegLine.Modify();
            until SeminarRegLine.Next() = 0;
        end;

        if LineCreated then
            Message(InvoiceLinesCreatedMsg)
        else
            Message(InvoiceNotCreatedMsg);
    end;
}

