tableextension 50001 "Sales & Receivables Setup" extends 311
{
    fields
    {
        field(50000; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
    }
}
