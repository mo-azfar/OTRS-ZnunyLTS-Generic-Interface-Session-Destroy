# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021 mo-azfar, https://github.com/mo-azfar/OTRS-Generic-Interface-Session-Destroy
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Session::SessionEnd;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData IsHashRefWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::Session::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Session::SessionEnd - GenericInterface Session Get Operation backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

	$Self->{Config}    = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::SessionEnd');
    $Self->{Operation} = $Param{Operation};

    $Self->{DebugPrefix} = 'SessionEnd';
	
    return $Self;
}

=head2 Run()

webservice REST configuration

	NAME => SessionEnd
	OPERATION BACKEND => Session::SessionEnd
	
	ROUTE MAPPING => /SessionEnd/:SessionID
	REQUEST METHOD => DELETE

Delete session information.

    my $Result = $OperationObject->Run(
        Data => {
            SessionID => '1234567890123456',
        },
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !IsHashRefWithData( $Param{Data} ) ) {

        return $Self->ReturnError(
            ErrorCode    => "$Self->{OperationName}.MissingParameter",
            ErrorMessage => "$Self->{OperationName}: The request is empty!",
        );
    }

    if ( !$Param{Data}->{SessionID} ) {
        return $Self->ReturnError(
            ErrorCode    => "$Self->{OperationName}.MissingParameter",
            ErrorMessage => "$Self->{OperationName}: SessionID is missing!",
        );
    }

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # Honor SessionCheckRemoteIP, SessionMaxIdleTime, etc.
    my $Valid = $SessionObject->CheckSessionID(
        SessionID => $Param{Data}->{SessionID},
    );
	
    if ( !$Valid ) {
        return $Self->ReturnError(
            ErrorCode    => "$Self->{OperationName}.SessionInvalid",
            ErrorMessage => "$Self->{OperationName}: SessionID is Invalid!",
        );
    }
    
    #returns true (session deleted), false (if session can't get deleted)
    my $RemoveSession = $SessionObject->RemoveSessionID(SessionID =>  $Param{Data}->{SessionID},);
    	
	return {
        Success => 1,
        Data    => {
            SessionStatus => $RemoveSession,
        },
    };  

}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
