xmlport 50010 ProjXMLPort
{
    Direction = Export;
    Format = Xml;
    UseRequestPage = true;
    schema
    {
        textelement(Root)
        {
            XmlName = 'Seminar_Registration_Participant_List';
            tableelement(Registrations; "Seminar Registration Header")
            {
                XmlName = 'Seminar';
                SourceTableView = sorting("No.");
                //Flowfieldy
                // CalcFields = "Balance at Date", "Net Change";
                fieldelement(No; Registrations."No.")
                {
                }
                fieldelement(Seminar_Code; Registrations."Seminar Code")
                {
                }
                fieldelement(Seminar_Name; Registrations."Seminar Name")
                {
                }
                fieldelement(Starting_Date; Registrations."Starting Date")
                {
                }
                fieldelement(Seminar_Duration; Registrations."Seminar Duration")
                {
                }
                fieldelement(Instructor_Name; Registrations."Instructor Name")
                {
                }
                fieldelement(Room_Name; Registrations."Seminar Room Name")
                {
                }
                tableelement(Participant; "Seminar Registration Line")
                {
                    LinkTable = "Registrations";
                    LinkFields = "Seminar Registration No." = FIELD("No.");
                    MinOccurs = Zero;

                    fieldelement(Customer_No; Participant."Bill-to Customer No.")
                    {
                    }
                    textelement(Customer_Name)
                    {
                        trigger OnBeforePassVariable()
                        var
                            Customer: Record Customer;
                        begin
                            Customer.Reset();
                            if (Customer.Get(Participant."Bill-to Customer No.")) then begin
                                Customer_Name := Customer.name;
                            end;
                        end;
                    }
                    fieldelement(Contact_No; Participant."Participant Contact No.")
                    {
                    }
                    fieldelement(Participant_Name; Participant."Participant Name")
                    {
                    }
                }
            }
        }
    }
}