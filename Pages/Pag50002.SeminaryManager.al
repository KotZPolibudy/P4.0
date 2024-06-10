page 50002 "Seminary Manager"
{
    Caption = 'Seminary Manager';
    PageType = RoleCenter;

    layout
    {

    }
    actions
    {
        area(Sections)
        {
            group(Lists)
            {
                Caption = 'Lists';
                action(Seminars)
                {
                    ApplicationArea = All;
                    Caption = 'Seminars';
                    RunObject = page "Seminars";
                }
                action(Instructors)
                {
                    ApplicationArea = All;
                    Caption = 'Instructors';
                    RunObject = page "Instructors";
                }
                action("Seminar Rooms")
                {
                    ApplicationArea = All;
                    Caption = 'Seminar Rooms';
                    RunObject = page "Seminar Rooms";
                }
                action("Seminar Registrations")
                {
                    ApplicationArea = All;
                    Caption = 'Seminar Registrations';
                    RunObject = page "Seminar Registration Headers";
                }
            }
            group(Tasks)
            {
                action("Participants Export")
                {
                    ApplicationArea = All;
                    Caption = 'Seminar participants export';
                    RunObject = xmlport ProjXMLPort;
                }
            }
        }
    }
}

profile "Seminar Manager"
{
    Caption = 'Seminar Manager';
    RoleCenter = "Seminary Manager";
}