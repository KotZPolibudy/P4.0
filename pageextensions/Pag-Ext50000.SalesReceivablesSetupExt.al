pageextension 50001 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Archiving")
        {
            group("Moduł szkoleń")
            {
                Caption = 'Moduł szkoleń';
                field("Nr konta K/G"; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
            }
        }
    }
}
