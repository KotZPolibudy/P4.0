pageextension 50000 "Salespersons Ext." extends "Salespersons/Purchasers"
{
    layout
    {
        addlast(Control1)
        {
            field(Sales; Rec.Sales)
            {
                ApplicationArea = All;
            }
        }
    }

    var
        myInt: Integer;
}